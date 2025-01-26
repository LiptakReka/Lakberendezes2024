import React, { useEffect, useState } from "react";
import { Link, NavLink } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import "./Navbar1.css";


const Navbar1 = ({ token, onLogout }) => {
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
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
      <div className="container">
        {/* Logo */}
        <Link className="navbar-brand" to="/">
          <strong>RoomLab</strong>
        </Link>

        {/* Hamburger Menü (mobilhoz) */}
        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
          aria-controls="navbarNav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        {/* Navigációs menü */}
        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav ms-auto">
            <li className="nav-item">
              <NavLink className="nav-link" to="/">
                Kezdőlap
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/about">
                Rólunk
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/planner">
                Tervező
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/contact">
                Kapcsolat
              </NavLink>
            </li>

            {/* Ha be van jelentkezve, megjelenik a kijelentkezés gomb */}
            {token && (
              <li className="nav-item">
                <button className="btn btn-danger nav-link" onClick={onLogout}>
                  Kijelentkezés
                </button>
              </li>
            )}

            {/* Beállítások menü legördülő */}
            <li className="nav-item dropdown">
              <button
                className="btn btn-outline-light dropdown-toggle"
                onClick={toggleDropdown}
              >
                Menü
              </button>
              {isDropdownOpen && (
                <ul className="dropdown-menu show">
                  <li>
                    <button
                      className="dropdown-item"
                      onClick={toggleDarkMode}
                    >
                      {darkMode ? "🌙 Sötét mód" : "☀️ Világos mód"}
                    </button>
                  </li>
                </ul>
              )}
            </li>

           
            <li className="nav-item">
              <div className="navbar-cart">
                <i className="fas fa-shopping-cart text-white"></i>
                <span className="cart-count bg-danger text-white">0</span>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
};

export default Navbar1;
