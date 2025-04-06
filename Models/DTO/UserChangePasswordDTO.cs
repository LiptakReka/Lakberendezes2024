namespace Lakberendezes.Models
{
    public class UserChangePasswordDTO
    {
        public required string Email { get; set; }
        public  required string CurrentPassword { get; set; }
        public required string NewPassword { get; set; }
    }
}
