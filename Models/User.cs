
namespace Lakberendezes.Models
{
    public class User
    {
        public int Id { get; set; }
        public required string Email { get; set; }
        public required string UserName { get; set; }
        public required string PasswordHash { get; set; }

        public required string fullname {  get; set; }
        public required DateTime datet {  get; set; }
        public required string ProfilePictureUrl { get; set; }
        
        //Kapcsolat
        public  ICollection<UserPlans> plans { get; set; }= new List<UserPlans>();
        public ICollection<UserRole> roles { get; set; } = new List<UserRole>();
    }
}
