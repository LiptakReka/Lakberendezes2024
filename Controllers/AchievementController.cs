using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AchievementController : ControllerBase
    {
        private readonly AppDbContext _context;
        public AchievementController(AppDbContext context)
        {
            _context = context;
        }

        [Authorize(Roles = "Admin")]
        //Összes Achievement
        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<Achievement>>> GetAchievements()
        {

            return await _context.achievements.ToListAsync();
        }

        [Authorize(Roles ="User,Admin")]
        [HttpGet("me")]
        public async Task<ActionResult<IEnumerable<Achievement>>> GetUserAchievement()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId==null)
            {
                return Unauthorized("Nincs bejelentkezve felhasználó");
            }

            var achievement = await _context.achievements
                .Where(a => a.user_Id.ToString() == userId)
                .ToListAsync();

            if (!achievement.Any())
            {
                return NotFound("Nincsenek achivementjeid");
            }
            return Ok(achievement);
        }
        //User alapú achievement
        [Authorize(Roles = "User,Admin")]
        [HttpGet("{UserId}")]
        public async Task<ActionResult<IEnumerable<Achievement>>>GetAchievement(int UserId)
        {
            var achievement = await _context.achievements
                .Where(a => a.user_Id== UserId)
                .ToListAsync();
            if (!achievement.Any())
            {
                return NotFound("Nincsenek még achievementjeid");
            }
            return Ok(achievement);
        }

        [Authorize(Roles = "Admin,User")]
        //Új achievement kezelése
        [Authorize(Roles = "User,Admin")]
        [HttpPost("new")]
        public async Task<ActionResult<Achievement>> CreateAchievement(Achievement achievement)
        {
            achievement.id = Guid.NewGuid(); 
            achievement.created_at = DateTime.Now; 

            _context.achievements.Add(achievement);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAchievement), new { Userid = achievement.user_Id }, achievement);
        }

        [Authorize(Roles = "Admin")]
        //Achievement törlése
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAchievement(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var achievement = await _context.achievements.FindAsync(id);
            if (achievement == null)
            {
                return NotFound("Nem található achievement");
            }

            _context.achievements.Remove(achievement);
            await _context.SaveChangesAsync();

            return Ok("Törölve");
        }

    }
}
