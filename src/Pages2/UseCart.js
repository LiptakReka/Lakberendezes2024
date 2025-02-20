import { create } from 'zustand';
import { persist } from 'zustand/middleware';

const useCart = create(
  persist(
    (set, get) => ({
      cart: [],
      cartCount: 0,
      addToCart: (product) => {
        set((state) => ({
          cart: [...state.cart, product],
          cartCount: state.cartCount + 1
        }));
      },
      removeFromCart: (productId) => {
        set((state) => ({
          cart: state.cart.filter((item) => item.id !== productId),
          cartCount: state.cartCount - 1
        }));
      },
      clearCart: () => {
        set({ cart: [], cartCount: 0 });
      },
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
