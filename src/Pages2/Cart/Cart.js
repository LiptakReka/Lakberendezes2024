import React, { useState } from 'react'
import useCart from './UseCart'
import {  Link } from 'react-router-dom'
import {  ShoppingCart } from 'lucide-react'
import axios from 'axios'
import './Cart.css'
import { PropagateLoader } from 'react-spinners'
import { useAchievements } from '../Achievement/UseAchivements'
import { enqueueSnackbar } from 'notistack'

export default function Cart() {
  const {unlockAchievement}= useAchievements();
    const {cart, removeFromCart, clearCart} = useCart();
    const [email, setEmail] = useState(() => {
        const user=JSON.parse(localStorage.getItem('user'));
        return user ? user.email : '';
    });
    const [loading, setloading] = useState(false);
    const [message, setMessage] = useState('');

    const sendEmail = async () => {
        if (!email) {
          enqueueSnackbar("Az email cím megadása kötelező",{variant: 'error'});
          return;
        }
      
        setloading(true);
        setMessage("");
      
        try {
          const response = await axios.post(
            "https://localhost:7247/api/Email/send-cart",
            {
              email,
              cartItems: cart.map(item => ({
                name: item.name,
                price: Number(item.price),
                shopLink: item.shoplink,
              })),
            },
            {
              headers: {
                "Content-Type": "application/json", 
              },
            }
          );
          setMessage(response.data.message || "Az email elküldve!");
          unlockAchievement("Kosár elküldve!","Összegzés elküldve", "🛒");
        } catch (error) {
          console.error('Error:', error);
          setMessage("Hiba történt az email küldésekor.");
        }
       
        setloading(false);
      };
      
  return (
    <div className='cart-sett-container'>
      <div className='cart-container'>
        <h1 className='cart-title'><ShoppingCart/>Kosár</h1>
        {cart.length ===0 ? (
            <p className='empty-cart-message'>A kosarad üres. <Link to="/planner" className='text-blue-500'>Vásárolj termékeket!</Link></p>
        ) : (
            <div>
                <ul className='cart-items'>
                    {cart.map((product) => (
                        <li key={product.id} className="flex justify-between items-center border-b py-2">
                    <div>
                        <h3 className='cart-item-info'>{product.name}</h3>
                        <p className='cart-item-name'>{product.price} Ft</p>
                        </div>
                        <div className='buy-button'>
                            <a href={product.shoplink} target='_blank' rel='noopener noreferrer' className='shops'>Megnézem</a>
                        <button className='clear-button' onClick={() => removeFromCart(product.id)}>Törlés</button>
        
                        </div>
                        </li>
                        ))}
                </ul>
                <div className='cart-buttons'>
                    <input type='email'
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder='Email cím'
                    className='p-2 border rounded-md w-full mb-2'/>
                    <button onClick={sendEmail} className='buy-button' disabled={loading}>{loading ? <PropagateLoader/> : "Kosár küldése e-mailben"}</button>
               
             <button className='clear-button' onClick={clearCart}>Kosár ürítése</button>
            </div>
            {message && <p className='text-green-600 mt-2'>{message}</p>}
            </div>
        )}

    </div>
    </div>
    
  )
}
