import React, { useState } from "react";
import axios from "axios";
import { Mail } from "lucide-react";
import { useNavigate } from "react-router-dom";
import "./ForgotPassword.css";

const ForgotPassword = () => {
    // Importáljuk a navigate függvényt a react-router-dom-ból és változóba mentjük a használathoz
    const navigate = useNavigate();
    // Állapotváltozók
    const [email, setEmail] = useState("");
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    const [isLoading, setIsLoading] = useState(false);

    // Függvény az elfelejtett jelszó kezelésére
    const handleSubmit = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setError("");
        setMessage("");

        try {
            await axios.post(
                process.env.REACT_APP_API_URL + "/Users/forgotpass", // Backend kommunikáció
                { email }
            );

            setMessage("Ha az e-mail cím létezik, elküldtük a visszaállítási linket.");
        } catch (err) {
            setError("Hiba történt! Próbáld újra később."); // Hibakezelés
        }
        setIsLoading(false);
    };

    return (
        <div className="forgot-container">
            <div className="forgot-card">
                <h2 className="forgot-title">Elfelejtett jelszó</h2>
                {message && <div className="alert alert-success">{message}</div>}
                {error && <div className="alert alert-error">{error}</div>}
                <form onSubmit={handleSubmit} className="forgot-form">
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
                    <button
                        type="submit"
                        className="submit-button"
                        disabled={isLoading}
                    >
                        {isLoading ? "Küldés..." : "Küldés"}
                    </button>
                    <button
                        type="button"
                        className="back-button"
                        onClick={() => navigate("/login")}
                    >
                        Vissza a bejelentkezéshez
                    </button>
                </form>
            </div>
        </div>
    );
};

export default ForgotPassword;
