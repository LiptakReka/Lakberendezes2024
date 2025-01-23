using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace Lakberendezes.Models
{
    public class JwtService
    {
        public required string _secretKey { get; init; }
        public  required string _issuer { get; init; }
        public required string _audience { get; init; }
        public  JwtService(IConfiguration config)
        {
            _secretKey = config["Jwt:Key"] ?? throw new ArgumentException("Secret key is missin ");
            _issuer = config["Jwt:Issuer"] ?? throw new ArgumentException("issuer is missin ");
            _audience = config["Jwt:Audience"] ?? throw new ArgumentException("Audience  is missin ");

        }
        public string GenerateToken(User user,IList<string> roles)
        {
            if (string.IsNullOrEmpty(user.Email))
            {
                throw new ArgumentNullException(nameof(user.Id));
               
            }
            if (string.IsNullOrEmpty(user.Id))
            {
                throw new ArgumentNullException(nameof(user.Email));
            }
            
            //1.felhasználói adatok (claims) hozzáadása
            //var claims = new List<Claim>
            //{
            //    new Claim(JwtRegisteredClaimNames.Sub, user.Id),
            //    new Claim (JwtRegisteredClaimNames.Email, user.Email),
            //    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            //    new Claim(ClaimTypes.Role,"ADMIN"),
            //    //new Claim(JwtRegisteredClaimNames.Nbf, ((DateTimeOffset)DateTime.UtcNow).ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64),
            //    //new Claim(JwtRegisteredClaimNames.Exp, ((DateTimeOffset)DateTime.UtcNow.AddHours(1)).ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64)




            //};

            ////Felhasználói szerepkörök
            //foreach (var role in roles)

            //{
            //    claims.Add(new Claim(ClaimTypes.Role, role));
            //}


            //2.Titkosítás

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secretKey));
            var creds= new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            //token létrehozás
           
            //var keey = Encoding.UTF8.GetBytes("+6naoStCZLQbteLFQRKYfrFjWk6WX5a/gqTxBgZgE88=");

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                //Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = creds
            };
            var tokenhandler = new JwtSecurityTokenHandler();
            var token=tokenhandler.CreateJwtSecurityToken(tokenDescriptor);
            var jwttoken=(JwtSecurityToken)token;
            var claimss=jwttoken.Claims.ToList();
            return  tokenhandler.WriteToken(jwttoken);
           

            

        }
    }
}
