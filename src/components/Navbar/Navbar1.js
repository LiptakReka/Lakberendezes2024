import React, { useState, useEffect } from "react";
import { Link, NavLink } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import { Settings, LogOut, Moon, Sun, User, ShoppingCartIcon } from "lucide-react";
import "./Navbar1.css";
import useCart from "../../Pages2/Cart/UseCart";

const Navbar1 = ({ token, username, onLogout }) => {
    //A kosár függvény implementációja
    const {cartCount} = useCart()
    //Állapotok létrehozása
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);
    const [darkMode, setDarkMode] = useState(false);        
    const [profilePicture, setProfilePicture] = useState(null);

    useEffect(() => {

        const storedUser = JSON.parse(localStorage.getItem("user"));
        if (storedUser && storedUser.profilePictureUrl) {
       
            //A profilkép URL-jének beállítása
            setProfilePicture(process.env.REACT_APP_Link_URL + `${storedUser.profilePictureUrl}`);
        }
        
        const storedDark = localStorage.getItem("darkMode") === "enabled";
        setDarkMode(storedDark);
    }, []);

    const toggleDropdown = () => {
        setIsDropdownOpen(!isDropdownOpen);
    };

    const toggleDarkMode = () => {
        const newMode = !darkMode;
        setDarkMode(newMode);
        localStorage.setItem("darkMode", newMode ? "enabled" : "disabled");
        document.body.classList.toggle("dark-mode");
    };

    return (
        <nav className={`navbar navbar-expand-lg ${darkMode ? "navbar-dark bg-dark" : "navbar-light bg-light"}`}>   {/*A navbáron a sötét mód megjelenítése*/}
            <div className="container">
                <Link className="navbar-brand" to="/">
                    <strong>RoomLab</strong>
                </Link>
                <Link to={"/cart"} className="nav-cart">       {/*A kosár megjelenítése*/}
                <ShoppingCartIcon/> Kosár
                {cartCount > 0 && (
            <span className="cart-count">{cartCount}</span>
            )}
                </Link>

                <button className="navbar-toggler" type="button" onClick={toggleDropdown} aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>

                <div className={`collapse navbar-collapse ${isDropdownOpen ? "show" : ""}`} id="navbarNav">
                    <ul className="navbar-nav ms-auto">
                        <li className="nav-item">
                            <NavLink className="nav-link" to="/">Kezdőlap</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link" to="/about">Rólunk</NavLink>          {/*A menüpontok megjelenítése*/}
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link" to="/planner">Tervező</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link" to="/contact">Kapcsolat</NavLink>
                        </li>

                        <li className="nav-item">
                            <button className="btn btn-outline-secondary" onClick={toggleDarkMode}>
                                {darkMode ? <Sun /> : <Moon />}
                            </button>
                        </li>

                        <li className="nav-item dropdown">
                            <button className="btn btn-outline-primary dropdown-toggle profile-btn" onClick={toggleDropdown}>
                                {profilePicture ? (
                                    <img src={profilePicture} alt="Profilkép" className="profile-img" />
                                ) : (
                                    <User />
                                )}
                            </button>
                            {isDropdownOpen && (
                                <ul className="dropdown-menu show">
                                    <li>
                                        <NavLink className="dropdown-item" to="/settings">
                                            <Settings /> Beállítások
                                        </NavLink>
                                    </li>
                                    <li>
                                        <button className="dropdown-item logout" onClick={onLogout}>
                                            <LogOut /> Kijelentkezés
                                        </button>
                                    </li>
                                </ul>
                            )}
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    );
};

export default Navbar1;
