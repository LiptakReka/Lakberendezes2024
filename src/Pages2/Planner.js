import React, { useState, useEffect } from 'react';
import './Planner.css';

const Planner = () => {
  const [selectedRoom, setSelectedRoom] = useState(null); // Kiválasztott szoba azonosítója
  const [products, setProducts] = useState([]); // Termékek listája
  const [designareaItems, setDesignAreaitems] = useState([]);

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

  //termékek a tervezőn
  const handleProductClick =(product)=>{
    setDesignAreaitems((prevItems)=>[
      ...prevItems,
      {...product, id: Math.random().toString() },
    ]);
  };

  //eltávolítás
  const handleRemoveItem= (itemId)=>{
    setDesignAreaitems((prevItems)=>
      prevItems.filter((item)=>item.id !== itemId)
    );
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
            <div className="product-card" key={product.id} onClick={()=>handleProductClick(product)}>
              <img src={product.imageurl} alt={product.name} className="product-image" />
              <h3>{product.name}</h3>
              <p>{product.price} Ft</p>
              <a href={product.shoplink} target="_blank" rel="noopener noreferrer" className="buy-btn">
                Vásárlás
              </a>
            </div>
          ))
        ) : (
          <p>Válassz ki egy szobát!</p>
        )}
      </div>
      {/*design*/}
      <h2>Tervező terület</h2>
      <div className='tervezoterulet'>
        {designareaItems.map((item)=>(
          <div 
          className='design-item'
          key={item.id}
          style={{
            position: "absolute",
            left:item.left || "50px",
            top:item.top || "50px",
          }}
          draggable
          onDragEnd={(e)=>{
            //elemek pozi
            const left =e.clientX - e.target.offsetWidth /2;
            const top =e.clientX - e.target.offsetHeight /2;
            setDesignAreaitems((prevItems)=>prevItems.map((i)=>i.id===item.id ? {...i,left,top}: i));
          }}
          >
            <img 
            src={item.imageurl}
            alt={item.name}
            style={{width: "100px", cursor: "move"}}
            />
            <button
            className='remove-btn'
            onClick={()=>handleRemoveItem(item.id)}
            >
              ❌
            </button>
            </div>
        ))}
      </div>
    </div>
  );
};

export default Planner;
