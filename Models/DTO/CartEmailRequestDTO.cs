namespace Lakberendezes.Models
{
    public class CartEmailRequestDTO
    {
        public string Email { get; set; }
        public  List<CartItem> CartItems { get; set; }
    }

   
}
