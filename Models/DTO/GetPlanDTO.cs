namespace Lakberendezes.Models.DTO
{
    public class GetPlanDTO
    {
        public int id { get; set; }
        public int userid { get; set; }
        public string? plandata { get; set; } //terv adatai
        public DateTime createdat { get; set; }
    }
}
