namespace Lakberendezes.Models
{
    public class ProductType
    {
        public required int id { get; set; }

        public required int categoryid { get; set; }
        public required Categories Categories { get; set; }
        public required string name { get; set; }


        //kapcsolatok

        
        
        public required ICollection<Product> products_ibfk_2 { get; set;}
    }
}
