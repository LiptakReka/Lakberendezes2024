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

namespace Lakberendezes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]



    public class CategoriesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CategoriesController(AppDbContext context)
        {
            _context = context;
        }


        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Categories>>> Getkategories()
        {
            return await _context.kategories.ToListAsync();
        }



        [Authorize(Roles = "User,Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Categories>> GetCategories(int id)
        {
           
            var categories = await _context.kategories.FindAsync(id);


            if (categories == null)
            {
                return NotFound();
            }

            return categories;
        }




        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategories(int id, Categories categories)
        {
            if (id != categories.id)
            {
                return BadRequest();
            }

            _context.Entry(categories).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CategoriesExists(id))
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




        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<Categories>> PostCategories([FromBody]CategDTO categories)
        {
            if (categories == null)
            {
                return BadRequest("A helységek adatai hiányoznak.");
            }

            var categs = new Categories
            {
                name = categories.name,

            };

            _context.kategories.Add(categs);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getkategories", new { id = categs.id }, categs);
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var categs = _context.kategories.ToList();

            if (categs == null || !categs.Any())
            {
                return NotFound("Nincsenek szobák");
            }
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Szobák");

                worksheet.Cell(1, 1).Value = "Azonosító";
                worksheet.Cell(1, 2).Value = "Név";

                int row = 2;
                foreach (var categ in categs)
                {
                    worksheet.Cell(row, 1).Value = categ.id;
                    worksheet.Cell(row, 2).Value = categ.name;
                    row++;

                }
                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "szobak.xlsx");
                }
            }

        }


        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategories(int id)
        {
            var categories = await _context.kategories.FindAsync(id);
            if (categories == null)
            {
                return NotFound();
            }

            _context.kategories.Remove(categories);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CategoriesExists(int id)
        {
            return _context.kategories.Any(e => e.id == id);
        }
    }
}
