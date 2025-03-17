using DocumentFormat.OpenXml.Office2010.Excel;

namespace Lakberendezes.Models
{
    public class Roles
    {
        public int id { get; set; }
        public required string name { get; set; }
        public ICollection<UserRole> roles { get; set; }
    }
}
