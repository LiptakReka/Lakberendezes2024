import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { Mail, Key } from "lucide-react";
import "./Login.css";

const Login = ({ setToken }) => {
    // A navigate függvény importálása a react-router-dom-ból és változóba mentése
    const navigate = useNavigate();
    // Állapotváltozók
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [isLoading, setIsLoading] = useState(false);

   
    // Függvény a felhasználói adatok mentésére
    const saveUserData = (token, user) => {
        localStorage.setItem("token", token);
        if (user) {
            localStorage.setItem("user", JSON.stringify(user));
        }
        localStorage.removeItem("achievements")
        
    };

    // Függvény a bejelentkezés kezelésére
    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setError("");

        try {
            const response = await axios.post(
                "https://localhost:7247/api/Users/login",
                { email, password }
            );

            if (response.data.token) {
                saveUserData(response.data.token, response.data.user || null);
                setToken(response.data.token);
                localStorage.setItem("isloggedin", true);
                localStorage.setItem("timeleft", Date.now() + 2 * 60 * 1000);
                navigate("/");
            } else {
                setError("Hibás bejelentkezési adatok.");
            }
        } catch (err) {
            setError("Hibás email vagy jelszó, vagy szerverhiba.");
        }

        setIsLoading(false);
    };

    return (
        <div className="login-container">
            <div className="login-card">
                <h2 className="login-title">Bejelentkezés</h2>
                {error && <div className="alert alert-error">{error}</div>}
                <form onSubmit={handleSubmit} className="login-form">
                    <div className="form-group">
                        <label className="form-label">
                            <Mail className="icon" /> E-mail cím
                        </label>
                        <input
                            type="email"
                            className="form-input"
                            placeholder="pl: pelda@gmail.com"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">
                            <Key className="icon" /> Jelszó
                        </label>
                        <input
                            type="password"
                            className="form-input"
                            placeholder="********"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <button
                        type="submit"
                        className="login-button"
                        disabled={isLoading}
                    >
                        {isLoading ? "Bejelentkezés..." : "Bejelentkezés"}
                    </button>
                    <button
                        type="button"
                        className="register-button"
                        onClick={() => navigate("/register")}
                    >
                        Regisztráció
                    </button>
                    <button
                        type="button"
                        className="forgot-password-button"
                        onClick={() => navigate("/forgot-password")}
                    >
                        Elfelejtett jelszó?
                    </button>
                </form>
            </div>
        </div>
    );
};

export default Login;
