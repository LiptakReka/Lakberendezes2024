import React, { useState, useEffect, useCallback, useRef } from "react";
import "./Planner.css"; 
import { X, Plus, Minus, Folder, Calendar, Bookmark } from "lucide-react";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import axios from "axios";
import { enqueueSnackbar } from "notistack";
import UseCart from "../Cart/UseCart";
import {useAchievements} from "../Achievement/UseAchivements";

const Planner = () => {
  const [showDropdown, setShowDropdown]=useState(false);
  const [dropdownlabel , setdropdownlabel]= useState("Válassz terméktípust");
  const {unlockAchievement} = useAchievements();
  const {addToCart} = UseCart();
  const [products, setProducts] = useState([]);
  const [placedProducts, setPlacedProducts] = useState([]);
  const [savedPlans, setSavedPlans] = useState([]);
  const [draggedProduct, setDraggedProduct] = useState(null);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });
  const [types, setTypes] = useState([]);
  const [selectedType, setSelectedType] = useState(null);
  const [selectedRoom, setSelectedRoom] = useState(1);
  const [showBackgrounds, setShowBackgrounds] = useState(false);
  const [selectedBackground, setSelectedBackground] = useState(null);
  const plannerRef = useRef(null);

const backgrounds = [
    { id: 1, url: "https://blog.pincel.app/wp-content/uploads/2024/05/empty-room-filler.jpg", name: "Nappali 1" },
    { id: 2, url: "https://i.pinimg.com/originals/34/99/d1/3499d12f28a741f0063ee8f2bbd711d9.jpg", name: "Nappali 2" },
    { id: 3, url: "https://t4.ftcdn.net/jpg/02/87/98/61/360_F_287986158_2Tz2w7QKcgmbpecZZzveGUdN9RNPB3c4.jpg", name: "Hálószoba 1" },
    { id: 4, url: "https://img.freepik.com/premium-photo/empty-interior-room-d-illustration_672982-3219.jpg", name: "Hálószoba 2" },
    { id: 5, url: "https://img.freepik.com/free-vector/empty-modern-room-interior_1284-9406.jpg", name: "Étkező 1" },
    { id: 6, url: "https://img.freepik.com/premium-photo/concretefloored-vacant-room_872147-23841.jpg", name: "Fürdőszoba 1" },
  ];


  const handleBackgroundSelect = (bg) => {
    setSelectedBackground(bg);
    setShowBackgrounds(false);
  };


  const fetchProductTypes = async (roomid) => {
    try {
      const token = localStorage.getItem("token"); 
    
      const response = await axios.get(process.env.REACT_APP_API_URL + `/ProductTypes/byroom?roomid=${roomid}`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      });
      

      setTypes(response.data);
    } catch (error) {
      console.error("Hálózati probléma: ", error);
      enqueueSnackbar("Hiba történt a típusok lekérésekor.", {
        variant: "error"
      });
    }
  };

  const handleTypeSelect = (typeId) => {
    const newTypeId = typeId === selectedType ? null : typeId;
    setSelectedType(newTypeId);
    setdropdownlabel(newTypeId ? typeNames[newTypeId] : "Válassz terméktípust");
    setShowDropdown(false);
    fetchFilteredProducts(selectedRoom, newTypeId);
  };


  const typeNames={
    1:"Kanapék",
    3:"Dohányzóasztal",
    5:"Tv állvány",
    11: "Ágy",
    13: "Éjjeliszekrény",
    14: "Szekrény",
    16: "Tükör",
    21:"Étkezőasztal",
    22:"Polc és szekrény",
    23:"Szék",
    34:"Zuhanyzó",
    35:"Fürdőszobai szekrény",
    36:"Mosókonyhai eszközök"

  }


  const fetchProductsByRoom = useCallback(async (roomid) => {
    try {
      const token = localStorage.getItem("token");
    
      const response = await axios.get(process.env.REACT_APP_API_URL + `/Products/szobák?roomid=${roomid}`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      });

      setProducts(response.data);
      setSelectedRoom(roomid);
      setSelectedType(null);
      fetchProductTypes(roomid);
    } catch (error) {
      console.error('Hálózati probléma:', error);
      enqueueSnackbar('Hiba történt a termékek lekérésekor.', { variant: 'error' });
    }
  }, []);

  const handleRoomSelect = (roomId) => {
    fetchProductsByRoom(roomId);
    setPlacedProducts([]);
    setSelectedType(null);
    setdropdownlabel("Válassz terméktípust");
  };

  useEffect(() => {
    fetchProductsByRoom(1);
    fetchSavedPlans();
  }, [fetchProductsByRoom]);


  const fetchFilteredProducts = async (roomid, typeid) => {
    try {
      const token = localStorage.getItem("token"); 
      let url = typeid 
        ? process.env.REACT_APP_API_URL + `/Products/typeandroom?roomid=${roomid}&typeid=${typeid}` 
        : process.env.REACT_APP_API_URL + `/Products/szobák?roomid=${roomid}`;

   
      const response = await axios.get(url, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      });

   
      setProducts(response.data);
    } catch (error) {
      console.error('Hálózati probléma:', error);
      enqueueSnackbar('Hiba történt a termékek lekérésekor.', { variant: 'error' });
    }
  };

const savePlan = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (!user) {
        enqueueSnackbar("Először jelentkezz be!", { variant: "error" });
        return;
    }

    try {
        const token = localStorage.getItem("token"); 
        const planResponse = await axios.post(process.env.REACT_APP_API_URL + "/Users/save-plan", {
            userId: user.id, 
            planData: JSON.stringify(placedProducts.map(p => ({
                productId: p.id,
                x: p.x,
                y: p.y,
                scale: p.scale || 1
            })))  
        }, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        if (planResponse.status !== 200) {
            throw new Error("Terv mentése sikertelen.");
        }

        const planId = planResponse.data.planId;

        await axios.post( process.env.REACT_APP_API_URL + "/PlanProducts/save", {
            userPlanId: planId,
            planData: JSON.stringify(placedProducts.map((product) => ({
                productId: product.id,
                x: product.x,
                y: product.y,
                scale: product.scale || 1
            })))
        }, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        enqueueSnackbar("Terv és termékek sikeresen mentve!", {variant: "success"});

    } catch (error) {
        console.error("Hiba a terv mentésekor:", error);
        toast.error("Hiba történt a terv mentésekor.", { position: "top-center" });
    }
    unlockAchievement("Első terv!", "Elmentetted az első terved!", "🏠");
  };



  const fetchSavedPlans = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (!user) return;

    try {
      const token = localStorage.getItem("token");
      const response = await axios.get(process.env.REACT_APP_API_URL + `/Users/get-plan/${user.id}`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

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


const loadPlan = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    try {
        const token = localStorage.getItem("token"); 
        const response = await axios.get(process.env.REACT_APP_API_URL + `/Users/get-plan/${user.id}`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
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


const handleMouseDown = (event, product) => {
    if (!Istouch()) {
    setDraggedProduct(product);
    setDragOffset({
      x: event.clientX - product.x,
      y: event.clientY - product.y,
    });
  }
  };

  const handleMouseMove = (event) => {
    if (!Istouch() && draggedProduct) {
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

 const Istouch = useCallback(() => {
    return "ontouchstart" in window || navigator.maxTouchPoints > 0;
  }, []);

  
  const handleTouch = useCallback((event, product) => {
    event.preventDefault(); // Megakadályozzuk az alapértelmezett viselkedést
    event.stopPropagation(); // Megakadályozzuk a buborékolást
    
    if (Istouch()) {
      setDraggedProduct(product);
      const touch = event.touches[0];
      setDragOffset({
        x: touch.clientX - product.x,
        y: touch.clientY - product.y,
      });
    }
  }, [Istouch]);

  const handleTouchMove = useCallback((event) => {
 
    if (Istouch() && draggedProduct) {

      if (event.cancelable) {
        event.preventDefault();
      }
      
      const touch = event.touches[0];
      const updatedProducts = placedProducts.map((product) =>
        product.id === draggedProduct.id
          ? { ...product, x: touch.clientX - dragOffset.x, y: touch.clientY - dragOffset.y }
          : product
      );
      setPlacedProducts(updatedProducts);
    }
  }, [draggedProduct, dragOffset, placedProducts, Istouch]);

  const handleTouchEnd = useCallback((event) => {
    if (Istouch() && draggedProduct) {
      if (event.cancelable) {
        event.preventDefault();
      }
      setDraggedProduct(null);
    }
  }, [Istouch, draggedProduct]);

  useEffect(() => {
    const plannerElement = plannerRef.current;
    
    if (plannerElement) {
 
      plannerElement.removeEventListener('touchmove', handleTouchMove);
      plannerElement.removeEventListener('touchend', handleTouchEnd);
      
   
      plannerElement.addEventListener('touchmove', handleTouchMove, { passive: false });
      plannerElement.addEventListener('touchend', handleTouchEnd, { passive: false });
      
  
      return () => {
        plannerElement.removeEventListener('touchmove', handleTouchMove);
        plannerElement.removeEventListener('touchend', handleTouchEnd);
      };
    }
  }, [handleTouchMove, handleTouchEnd]);

  const handleZoom = useCallback((productId, scaleChange) => {
    setPlacedProducts(placedProducts.map(p => {
      if (p.id === productId) {
        const currentScale = p.scale || 1;
        const adaptiveChange = currentScale < 0.2 ? scaleChange * 0.1 : scaleChange;
        return {
          ...p,
          scale: Math.max(0.01, Math.min(currentScale + adaptiveChange, 3))
        };
      }
      return p;
    }));
  }, [placedProducts]);

  return (
    <div 
      className="planner-container" 
      ref={plannerRef}
      onMouseMove={handleMouseMove} 
      onMouseUp={handleMouseUp} 
      onTouchEnd={handleTouchEnd}
    >
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
      
    
      <div className="scale-warning-banner">
        <div className="warning-icon">ⓘ</div>
        <p>Figyelem! A megjelenített bútorok méretaránya csak illusztráció, nem tükrözi a valós méretarányokat és a felhasználói élmény érdekében ajánlott számítógépen tervezni a felületen.</p>
      </div>
      
      <div className="rooms">
        <button onClick={() => handleRoomSelect(1)} className={`category-button ${selectedRoom === 1 ? 'active' : ''}`}>Nappali</button>
        <button onClick={() => handleRoomSelect(5)} className={`category-button ${selectedRoom === 5 ? 'active' : ''}`}>Étkező</button>
        <button onClick={() => handleRoomSelect(3)} className={`category-button ${selectedRoom === 3 ? 'active' : ''}`}>Hálószoba</button>
        <button onClick={() => handleRoomSelect(4)} className={`category-button ${selectedRoom === 4 ? 'active' : ''}`}>Fürdőszoba</button>
      </div>
      <div className="dropdown-container">
        <button onClick={()=> setShowDropdown(!showDropdown)}
        className="dropdown-button">
          {dropdownlabel}
        </button>
        {showDropdown && (
          <div className="product-types">
          {Array.isArray(types) && types.map(type => (
            <button 
              key={type.id} 
              onClick={() => handleTypeSelect(type.id)} 
              className={`type-button ${selectedType === type.id ? 'active' : ''}`}
            >
              { typeNames[type.id] || type.name}
            </button>
          ))}
        </div>
        )}
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

        <div className="tervezoterulet" style={{
          backgroundImage: selectedBackground ? `url(${selectedBackground.url})` : 'none',
          backgroundSize: 'cover',
          backgroundPosition: 'center'
        }}>
          <div className="background-picker">
            <button 
              className="background-picker-button"
              onClick={() => setShowBackgrounds(!showBackgrounds)}
            >
              <span className="visually-hidden">Háttér</span>
            </button>
            
            {showBackgrounds && (
              <div className="background-options">
                <h3 className="background-options-title">Válassz hátteret</h3>
                <div className="background-grid">
                  {backgrounds.map(bg => (
                    <div 
                      key={bg.id}
                      onClick={() => handleBackgroundSelect(bg)}
                      className={`background-item ${selectedBackground && selectedBackground.id === bg.id ? 'active' : ''}`}
                      style={{ backgroundImage: `url(${bg.url})` }}
                      title={bg.name}
                    />
                  ))}
                </div>
                <button 
                  className="background-remove-btn"
                  onClick={() => {
                    setSelectedBackground(null);
                    setShowBackgrounds(false);
                  }}
                >
                  Háttér eltávolítása
                </button>
              </div>
            )}
          </div>

          {placedProducts.map((product) => (
            <div
              className="placed-product"
              key={product.id}
              style={{
                left: `${product.x}px`,
                top: `${product.y}px`,
                transform: `scale(${product.scale || 0.5})`,
                position: 'absolute',
                userSelect: 'none',
                WebkitUserSelect: 'none',
                touchAction: 'none', // Fontos a dragginghez
                cursor: 'move',
              }}
              onMouseDown={(event) => {
                event.preventDefault();
                handleMouseDown(event, product);
              }}
              onTouchStart={(event) => handleTouch(event, product)}
              onDoubleClick={(e) => e.preventDefault()}
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
