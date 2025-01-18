import React, { useState, useEffect } from 'react';
import './Planner.css';

const Planner = () => {
  const [selectedRoom, setSelectedRoom] = useState(null); // Kiválasztott szoba azonosítója
  const [products, setProducts] = useState([]); // Termékek listája
  const [designareaItems, setDesignAreaitems] = useState([]);
  const [draggedProduct, setDraggedProduct] = useState(null)
  const [placedProducts, setPlacedProducts] = useState([])

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
const addToPlanner=(product)=>{
  setPlacedProducts([
    ...placedProducts,
    {...product, x:50 , y:50 , scale:1 ,id: Date.now() },
  ]);
};

const handleMouseMove=(e)=>{
  if(draggedProduct) {
    const updatedProducts= placedProducts.map((p)=>
    p.id===draggedProduct.id
  ? {...p, x:e.clientX - draggedProduct.offsetX, y: e.clientY - draggedProduct.offsetY,}
  :p
);
setPlacedProducts(updatedProducts);
  }
};

const handleMouseDown =(product,e)=>{
  setDraggedProduct({
    id:product.id,
    offsetX: e.clientX - product.x,
    offsetY: e.clientY - product.y,
  });
};

const handleMouseUp=()=>{
  setDraggedProduct(null)
};

const handleZoom=(id, direction)=>{
  setPlacedProducts((prevProducts)=>
  prevProducts.map((p)=>
  p.id===id
    ? {...p, scale:Math.max(0.5, p.scale + direction)}
    :p
)
);
};

  return (
    <div className="planner-container"
    onMouseMove={handleMouseMove}
    onMouseUp={handleMouseUp}>
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
              <button className='buy-btn' onClick={()=>addToPlanner(product)}>
                Hozzáadás a tervezőhöz
              </button>
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
        {placedProducts.map((product)=>(
          <div 
          className='placed-area'
          key={product.id}
          style={{
            position: "absolute",
            left:`${product.x}px`,
            top:`${product.y}px`,
          }}
         onMouseDown={(e)=> handleMouseDown(product,e)}
          >
              <button
            className='remove-btn'
            onClick={()=>setPlacedProducts(placedProducts.filter((p)=> p.id !==product.id))}>
            
              ❌
            </button>
            <img 
            src={product.imageurl}
            alt={product.name}
            style={{
              transform:`scale(${product.scale})`,
              transition:"transform 0.2s ease-in-out",
            }}
            />
            <div className='zoom-controls'>
              <button onClick={()=>handleZoom(product.id, 0.1)} > + </button>
              <button onClick={()=>handleZoom(product.id, -0.1)}> - </button>
              </div>
            </div>
        ))}
      </div>
    </div>
  );
};

export default Planner;
