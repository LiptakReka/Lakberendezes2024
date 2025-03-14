using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LakberendezesAdmin.Pages.Models
{
    public class AuthResponse
    {
        public string token { get; set; }
        public User User { get; set; }
    }
}
