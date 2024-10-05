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

        // GET: api/UserPlans
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserPlans>>> Getuserplan()
        {
            return await _context.userplan.ToListAsync();
        }

        // GET: api/UserPlans/5
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

        // PUT: api/UserPlans/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
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

        // POST: api/UserPlans
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<UserPlans>> PostUserPlans(UserPlans userPlans)
        {
            _context.userplan.Add(userPlans);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUserPlans", new { id = userPlans.id }, userPlans);
        }

        // DELETE: api/UserPlans/5
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
            return _context.userplan.Any(e => e.id == id);
        }
    }
}
