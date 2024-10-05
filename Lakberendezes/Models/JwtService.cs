using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace Lakberendezes.Models
{
    public class JwtService
    {
        private readonly string _secretKey;
        private readonly string _issuer;
        private readonly string _audience;
        public JwtService(IConfiguration config)
        {
            _secretKey = config["Jwt:Key"];
            _issuer = config["Jwt:Issuer"];
            _audience = config["Jwt:Audience"];

        }
        public string GenerateToken(User user,IList<string> roles)
        {
            
            //1.felhasználói adatok (claims) hozzáadása
            var claims = new List<Claim>();
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.email);
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString());
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString());
               

            };

            //Felhasználói szerepkörök
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }


            //2.Titkosítás

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secretKey));
            var creds= new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            //token létrehozás
            var tokens= new JwtSecurityToken(
                issuer: _issuer,
                audience: _audience,
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds
            );


            return new JwtSecurityTokenHandler().WriteToken(tokens);

        }
    }
}
