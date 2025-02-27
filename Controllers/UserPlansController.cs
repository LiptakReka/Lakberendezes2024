using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lakberendezes.Data;
using Lakberendezes.Models;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserPlansController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserPlansController(AppDbContext context)
        {
            _context = context;
        }

<<<<<<< HEAD
        // GET: api/UserPlans
=======
       
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserPlans>>> Getuserplan()
        {
            return await _context.userplan.ToListAsync();
        }

<<<<<<< HEAD
        // GET: api/UserPlans/5
=======
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpGet("{id}")]
        public async Task<ActionResult<UserPlans>> GetUserPlans(int id)
        {
            var userPlans = await _context.userplan.FindAsync(id);

            if (userPlans == null)
            {
                return NotFound();
            }

            return userPlans;
        }

<<<<<<< HEAD
        // PUT: api/UserPlans/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
=======
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUserPlans(int id, UserPlans userPlans)
        {
            if (id != userPlans.id)
            {
                return BadRequest();
            }

            _context.Entry(userPlans).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserPlansExists(id))
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

<<<<<<< HEAD
        // POST: api/UserPlans
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
=======
  
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpPost]
        public async Task<ActionResult<UserPlans>> PostUserPlans( UserPlans userPlans)
        {
            _context.userplan.Add(userPlans);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUserPlans", new { id = userPlans.id }, userPlans);
        }

<<<<<<< HEAD
        // DELETE: api/UserPlans/5
=======
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUserPlans(int id)
        {
            var userPlans = await _context.userplan.FindAsync(id);
            if (userPlans == null)
            {
                return NotFound();
            }

            _context.userplan.Remove(userPlans);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool UserPlansExists(int id)
        {
            return _context.userplan.Any(e => e.id.ToString() == id.ToString());
        }
    }
}
