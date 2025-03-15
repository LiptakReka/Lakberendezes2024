using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LakberendezesAdmin.Pages.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PasswordHash { get; set; }
        public string fullname { get; set; }
        public DateTime datet { get; set; }

        public string ProfilePictureUrl { get; set; }
        public List<string> Roles {get; set; }

    }
}
