using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Configuration;
using Microsoft.Extensions.Configuration;
using System.Text;
using Microsoft.AspNetCore.Authentication.Facebook;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);


// Add services to the containe

builder.Services.AddIdentity<User, IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

builder.Services.AddAuthentication(option =>
{
    option.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    option.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddFacebook(facebookOptions =>
{
    facebookOptions.AppId = builder.Configuration["Authentication:Facebook:AppId"];
    facebookOptions.AppSecret = builder.Configuration["Authentication:Facebook:AppSecret"];
})
.AddJwtBearer(option =>
{
    option.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        ValidAudience = builder.Configuration["Jwt:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});
builder.Services.AddScoped<JwtService>();
builder.Services.AddDbContext<AppDbContext>(options =>
options.UseMySql(
    builder.Configuration.GetConnectionString("DefaultConnection"),
    ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))));

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo { Title = "Lakberendezes", Version = "v1" });

    //hozzáadjuk a OAuth2-t
    options.AddSecurityDefinition("oauth2", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.OAuth2,
        Flows = new OpenApiOAuthFlows
        {
            AuthorizationCode = new OpenApiOAuthFlow
            {
                AuthorizationUrl = new Uri("https://www.facebook.com/dialog/oauth"),
                TokenUrl = new Uri("https://graph.facebook.com/oauth/access_token"),
                Scopes = new Dictionary<string, string>
                {
                    {"email", "Access your email address" },
                    {"public_profile", "Access your public profile" }
                }
            }
        }
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement{
        {
            new OpenApiSecurityScheme
            {
                Reference=new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="oauth2"
                }
            },
            new [] {"email", "public_profile"}
        }
    });
});
//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowFacebook", builder =>
//    {
//        builder
//            .WithOrigins("https://graph.facebook.com", "https://www.facebook.com")
//            .AllowAnyMethod()
//            .AllowAnyHeader()
//            .AllowCredentials()
//            .SetIsOriginAllowed(origin => true)
//            .WithExposedHeaders("WWW-Authenticate", "Authorization")  // Engedélyezi a hitelesítési headereket
//            .WithMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");  // Kifejezetten engedélyezzük az OPTIONS metódust is
//    });

//});


var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "Lakberendezes v1");

        //oauth2
        options.OAuthClientId("1308178167221002");
        options.OAuthClientSecret("2df0bf6903831c35718a8a02dd7540b8");
        options.OAuthAppName("Lakberendezes");
        options.OAuthUsePkce();
    });
}

app.UseCors("AllowFacebook");
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
;
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    await EnsureRolesCreated(roleManager);
}
async Task EnsureRolesCreated(RoleManager<IdentityRole> roleManager)
{
    string[] rolenames = { "USER", "ADMIN" };
    foreach (var rolenamee in rolenames)
    {
        var roleexist = await roleManager.RoleExistsAsync(rolenamee);
        if (!roleexist)
        {
            await roleManager.CreateAsync(new IdentityRole(rolenamee));
        }
    }
}

app.Run();
