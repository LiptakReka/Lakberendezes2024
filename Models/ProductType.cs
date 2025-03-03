using System.Text.Json.Serialization;

namespace Lakberendezes.Models
{
    public class ProductType
    {
        public  int id { get; set; }

        public required int categoryid { get; set; }
        [JsonIgnore]
        public  Categories Categories { get; set; }
        public required string name { get; set; }


        //kapcsolatok

        [JsonIgnore]
        public  ICollection<Product> products_ibfk_2 { get; set;}
    }
}
