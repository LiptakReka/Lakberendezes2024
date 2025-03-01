using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Lakberendezes.Data;
using Lakberendezes.Models;
using ClosedXML.Excel;

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
        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var shopss = _context.shops.ToList();

            if (shopss == null || !shopss.Any())
            {
                return NotFound("Nincsenek üzletek");
            }
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Üzletek");

                worksheet.Cell(1, 1).Value = "Azonosító";
                worksheet.Cell(1, 2).Value = "Név";
                worksheet.Cell(1, 3).Value = "Weboldal";

                int row = 2;
                foreach (var shopp in shopss)
                {
                    worksheet.Cell(row, 1).Value = shopp.id;
                    worksheet.Cell(row, 2).Value = shopp.name;
                    worksheet.Cell(row, 3).Value = shopp.websiteurl;
                    row++;

                }
                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "uzeletek.xlsx");
                }
            }

        }

        [HttpPost]

        public async Task<ActionResult<Shops>> PostShops([FromBody] ShopDTO shopDTO)
        {
            if (shopDTO == null)
            {
                return BadRequest("Az üzlet adatok hiányoznak.");
            }

            var shopss = new Shops
            {
                name = shopDTO.name,
                websiteurl = shopDTO.websiteurl,
                
            };

            _context.shops.Add(shopss);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetShops", new { id = shopss.id }, shopss);
        }

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
