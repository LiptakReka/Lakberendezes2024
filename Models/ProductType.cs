namespace Lakberendezes.Models
{
    public class ProductType
    {
        public  int id { get; set; }

        public required int categoryid { get; set; }
        public  Categories? Categories { get; set; }
        public required string name { get; set; }


        //kapcsolatok

        
        
        public  ICollection<Product>? products_ibfk_2 { get; set;}
    }
}
