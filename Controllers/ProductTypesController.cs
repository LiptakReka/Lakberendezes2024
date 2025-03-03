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
using ClosedXML.Excel;
using Newtonsoft.Json.Linq;
using System.Text.Json;
using System.Security.Cryptography.Xml;
using System.Text.Json.Serialization;

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductTypesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProductTypesController(AppDbContext context)
        {
            _context = context;
        }

       
        //[Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductType>>> Getproducttype()
        {
            return await _context.producttype.ToListAsync();
        }

       
        [HttpGet("{id}")]
        public async Task<ActionResult<ProductType>> GetProductType(int id)
        {
            var productType = await _context.producttype.FindAsync(id);

            if (productType == null)
            {
                return NotFound();
            }

            return productType;
        }

      
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductType(int id, ProductType productType)
        {
            if (id != productType.id)
            {
                return BadRequest();
            }

            _context.Entry(productType).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductTypeExists(id))
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

     
        [HttpPost]
        public async Task<ActionResult<ProductType>> PostProductType(ProductTypesDTO productType)
        {
            if (productType == null)
            {
                return BadRequest("Az üzlet adatok hiányoznak.");
            }

            var types = new ProductType
            {
                categoryid = productType.categoryid,
                name = productType.name,

            };

            _context.producttype.Add(types);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getproducttype", new { id = types.id }, types);
        }
        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var types = _context.producttype.ToList();

            if (types == null || !types.Any())
            {
                return NotFound("Nincsenek bútortípusok");
            }
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Bútortípusok");

                worksheet.Cell(1, 1).Value = "Azonosító";
                worksheet.Cell(1, 2).Value = "Név";

                int row = 2;
                foreach (var type in types)
                {
                    worksheet.Cell(row, 1).Value = type.id;
                    worksheet.Cell(row, 2).Value = type.name;
                    row++;

                }
                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "butortipusok.xlsx");
                }
            }

        }
        [HttpGet("byroom")]
        public async Task<ActionResult<IEnumerable<ProductType>>> GetTypesbyRoom(int roomid)
        {
            try
            {
                var types = await _context.producttype
                    .Where(t => _context.products
                        .Where(p => p.roomid == roomid)
                        .Select(p => p.product_type_id)
                        .Distinct()
                        .Contains(t.id))
                    .ToListAsync();

                return Ok(types);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Belső szerver hiba: {ex.Message}");
            }
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProductType(int id)
        {
            var productType = await _context.producttype.FindAsync(id);
            if (productType == null)
            {
                return NotFound();
            }

            _context.producttype.Remove(productType);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProductTypeExists(int id)
        {
            return _context.producttype.Any(e => e.id == id);
        }
    }
}
