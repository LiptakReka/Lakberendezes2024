using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Lakberendezes.Models
{
    public class JwtService
    {
        public required string _secretKey { get; init; }
        public required string _issuer { get; init; }
        public required string _audience { get; init; }
        public readonly int _tokenexpiryMinutes;

        public JwtService(IConfiguration config)
        {
            _secretKey = config["Jwt:Key"] ?? throw new ArgumentException("Secret key is missing");
            _issuer = config["Jwt:Issuer"] ?? throw new ArgumentException("Issuer is missing");
            _audience = config["Jwt:Audience"] ?? throw new ArgumentException("Audience is missing");
            _tokenexpiryMinutes = config.GetValue<int>("Jwt:TokenExpiryMinutes");
        }

        public string GenerateToken(User user, IList<string> roles)
        {
            if (string.IsNullOrEmpty(user.Email))
            {
                throw new ArgumentNullException(nameof(user.Email));
            }
            if (string.IsNullOrEmpty(user.Id))
            {
                throw new ArgumentNullException(nameof(user.Id));
            }

            var expiration = DateTimeOffset.UtcNow.AddMinutes(_tokenexpiryMinutes);

            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Nbf, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64),
                new Claim(JwtRegisteredClaimNames.Exp, expiration.ToUnixTimeSeconds().ToString(),ClaimValueTypes.Integer64)
            };

            // Felhasználói szerepkörök hozzáadása
            foreach (var role in roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            // Titkosítás
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            // Token létrehozás
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = expiration.DateTime,
                SigningCredentials = creds,
                Issuer = _issuer,
                Audience = _audience
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}