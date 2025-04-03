namespace Lakberendezes.Models
{
    public class Shops
    {

        public int id { get; set; }//áruház id
        public required string name { get; set; }
        
        public required string websiteurl { get; set; }//áruház 

        public required string PhoneNumber { get; set; }

        public required string Email { get; set; }

        //navigációs tulajdonság

      

        public ICollection<Product>? products_ibfk_1 { get; set; }
        

    }
}
