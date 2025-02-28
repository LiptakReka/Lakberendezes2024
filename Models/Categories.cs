namespace Lakberendezes.Models
{
    public class Categories
    {
        public required int id { get; set; }
        public required string name { get; set; }


        public required ICollection<ProductType> producttype_ibfk_1 { get; set; }
        public required ICollection<Product> products_ibfk_3 { get; set; }
       
    }
}
