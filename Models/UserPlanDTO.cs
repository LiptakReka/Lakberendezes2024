namespace Lakberendezes.Models
{
    public class UserPlanDTO
    {
        public string UserId { get; set; } // Felhasználó azonosítója
        public string PlanData { get; set; }
        public DateTime? CreatedAt { get; set; }
        
    }
}
