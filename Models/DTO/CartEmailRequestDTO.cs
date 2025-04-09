namespace Lakberendezes.Models
{
    public class CartEmailRequestDTO
    {
        public required string Email { get; set; }
        public  List<CartItem>? CartItems { get; set; } //kosár tartalma
    }

   
}
