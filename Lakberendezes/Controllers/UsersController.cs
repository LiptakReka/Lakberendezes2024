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


namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtService _jwtService;

        public UsersController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [Authorize]
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
            if (id != user.id)
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
        [Authorize]
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.id }, user);
        }

        [HttpPost("register")]
        public async Task<ActionResult> Register(UserRegisterDTO registerDTO)
        {
            //ellenőrzés hogy van e már email
            if (_context.users.Any(u=> u.email==registerDTO.Email))
            {
                return BadRequest("Ez az e-mail cím már használatban van");
            }
            //jelsző hash
            var passwordHasher = new PasswordHasher<User>();



            //Új felhasználó

            var user = new User
            {
                email=registerDTO.Email,
                fullname=registerDTO.FullName,
               
                datet=DateTime.UtcNow

            };
            user.PASSWORD_hash = passwordHasher.HashPassword(user, registerDTO.Password);

            _context.users.Add(user);
            await _context.SaveChangesAsync();
            return Ok("Regisztráció sikeres!");
        }

        //bejelentkezés
        [HttpPost("login")]
        public async Task<ActionResult> Login(UserLoginDTO loginDTO)
        {
            var user = await _context.users.SingleOrDefaultAsync(u => u.email==loginDTO.Email);
            if (user == null)
            {
                return Unauthorized("Hibás email vagy jelszó.");
            }


            var passwordHasher = new PasswordHasher<User>();
            var result=passwordHasher.VerifyHashedPassword(user,user.PASSWORD_hash, loginDTO.Password);

            if (result== PasswordVerificationResult.Failed)
            {
                return Unauthorized("Hibás jelszó és vagy email.");
            }

            //Jwt token
            var token = _jwtService.GenerateToken(user);
            return Ok(new {Token=token});
        }

        // DELETE: api/Users/5
        [Authorize]
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
            return _context.users.Any(e => e.id == id);
        }
    }
}
