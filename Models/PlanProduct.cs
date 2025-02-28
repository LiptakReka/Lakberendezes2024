using Microsoft.EntityFrameworkCore.Metadata.Internal;
namespace Lakberendezes.Models
{
    public class PlanProduct
    {
        public int id { get; set; }
        public required int productid { get; set; }
        public  Product Product { get; set; }

        public required int userplanid { get; set; }
        public  UserPlans Userplans { get; set; }
        public required string position { get; set; }
        public float scale {  get; set; }

        
      
    }
}
