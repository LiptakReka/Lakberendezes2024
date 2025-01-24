import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Navbar1 from './components/Navbar1';
import Home from "./Pages2/Home";
import Planner from "./Pages2/Planner";
import About from "./Pages2/About";
import Contact from "./Pages2/Contact";
import Login from './components/Login';
import Register from './components/Register'
import './output.css';



const App = () => {
    const [token, setToken] = useState(localStorage.getItem("token") || null);
    const [showRegister, setShowRegister] = useState(false);


    const handleLogout=()=>{
      localStorage.removeItem("token");
      setToken(null);
    }
    useEffect(() => {
        if (token) {
            localStorage.setItem("token", token);
        } else {
            localStorage.removeItem("token");
        }
    }, [token]);

    if (!token) {
        return showRegister ? (
            <Register setToken={setToken} onLoginClick={() => setShowRegister(false)} />
        ) : (
            <Login setToken={setToken} onRegisterClick={() => setShowRegister(true)} />
        );
    }

    return (
        <Router>
            <Navbar1 token={token} onLogout={handleLogout} />
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<About />} />
                <Route path="/planner" element={<Planner />} />
                <Route path="/contact" element={<Contact />} />
            </Routes>
        </Router>
    );
};

export default App;
