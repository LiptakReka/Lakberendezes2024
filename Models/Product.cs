namespace Lakberendezes.Models
{
<<<<<<< HEAD
    public class Product  // Nagybetűvel írt osztálynév
    {
        public  int id { get; set; }  // Elsődleges kulcs
        public required string name { get; set; }  // Termék neve
        public required decimal price { get; set; }  // Termék ára

        public required string shoplink { get; set; }  // Bolt linkje
        public required string imageurl { get; set; }  // Termék képe

        // Kapcsolatok
        public required int shopid { get; set; }  // Idegen kulcs az áruházhoz
        public  Shops Shops { get; set; }

        public required int product_type_id { get; set; }  // Idegen kulcs a terméktípushoz
        public  ProductType ProductType { get; set; }

        public required int roomid { get; set; }  // Idegen kulcs a szobához (kategories tábla)
        
        // Navigációs tulajdonság a PlanProduct-hoz
=======
    public class Product  
    {
        public  int id { get; set; } 
        public required string name { get; set; } 
        public required decimal price { get; set; } 

        public required string shoplink { get; set; } 
        public required string imageurl { get; set; }  

      
        public required int shopid { get; set; }  
        public  Shops Shops { get; set; }

        public required int product_type_id { get; set; }  
        public  ProductType ProductType { get; set; }

        public required int roomid { get; set; } 
        
      
>>>>>>> 55d865c (Exportálás excelbe)

        public  Categories Categories { get; set; }
        public  ICollection<PlanProduct> products { get; set; }
    }
}
