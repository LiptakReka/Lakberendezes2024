using Microsoft.AspNetCore.Identity;
namespace Lakberendezes.Models
{
    public class User : IdentityUser
    {
        
       
        public required string fullname {  get; set; }
        public required DateTime dateat {  get; set; }
        

        public  ICollection<UserPlans> plans { get; set; }= new List<UserPlans>();
    }
}
