using Microsoft.AspNetCore.Identity;
namespace Lakberendezes.Models
{
    public class User : IdentityUser
    {
        public  new string id { get; set; }
        public required string email     { get; set; }
        public  string PASSWORD_hash { get; set; }
        public required string fullname {  get; set; }
        public required DateTime datet {  get; set; }
        

        public  ICollection<UserPlans> plans { get; set; }= new List<UserPlans>();
    }
}
