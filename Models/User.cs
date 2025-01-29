using Microsoft.AspNetCore.Identity;
namespace Lakberendezes.Models
{
    public class User : IdentityUser
    {
        
       
        public required string fullname {  get; set; }
        public required DateTime datet {  get; set; }
        

        public  ICollection<UserPlans> plans { get; set; }= new List<UserPlans>();
    }
}
