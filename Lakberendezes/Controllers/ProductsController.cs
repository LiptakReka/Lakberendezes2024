using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lakberendezes.Data;
using Lakberendezes.Models;
using Microsoft.AspNetCore.Authorization;


namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProductsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/Products
        [Authorize]
        [HttpGet]
        
        public async Task<ActionResult<IEnumerable<Product>>> Getproducts()
        {
            return await _context.products.ToListAsync();
        }

        [HttpGet("search")]
        
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts
        (
            decimal? minimum,
            decimal? maximum,
            int? roomId,
            string? Név

        )
        {
            var lekerdezes=_context.products.AsQueryable();

            if (minimum.HasValue)
            {
                lekerdezes = lekerdezes.Where(p => p.price >= minimum.Value);

            }

            if (maximum.HasValue)
            {
                lekerdezes=lekerdezes.Where(p=>p.price>=maximum.Value);
            }

            if (roomId.HasValue)
            {
                lekerdezes=lekerdezes.Where(p=>p.roomid >= roomId.Value);
            }

            if (!string.IsNullOrEmpty(Név))
            {
                lekerdezes=lekerdezes.Where(_ => _.name.Contains(Név));
            }
            return await 
                lekerdezes.ToListAsync();

        }

        // GET: api/Products/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var product = await _context.products.FindAsync(id);

            if (product == null)
            {
                return NotFound();
            }

            return product;
        }

        // PUT: api/Products/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProduct(int id, Product product)
        {
            if (id != product.id)
            {
                return BadRequest();
            }

            _context.Entry(product).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductExists(id))
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

        // POST: api/Products
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [Authorize(Roles ="Admin")]
        [HttpPost]

        public async Task<ActionResult<Product>> PostProduct(Product product)
        {

            if (Uri.IsWellFormedUriString(product.shoplink, UriKind.Absolute))
            {
                return BadRequest("Érvénytelen link");
            }
            _context.products.Add(product);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProduct", new { id = product.id }, product);
        }

        // DELETE: api/Products/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            var product = await _context.products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            _context.products.Remove(product);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProductExists(int id)
        {
            return _context.products.Any(e => e.id == id);
        }
    }
}
