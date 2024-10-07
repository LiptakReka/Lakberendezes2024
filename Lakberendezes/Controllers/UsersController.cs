using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Identity;
using NuGet.Common;
using Microsoft.AspNetCore.Authorization;
using BCrypt.Net;


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

        public UsersController(AppDbContext context, UserManager<User> userManager, RoleManager<IdentityRole> roleManager, SignInManager<User> signInManager, JwtService jwtService)
        {
            _context = context;
            _roleManager = roleManager;
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtService = jwtService;

        }

        // GET: api/Users
        //[Authorize(Roles ="ADMIN")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> Getusers()
        {
            return await _context.users.ToListAsync();
        }

        // GET: api/Users/5
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

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id.ToString() != user.Id)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[Authorize]
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }

        [HttpPost("register")]
        public async Task<ActionResult> Register(UserRegisterDTO registerDTO)
        {
            //ellenőrzés hogy van e már email
            if (_context.users.Any(u => u.Email == registerDTO.Email))
            {
                return BadRequest("Ez az e-mail cím már használatban van");
            }
            //jelsző hash
            var passwordHasher = new PasswordHasher<User>();



            //Új felhasználó

            var user = new User
            {
                Email = registerDTO.Email,
                fullname = registerDTO.FullName,
                UserName = registerDTO.Username,
                //jelszó hash
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(registerDTO.Password),
                dateat = DateTime.UtcNow


            };

            var result = await _userManager.CreateAsync(user, registerDTO.Password);
            if (result.Succeeded)
            {
                //ha sikeres a regisztráció szerepkört kap a felhasználó
                await _userManager.AddToRoleAsync(user, "USER");
                return Ok("Felhasználó regisztrálva ");
            }
            return BadRequest(result.Errors);
        }

        //bejelentkezés
        [HttpPost("login")]
        public async Task<ActionResult> Login(UserLoginDTO loginDTO)
        {
            var user = await _userManager.FindByEmailAsync(loginDTO.Email);
            if (user == null)
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }

            //Szerepkörök lekérdezése
            var roles = await _userManager.GetRolesAsync(user);

            //jelszó ellenőr
            var result = await _signInManager.PasswordSignInAsync(user.UserName, loginDTO.Password, false, lockoutOnFailure: false);
            if (!result.Succeeded)
            {
                return Unauthorized("Érvénytelen email vagy jelszó");
            }
            //Jwt token
            var token = _jwtService.GenerateToken(user, roles);
            return Ok(new { token });
        }

        [Authorize(Roles = "ADMIN")]
        [HttpGet("admin")]
        public IActionResult AdminEnd()
        {
            return Ok("Ez a felület admin jogosultságot követel meg.");
        }

        [Authorize(Roles = "USER")]
        [HttpGet("user-only")]
        public IActionResult Useronly()
        {
            return Ok("Felhasználók férhetnek hozzá");
        }

        [HttpPost("AddRoles")]
        //[Authorize(Roles = "USER")]
        public async Task<IActionResult> AddRoles(string email, string role)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                return NotFound("Nem létezik ilyen felhasználó");
            }
            var result = await _userManager.AddToRoleAsync(user, role);
            if (!result.Succeeded)
            {
                return BadRequest("Szerepkör hozzáadása sikertelen.");
            }
            return Ok("Szerepkör hozzáadva");
        }
        [HttpPost("RemoveRoles")]
        //[Authorize(Roles = "Admin")]
        public async Task<IActionResult> RemoveRoles(string email, string role)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                return NotFound("Nem létezik ilyen felhasználó");
            }
            var result = await _userManager.RemoveFromRoleAsync(user, role);
            if (!result.Succeeded)
            {
                return BadRequest("Szerepkör hozzáadása sikertelen.");
            }
            return Ok("Szerepkör eltávolítva");
        }

        // DELETE: api/Users/5
        //[Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserExists(int id)
        {
            return _context.users.Any(e => e.Id.ToString() == id.ToString());
        }
    }
}
