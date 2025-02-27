using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddAuthentication(options =>
{
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = false,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("+6naoStCZLQbteLFQRKYfrFjWk6WX5a/gqTxBgZgE88 ="))
    };
});



builder.Services.AddScoped<IEmailSender, EmailSender>();

<<<<<<< HEAD
// Configuration from appsettings.json
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);


// Add services to the container
=======
// appsettings config
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);


// Szükséges meghívások
>>>>>>> 55d865c (Exportálás excelbe)
builder.Services.AddScoped<JwtService>();



builder.Services.AddIdentity<User, IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

<<<<<<< HEAD
// Setup MySQL DbContext
=======
//MYSQL 
>>>>>>> 55d865c (Exportálás excelbe)
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))));

<<<<<<< HEAD
// Add Swagger for API documentation
=======
// Swagger
>>>>>>> 55d865c (Exportálás excelbe)
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Lakberendezes API",
        Version = "v1",
        Description = "Lakberendezes platform API dokument ci ja"
    });
});

<<<<<<< HEAD
// Add controllers
=======
// controllerek
>>>>>>> 55d865c (Exportálás excelbe)
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

<<<<<<< HEAD
// CORS enged lyez se
app.UseCors("AllowAll");


// Configure the HTTP request pipeline
=======
// CORS engedélyezése
app.UseCors("AllowAll");


// HTTP config
>>>>>>> 55d865c (Exportálás excelbe)
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

<<<<<<< HEAD
// Map controllers for the endpoints
=======
//végpontok beállítása
>>>>>>> 55d865c (Exportálás excelbe)
app.MapControllers();
app.UseStaticFiles();


<<<<<<< HEAD
// Ensure roles exist (USER, ADMIN)
=======

>>>>>>> 55d865c (Exportálás excelbe)
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    await EnsureRolesCreated(roleManager);
}

<<<<<<< HEAD
// Method to ensure roles exist
=======
//Szerepkörök
>>>>>>> 55d865c (Exportálás excelbe)
async Task EnsureRolesCreated(RoleManager<IdentityRole> roleManager)
{
    string[] roleNames = { "USER", "ADMIN" };
    foreach (var roleName in roleNames)
    {
        var roleExist = await roleManager.RoleExistsAsync(roleName);
        if (!roleExist)
        {
            var roleResult = await roleManager.CreateAsync(new IdentityRole(roleName));
            if (!roleResult.Succeeded)
            {
                throw new Exception($"Failed to create role: {roleName}");
            }
        }
    }
}

app.Run();
