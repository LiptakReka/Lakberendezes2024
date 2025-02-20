import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import Navbar1 from './components/Navbar1';
import Home from "./Pages2/Home";
import Planner from "./Pages2/Planner";
import About from "./Pages2/About";
import { Toaster } from 'react-hot-toast';
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { SnackbarProvider } from 'notistack';
import Login from './components/Login';
import Register from './components/Register';
import ForgotPassword from './components/ForgotPassword';
import ResetPassword from './components/ResetPassword';
import UserSetts from './Pages2/UserSetts';
import './output.css';
import Cart from './Pages2/Cart';
import { AchievementProvider } from './Pages2/UseAchivements';

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
            <SnackbarProvider>
            <AchievementProvider>
            <Toaster />
            <ToastContainer />
            
            {token && <Navbar1 token={token} onLogout={handleLogout} />}
            
            <Routes>
                
                <Route path="/reset-password" element={<ResetPassword />} />
                <Route path="/forgot-password" element={<ForgotPassword />} />

                
                {!token ? (
                    <>
                        <Route path="/login" element={<Login setToken={setToken} />} />
                        <Route path="/register" element={<Register setToken={setToken} />} />
                        <Route path="/reset-password" element={<ResetPassword />} />
                        <Route path="/forgot-password" element={<ForgotPassword />} />

                        <Route path="*" element={<Navigate to="/login" replace />} />
                    </>
                ) : (
                    <>
                       
                        <Route path="/" element={<Home />} />
                        <Route path='/cart' element={<Cart/>}/>
                        <Route path="/about" element={<About />} />
                        <Route path="/planner" element={<Planner />} />
                        
                        <Route path="/settings" element={<UserSetts />} />

                        
                        <Route path="*" element={<Navigate to="/" replace />} />
                    </>
                )}
            </Routes>
            </AchievementProvider>
            </SnackbarProvider>
            
            
        </Router>
        
        
    );
    
};


export default App;
