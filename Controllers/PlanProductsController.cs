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
    public class PlanProductsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PlanProductsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/PlanProducts
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PlanProduct>>> Getplanproducts()
        {
            return await _context.planproducts.ToListAsync();
        }

        // GET: api/PlanProducts/5
        [HttpGet("{id}")]
        public async Task<ActionResult<PlanProduct>> GetPlanProduct(int id)
        {
            var planProduct = await _context.planproducts.FindAsync(id);

            if (planProduct == null)
            {
                return NotFound();
            }

            return planProduct;
        }

        // PUT: api/PlanProducts/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPlanProduct(int id, PlanProduct planProduct)
        {
            if (id != planProduct.id)
            {
                return BadRequest();
            }

            _context.Entry(planProduct).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PlanProductExists(id))
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

        // POST: api/PlanProducts
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<PlanProduct>> PostPlanProduct(PlanProduct planProduct)
        {
            _context.planproducts.Add(planProduct);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPlanProduct", new { id = planProduct.id }, planProduct);
        }

        // DELETE: api/PlanProducts/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlanProduct(int id)
        {
            var planProduct = await _context.planproducts.FindAsync(id);
            if (planProduct == null)
            {
                return NotFound();
            }

            _context.planproducts.Remove(planProduct);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PlanProductExists(int id)
        {
            return _context.planproducts.Any(e => e.id == id);
        }
    }
}
