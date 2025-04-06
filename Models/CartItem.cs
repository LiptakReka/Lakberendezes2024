namespace Lakberendezes.Models
{
    public class CartItem
    {
        public required string Name { get; set; }
        public decimal Price { get; set; }
        public required string ShopLink { get; set; }
    }
}
