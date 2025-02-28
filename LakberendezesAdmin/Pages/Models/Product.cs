using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LakberendezesAdmin.Pages.Models
{
   public  class Product
    {
        public int? id { get; set; }
        public string name { get; set; }
        public decimal? price { get; set; }
        public string shoplink { get; set; }
        public string imageurl {  get; set; }
        public int? shopid {  get; set; }
        public int product_type_id {  get; set; }
        public int? roomid {  get; set; }
    }
}
