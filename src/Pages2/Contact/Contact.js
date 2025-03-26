import React, { useEffect, useState } from 'react';
import "./Contact.css";
import { Mail, Phone, Search } from 'lucide-react';
import axios from 'axios';

const pagecontact = [
  { name: "RoomLab", phoneNumber: "+36 30-927-0458", email: "roomlabservice@gmail.com", websiteurl: "https://roomlab-48d26.web.app" }
];

const ContactCard = ({ name, phoneNumber, email, index }) => {
  return (
    <div className="contact-card" style={{ "--index": index }}>
      <h3 className="contact-name">{name}</h3>
      <p className="contact-phone">
        <Phone /> {phoneNumber ? phoneNumber : <span className="unavailable">Telefonszám nem elérhető</span>}
      </p>
      {email ? (
        <a href={`mailto:${email}`} className="contact-email">
          <Mail /> {email}
        </a>
      ) : (
        <span className="unavailable">Email cím nem elérhető</span>
      )}
      
    </div>
  );
};

export default function ContactPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [shops, setShops] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchShops = async () => {
      try {
        const token = localStorage.getItem("token"); 
        
        
        const response = await axios.get(process.env.REACT_APP_API_URL + "/Shops", {
          headers: {
            "Authorization":token
          }
        });
        
      
        setShops(response.data);
      } catch (error) {
        setError(error.response?.data?.message || error.message);
      }
    };
    
    fetchShops();
  }, []);

  const filteredShops = shops.filter(shop => 
    shop.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="contact-page">
      <div className="containerd">
        <h1 className="main-title">Kapcsolatfelvétel</h1>
        <p className="subtext">Ha kérdésed van, bátran vedd fel velünk a kapcsolatot!</p>

        <div className="section">
          <h2 className="section-title">RoomLab elérhetőségek</h2>
          <div className="contacts-grid">
            {pagecontact.map((contact, index) => (
              <ContactCard key={index} {...contact} index={index} />
            ))}
          </div>
        </div>

        <div className="section">
          <h2 className="section-title">Források elérhetőségei</h2>
          <div className="search-container">
            <input 
              type="text" 
              placeholder="Keresés név szerint..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
            <Search />
          </div>
          <div className="contacts-grid">
            {error ? (
              <p className="error">{error}</p>
            ) : (
              filteredShops.map((shop, index) => (
                <ContactCard key={index} {...shop} index={index} />
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}