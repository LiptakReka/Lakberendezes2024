import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Autolog.css';

const AutologTime = 2 * 60 * 1000; // 2 perc

export default function Autolog({ logout }) {
  const navigate = useNavigate();
  const [timeLeft, setTimeLeft] = useState(AutologTime);
  const timeoutRef = useRef(null);
  const intervalRef = useRef(null);
  
  useEffect(() => {
    // Ellenőrizzük a bejelentkezési állapotot
    const isLoggedIn = localStorage.getItem("isloggedin");
    if (!isLoggedIn) {
      return;
    }

    // Ellenőrizzük, hogy lejárt-e az időzítő
    const storedTime = localStorage.getItem("timeleft");
    if (storedTime && Date.now() > parseInt(storedTime, 10)) {
      logout();
      navigate('/login');
      return;
    }
    
    // Ha nem járt le az idő, kiszámítjuk a hátralévő időt
    const remainingTime = storedTime ? Math.max(0, parseInt(storedTime, 10) - Date.now()) : AutologTime;
    setTimeLeft(remainingTime);

    // Időzítő beállítása
    const setupTimer = () => {
      // Töröljük a korábbi időzítőket, ha vannak
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      if (intervalRef.current) clearInterval(intervalRef.current);
      
      // Új időzítők beállítása
      timeoutRef.current = setTimeout(() => {
        logout();
        navigate('/login');
      }, AutologTime);
      
      // Időszámláló frissítése másodpercenként
      intervalRef.current = setInterval(() => {
        setTimeLeft((prev) => {
          const newTime = Math.max(0, prev - 1000);
          if (newTime === 0) {
            clearInterval(intervalRef.current);
          }
          return newTime;
        });
      }, 1000);
      
      // Időzítő adatainak mentése
      localStorage.setItem("timeleft", Date.now() + AutologTime);
      setTimeLeft(AutologTime);
    };

    // Kezdeti időzítő beállítása
    setupTimer();

    // Reset funkció, amely bármely interakciókor visszaállítja az időzítőt
    const resetTimer = () => {
      setupTimer();
    };

    // Eseményfigyelők hozzáadása
    window.addEventListener("mousemove", resetTimer);
    window.addEventListener("keydown", resetTimer);
    
    // Tisztítás
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      if (intervalRef.current) clearInterval(intervalRef.current);
      window.removeEventListener("mousemove", resetTimer);
      window.removeEventListener("keydown", resetTimer);
    };
  }, [logout, navigate]);
  
  // Formázott idő számítása
  const minutes = Math.floor(timeLeft / 60000);
  const seconds = Math.floor((timeLeft % 60000) / 1000);
  
  return (
    <div className="autolog-timer">
      {minutes}:{seconds < 10 ? '0' : ''}{seconds}
    </div>
  );
}
