import { create } from 'zustand';
import { persist } from 'zustand/middleware';

const useCart = create(
  persist(
    (set, get) => ({
      cart: [],            // Tárolja a kosárba helyezett termékeket
      cartCount: 0,        // Tárolja a kosárban lévő termékek számát
      
      // Hozzáadás a kosárhoz
      addToCart: (product) => {
        set((state) => ({
          cart: [...state.cart, product],
          cartCount: state.cartCount + 1
        }));
      },
      
      // Eltávolítás a kosárból
      removeFromCart: (productId) => {
        set((state) => ({
          cart: state.cart.filter((item) => item.id !== productId),
          cartCount: state.cartCount - 1
        }));
      },
      
      // Kosár ürítése
      clearCart: () => {
        set({ cart: [], cartCount: 0 });
      },
      
      // Kosár elemeinek számának lekérdezése
      getCartCount: () => {
        return get().cartCount;
      }
    }),
    {
      name: 'cart-storage'
    }
  )
);

export default useCart;
