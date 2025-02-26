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
    public class ShopsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ShopsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Shops
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Shops>>> Getshops()
        {
            return await _context.shops.ToListAsync();
        }

        // GET: api/Shops/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Shops>> GetShops(int id)
        {
            var shops = await _context.shops.FindAsync(id);

            if (shops == null)
            {
                return NotFound();
            }

            return shops;
        }

        // PUT: api/Shops/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutShops(int id, Shops shops)
        {
            if (id != shops.id)
            {
                return BadRequest();
            }

            _context.Entry(shops).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ShopsExists(id))
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

        // POST: api/Shops
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Shops>> PostShops(Shops shops)
        {
            _context.shops.Add(shops);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetShops", new { id = shops.id }, shops);
        }

        // DELETE: api/Shops/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShops(int id)
        {
            var shops = await _context.shops.FindAsync(id);
            if (shops == null)
            {
                return NotFound();
            }

            _context.shops.Remove(shops);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ShopsExists(int id)
        {
            return _context.shops.Any(e => e.id == id);
        }
    }
}
