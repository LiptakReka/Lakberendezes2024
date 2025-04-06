namespace Lakberendezes.Models
{
    public class Categories
    {
        public  int id { get; set; }
        public required string name { get; set; }


        public  ICollection<ProductType>? producttype_ibfk_1 { get; set; }
        public  ICollection<Product>? products_ibfk_3 { get; set; }
       
    }
}
