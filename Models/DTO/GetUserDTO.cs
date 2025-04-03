namespace Lakberendezes.Models
{
    public class GetUserDTO
    {
        public int Id { get; set; }
        public required string Email { get; set; }
        public required string UserName { get; set; }
        public required string PasswordHash { get; set; }
        public required string fullname { get; set; }
        public DateTime datet { get; set; }
        public required string ProfilePictureUrl { get; set; }
    }
}
