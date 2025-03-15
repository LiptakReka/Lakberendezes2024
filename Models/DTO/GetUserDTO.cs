namespace Lakberendezes.Models
{
    public class GetUserDTO
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PasswordHash { get; set; }
        public string fullname { get; set; }
        public DateTime datet { get; set; }
        public string ProfilePictureUrl { get; set; }
    }
}
