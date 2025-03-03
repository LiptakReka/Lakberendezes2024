import React, { useState } from 'react';
import "./Register.css";
import { Mail, Key, Users, Image } from "lucide-react";
import { useNavigate } from 'react-router-dom';

const Register = () => {
    const navigate = useNavigate();
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullname, setFullname] = useState("");
    const [error, setError] = useState('');
    const [username, setUsername] = useState("");
    const [profilePicture, setProfilePicture] = useState(null);
    const [success, setSuccess] = useState("");

    const handleregister = async (e) => {
        e.preventDefault();


        const formData = new FormData();
        formData.append('fullname', fullname);
        formData.append('username', username);
        formData.append('password', password);
        formData.append('email', email);
        if (profilePicture) {
            formData.append('ProfilePictureUrl', profilePicture);
        }

        try {
            const response = await fetch('https://localhost:7247/api/Users/register', {
                method: 'POST',
                body: formData, 
            });

            if (response.ok) {
                setSuccess("Sikeres regisztráció!");
                setFullname('');
                setEmail('');
                setPassword('');
                setUsername('');
                setProfilePicture(null);
            } else {
                const errorData = await response.json();
                console.error("Szerver hiba:", errorData);
                setError(errorData.message || "Hibás adatok vagy ismeretlen hiba.");
            }
        } catch (error) {
            console.error('Hálózati hiba:', error);
            setError('Nem sikerült kapcsolatot létesíteni a kiszolgálóval.');
        }
    };

    return (
        <div className="register-container">
            <div className="register-box">
                <h2 className="register-title">Regisztráció</h2>
                {error && <div className="alert alert-error">{error}</div>}
                {success && <div className="alert alert-success">{success}</div>}
                <form onSubmit={handleregister} className="register-form">
                    <div className="form-group">
                        <label className="form-label">
                            <Users className="icon" /> Teljes név:
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
                            <Users className="icon" /> Felhasználónév:
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
                            <Mail className="icon" /> E-mail:
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
                            <Key className="icon" /> Jelszó:
                        </label>
                        <input
                            type="password"
                            className="form-input"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">
                            <Image className="icon" /> Profilkép:
                        </label>
                        <input
                            type="file"
                            className="form-input"
                            onChange={(e) => setProfilePicture(e.target.files[0])}
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
