import React, { useState, useEffect } from "react";
import "./Planner.css"; 
import { X, Plus, Minus,  Folder, Calendar, Bookmark } from "lucide-react";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import axios from "axios";
import { enqueueSnackbar } from "notistack";
import UseCart from "./UseCart";
import {useAchievements} from "../Pages2/UseAchivements";


const Planner = () => {
  const {unlockAchievement} = useAchievements();
  const {addToCart} = UseCart();
  const [products, setProducts] = useState([]);
  const [placedProducts, setPlacedProducts] = useState([]);
  const [savedPlans, setSavedPlans] = useState([]);
  const [draggedProduct, setDraggedProduct] = useState(null);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });
  

  useEffect(() => {
    fetchProductsByRoom(1);
    fetchSavedPlans();
  }, []);

  const fetchProductsByRoom = async (roomId) => {
    try {
      const response = await fetch(`https://localhost:7247/api/Products/szobák?roomId=${roomId}`, {
        headers: {
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error('Hálózati hiba a szobák lekéréseben');
      }

      const data = await response.json();
      setProducts(data);
    } catch (error) {
      console.error('Hálózati probléma:', error);
      enqueueSnackbar('Hiba történt a termékek lekérésekor.', { variant: 'error' });
    }
  };

  const fetchSavedPlans = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (!user) return;

    try {
      const response = await axios.get(`https://localhost:7247/api/Users/get-plan/${user.id}`);
      console.log("fetchPlans adatai:", response.data); // 🔥 Debugging

      if (Array.isArray(response.data)) {
        setSavedPlans(response.data);
      } else if (response.data) {
        setSavedPlans([response.data]);
      } else {
        setSavedPlans([]);
      }
    } catch (error) {
      console.error("Hiba a mentett tervek lekérésekor:", error);
      setSavedPlans([]);
      enqueueSnackbar('Hiba történt a mentett tervek lekérésekor.', {variant: 'error'});
    }
};
;

const savePlan = async () => {
  const user = JSON.parse(localStorage.getItem("user"));
  if (!user) {
      enqueueSnackbar("Először jelentkezz be!", { variant: "error" });
      return;
  }

  try {
     
      const planResponse = await axios.post("https://localhost:7247/api/Users/save-plan", {
          userId: user.id, 
          planData: JSON.stringify(placedProducts.map(p => ({
              productId: p.id,
              x: p.x,
              y: p.y,
              scale: p.scale || 1
          })))  
      });

      if (planResponse.status !== 200) {
          throw new Error("Terv mentése sikertelen.");
      }

      const planId = planResponse.data.planId;

     
      await axios.post("https://localhost:7247/api/PlanProducts/save", {
          userPlanId: planId,
          planData: JSON.stringify(placedProducts.map((product) => ({
              productId: product.id,
              x: product.x,
              y: product.y,
              scale: product.scale || 1
          })))
      });

      enqueueSnackbar("Terv és termékek sikeresen mentve!", {variant: "success"});

  } catch (error) {
      console.error("Hiba a terv mentésekor:", error);
      toast.error("Hiba történt a terv mentésekor.", { position: "top-center" });
  }
  unlockAchievement("Első terv!", "Elmentetted az első terved!", "🏠");
};


  const handleRoomSelect = (roomId) => {
    fetchProductsByRoom(roomId);
    setPlacedProducts([]);
  };

  const addToPlanner = (product) => {
    setPlacedProducts([
      ...placedProducts,
      {
        ...product,
        x: 100,
        y: 100,
        scale: 0.5,
      },
    ]);
  };

  const handleMouseDown = (event, product) => {
    setDraggedProduct(product);
    setDragOffset({
      x: event.clientX - product.x,
      y: event.clientY - product.y,
    });
  };

  const handleMouseMove = (event) => {
    if (draggedProduct) {
      const updatedProducts = placedProducts.map((product) =>
        product.id === draggedProduct.id
          ? { ...product, x: event.clientX - dragOffset.x, y: event.clientY - dragOffset.y }
          : product
      );
      setPlacedProducts(updatedProducts);
    }
  };

  const handleMouseUp = () => {
    setDraggedProduct(null);
  };

  const handleZoom = (productId, scaleChange) => {
    setPlacedProducts(placedProducts.map(p =>
      p.id === productId ? { ...p, scale: Math.max(0.5, Math.min((p.scale || 1) + scaleChange, 3)) } : p
    ));
  };

  const loadPlan = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    try {
        const response = await axios.get(`https://localhost:7247/api/Users/get-plan/${user.id}`);
        console.log("loadPlan adatai:", response.data);

        if (!response.data || !response.data.products) {
            enqueueSnackbar("Nincsenek termékek ebben a tervben!", { variant: "error" });
            return;
        }

       
        const loadedProducts = Array.isArray(response.data.products)
        ? response.data.products.map(p => {
            const [x, y] = (p.position || "0,0").split(",").map(Number);
            return {
              id: p.productid,
              name: p.name,
              imageurl: p.imageurl,
              price: p.price,
              shoplink: p.shoplink,
              x: x || 0,
              y: y || 0,
              scale: p.scale || 1
            };
          })
        : [];
        setPlacedProducts(loadedProducts);
        enqueueSnackbar("Terv sikeresen betöltve!", { variant: "success" });
        
    } catch (error) {
        console.error("Hiba a terv betöltésekor:", error);
        enqueueSnackbar("Hiba történt a terv betöltésekor.", { variant: "error" });
    }
};


  return (
    <div className="planner-container" onMouseMove={handleMouseMove} onMouseUp={handleMouseUp}>
    

     
       
    <div className="save-load-container">
  <button className="save-btn" onClick={savePlan}>
    <Bookmark /> Terv mentése
  </button>

  <div className="plan-info">
    <span><Calendar/> {savedPlans.length > 0 ? new Date(savedPlans[0].createdat + "Z").toLocaleString("hu-HU") : "Nincs dátum"}</span>
  </div>

  <button className="load-btn" onClick={() => loadPlan()}>
    <Folder/> Betöltés
  </button>
</div>


          <div className="rooms">
            <button onClick={() => handleRoomSelect(1)} className="category-button">Nappali</button>
            <button onClick={() => handleRoomSelect(5)} className="category-button">Étkező</button>
            <button onClick={() => handleRoomSelect(3)} className="category-button">Hálószoba</button>
            <button onClick={() => handleRoomSelect(4)} className="category-button">Fürdőszoba</button>
          </div>

          <div className="products-and-planner">
            <div className="products">
              {products.length > 0 ? (
                products.map((product) => (
                  <div className="product-card" key={product.id}>
                    <img src={product.imageurl} alt={product.name} className="product-image" />
                    <h3>{product.name}</h3>
                    <p>{product.price} Ft</p>
                    <button className="buy-btn" onClick={() => addToPlanner(product)}>Hozzáadás</button>
                    <button
              className="bg-blue-500 text-white p-2 rounded-md mt-2"
              onClick={() => addToCart(product)}
            >
              Kosárba
            </button>
                  </div>
                ))
              ) : (
                <p>Válassz ki egy szobát!</p>
              )}
            </div>

            <div className="tervezoterulet">
              {placedProducts.map((product) => (
                <div
                  className="placed-product"
                  key={product.id}
                  style={{
                    left: `${product.x}px`,
                    top: `${product.y}px`,
                    transform: `scale(${product.scale || 0.5})`,
                    position: 'absolute'
                  }}
                  onMouseDown={(event) => handleMouseDown(event, product)}
                >
                  <button
                    className="remove-btn"
                    onClick={(e) => {
                      e.stopPropagation();
                      setPlacedProducts(placedProducts.filter((p) => p.id !== product.id));
                    }}
                  >
                    <X />
                  </button>
                  <img
                    src={product.imageurl}
                    alt={product.name}
                    draggable={false}
                    style={{ pointerEvents: "none" }}
                  />
                  <div className="zoom-controls">
                    <button onClick={() => handleZoom(product.id, 0.1)}> <Plus/> </button>
                    <button onClick={() => handleZoom(product.id, -0.1)}> <Minus/> </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
       
     
    
    </div>
  );
};

export default Planner;