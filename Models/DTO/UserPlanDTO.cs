namespace Lakberendezes.Models
{
    public class UserPlanDTO
    {
        public int UserId { get; set; } 
        public required string PlanData { get; set; }
        public DateTime? CreatedAt { get; set; }
        
    }
}
