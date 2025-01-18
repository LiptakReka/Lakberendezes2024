import React, { useState, useEffect } from 'react';
import './Planner.css';

const Planner = () => {
  const [selectedRoom, setSelectedRoom] = useState(null); // Kiválasztott szoba azonosítója
  const [products, setProducts] = useState([]); // Termékek listája

  // Termékek lekérdezése adott szobához
  const fetchProductsByRoom = async (roomId) => {
    try {
      const response = await fetch(`https://localhost:7247/api/Products/szobák?roomId=${roomId}`);
      if (!response.ok) {
        throw new Error('Hiba a termékek lekérésekor');
      }
      const data = await response.json();
      setProducts(data); // Termékek beállítása az állapotban
    } catch (error) {
      console.error('Hiba a termékek lekérésekor:', error);
      setProducts([]); // Üres lista hiba esetén
    }
  };

  // Gombkattintás kezelése a szoba kiválasztásához
  const handleRoomSelect = (roomId) => {
    setSelectedRoom(roomId); // Kiválasztott szoba beállítása
    fetchProductsByRoom(roomId); // Termékek lekérdezése a szobához
  };

  return (
    <div className="planner-container">
      <h1>Tervező</h1>

      {/*Room categories */}
      <div className="rooms">
        <button  onClick={() => handleRoomSelect(1)} className="category-button">Nappali</button>
        <button onClick={() => handleRoomSelect(5)} className="category-button">Étkező</button>
        <button onClick={() => handleRoomSelect(3)} className="category-button">Hálószoba</button>
        <button onClick={() => handleRoomSelect(4)} className="category-button">Fürdőszoba</button>
      </div>

      <h2>Bútorok és dekorációk</h2>
      <div className="products">
        {products.length > 0 ? (
          products.map((product) => (
            <div className="product-card" key={product.id}>
              <img src={product.imageurl} alt={product.name} className="product-image" />
              <h3>{product.name}</h3>
              <p>{product.price} Ft</p>
              <a href={product.url} target="_blank" rel="noopener noreferrer" className="buy-btn">
                Vásárlás
              </a>
            </div>
          ))
        ) : (
          <p>Válassz ki egy szobát!</p>
        )}
      </div>
      {/*design*/}
      <div className='tervezoterulet'>Húzd ide a bútorokat</div>
    </div>
  );
};

export default Planner;
