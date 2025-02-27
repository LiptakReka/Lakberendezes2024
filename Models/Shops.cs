namespace Lakberendezes.Models
{
    public class Shops
    {
<<<<<<< HEAD
        public required int id { get; set; }//áruház id
        public required string name { get; set; }
        
        public required string websiteurl { get; set; }//áruház neve

        //navigációs tulajdonság
=======
        public required int id { get; set; }
        public required string name { get; set; }
        
        public required string websiteurl { get; set; }

      
>>>>>>> 55d865c (Exportálás excelbe)
        public required ICollection<Product> products_ibfk_1 { get; set; }
        

    }
}
