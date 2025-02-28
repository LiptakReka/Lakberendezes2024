namespace Lakberendezes.Models
{
    public class Product  
    {
        public  int id { get; set; } 
        public required string name { get; set; } 
        public required decimal price { get; set; } 

        public required string shoplink { get; set; } 
        public required string imageurl { get; set; }  

      
<<<<<<< HEAD
        public  int shopid { get; set; }  
        public  Shops Shops { get; set; }

        public  int product_type_id { get; set; }  
        public  ProductType ProductType { get; set; }

        public int roomid { get; set; } 
=======
        public required int shopid { get; set; }  
        public  Shops Shops { get; set; }

        public required int product_type_id { get; set; }  
        public  ProductType ProductType { get; set; }

        public required int roomid { get; set; } 
>>>>>>> 1ca7ca1306445d0c105ec3d1717a26a7e0223325
        
      

        public  Categories Categories { get; set; }
        public  ICollection<PlanProduct> products { get; set; }
    }
}
