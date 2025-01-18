import React, { useState } from 'react'
import '@fortawesome/fontawesome-free/css/all.min.css';
import "./Navbar1.css"
import { Link } from 'react-router-dom';

const Navbar1 = () => {
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);
    const [darkMode, setDarkMode] = useState(false);
    const [showLogin, setShowLogin] = useState(false);
    const [RegisterModal, setRegisterModal] = useState(false)

    const toggleDropdown = () => {
        setIsDropdownOpen(!isDropdownOpen);
    };

    const toggleDarkMode = () => {
        setDarkMode(!darkMode);
        document.body.classList.toggle("dark-mode");
    };

    const toggleLoginModal = () => {
        setShowLogin(!showLogin);
    };

    const toggleRegisterModal=()=>{
        setRegisterModal(!RegisterModal)
    } ;
    return (
        <nav className="navbar">
            <div className="navbar-logo">RoomLab</div>
            <ul className="navbar-links">
                <li><Link to="/home">Kezdőlap</Link></li>
                <li><Link to="/about">Rólunk</Link></li>
                <li><Link to="/planner">Tervező</Link></li>
                <li><Link to="/contact">Kapcsolat</Link></li>
            </ul>
            <div className='navbar-right'>
                <button className='menu-button' onClick={toggleLoginModal}>
                    Bejelentkezés
                </button>
                       <button className='menu-button' onClick={toggleRegisterModal}>
                    Regisztráció
                </button>
                {showLogin && (
                <div className="login-modal">
                    <div className="login-content">
                        <h2>Bejelentkezés</h2>
                        <form>
                            <label>
                                Felhasználónév:
                                <input type="text" name="username" />
                            </label>
                            <label>
                                Jelszó:
                                <input type="password" name="password" />
                            </label>
                            <button type="submit">Bejelentkezés</button>
                        </form>
                        <button onClick={toggleLoginModal}>Bezár</button>
                    </div>
                </div>
            )}
            </div>
            <div className="navbar-right">

                {RegisterModal && (
                    <div className='register-modal'>
                        <div className='register-content'>
                            <h2>Regisztráció</h2>
                            <form>
                                <label htmlFor='username'>Felhasználónév: </label>
                                <input type='text' id='userrname' placeholder='Add meg a neved: '/>

                                <label htmlFor='email'>Email: </label>
                                <input type='email' id='email' placeholder='Add meg az email címed: '/>

                                <label htmlFor='password'>Jelszó: </label>
                                <input type='password' id='password' placeholder='Jelszó: '/>

                                <label htmlFor='confirm-password'>Jelszó megerősítése: </label>
                                <input type='password' id='confirm-password' placeholder='Jelszó megerősítése: '/>

                                <button type='submit'>Regisztráció</button>
                            </form>
                            <button className='close-button' onClick={toggleRegisterModal}>Bezár</button>
                        </div>
                    </div>
                )}
            
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
            </div>
            
        </nav>
    );
};

export default Navbar1;
