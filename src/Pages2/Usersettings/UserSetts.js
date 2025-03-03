import React, { useEffect, useState } from 'react';
import { Settings, Moon, Sun, User, Mail,  Lock, Shield, TriangleRight, List,  User2, Key, Camera, Trophy } from "lucide-react";
import axios from 'axios';
import "./Usersetts.css";
import ProfilePictureUpload from '../../components/Profilepicture/ProfilePicture';
import { useAchievements } from '../Achievement/UseAchivements';


export default function UserSetts() {
    const {achievements}=useAchievements();
    const [darkMode, setdarkMode] = useState(false);
    const [user, setuser] = useState(null);
    const [password, setPassword] = useState("");
    const [oldpassword, setOldpassword] = useState("");
    const [message, setMessage] = useState("");
    const [activeTab, setActiveTab] = useState("profile");

    useEffect(() => {
        const savedUsername = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : null;
        setuser(savedUsername);

        const storedDark = localStorage.getItem("darkMode") === "enabled";
        setdarkMode(storedDark);
        if (storedDark) document.body.classList.add("dark-mode");
    }, []);

    const toggleDarkMode = () => {
        const newMode = !darkMode;
        setdarkMode(newMode);
        localStorage.setItem("darkMode", newMode ? "enabled" : "disabled");
        document.body.classList.toggle("dark-mode");
    };

    const handlePasswordChange = async () => {
        if (!oldpassword || !password) {
            setMessage("Minden mezőt ki kell tölteni!");
            return;
        }
        try {
            const response = await axios.post("https://localhost:7247/api/Users/change-password", {
                email: user.email,
                currentPassword: oldpassword,
                newPassword: password,
            });

            setMessage(response.data.message);
            setOldpassword("");
            setPassword("");

        } catch (error) {
            setMessage(error.response?.data || "Hiba történt a jelszó módosításánál");
        }
    };

    return (
        <div className="user-setts-container">
            <div className="settings-container">
                <h2 className='cim'> <Settings /> Beállítások</h2>
                <div className="tabs">
                    <button className={activeTab === "profile" ? "active" : ""} onClick={() => setActiveTab("profile")}>
                        <User /> Profil
                    </button>
                    <button className={activeTab === "display" ? "active" : ""} onClick={() => setActiveTab("display")}>
                        <Moon /> Megjelenítés
                    </button>
                    <button className={activeTab === "security" ? "active" : ""} onClick={() => setActiveTab("security")}>
                        <Shield /> Biztonság
                    </button>
                </div>

                {activeTab === "profile" && (
  <div className="tab-content">
    {user ? (
      <div className="user-info-container">

        <div className="user-details">
          <p><strong><User2/> Név:</strong> {user.userName}</p>
          <p><strong><Mail/> Email:</strong> {user.email}</p>
          <p><strong><Key/> Jogosultság:</strong> {user.roles ? user.roles.join(", ") : "Nincs jogosultság"}</p>
        </div>

        <div className="profile-achievement-section">
          <div className="profile-picture-container">
            <h3><Camera/> Profilkép módosítása</h3>
            <ProfilePictureUpload />
          </div>

          <div className="achievements-container">
            <h3><Trophy/> Megszerzett Achievementek</h3>
            {achievements.length === 0 ? (
              <p className="no-achievements">Még nincs megszerzett achievement.</p>
            ) : (
              <ul className="achievements-list">
                {achievements.map((ach, index) => (
                  <li key={index} className="achievement">
                    <span className="achievement-icon">{ach.icon && typeof ach.icon ==="string" ? ach.icon : <TriangleRight/>}</span>
                    <div>
                      <h4>{ach.title && typeof ach.title ==="string" ? ach.title : <List/>}</h4>
                      <p>{ach.descreption && typeof ach.descreption ==="string" ? ach.descreption : ""}</p>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      </div>
    ) : (
      <p>Nem található felhasználói adat</p>
    )}
  </div>
)}
                

                {activeTab === "display" && (
                    <div className='tab-content'>
                        <button className="dark-mode-btn" onClick={toggleDarkMode}>
                            {darkMode ? <Sun /> : <Moon />}
                        </button>
                    </div>
                )}

                {activeTab === "security" && (
                    <div className='tab-content'>
                        <h1>Jelszó módosítása</h1>
                        <div className='password-change'>
                            <input type='password' placeholder='Jelenlegi jelszó' value={oldpassword} onChange={(e) => setOldpassword(e.target.value)} />
                            <input type='password' placeholder='Új jelszó' value={password} onChange={(e) => setPassword(e.target.value)} />
                            <button className='settings-btn' onClick={handlePasswordChange}>
                                <Lock /> Jelszó módosítása
                            </button>
                        </div>
                        {message && <p className='message'>{message}</p>}
                    </div>
                )}
            </div>
        </div>
    );
}
