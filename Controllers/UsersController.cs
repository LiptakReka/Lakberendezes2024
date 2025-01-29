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

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        private readonly IConfiguration _config;

        public UsersController(UserManager<User> userManager, SignInManager<User> signInManager, IConfiguration config)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _config = config;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            var users = await _userManager.Users.ToListAsync();
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
        public async Task<IActionResult> Register(RegisterRequestDto registerDTO)
        {
            var existingUser = await _userManager.FindByEmailAsync(registerDTO.Email);
            if (existingUser != null)
            {
                return BadRequest("Ez az email már használatban");
            }
            var user = new User
            {
                UserName = registerDTO.Email,
                Email = registerDTO.Email,
                fullname = registerDTO.fullname,
                datet = DateTime.UtcNow
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
        public async Task<IActionResult> Login(UserLoginDTO loginDTO)
        {
            if (loginDTO == null || string.IsNullOrWhiteSpace(loginDTO.Password))
            {
                return BadRequest("A jelszó nem lehet üres.");
            }

            var user = await _userManager.FindByEmailAsync(loginDTO.Email);
            if (user == null)
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }

            if (await _userManager.IsLockedOutAsync(user))
            {
                return Unauthorized("Ez a fiók zárolva");
            }


            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDTO.Password, false);
            if (!result.Succeeded)
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }

            var roles = await _userManager.GetRolesAsync(user);

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_config["Jwt:Key"]);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
           {
        new Claim(ClaimTypes.NameIdentifier, user.Id),
        new Claim(ClaimTypes.Email, user.Email),
        new Claim(ClaimTypes.Role, roles.FirstOrDefault() ?? "User")
    }),
                Expires = DateTime.UtcNow.AddHours(3),
                Issuer = _config["Jwt:Issuer"],
                Audience = _config["Jwt:Audience"],
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
            };


            var token = tokenHandler.CreateToken(tokenDescriptor);
            var passwordCheck = await _userManager.CheckPasswordAsync(user, loginDTO.Password);
            Console.WriteLine($"Jelszó ellenőrzés eredménye: {passwordCheck}");

            return Ok(new { Token = tokenHandler.WriteToken(token) });
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

            var frontendUrl = _config["FrontendUrl"];
            var resetLink = $"{frontendUrl}/reset-password?token={Uri.EscapeDataString(token)}&email={Uri.EscapeDataString(model.Email)}";
            string emailBody = $@"
        <p>Kattints az alábbi linkre a jelszavad visszaállításához:</p> 
        <a href='{resetLink}'>Visszaállítás</a>";

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

            var tokenStore = new IdentityUserToken<string>
            {
                UserId = user.Id,
                LoginProvider = "ResetPassword",
                Name = "PasswordResetToken",
                Value = model.Token
            };
            var dbcontext = HttpContext.RequestServices.GetService<AppDbContext>();
            dbcontext.UserTokens.Add(tokenStore);
            await dbcontext.SaveChangesAsync();

            return Ok("Jelszó visszaállítva!");
        }



        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            await _userManager.DeleteAsync(user);
            return NoContent();
        }
    }
}

