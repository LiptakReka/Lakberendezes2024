using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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
<<<<<<< HEAD

=======
        //Összes Achievement
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<Achievement>>> GetAchievements()
        {

            return await _context.achievements.ToListAsync();
        }
<<<<<<< HEAD

=======
        //User alapú achievement
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpGet("{UserId}")]
        public async Task<ActionResult<IEnumerable<Achievement>>>GetAchievement(string UserId)
        {
            var achievement = await _context.achievements
                .Where(a => a.user_Id == UserId)
                .ToListAsync();
            if (!achievement.Any())
            {
                return NotFound("Nincsenek még achievementjeid");
            }
            return Ok(achievement);
        }
<<<<<<< HEAD

=======
        //Új achievement kezelése
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpPost("new")]
        public async Task<ActionResult<Achievement>> CreateAchievement(Achievement achievement)
        {
            achievement.id = Guid.NewGuid(); 
            achievement.created_at = DateTime.Now; 
<<<<<<< HEAD
            achievement.id = Guid.NewGuid(); // Generálunk egy új GUID azonosítót
            achievement.created_at = DateTime.UtcNow; // Beállítjuk az időbélyeget
=======
            achievement.id = Guid.NewGuid(); 
            achievement.created_at = DateTime.UtcNow; 
>>>>>>> 55d865c (Exportálás excelbe)

            _context.achievements.Add(achievement);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAchievement), new { UserId = achievement.user_Id }, achievement);
        }

<<<<<<< HEAD
=======
        //Achievement törlése
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAchievement(Guid id)
        {
            var achievement = await _context.achievements.FindAsync(id);
            if (achievement == null)
            {
                return NotFound();
            }

            _context.achievements.Remove(achievement);
            await _context.SaveChangesAsync();

            return Ok("Törölve");
        }

    }
}
