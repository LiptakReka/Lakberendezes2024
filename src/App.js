import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import Navbar1 from '../src/components/Navbar/Navbar1';
import Home from "./Pages2/Home/Home";
import Planner from "./Pages2/Planner/Planner";
import About from "./Pages2/About/About";
import { Toaster } from 'react-hot-toast';
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { SnackbarProvider } from 'notistack';
import Login from '../src/components/Login/Login';
import Register from '../src/components/Register/Register';
import ForgotPassword from '../src/components/ForgotPassword/ForgotPassword';
import ResetPassword from '../src/components/ResetPassword/ResetPassword';
import UserSetts from './Pages2/Usersettings/UserSetts';
import ContactPage from '../src/Pages2/Contact/Contact';
import Cart from './Pages2/Cart/Cart';
import { AchievementProvider } from './Pages2/Achievement/UseAchivements';
import Autolog from './components/AutoLog/Autolog';

const App = () => {
    const [token, setToken] = useState(localStorage.getItem("token") || null);
    
    const handleLogout = () => {
        localStorage.removeItem("token");
        localStorage.removeItem("isloggedin");
        setToken(null);
    };

    useEffect(() => {
        if (token) {
            localStorage.setItem("token", token);
            localStorage.setItem("isloggedin", "true");
        } else {
            localStorage.removeItem("isloggedin");
        }
    }, [token]);

    return (
        <Router>
            <SnackbarProvider>
            <AchievementProvider>
            <Toaster />
            <ToastContainer />
            
            {token && <Navbar1 token={token} onLogout={handleLogout} />}
            {token && <Autolog logout={handleLogout} />}
            
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
                        <Route path="/contact" element={<ContactPage />} />
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
