import React, { useState } from 'react';
import "./Register.css";
import { Mail, Key, Users, Image } from "lucide-react";
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { StarsIcon } from 'hugeicons-react';
import Passwordreq from '../../Pages2/Passwordreq/Passwordreq'; 

const Register = () => {
    // A navigate függvény importálása 
    const navigate = useNavigate();
    // Állapotváltozók 
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullname, setFullname] = useState("");
    const [error, setError] = useState('');
    const [confirmPassword, setConfirmPassword] = useState("");
    const [username, setUsername] = useState("");
    const [profilePicture, setProfilePicture] = useState(null);
    const [success, setSuccess] = useState("");
    const [setPasswordReqs] = useState({
        length: false,
        uppercase: false,
        lowercase: false,
        number: false,
        special: false
    });
    const [showPasswordReqs, setShowPasswordReqs] = useState(false);


    const checkPasswordRequirements = (password) => {
        const reqsStatus = {
            length: password.length >= 8,
            uppercase: /[A-Z]/.test(password),
            lowercase: /[a-z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
        };
        setPasswordReqs(reqsStatus);
        return Object.values(reqsStatus).every(req => req === true);
    };

    // Jelszó változás kezelése
    const handlePasswordChange = (e) => {
        const newPassword = e.target.value;
        setPassword(newPassword);
        setShowPasswordReqs(true);
        checkPasswordRequirements(newPassword);
    };

    // Függvény a regisztráció kezelésére
    const handleregister = async (e) => {
        e.preventDefault();

        // Jelszó ellenőrzése
        if (password !== confirmPassword) {
            setError("A jelszavak nem egyeznek meg!");
            return;
        }

        // Jelszó követelmények ellenőrzése
        if (!checkPasswordRequirements(password)) {
            setError("A jelszó nem felel meg az összes követelménynek!");
            return;
        }

        const formData = new FormData();
        formData.append('fullname', fullname);
        formData.append('username', username);
        formData.append('password', password);
        formData.append('email', email);
        if (profilePicture) {
            formData.append('ProfilePictureUrl', profilePicture);
        }

        try {
           
            await axios.post(
               process.env.REACT_APP_API_URL + "/Users/register",
                formData,
                {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                }
            );

            setSuccess("Sikeres regisztráció!");
            setFullname('');
            setEmail('');
            setPassword('');
            setConfirmPassword('');
            setUsername('');
            setProfilePicture(null);
            
            setTimeout(() => {
                navigate('/login');
            }, 2000);
        } catch (error) {
            console.error('Hálózati hiba:', error);
            
            if (error.response && error.response.data) {
                
                const errorData = error.response.data;
                setError(errorData.message || "Hibás adatok vagy ismeretlen hiba.");
            } else {
                setError('Nem sikerült kapcsolatot létesíteni a kiszolgálóval.');
            }
        }
    };

    return (
        <div className="register-container">
            <div className="register-box">
                <h2 className="register-title">Regisztráció</h2>
                <h3 className="register-subtitle">A csillaggal jelölt mezők kitöltése kötelező!</h3>
                {error && <div className="alert alert-error">{error}</div>}
                {success && <div className="alert alert-success">{success}</div>}
                <form onSubmit={handleregister} className="register-form">
                    <div className="form-group">
                        <label className="form-label">
                            <Users className="icon" /> Teljes név: <StarsIcon className='reqstar'/>
                        </label>
                        <input
                            type="text"
                            className="form-input"
                            value={fullname}
                            onChange={(e) => setFullname(e.target.value)}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">
                            <Users className="icon" /> Felhasználónév: <StarsIcon className='reqstar'/> 
                        </label>
                        <input
                            type="text"
                            className="form-input"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">
                            <Mail className="icon" /> E-mail: <StarsIcon className='reqstar'/>
                        </label>
                        <input
                            type="email"
                            className="form-input"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">
                            <Key className="icon" /> Jelszó: <StarsIcon className='reqstar'/>
                        </label>
                        <input
                            type="password"
                            className="form-input"
                            value={password}
                            onChange={handlePasswordChange}
                            onFocus={() => setShowPasswordReqs(true)} // Megjelenítjük a követelményeket fókuszáláskor is
                            onBlur={() => setShowPasswordReqs(false)} // Opcionális: elrejthetjük, ha elveszíti a fókuszt
                            required
                        />
                       
                        <Passwordreq password={password} isVisible={showPasswordReqs} />
                    </div>
                    
                    <div className="form-group">
                        <label className="form-label">
                            <Key className="icon" /> Jelszó újra: <StarsIcon className='reqstar'/>
                        </label>
                        <input
                            type="password"
                            className="form-input"
                            value={confirmPassword}
                            onChange={(e) => setConfirmPassword(e.target.value)}
                            required
                        />
                    </div>
                    
                    <div className="form-group">
                        <label className="form-label">
                            <Image className="icon" /> Profilkép:  <StarsIcon className='reqstar'/>
                        </label>
                        <input
                            type="file"
                            className="form-input"
                            onChange={(e) => setProfilePicture(e.target.files[0])}
                            required
                        />
                    </div>
                    
                    <button type="submit" className="register-button">
                        Regisztráció
                    </button>
                    
                    <button 
                        type="button" 
                        className="login-link-button"
                        onClick={() => navigate("/login")}
                    >
                        Már van fiókod? Bejelentkezés
                    </button>
                </form>
            </div>
        </div>
    );
};

export default Register;
