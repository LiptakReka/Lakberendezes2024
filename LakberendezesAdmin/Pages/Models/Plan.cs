using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LakberendezesAdmin.Pages.Models
{
    internal class Plan
    {
        public int id { get; set; }
        public string userid { get; set; }
        public string plandata { get; set; }
        public DateTime createdat {  get; set; }
    }
}
