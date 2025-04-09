using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Lakberendezes.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.UI.Services;
using Lakberendezes.Data;
using Newtonsoft.Json;
using ClosedXML.Excel;
using Lakberendezes.Models.DTO;
using Lakberendezes.Models.Service;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly CloudinaryService _cloudinaryService;
        private readonly AppDbContext _context;
        private readonly JwtService _jwtService;
        private readonly IConfiguration _config;
        public UsersController(CloudinaryService cloudinaryService, AppDbContext context, IConfiguration config, JwtService jwtService)
        {
            _context = context;
            _cloudinaryService = cloudinaryService;
            _jwtService = jwtService;
            _config = config;
        }

        [Authorize(Roles = "User,Admin")]
        //Terv lekérése felhasználó alapján
        [HttpGet("get-plan/{userId}")]
        public async Task<IActionResult> GetUserPlan(int userId)
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

        [Authorize(Roles = "Admin")]
        //Összes felhasználó lekérése
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.users
                .Select(u => new GetUserDTO
                {
                    Id = u.Id,
                    fullname = u.fullname ?? "",
                    ProfilePictureUrl = u.ProfilePictureUrl ?? "",
                    datet = u.datet,
                    UserName = u.UserName ?? "",
                    Email = u.Email ?? "",
                    PasswordHash = u.PasswordHash ?? ""
                })
                .ToListAsync();

            return Ok(users);
        }

        [Authorize(Roles = "Admin")]
        //Felhasználó keresése id alapján
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }
            return user;
        }

        [HttpPost("register")]
        //Új felhasználó regisztrálása
        public async Task<IActionResult> Register([FromForm] UserRegisterDTO registerDTO)
        {
            var existingUser = await _context.users.FirstOrDefaultAsync(u => u.Email == registerDTO.Email);
            if (existingUser != null)
            {
                return BadRequest("Ez az email már használatban");
            }
            var existingname = await _context.users.FirstOrDefaultAsync(u => u.UserName == registerDTO.Username);
            if (existingname != null)
            {
                return BadRequest("Ez a felhasználónév már használatban");
            }

            if (!isvalidPassword(registerDTO.Password))
            {
                return BadRequest("A jelszónak tartalmaznia kell legalább egy speciális karaktert, egy számot , egy nagybetűt, és egy kis betűt.");
            }
            //profilkép feltöltése felhőbe
            string profilePicturePath = "https://res.cloudinary.com/dd10jzece/image/upload/v1743009597/profile_pictures/apoghzaa8cj77vnj3d0y.jpg";

            if (registerDTO.ProfilePictureUrl != null)
            {
                try
                {
                    profilePicturePath = await _cloudinaryService.UploadImage(registerDTO.ProfilePictureUrl);
                }
                catch (Exception ex)
                {
                    return BadRequest(ex.Message);
                }
            }

            var user = new User
            {
                UserName = registerDTO.Username,
                Email = registerDTO.Email,
                fullname = registerDTO.FullName,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(registerDTO.Password),//jelszó hashelése
                datet = DateTime.Now,
                ProfilePictureUrl = profilePicturePath
            };

            _context.users.Add(user);
            await _context.SaveChangesAsync();

            var role = await _context.role.FirstOrDefaultAsync(r => r.name == "User");
            if (role == null)
            {
                return BadRequest("A 'User' szerepkör nem található.");
            }

            var userRole = new UserRole
            {
                Userid = user.Id,
                Roleid = role.id
            };
            _context.userroles.Add(userRole);
            await _context.SaveChangesAsync();

            return Ok("Regisztráció sikeres!");
        }

        private bool isvalidPassword(string password) //A jelszó követelmények ellenőrzése
        {
            if (password.Length < 8)
            {
                return false;
            }
            bool hasUpper = false, hasLower = false, hasDigit = false, hasSpecial = false;
            foreach (var c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                else if (char.IsLower(c)) hasLower = true;
                else if (char.IsDigit(c)) hasDigit = true;
                else if (char.IsSymbol(c) || char.IsPunctuation(c)) hasSpecial = true;
            }
            return hasUpper && hasLower && hasDigit && hasSpecial;
        }


        [HttpPost("login")]
        //Felhasználó bejelentkezése
        public async Task<ActionResult> Login(UserLoginDTO loginDTO)
        {
            var user = await _context.users.Include(u => u.roles).ThenInclude(ur => ur.Role).FirstOrDefaultAsync(u => u.Email == loginDTO.Email);
            if (user == null || !BCrypt.Net.BCrypt.Verify(loginDTO.Password, user.PasswordHash))
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }

            var roles = user.roles.Select(ur => ur.Role.name).ToList();
            var token = _jwtService.GenerateToken(user, roles);

            var userData = new
            {
                Id = user.Id,
                Email = user.Email,
                UserName = user.UserName,
                Roles = roles,
                ProfilePictureUrl = user.ProfilePictureUrl ?? "default-profile.png",
            };

            return Ok(new { token, user = userData });
        }

        [Authorize(Roles = "User,Admin")]
        //Jelszó módosítása
        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] UserChangePasswordDTO model)
        {
            if (model == null || string.IsNullOrEmpty(model.Email) || string.IsNullOrEmpty(model.CurrentPassword) || string.IsNullOrEmpty(model.NewPassword))
            {
                return BadRequest("Minden mező kitöltése kötelező");
            }
            var user = await _context.users.FirstOrDefaultAsync(u => u.Email == model.Email);
            if (user == null || !BCrypt.Net.BCrypt.Verify(model.CurrentPassword, user.PasswordHash))
            {
                return NotFound("Felhasználó nem található vagy a jelenlegi jelszó hibás");
            }

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
            _context.users.Update(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Jelszó sikeresen módosítva!" });
        }

        [Authorize(Roles = "Admin, User")]
        //Profilkép lekérése
        [HttpGet("profilepic")]
        public async Task<IActionResult> GetProfilePicture([FromQuery] string email)
        {
            try
            {
                var user = await _context.users.FirstOrDefaultAsync(u => u.Email == email);
                if (user == null)
                {
                    return NotFound("Felhasználó nem található");
                }
                var profilePictureUrl = string.IsNullOrEmpty(user.ProfilePictureUrl)
                    ? "/default_profile.png"
                    : user.ProfilePictureUrl;
                return Ok(new { profilePictureUrl });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);

            }
        }

        [Authorize(Roles = "User,Admin")]
        //Profilkép feltöltése
        [HttpPost("upload-profile-picture")]
        public async Task<IActionResult> UploadProfilePicture(IFormFile file, [FromForm] string email)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("Nincs kiválasztott fájl.");
            }

            try
            {
                var imageUrl = await _cloudinaryService.UploadImage(file);
                var user = await _context.users.FirstOrDefaultAsync(u => u.Email == email);
                if (user==null)
                {
                    return NotFound("A felhasználó nem található");
                }
                user.ProfilePictureUrl = imageUrl;
                _context.users.Update(user);
                await _context.SaveChangesAsync();
                return Ok(new { imageUrl });
            }
            catch (Exception ex)
            {

                return BadRequest(ex.Message);
            }
           
        }

        [Authorize(Roles = "User,Admin")]
        //Terv mentése felhasználóhoz
        [HttpPost("save-plan")]
        public async Task<IActionResult> SaveUserPlan([FromBody] UserPlanDTO planDTO)
        {
            var user = await _context.users.FindAsync(planDTO.UserId);
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
        //Jelszó visszaállítási kérelem
        public async Task<IActionResult> Forgotpass(ForgotPasswordDTO model, [FromServices] Models.IEmailSender emailSender)
        {
            var user = await _context.users.FirstOrDefaultAsync(u => u.Email == model.Email);
            if (user == null)
            {
                return BadRequest("Nincs ilyen email cím regisztrálva.");
            }

            var token = Guid.NewGuid().ToString();
            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(token);
            _context.users.Update(user);
            await _context.SaveChangesAsync();

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
        //Jelszó visszaállítása
        public async Task<IActionResult> ResetPassword(ResetPasswordDTO model)
        {
            var user = await _context.users.FirstOrDefaultAsync(u => u.Email == model.Email);
            if (user == null)
            {
                return BadRequest("Felhasználó nem található");
            }

            if (!BCrypt.Net.BCrypt.Verify(model.Token, user.PasswordHash))
            {
                return BadRequest("Hibás vagy lejárt token");
            }

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
            _context.users.Update(user);
            await _context.SaveChangesAsync();

            return Ok("Jelszó visszaállítva!");
        }

        [Authorize(Roles="Admin")]
        //Összes role lekérése
        [HttpGet("allrole")]
        public async Task<ActionResult<IEnumerable<Roles>>>AllRole()
        {
            var roles = await _context.userroles.Select(r => new
            {
                r.Userid,
                r.Roleid
            }).ToListAsync();
            return Ok(roles);
        }


        [Authorize(Roles = "Admin")]
        //Role hozzáadása felhasználóhoz
        [HttpPost("Add-Role")]
        public async Task<IActionResult> AddROle([FromBody] UserRoleDTOcs userRole)
        {
            var user = await _context.users.FirstOrDefaultAsync(u => u.Id == userRole.UserId);
            if (user == null)
            {
                return NotFound("Nem található felhasználó");
            }
            var rolee = await _context.role.FirstOrDefaultAsync(r => r.name == userRole.Rolename);
            if (rolee == null)
            {
                return BadRequest("Nincs ilyen role");
            }

            if (user.roles.Any(ur => ur.Roleid == rolee.id))
            {
                return BadRequest("A felhasználó már rendelkezik ezzel a role-al");
            }

            var userRoleEntity = new UserRole
            {
                Userid = user.Id,
                Roleid = rolee.id
            };

            _context.userroles.Add(userRoleEntity);
            await _context.SaveChangesAsync();
            return Ok("Role hozzáadva");
        }


        [Authorize(Roles = "Admin")]
        //Role törlése felhasználótól
        [HttpDelete("{userId}/Remove-Role/{roleId}")]
        public async Task<IActionResult> RemoveRole(int userId, int roleId)
        {
            var user = await _context.users.Include(u => u.roles).FirstOrDefaultAsync(u => u.Id == userId);
            if (user == null)
            {
                return NotFound("Nincs ilyen felhasználó");
            }

            var role = await _context.role.FindAsync(roleId);
            if (role == null)
            {
                return NotFound("Nincs ilyen role");
            }

            var userRole = user.roles.FirstOrDefault(ur => ur.Roleid == role.id);
            if (userRole == null)
            {
                return BadRequest("Felhasználó nem rendelkezik ezzel a role-al");
            }

            _context.userroles.Remove(userRole);
            await _context.SaveChangesAsync();

            return Ok("Role törölve");
        }



        [Authorize(Roles = "Admin")]
        //Felhasználók exportálása Excel fájlba wpf-hez
        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var users = _context.users.ToList();

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
                worksheet.Cell(1, 5).Value = "Jelszóhash";
                worksheet.Cell(1, 6).Value = "Felhasználónév";
                worksheet.Cell(1, 7).Value = "Profilkép URL";

                int row = 2;
                foreach (var user in users)
                {
                    worksheet.Cell(row, 1).Value = user.Id;
                    worksheet.Cell(row, 2).Value = user.Email;
                    worksheet.Cell(row, 3).Value = user.fullname;
                    worksheet.Cell(row, 4).Value = user.datet;
                    worksheet.Cell(row, 5).Value = user.PasswordHash;
                    worksheet.Cell(row, 6).Value = user.UserName;
                    worksheet.Cell(row, 7).Value = user.ProfilePictureUrl;
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

        [Authorize(Roles = "Admin,User")]
        //Felhasználó törlése név alapján
        [HttpDelete("{userName}")]
        public async Task<IActionResult> DeleteUserByName(string userName)
        {
            var user = await _context.users
                .Where(u => u.UserName != null && u.UserName == userName)
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound(new { message = "Felhasználó nem található!" });
            }

            _context.users.Remove(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = $"A(z) {userName} felhasználó törölve lett." });
        }

    }
}
