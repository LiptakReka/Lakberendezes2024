import React, { useState } from 'react';
import "./Contact.css";
import { Mail, Phone, Search } from 'lucide-react';


const pagecontact = [
  {name: "RoomLab", phone: "+36 30-927-0458", email: "roomlabservice@gmail.com"}
];

const businesses = [
  { name: "Bogart Bútor", phone: "+36 1-808-9860", email: "info@bogart-butor.hu" },
  { name: "Alaba", phone: "+36 30-366-1576", email: "info@alaba.hu" },
  { name: "XXXLutz", phone: "+36 23-801-911", email: "shop@xxxlutz.hu" },
  { name: "BRW Bútorház", phone: "+36 70-401-2044", email: "rob.butorhaz@gmail.com" },
  { name: "JYSK", phone: "+36 1-701-4222", email: "vevoszolgalat-hu@jysk.com" },
  { name: "Möbelix", phone: "+36 46-814-113", email: "info@moebelix.hu" },
  { name: "Zondo", phone: "+36 1-550-7605", email: "info@zondo.hu" },
  { name: "Soma bútor", phone: "+36 70-797-5817", email: "info@somabutor.hu" },
  { name: "Bútor7", phone: "nem áll rendelkezésre", email: "info@butor7.hu" },
  { name: "Bútorline", phone: "+36 20-273-0605", email: "info@butorline.hu" },
  { name: "RS Bútor", phone: "+36 1-329-0050", email: "rsinfo@rs.hu" },
  { name: "IKEA", phone: "+36 1-808-9230", email: "nem áll rendelkezésre" },
  { name: "Magyar Bútorbolt", phone: "nem áll rendelkezésre", email: "megrendeles@magyarbutorbolt.hu" },
  { name: "Butlers", phone: "+36 30-726-9588", email: "home@butlers.hu" },
];

const ContactCard = ({ name, phone, email, index }) => {
  const isPhoneAvailable = phone !== "nem áll rendelkezésre";
  const isEmailAvailable = email !== "nem áll rendelkezésre";
  
  return (
    <div className="contact-card" style={{"--index": index}}>
      <h3 className="contact-name">{name}</h3>
      <p className="contact-phone">
        <Phone/>
        {isPhoneAvailable ? phone : <span className="email-unavailable">Telefonszám nem elérhető</span>}
      </p>
      {isEmailAvailable ? (
        <a href={`mailto:${email}`} className="contact-email">
          <Mail/>
          { email}
        </a>
      ) : (
        <span className="email-unavailable">Email cím nem elérhető</span>
      )}
    </div>
  );
};

export default function ContactPage() {
  const [searchTerm, setSearchTerm] = useState('');
  
  const filteredBusinesses = businesses.filter(business => 
    business.name.toLowerCase().includes(searchTerm.toLowerCase())
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
          <h2 className="section-title">Közreműködők</h2>
          <div className="search-container">
            <input 
              type="text" 
              placeholder="Keresés név szerint..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
              
            />
            <Search/>
          </div>
          <div className="contacts-grid">
            {filteredBusinesses.map((business, index) => (
              <ContactCard key={index} {...business} index={index} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
