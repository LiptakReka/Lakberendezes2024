import React, { useState, useEffect, useCallback } from "react";
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

const backgrounds = [
    { id: 1, url: "https://blog.pincel.app/wp-content/uploads/2024/05/empty-room-filler.jpg", name: "Nappali 1" },
    { id: 2, url: "https://img.freepik.com/free-psd/blank-wall-psd-japandi-living-room-interior_53876-109284.jpg?t=st=1741782416~exp=1741786016~hmac=908ccceaa768aac602c8e7f4099a3d9143343ee1e0c790cca7de5022ab31e5c6&w=1380", name: "Nappali 2" },
    { id: 3, url: "https://t4.ftcdn.net/jpg/02/87/98/61/360_F_287986158_2Tz2w7QKcgmbpecZZzveGUdN9RNPB3c4.jpg", name: "Hálószoba 1" },
    { id: 4, url: "https://img.freepik.com/premium-photo/empty-interior-room-d-illustration_672982-3219.jpg", name: "Hálószoba 2" },
    { id: 5, url: "https://img.freepik.com/free-vector/empty-modern-room-interior_1284-9406.jpg", name: "Étkező 1" },
    { id: 6, url: "https://img.freepik.com/free-photo/minimal-rooms-walls-with-lighting-effects-3d-rendering_23-2149210321.jpg?t=st=1741781431~exp=1741785031~hmac=a53ab63f717856d27d796727de3ed134a2589cf45bd8721d6db925ed7ef90350&w=1380", name: "Fürdőszoba 1" },
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

 const Istouch=()=>{
    return "ontouchstart" in window || navigator.maxTouchPoints > 0 ;
  }

  
  const handleTouch=(event, product)=>{
    if (Istouch()) {
      event.preventDefault();
      setDraggedProduct(product);
      const otuch=event.touches[0];
      setDragOffset({
        x: otuch.clientX - product.x,
        y: otuch.clientY - product.y,
      });
    }
  };

  const handleTouchMove=(event)=>{
    if (Istouch() && draggedProduct) {
      event.preventDefault();
      const otuch=event.touches[0];
      const updatedProducts = placedProducts.map((product) =>
        product.id === draggedProduct.id
          ? { ...product, x: otuch.clientX - dragOffset.x, y: otuch.clientY - dragOffset.y }
          : product
      );
      setPlacedProducts(updatedProducts);
    }
  };

  const handleTENd=()=>{
    if (Istouch()) {
      setDraggedProduct(null);
    }
  }

  const handleZoom = (productId, scaleChange) => {
    setPlacedProducts(placedProducts.map(p =>
      p.id === productId ? { ...p, scale: Math.max(0.5, Math.min((p.scale || 1) + scaleChange, 3)) } : p
    ));
  };

  return (
    <div className="planner-container" onMouseMove={handleMouseMove} onMouseUp={handleMouseUp} onTouchMove={handleTouchMove} onTouchEnd={handleTENd}>
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
        <p>Figyelem! A megjelenített bútorok méretaránya csak illusztráció, nem tükrözi a valós méretarányokat.</p>
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
                position: 'absolute'
              }}
              onMouseDown={(event) => handleMouseDown(event, product)}
              onTouchStart={(event) => handleTouch(event, product)}
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
