import React, { useEffect, useState } from 'react';
import { Settings, User, Mail, Lock, Shield, TriangleRight, List, User2, Key, Camera, Trophy } from "lucide-react";
import axios from 'axios';
import "./Usersetts.css";
import ProfilePictureUpload from '../../components/Profilepicture/ProfilePicture';
import { useAchievements } from '../Achievement/UseAchivements';

export default function UserSetts() {
  
    const { achievements } = useAchievements();
    const [user, setuser] = useState(null);
    const [password, setPassword] = useState("");
    const [oldpassword, setOldpassword] = useState("");
    const [message, setMessage] = useState("");
    const [activeTab, setActiveTab] = useState("profile");
    const [userAchievements, setUserAchievements] = useState([]);
    const [deleteconfirm, setdeleteconfirm] = useState("");
    const [deleteMessage, setdeleteMessage] = useState("");
    const [showdeleteconfirm, setshowdeleteconfirm] = useState(false);


    const handledelete = async () => {
      if(deleteconfirm !== user.userName){
        setdeleteMessage("A felhasználónév nem egyezik");
        return;
      }
      try{
         await axios.delete(
          `${process.env.REACT_APP_API_URL}/Users/${user.userName}`,{
            headers:{
              Authorization: localStorage.getItem("token"),
            },
          }
        );
        setdeleteMessage("Fiók sikeresen törölve!");
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        setTimeout(() => {
          window.location.href="/";
        }, 2000);

      }catch(error){
        if(error.response?.status===403){
          setdeleteMessage("Nincs jogosultságod a törléshez");
        }else{
          setdeleteMessage(error.response?.data?.message || "Hiba történt a törlés során");
        }
      }
    };

    const deleteconfirms = () => {
      setshowdeleteconfirm(!showdeleteconfirm);
      setdeleteconfirm("");
      setdeleteMessage("");
    }

    useEffect(() => {
        const fetchAchievements = async () => {
            if (!user) return;
            
            try {
                const token = localStorage.getItem("token");
                const response = await axios.get(
                    `${process.env.REACT_APP_API_URL}/Achievement/me`,
                    {
                        headers: {
                            Authorization: token,
                        },
                    }
                );
                setUserAchievements(response.data);
            } catch (error) {
                console.error("Error fetching achievements:", error);
            }
        };
    
        if (activeTab === "profile" && user) {
            fetchAchievements();
        }
    }, [activeTab, user]);

    useEffect(() => {
        const savedUsername = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : null;
        setuser(savedUsername);
    }, []);


    const handletab = (tab) => {
        setActiveTab(tab);
    };
    
    const handlePasswordChange = async () => {
        if (!oldpassword || !password) {
            setMessage("Minden mezőt ki kell tölteni!");
            return;
        }
        try {
            const response = await axios.post(process.env.REACT_APP_API_URL + "/Users/change-password", {
                email: user.email,
                currentPassword: oldpassword,
                newPassword: password,
            }, {
                headers: {
                    Authorization: localStorage.getItem("token"),
                },
            });

            setMessage(response.data.message);
            setOldpassword("");
            setPassword("");

        } catch (error) {
            setMessage(error.response?.data || "Hiba történt a jelszó módosításánál");
        }
    };

    
    const displayAchievements = achievements.length > 0 ? achievements : userAchievements;

    return (
        <div className="user-setts-container">
            <div className="settings-container">
                <h2 className='cim'> <Settings /> Beállítások</h2>
                <div className="tabs">
                    <button className={activeTab === "profile" ? "active" : ""} onClick={() => handletab("profile")}>
                        <User /> Profil
                    </button>
                    <button className={activeTab === "security" ? "active" : ""} onClick={() => handletab("security")}>
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
                            {displayAchievements.length === 0 ? (
                              <p className="no-achievements">Még nincs megszerzett achievement.</p>
                            ) : (
                              <ul className="achievements-list">
                                {displayAchievements.map((ach, index) => (
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

                {activeTab === "security" && (
                    <div className='tab-content'>
                        <h1>Biztonsági beállítások</h1>
                        <div className='security-container'>
                            <div className='security-section'>
                                <h2>Jelszó módosítása</h2>
                                <div className='password-change'>
                                    <input type='password' placeholder='Jelenlegi jelszó' value={oldpassword} onChange={(e) => setOldpassword(e.target.value)} />
                                    <input type='password' placeholder='Új jelszó' value={password} onChange={(e) => setPassword(e.target.value)} />
                                    <button className='settings-btn' onClick={handlePasswordChange}>
                                        <Lock /> Jelszó módosítása
                                    </button>
                                    {message && <p className='message'>{message}</p>}
                                </div>
                            </div>
                            
                            <div className='security-section'>
                                <h2>Fiók törlése</h2>
                                <div className='delete-account-section'>
                                    <p className='warning-text'>Figyelem! A fiók törlése végleges, nem visszafordítható</p>
                                    {!showdeleteconfirm ? (
                                        <button className='delete-account-btn' onClick={deleteconfirms}>
                                            <Lock /> Fiók törlése
                                        </button>
                                    ) : (
                                        <div className='delete-confirmation'>
                                            <p>A törlés megerősítéséhez írd be a felhasználónevedet: <strong>{user?.userName}</strong></p>
                                            <input type='text' placeholder='Felhasználónév' value={deleteconfirm} onChange={(e) => setdeleteconfirm(e.target.value)} />
                                            <div className='delete-btn-group'>
                                                <button className='cancel-delete-btn' onClick={deleteconfirms}>Mégse</button>
                                                <button className='confirm-delete-btn' onClick={handledelete}>Törlés</button>
                                            </div>
                                            {deleteMessage && <p className='delete-message'>{deleteMessage}</p>}
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}
