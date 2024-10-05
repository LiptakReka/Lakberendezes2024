using Microsoft.AspNetCore.Identity;

namespace Lakberendezes.Models
{
    public class IdentityRoles
    {
        public async Task CreateRoles(IServiceProvider serviceProvider)
        {
            var rolemanager=serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
            string[] rolenames = { "Admin", "User" };
            foreach (var roleName in rolenames)
            {
                var roleexist=await rolemanager.RoleExistsAsync(roleName);
                if (!roleexist)
                {
                    await rolemanager.CreateAsync(new IdentityRole(roleName));
                }
            }
        }
    }
}
