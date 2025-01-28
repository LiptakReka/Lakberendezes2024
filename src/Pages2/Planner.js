import React, { useState, useEffect } from "react";
import "./Planner.css"; // Külső CSS fájl, a stílusok miatt
import axios from "axios";

const Planner = () => {
  const [products, setProducts] = useState([]);
  const [placedProducts, setPlacedProducts] = useState([]);
  const [draggedProduct, setDraggedProduct] = useState(null);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });

  useEffect(() => {
    // Alapértelmezett szoba (pl. nappali)
    fetchProductsByRoom(1);
  }, []);

  const fetchProductsByRoom = async (roomId) => {
    try {
        const token = localStorage.getItem("token"); // 🔹 Token lekérése helyesen
        if (!token) {
            console.error("Nincs bejelentkezve! Token nem található.");
            return;
        }

        const response = await axios.get(`https://localhost:7247/api/Products/szobak?roomId=${roomId}`, {
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "application/json"
            },
        });

        setProducts(response.data);

    } catch (error) {
        console.error("Hiba történt a termékek lekérésekor:", error);
    }
};

  

const handleRoomSelect = async (roomId) => { // 🔹 async hozzáadása
  await fetchProductsByRoom(roomId);
  setPlacedProducts([]); // Töröljük a tervezőfelületről az előző szoba bútorait
};


  const addToPlanner = (product) => {
    setPlacedProducts([
      ...placedProducts,
      {
        ...product,
        x: 100,
        y: 100,
        scale: 1, // Kezdeti méret
      },
    ]);
  };

  const handleMouseDown = (event, product) => {
    setDraggedProduct(product);
    // Drag offset mentése az egér és az elem közötti távolsághoz
    setDragOffset({
      x: event.clientX - product.x,
      y: event.clientY - product.y,
    });
  };

  const handleMouseMove = (event) => {
    if (draggedProduct) {
      const updatedProducts = placedProducts.map((product) =>
        product.id === draggedProduct.id
          ? {
              ...product,
              x: event.clientX - dragOffset.x, // Pozíció frissítése az offsettel
              y: event.clientY - dragOffset.y,
            }
          : product
      );
      setPlacedProducts(updatedProducts);
    }
  };

  const handleMouseUp = () => {
    setDraggedProduct(null);
  };

  const handleZoom = (productId, scaleChange) => {
    setPlacedProducts((prevProducts) =>
      prevProducts.map((product) =>
        product.id === productId
          ? {
              ...product,
              scale: Math.max(0.5, Math.min((product.scale || 1) + scaleChange, 3)),
            }
          : product
      )
    );
  };

  return (
    <div className="planner-container" onMouseMove={handleMouseMove} onMouseUp={handleMouseUp}>
      <h1>Tervező</h1>

      {/* Szoba kategóriák */}
      <div className="rooms">
        <button onClick={() => handleRoomSelect(1)} className="category-button">Nappali</button>
        <button onClick={() => handleRoomSelect(5)} className="category-button">Étkező</button>
        <button onClick={() => handleRoomSelect(3)} className="category-button">Hálószoba</button>
        <button onClick={() => handleRoomSelect(4)} className="category-button">Fürdőszoba</button>
      </div>

      {/* Bútorok és tervezőfelület */}
      <div className="products-and-planner">
        <div className="products">
          {products.length > 0 ? (
            products.map((product) => (
              <div className="product-card" key={product.id}>
                <img src={product.imageurl} alt={product.name} className="product-image" />
                <h3>{product.name}</h3>
                <p>{product.price} Ft</p>
                <button className="buy-btn" onClick={() => addToPlanner(product)}>Hozzáadás a tervezőhöz</button>
                <a href={product.shoplink} target="_blank" rel="noopener noreferrer" className="buy-btn">Vásárlás</a>
              </div>
            ))
          ) : (
            <p>Válassz ki egy szobát!</p>
          )}
        </div>

        <div className="tervezoterulet">
          {placedProducts.map((product) => (
            <div
              className="placed-area"
              key={product.id}
              style={{
                left: `${product.x}px`,
                top: `${product.y}px`,
                transform: `scale(${product.scale || 1})`,
              }}
              onMouseDown={(event) => handleMouseDown(event, product)}
            >
              <button
                className="remove-btn"
                onClick={(e) => {
                  e.stopPropagation(); // Esemény buborék megakadályozása
                  setPlacedProducts(placedProducts.filter((p) => p.id !== product.id));
                }}
              >
                ❌
              </button>
              <img
                src={product.imageurl}
                alt={product.name}
                draggable={false}
                style={{
                  pointerEvents: "none",
                }}
              />
              <div className="zoom-controls">
                <button onClick={() => handleZoom(product.id, 0.1)}> + </button>
                <button onClick={() => handleZoom(product.id, -0.1)}> - </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Planner;
