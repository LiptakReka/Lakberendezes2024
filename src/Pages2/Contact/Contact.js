import React, { useEffect, useState } from 'react';
import "./Contact.css";
import { Mail, Phone,  Search } from 'lucide-react';

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
        const response = await fetch('https://localhost:7247/api/Shops');
        if (!response.ok) {
          throw new Error('Hiba a keresés során');
        }
        const data = await response.json();
        console.log(data);
        setShops(data);
      } catch (error) {
        setError(error.message);
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