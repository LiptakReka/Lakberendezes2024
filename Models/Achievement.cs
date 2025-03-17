namespace Lakberendezes.Models
{
    public class Achievement
    {
        public Guid id { get; set; }
        public int user_Id {  get; set; }
       
        public string title {  get; set; }
        public string description { get; set; }
        public string icon {  get; set; }
        public DateTime created_at { get; set; }
    }
}
