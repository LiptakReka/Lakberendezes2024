namespace Lakberendezes.Models
{
    public class PlanProductDTO
    {
        public required int UserPlanId { get; set; }  // 🔹 A terv azonosítója
        public required string PlanData { get; set; }
    }

    public class PlanProductItemDTO
    {
        public int ProductId { get; set; }
        public float X { get; set; }
        public float Y { get; set; }
        public float scale {  get; set; }
    } 
}

