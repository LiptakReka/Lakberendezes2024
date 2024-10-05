namespace Lakberendezes.Models
{
    public class UserPlans
    {
        public int id { get; set; }
        public int userid { get; set; }
        public required User User { get; set; }
        public  required string plandata { get; set; }
        public DateTime createdat { get; set; }

        public  required ICollection<PlanProduct> Products { get; set; }
        
        
     
    }
}
