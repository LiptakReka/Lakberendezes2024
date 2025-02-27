using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lakberendezes.Data;
using Lakberendezes.Models;
using Newtonsoft.Json;

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

        [HttpGet("get-products/{planId}")]
        public async Task<IActionResult> GetPlanProducts(int planId)
        {
            var planproducTs= await _context.planproducts
                .Where(p=>p.userplanid == planId)
                .Select(p=> new
                {
                    p.id,
                    p.productid,
                    p.position,
                    p.scale
                })
                .ToListAsync();
            if(!planproducTs.Any() )
            {
                return NotFound("A tervhez nem tartozik termék");
            }
            return Ok(planproducTs);
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

<<<<<<< HEAD
        // PUT: api/PlanProducts/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
=======
        
>>>>>>> 55d865c (Exportálás excelbe)
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

<<<<<<< HEAD
        // POST: api/PlanProducts
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
=======
     
>>>>>>> 55d865c (Exportálás excelbe)
        [HttpPost]
        public async Task<ActionResult<PlanProduct>> PostPlanProduct(PlanProduct planProduct)
        {
            _context.planproducts.Add(planProduct);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPlanProduct", new { id = planProduct.id }, planProduct);
        }

        [HttpPost("save")]
        public async Task<IActionResult> SavePlanProducts([FromBody] PlanProductDTO plan)
        {
            var userplan = await _context.userplan.FirstOrDefaultAsync(p => p.id == plan.UserPlanId);
            if (userplan == null)
            {
                return NotFound("A terv nem található");
            }

<<<<<<< HEAD
            // 🔹 JSON adat deszerializálása
=======
           
>>>>>>> 55d865c (Exportálás excelbe)
            var planproducts = JsonConvert.DeserializeObject<List<PlanProductItemDTO>>(plan.PlanData);

            if (planproducts == null || !planproducts.Any())
            {
                return BadRequest("A terv üres vagy hibás formátumú.");
            }

            foreach (var product in planproducts)
            {
                var planProduct = new PlanProduct
                {
                    userplanid = userplan.id,
                    productid = product.ProductId,
                    position = $"{product.X}, {product.Y}",
<<<<<<< HEAD
                    scale=product.scale// 🔹 Az egyes termékek X és Y pozíciója
=======
                    scale=product.scale
>>>>>>> 55d865c (Exportálás excelbe)
                };

                _context.planproducts.Add(planProduct);
            }

            await _context.SaveChangesAsync();

            return Ok(new { message = "Terv termékei sikeresen elmentve!" });
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
