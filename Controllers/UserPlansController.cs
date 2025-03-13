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
    public class UserPlansController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserPlansController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("search/{id}")]

        public async Task<ActionResult<IEnumerable<UserPlans>>> GetPlans(int id)
        {
            var plans = await _context.userplan
                .Where(p => p.id==id)
                .ToListAsync();
            if (plans.Count == 0)
            {
                return NotFound("Nem található ilyen nevű terv");
            }
            return Ok(plans);


        }
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserPlans>>> Getuserplan()
        {
            return await _context.userplan.ToListAsync();
        }

        [HttpGet("Export")]
        public IActionResult ExportTocsv()
        {
            var plans = _context.userplan.ToList();

            if (plans == null || !plans.Any())
            {
                return NotFound("Nincsenek termékek");
            }
            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Termékek");

                worksheet.Cell(1, 1).Value = "id";
                worksheet.Cell(1, 2).Value = "Felhasználó azonosító";
                worksheet.Cell(1, 3).Value = "Terv adatok";
                worksheet.Cell(1, 4).Value = "Készült";
               

                int row = 2;
                foreach (var plan in plans)
                {
                    worksheet.Cell(row, 1).Value = plan.id; 
                    worksheet.Cell(row, 2).Value = plan.userid;
                    worksheet.Cell(row, 3).Value = plan.plandata;
                    worksheet.Cell(row, 4).Value = plan.createdat;
                    row++;

                }
                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "tervek.xlsx");
                }
            }

        }
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

  
        [HttpPost]
        public async Task<ActionResult<UserPlans>> PostUserPlans( UserPlans userPlans)
        {
            _context.userplan.Add(userPlans);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUserPlans", new { id = userPlans.id }, userPlans);
        }

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
