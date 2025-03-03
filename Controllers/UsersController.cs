using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Lakberendezes.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.AspNetCore.Authorization;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages;
using Microsoft.AspNetCore.Identity.UI.Services;
using Lakberendezes.Data;
using Newtonsoft.Json;
using ClosedXML.Excel;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtService _jwtService;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        private readonly IConfiguration _config;
        public UsersController(AppDbContext context, IConfiguration config, UserManager<User> userManager, RoleManager<IdentityRole> roleManager, SignInManager<User> signInManager, JwtService jwtService)
        {
            _context = context;
            _roleManager = roleManager;
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtService = jwtService;
            _config = config;
        }

        [HttpGet("get-plan/{userId}")]
        public async Task<IActionResult> GetUserPlan(string userId)
        {
            var userPlan = await _context.userplan
                .Include(p => p.Products)
                .Where(p => p.userid == userId)
                .OrderByDescending(p => p.createdat)
                .Select(p => new
                {
                    p.id,
                    createdat = p.createdat.ToString("yyyy-MM-dd HH:mm:ss"),
                    Products = p.Products.Select(pp => new
                    {
                        pp.productid,
                        pp.Product.name,
                        pp.Product.imageurl,
                        pp.Product.price,
                        pp.Product.shoplink,
                        pp.position,
                        pp.scale
                    }).ToList()
                })
                .FirstOrDefaultAsync();

            if (userPlan == null)
            {
                return NotFound("Nincs elmentett terv.");
            }

            return Ok(userPlan);
        }


        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.Users
                .Select(u => new GetUserDTO
                {
                    Id = u.Id ?? "",
                    fullname = u.fullname ?? "",
                    ProfilePictureUrl = u.ProfilePictureUrl ?? "",
                    NormalizedUserName = u.NormalizedUserName ?? "",
                    datet = u.datet,
                    UserName = u.UserName ?? "",
                    Email = u.Email ?? "",
                    NormalizedEmail = u.NormalizedEmail ?? "",
                    PhoneNumber = u.PhoneNumber ?? "",
                    EmailConfirmed = u.EmailConfirmed,
                    PhoneNumberConfirmed = u.PhoneNumberConfirmed,
                    TwoFactorEnabled = u.TwoFactorEnabled,
                    PasswordHash = u.PasswordHash ?? "",
                    SecurityStamp = u.SecurityStamp ?? "",
                    ConcurrencyStamp = u.ConcurrencyStamp ?? "",
                    LockoutEnabled = u.LockoutEnabled,
                    LockoutEnd = u.LockoutEnd,
                    AccessFailedCount = u.AccessFailedCount
                })
                .ToListAsync();

            return Ok(users);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
            {
                return NotFound();
            }
            return user;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromForm] UserRegisterDTO registerDTO)
        {
            var existingUser = await _userManager.FindByEmailAsync(registerDTO.Email);
            if (existingUser != null)
            {
                return BadRequest("Ez az email már használatban");
            }

            string profilePicturePath = "/profile_pictures/default-profile.png"; 

            if (registerDTO.ProfilePictureUrl != null)
            {
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/profile_pictures");
                Directory.CreateDirectory(uploadsFolder);  

                string uniqueFileName = $"{Guid.NewGuid()}_{registerDTO.ProfilePictureUrl.FileName}";
                string filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await registerDTO.ProfilePictureUrl.CopyToAsync(stream);
                }

                profilePicturePath = $"/profile_pictures/{uniqueFileName}"; 
            }

            var user = new User
            {
                UserName = registerDTO.Username,
                Email = registerDTO.Email,
                fullname = registerDTO.FullName,
                datet = DateTime.Now,
                ProfilePictureUrl = profilePicturePath
            };

            var result = await _userManager.CreateAsync(user, registerDTO.Password);
            if (!result.Succeeded)
            {
                return BadRequest(result.Errors);
            }

            await _userManager.AddToRoleAsync(user, "User");
            return Ok("Regisztráció sikeres!");
        }


        [HttpPost("login")]
        public async Task<ActionResult> Login(UserLoginDTO loginDTO)
        {
            var user = await _userManager.FindByEmailAsync(loginDTO.Email);
            if (user == null)
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }


            var roles = await _userManager.GetRolesAsync(user);


            var result = await _signInManager.PasswordSignInAsync(user.UserName, loginDTO.Password, false, lockoutOnFailure: false);
            if (!result.Succeeded)
            {
                return Unauthorized("Érvénytelen email vagy jelszó");
            }


            var token = _jwtService.GenerateToken(user, roles);


            var userData = new
            {
                Id = user.Id,
                Email = user.Email,
                UserName = user.UserName,
                Roles = roles,
                profilePictureUrl = user.ProfilePictureUrl ?? "default-profile.png",
            };

            return Ok(new { token, user = userData });
        }

        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] UserChangePasswordDTO model)
        {
            if (model == null || string.IsNullOrEmpty(model.Email) || string.IsNullOrEmpty(model.CurrentPassword) || string.IsNullOrEmpty(model.NewPassword))
            {
                return BadRequest("Minden mező kitöltése kötelező");
            }
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
            {
                return NotFound("Felhasználó nem található");
            }
            var passwordCheck = await _userManager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);
            if (!passwordCheck.Succeeded)
            {
                return BadRequest(passwordCheck.Errors);
            }
            return Ok(new { message = "Jelszó sikeresen módosítva!" });
        }
        [AllowAnonymous]
        [HttpPost("upload-profile-picture")]
        public async Task<IActionResult> UploadProfilePicture(IFormFile file, [FromForm] string email)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("Nincs kiválasztott fájl.");
            }


            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "profile_pictures");
            if (!Directory.Exists(uploadsFolder))
            {
                Directory.CreateDirectory(uploadsFolder);
            }

            var uniqueFileName = $"{Guid.NewGuid()}_{Path.GetFileName(file.FileName)}";
            var filePath = Path.Combine(uploadsFolder, uniqueFileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            var imageUrl = $"/profile_pictures/{uniqueFileName}";

            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                return NotFound("Felhasználó nem található.");
            }

            user.ProfilePictureUrl = imageUrl;
            await _userManager.UpdateAsync(user);

            return Ok(new { imageUrl });
        }

        [HttpPost("save-plan")]
        public async Task<IActionResult> SaveUserPlan([FromBody] UserPlanDTO planDTO)
        {
            var user = await _userManager.FindByIdAsync(planDTO.UserId);
            if (user == null)
            {
                return NotFound("Felhasználó nem található.");
            }

            var userPlan = new UserPlans
            {
                userid = planDTO.UserId,
                plandata = planDTO.PlanData,

                createdat = DateTime.Now
            };

            _context.userplan.Add(userPlan);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Terv sikeresen elmentve!", planId = userPlan.id });
        }





        [HttpPost("forgotpass")]
        public async Task<IActionResult> Forgotpass(ForgotPasswordDTO model, [FromServices] Lakberendezes.Models.IEmailSender emailSender)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
            {
                return BadRequest("Nincs ilyen email cím regisztrálva.");
            }

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);

            Console.WriteLine(token);

            var frontendUrl = _config["FrontendUrl"];
            var resetLink = $"{frontendUrl}/reset-password?token={Uri.EscapeDataString(token)}&email={Uri.EscapeDataString(model.Email)}";


            string emailBody = $@"
<!DOCTYPE html>
<html lang='hu'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <meta name='color-scheme' content='light dark'>
    <meta name='supported-color-schemes' content='light dark'>
    <title>Jelszó visszaállítás - RoomLab</title>
    <style>
        /* Reset styles */
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}

        /* Base styles */
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #f5f5f5;
            padding: 20px;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }}

        /* Container styles */
        .email-wrapper {{
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        }}

        /* Header styles */
        .email-header {{
            background: linear-gradient(135deg, #6a57d4 0%, #5438d7 100%);
            padding: 40px 20px;
            text-align: center;
            color: #ffffff;
        }}

        .logo {{
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #ffffff !important;
            -webkit-text-fill-color: #ffffff;
        }}

        /* Button styles */
        .reset-button {{
            display: inline-block;
            background: #6a57d4 !important;
            color: #ffffff !important;
            text-decoration: none !important;
            padding: 16px 32px !important;
            border-radius: 8px !important;
            font-weight: 600 !important;
            font-size: 16px !important;
            -webkit-text-size-adjust: none;
            -webkit-text-fill-color: #ffffff;
            mso-hide: all;
            text-align: center;
        }}

        /* Mobile styles */
        @media screen and (max-width: 600px) {{
            .email-wrapper {{
                border-radius: 0;
            }}

            .reset-button {{
                display: block;
                width: 100%;
                text-align: center;
                padding: 16px 24px !important;
            }}
        }}

        /* Dark mode support */
        @media (prefers-color-scheme: dark) {{
            body {{
                background: #1a1a1a;
                color: #ffffff;
            }}

            .email-wrapper {{
                background: #2d2d2d;
            }}

            .notice-box {{
                background: #363636;
            }}

            .notice-text {{
                color: #e0e0e0;
            }}
        }}
    </style>
</head>
<body>
    <div class='email-wrapper'>
        <div class='email-header'>
            <div class='logo'>RoomLab</div>
            <div style='color: #ffffff; font-size: 16px; font-weight: 500;'>Jelszó visszaállítás</div>
        </div>
        
        <div style='padding: 40px 32px;'>
            <h1 style='font-size: 20px; font-weight: 600; color: #2d3748; margin-bottom: 24px;'>
                Kedves {user.UserName}!
            </h1>
            
            <p style='color: #4a5568; font-size: 16px; margin-bottom: 32px;'>
                Kérést kaptunk a RoomLab fiókod jelszavának visszaállítására. Az alábbi gombra kattintva tudod megváltoztatni a jelszavad:
            </p>
            
            <div style='text-align: center; margin: 32px 0;'>
                <a href='{resetLink}' 
                   style='background: #6a57d4; color: #ffffff !important; text-decoration: none; display: inline-block; padding: 16px 32px; border-radius: 8px; font-weight: 600; font-size: 16px; -webkit-text-fill-color: #ffffff;'>
                    Jelszó visszaállítása
                </a>
            </div>
            
            <div style='background: #f8fafc; border-left: 4px solid #6a57d4; padding: 16px; margin: 32px 0; border-radius: 4px;'>
                <p style='color: #64748b; font-size: 14px; margin: 0;'>
                    <strong>Fontos:</strong> A biztonsági link 24 órán belül lejár. Ha nem te kérted a jelszó visszaállítását, 
                    nyugodtan hagyd figyelmen kívül ezt az emailt - a fiókod biztonságban van.
                </p>
            </div>
        </div>
        
        <div style='background: #f8fafc; padding: 32px; text-align: center; border-top: 1px solid #e2e8f0;'>
            <p style='color: #64748b; font-size: 14px; margin-bottom: 16px;'>
                Üdvözlettel,<br>
                <strong>RoomLab Csapat</strong> 🎨
            </p>
        </div>
    </div>
</body>
</html>";

            await emailSender.SendEmailAsync(model.Email, "Jelszó visszaállítása", emailBody);

            return Ok("Ha az email cím helyes, egy visszaállítási linket küldtünk.");
        }


        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword(ResetPasswordDTO model)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
            {
                return BadRequest("Felhasználó nem található");
            }

            var result = await _userManager.ResetPasswordAsync(user, model.Token, model.NewPassword);
            if (!result.Succeeded)
            {
                return BadRequest("Hibás vagy lejárt token");
            }

            var dbcontext = HttpContext.RequestServices.GetService<AppDbContext>();


            var existingToken = await dbcontext.UserTokens
                .FirstOrDefaultAsync(t => t.UserId == user.Id && t.LoginProvider == "ResetPassword" && t.Name == "PasswordResetToken");

            if (existingToken != null)
            {
                dbcontext.UserTokens.Remove(existingToken);
                await dbcontext.SaveChangesAsync();
            }


            var tokenStore = new IdentityUserToken<string>
            {
                UserId = user.Id,
                LoginProvider = "ResetPassword",
                Name = "PasswordResetToken",
                Value = model.Token
            };
            dbcontext.UserTokens.Add(tokenStore);
            await dbcontext.SaveChangesAsync();

            return Ok("Jelszó visszaállítva!");
        }

        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var users = _context.Users.ToList();

            if (users == null || !users.Any())
            {
                return NotFound("Nincsenek felhasználók");
            }
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Felhasználók");

                worksheet.Cell(1, 1).Value = "Azonosító";
                worksheet.Cell(1, 2).Value = "Email";
                worksheet.Cell(1, 3).Value = "Teljes név";
                worksheet.Cell(1, 4).Value = "Regisztrált";
                worksheet.Cell(1, 5).Value = "Hozzáférés megadva";
                worksheet.Cell(1, 6).Value = "Konkurencia bélyeg ";
                worksheet.Cell(1, 7).Value = "Kizárás engedélyezve";
                worksheet.Cell(1, 8).Value = "Kizárás vége";
                worksheet.Cell(1, 9).Value = "Email normalizálva";
                worksheet.Cell(1, 10).Value = "Felhasználónév normalizálva";
                worksheet.Cell(1, 11).Value = "Jelszóhash";
                worksheet.Cell(1, 12).Value = "Telefonszám";
                worksheet.Cell(1, 13).Value = "Telefonszám megerősítve";
                worksheet.Cell(1, 14).Value = "Biztonsági bélyeg";
                worksheet.Cell(1, 15).Value = "Két faktoros hitelesítés";
                worksheet.Cell(1, 16).Value = "Felhasználónév";
                worksheet.Cell(1, 17).Value = "Profilkép URL";

                int row = 2;
                foreach (var user in users)
                {
                    worksheet.Cell(row, 1).Value = user.Id;
                    worksheet.Cell(row, 2).Value = user.Email;
                    worksheet.Cell(row, 3).Value = user.fullname;
                    worksheet.Cell(row, 4).Value = user.datet;
                    worksheet.Cell(row, 5).Value = user.AccessFailedCount;
                    worksheet.Cell(row, 6).Value = user.ConcurrencyStamp;
                    worksheet.Cell(row, 7).Value = user.LockoutEnabled;
                    worksheet.Cell(row, 8).Value = user.LockoutEnd.ToString();
                    worksheet.Cell(row, 9).Value = user.NormalizedEmail;
                    worksheet.Cell(row, 10).Value = user.NormalizedUserName;
                    worksheet.Cell(row, 11).Value = user.PasswordHash;
                    worksheet.Cell(row, 12).Value = user.PhoneNumber;
                    worksheet.Cell(row, 13).Value = user.PhoneNumberConfirmed;
                    worksheet.Cell(row, 14).Value = user.SecurityStamp;
                    worksheet.Cell(row, 15).Value = user.TwoFactorEnabled;
                    worksheet.Cell(row, 16).Value = user.UserName;
                    worksheet.Cell(row, 17).Value = user.ProfilePictureUrl;
                    row++;

                }
                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "felhasznalok.xlsx");
                }
            }

        }

        [HttpDelete("{userName}")]
        public async Task<IActionResult> DeleteUserByName(string userName)
        {
            var user = await _context.Users
                .Where(u => u.UserName != null && u.UserName == userName)
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound(new { message = "Felhasználó nem található!" });
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = $"A(z) {userName} felhasználó törölve lett." });
        }

    }
}

