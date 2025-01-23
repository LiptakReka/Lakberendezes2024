import React, { useState } from 'react'
import "./Navbar1.css"
import { Link, NavLink } from 'react-router-dom';

const Navbar1 = ({token, onLogout}) => {
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);
    const [darkMode, setDarkMode] = useState(false);


    const toggleDropdown = () => {
        setIsDropdownOpen(!isDropdownOpen);
    };

    const toggleDarkMode = () => {
        setDarkMode(!darkMode);
        document.body.classList.toggle("dark-mode");
    };

    return (
        <nav className="navbar">
            <div className="navbar-logo">RoomLab</div>
            <ul className="navbar-links">
                <li><NavLink to="/">Kezdőlap</NavLink></li>
                <li><NavLink to="/about">Rólunk</NavLink></li>
                <li><NavLink to="/planner">Tervező</NavLink></li>
                <li><NavLink to="/contact">Kapcsolat</NavLink></li>

                {token && (
                    <li>
                        <button onClick={onLogout}> Kijelentkezés</button>
                    </li>
                )}
            </ul>
               
            
                <div className="menu-container">
                    <button
                        className="menu-button"
                        onClick={toggleDropdown}
                        aria-expanded={isDropdownOpen}
                    >
                        Menü
                    </button>
                    {isDropdownOpen && (
                        <ul className="dropdown-menu">
                            <li>
                                <button className="dark-mode-toggle" onClick={toggleDarkMode}>
                                    {darkMode ? "🌙 Sötét mód" : "☀️ Világos mód"}
                                </button>
                            </li>
                           
                        </ul>
                    )}
                </div>
                <div className="navbar-cart">
                    <i className="fas fa-shopping-cart"></i>
                    <span className="cart-count">0</span>
                </div>
            
        </nav>
    );
};

export default Navbar1;
