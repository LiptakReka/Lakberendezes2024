using Microsoft.EntityFrameworkCore.Metadata.Internal;
namespace Lakberendezes.Models
{
    public class PlanProduct
    {
        public required int id { get; set; }
        public required int productid { get; set; }
        public required Product Product { get; set; }

        public required int userplanid { get; set; }
        public required UserPlans Userplans { get; set; }
        public required string position { get; set; }

        
      
    }
}
