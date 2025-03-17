namespace Lakberendezes.Models
{
    public class ProductDTO
    {
        public required string name { get; set; }
        public required decimal price { get; set; }
        public required string shoplink {  get; set; }
        public required string imageurl {  get; set; }
        public required int shopid {  get; set; }
        public required int product_type_id { get; set; }
        public required int roomid { get; set; }
    }
}
