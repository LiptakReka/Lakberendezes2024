using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Extensions.Configuration;
namespace Lakberendezes.Models.Service
{
    public class CloudinaryService
    {
        private readonly Cloudinary cloudinary;
        public CloudinaryService(IConfiguration configuration)
        {
            var cloudsettings = configuration.GetSection("CloudinarySettings");
            var account = new Account(
                cloudsettings["CloudName"],
                cloudsettings["ApiKey"],
                cloudsettings["ApiSecret"]
            );
            cloudinary = new Cloudinary(account);
        }

        public async Task<string> UploadImage(IFormFile file)
        {
            using var stream = file.OpenReadStream();
            var uploadParams = new ImageUploadParams
            {
                File = new FileDescription(file.FileName, stream),
                Folder="profile_pictures",
                Transformation = new Transformation().Width(500).Height(500).Crop("fill")
            };
            try
            {
                var uploadResult = await cloudinary.UploadAsync(uploadParams);
                if (uploadResult==null)
                {
                    throw new Exception("Kép feltöltése sikertelen");
                }
                return uploadResult.SecureUrl.ToString();
            }
            catch
            {
                throw new Exception("Kép feltöltése sikertelen");
            }
            

        }
    }
}
