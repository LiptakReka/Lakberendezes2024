import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import Navbar1 from './components/Navbar1';
import Home from "./Pages2/Home";
import Planner from "./Pages2/Planner";
import About from "./Pages2/About";
import Contact from "./Pages2/Contact";
import Login from './components/Login';
import Register from './components/Register';
import ForgotPassword from './components/ForgotPassword';
import ResetPassword from './components/ResetPassword';
import './output.css';

const App = () => {
    const [token, setToken] = useState(localStorage.getItem("token") || null);

    const handleLogout = () => {
        localStorage.removeItem("token");
        setToken(null);
    };

    useEffect(() => {
        if (token) {
            localStorage.setItem("token", token);
        } else {
            localStorage.removeItem("token");
        }
    }, [token]);

    return (
        <Router>
            
            {token && <Navbar1 token={token} onLogout={handleLogout} />}
            
            <Routes>
                
                <Route path="/reset-password" element={<ResetPassword />} />
                <Route path="/forgot-password" element={<ForgotPassword />} />

                
                {!token ? (
                    <>
                        <Route path="/login" element={<Login setToken={setToken} />} />
                        <Route path="/register" element={<Register setToken={setToken} />} />
                        <Route path="*" element={<Navigate to="/login" replace />} />
                    </>
                ) : (
                    <>
                       
                        <Route path="/" element={<Home />} />
                        <Route path="/about" element={<About />} />
                        <Route path="/planner" element={<Planner />} />
                        <Route path="/contact" element={<Contact />} />

                        
                        <Route path="*" element={<Navigate to="/" replace />} />
                    </>
                )}
            </Routes>
        </Router>
    );
};

export default App;
