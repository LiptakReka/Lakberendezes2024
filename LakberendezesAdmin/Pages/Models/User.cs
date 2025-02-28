using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LakberendezesAdmin.Pages.Models
{
    internal class User
    {
        public string Id {  get; set; }
        public string Email { get; set; }
        public string fullname {  get; set; }
        public DateTime datet { get; set; }
        public int AccessFailedCount { get; set; }  
        public string ConcurrencyStamp {  get; set; }
        public int EmailComfirmed {  get; set; }
        public bool LockoutEnabled {  get; set; }
        public DateTime? LockoutEnd { get; set; }
        public string NormalizedEmail { get; set; }   
        public string NormalizedUserName { get; set; }  
        public string PasswordHash { get; set; }  
        public string PhoneNumber {  get; set; }
        public bool PhoneNumberConfirmed {  get; set; }
        public string SecurityStamp {  get; set; }
        public string UserName { get; set; }
        public string ProfilePictureUrl {  get; set; }

    }
}
