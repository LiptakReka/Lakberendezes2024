<<<<<<< HEAD
﻿using System.Text.Json.Serialization;

namespace Lakberendezes.Models
=======
﻿namespace Lakberendezes.Models
>>>>>>> 5fdea6799604db3f88eb69efc119cb025c9aaeaa
{
    public class ProductType
    {
        public  int id { get; set; }

        public required int categoryid { get; set; }
<<<<<<< HEAD
        [JsonIgnore]
=======
>>>>>>> 5fdea6799604db3f88eb69efc119cb025c9aaeaa
        public  Categories Categories { get; set; }
        public required string name { get; set; }


        //kapcsolatok

<<<<<<< HEAD
        [JsonIgnore]
=======
        
        
>>>>>>> 5fdea6799604db3f88eb69efc119cb025c9aaeaa
        public  ICollection<Product> products_ibfk_2 { get; set;}
    }
}
