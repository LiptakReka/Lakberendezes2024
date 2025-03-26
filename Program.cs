using Lakberendezes.Data;
using Lakberendezes.Models;
using Lakberendezes.Models.Service;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;


var builder = WebApplication.CreateBuilder(args);

var jwtsettings = builder.Configuration.GetSection("Jwt");
var secretkey = jwtsettings["Key"];
var audience = jwtsettings["Audience"];
var issuer = jwtsettings["Issuer"];
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = issuer,
            ValidateAudience = true,
            ValidAudience=audience,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretkey!))
        };
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                if (context.Request.Headers.ContainsKey("Authorization"))
                {
                    var authHeader = context.Request.Headers["Authorization"].ToString();
                    if (!string.IsNullOrEmpty(authHeader) && !authHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
                    {
                        context.Token = authHeader;
                    }
                }
                return Task.CompletedTask;
            }
        };
});

builder.Services.ConfigureApplicationCookie(options =>
{
    options.Events.OnRedirectToLogin = context =>
    {
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        return Task.CompletedTask;
    };
});
builder.Services.AddScoped<IEmailSender, EmailSender>();

// appsettings config
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);


// Szükséges meghívások
builder.Services.AddScoped<JwtService>();
builder.Services.AddSingleton<CloudinaryService>();




//MYSQL 
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))));

// Swagger
builder.Services.AddSwaggerGen(async options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Lakberendezes API",
        Version = "v1",
        Description = "Lakberendezes platform API dokument ci ja"
    });
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Add meg a Jwt tokent a headerben"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

    // controllerek
    builder.Services.AddControllers();
    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll", policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader();
        });
    });

    var app = builder.Build();

    // CORS engedélyezése
    app.UseCors("AllowAll");
    app.Use(async (context, next) =>
    {
        var token = context.Request.Headers["Authorization"].ToString();
        Console.WriteLine($"Received Token: {token}");
        await next();
    });



// HTTP config
if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI(options =>
        {
            options.SwaggerEndpoint("/swagger/v1/swagger.json", "Lakberendezes API v1");
        });
    }

    app.UseHttpsRedirection();
    app.UseAuthentication();
    app.UseAuthorization();

    //végpontok beállítása
    app.MapControllers();
    app.UseStaticFiles();



using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await EnsureRolesCreated(context);
}

async Task EnsureRolesCreated(AppDbContext context)
{
    string[] roleNames = { "User", "Admin" };
    foreach (var roleName in roleNames)
    {
        if (!context.role.Any(r => r.name == roleName))
        {
            context.role.Add(new Roles { name = roleName });
        }
    }
    await context.SaveChangesAsync();
}


app.Run();

