namespace Lakberendezes.Models
{
    public class UserRole
    {
        public int Userid { get; set; }
        public User? User { get; set; }
        public int Roleid { get; set; }
        public Roles? Role { get; set; }
    }
}
