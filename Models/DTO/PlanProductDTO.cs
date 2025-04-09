namespace Lakberendezes.Models
{
    public class PlanProductDTO
    {
        public required int UserPlanId { get; set; } 
        public required string PlanData { get; set; }
    }

    public class PlanProductItemDTO
    {
        public int ProductId { get; set; }
        public float X { get; set; } //x koordináta
        public float Y { get; set; } //y koordináta
        public float scale {  get; set; } //méret
    } 
}

