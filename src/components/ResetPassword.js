import React, { useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import axios from "axios";
import { Key } from "lucide-react";
import "./ResetPassword.css";

const ResetPassword = () => {
    const [searchParams] = useSearchParams();
    const token = searchParams.get("token");
    const email = searchParams.get("email");

    const [password, setPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [error, setError] = useState("");
    const [success, setSuccess] = useState(false);
    const navigate = useNavigate();

    const handleResetPassword = async (e) => {
        e.preventDefault();

        if (password !== confirmPassword) {
            setError("A jelszavak nem egyeznek.");
            return;
        }

        try {
            const response = await axios.post("https://localhost:7247/api/Users/reset-password", {
                email,
                token,
                newPassword: password
            });

            if (response.status === 200) {
                setSuccess(true);
                setError("");
                setTimeout(() => navigate("/login"), 3000);
            }
        } catch (err) {
            setError("Hiba történt a jelszó visszaállításakor. Próbáld újra.");
        }
    };

    return (
        <div className="reset-container">
            <div className="reset-card">
                <div className="reset-card-body">
                    <h2 className="reset-title">Jelszó visszaállítás</h2>
                    {success ? (
                        <div className="alert alert-success">
                            A jelszó sikeresen megváltozott! Átirányítás a bejelentkezéshez...
                        </div>
                    ) : (
                        <>
                            {error && <div className="alert alert-error">{error}</div>}
                            <form onSubmit={handleResetPassword} className="reset-form">
                                <div className="form-group">
                                    <label className="form-label">
                                        <Key className="icon" /> Új jelszó
                                    </label>
                                    <input
                                        type="password"
                                        className="form-input"
                                        placeholder="Új jelszó"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        required
                                    />
                                </div>
                                <div className="form-group">
                                    <label className="form-label">
                                        <Key className="icon" /> Új jelszó megerősítése
                                    </label>
                                    <input
                                        type="password"
                                        className="form-input"
                                        placeholder="Jelszó újra"
                                        value={confirmPassword}
                                        onChange={(e) => setConfirmPassword(e.target.value)}
                                        required
                                    />
                                </div>
                                <button type="submit" className="reset-button">
                                    Jelszó visszaállítása
                                </button>
                            </form>
                        </>
                    )}
                </div>
            </div>
        </div>
    );
};

export default ResetPassword;
