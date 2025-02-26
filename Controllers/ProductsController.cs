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
using System.Composition;
using System.Text;
using Org.BouncyCastle.Asn1.Cms;


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
       
        [HttpGet]
        
        public async Task<ActionResult<IEnumerable<Product>>> Getproducts()
        {
            return await _context.products.ToListAsync();
        }

        //[Authorize(Roles ="User")]
        [HttpGet("szobák")]
        public async Task<IActionResult> GetProductsByCategory([FromQuery] int? roomId)
        {
            if (roomId == null)
            {
                // Ha nincs kategória megadva, az összes terméket visszaadja
                return Ok(await _context.products.ToListAsync());
            }

            // Ha van kategória, szűrés
            var products = await _context.products
                                         .Where(p => p.roomid == roomId)
                                         .ToListAsync();

            return Ok(products);
        }
        //[Authorize(Roles ="USER")]
        [HttpGet("search/{name}")]
        
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts(string name)
        {
            var products=await _context.products
                .Where(p=>p.name.Contains(name))
                .ToListAsync();
            if (products.Count==0)
            {
                return NotFound("Nem található ilyen nevű termék");
            }
            return Ok(products);
           

        }
        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var products= _context.products.ToList();
            if(products==null || !products.Any())
            {
                return NotFound("Nincsenek termékek");
            }
            var csv = new StringBuilder();
            csv.AppendLine("ID,Név,Ár,Webshop,Kép URL");
            foreach(var product in products)
            {
                csv.AppendLine($"{product.id},\"{product.name},\"{product.price},\"{product.shoplink},\"{product.imageurl}");
            }
            var bytes=Encoding.UTF8.GetBytes(csv.ToString());
            return File(bytes, "text/csv", "termekek.csv");
        }
        // GET: api/Products/5
        //[Authorize(Roles ="ADMIN")]
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
        //[Authorize(Roles ="ADMIN")]
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
        //[Authorize(Roles ="Admin")]
        [HttpPost]
        
        public async Task<ActionResult<Product>> PostProduct([FromBody] ProductDTO productDto)
        {
            if (productDto == null)
            {
                return BadRequest("A termékadatok hiányoznak.");
            }

            var product = new Product
            {
                name = productDto.name,
                price = productDto.price,
                shoplink = productDto.shoplink,
                imageurl = productDto.imageurl,
                shopid = productDto.shopid,
                product_type_id = productDto.product_type_id,
                roomid = productDto.roomid
            };

            _context.products.Add(product);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProduct", new { id = product.id }, product);
        }



        // DELETE: api/Products/5
        //[Authorize (Roles ="ADMIN")]
        [HttpDelete("deleteByName{name}")]
        public async Task<IActionResult> DeleteProduct(string name)
        {
            var product = await _context.products
                .Where(x => x.name.Contains(name))
                .ToListAsync();
            if (!product.Any())
            {
                return NotFound(new {message="Nincs ilyen termék!"});
            }

            if (product.Count>1)
            {
                return BadRequest(new { message = "Több termék is van ilyen néven!" });
            }
            _context.products.Remove(product.First());
            await _context.SaveChangesAsync();
            return Ok(new { message = "Sikeresen törölve lett!" });
        }

        private bool ProductExists(int id)
        {
            return _context.products.Any(e => e.id == id);
        }
    }
}
