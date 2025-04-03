namespace Lakberendezes.Models
{
    public class Achievement
    {
        public Guid id { get; set; }
        public int user_Id {  get; set; }
       
        public required string title {  get; set; }
        public required string description { get; set; }
        public required string icon {  get; set; }
        public DateTime created_at { get; set; }
    }
}
