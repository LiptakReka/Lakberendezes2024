namespace Lakberendezes.Models
{
  public record RegisterRequestDto(string UserName, string Password, string Email, string fullname, DateTime datet);
}
