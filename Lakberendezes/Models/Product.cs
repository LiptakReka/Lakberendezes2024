namespace Lakberendezes.Models
{
    public class Product  // Nagybetűvel írt osztálynév
    {
        public required int id { get; set; }  // Elsődleges kulcs
        public required string name { get; set; }  // Termék neve
        public required decimal price { get; set; }  // Termék ára

        public required string shoplink { get; set; }  // Bolt linkje
        public required string imageurl { get; set; }  // Termék képe

        // Kapcsolatok
        public required int shopid { get; set; }  // Idegen kulcs az áruházhoz
        public required Shops Shops { get; set; }

        public required int product_type_id { get; set; }  // Idegen kulcs a terméktípushoz
        public required ProductType ProductType { get; set; }

        public required int roomid { get; set; }  // Idegen kulcs a szobához (kategories tábla)
        
        // Navigációs tulajdonság a PlanProduct-hoz

        public required Categories Categories { get; set; }
        public required ICollection<PlanProduct> products { get; set; }
    }
}
