import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Autolog.css';

const AutologTime = 30 * 60 * 1000; 

export default function Autolog({ logout }) {
  const navigate = useNavigate();
  const [timeLeft, setTimeLeft] = useState(AutologTime);
  const timeoutRef = useRef(null);
  const intervalRef = useRef(null);
  
  useEffect(() => {
 
    const isLoggedIn = localStorage.getItem("isloggedin");
    if (!isLoggedIn) {
      return;
    }

  
    const storedTime = localStorage.getItem("timeleft");
    if (storedTime && Date.now() > parseInt(storedTime, 10)) {
      logout();
      navigate('/login');
      return;
    }
    
  
    const remainingTime = storedTime ? Math.max(0, parseInt(storedTime, 10) - Date.now()) : AutologTime;
    setTimeLeft(remainingTime);

    
    const setupTimer = () => {
    
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      if (intervalRef.current) clearInterval(intervalRef.current);
      
    
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
      
      //adatoK mentése
      localStorage.setItem("timeleft", Date.now() + AutologTime);
      setTimeLeft(AutologTime);
    };

   
    setupTimer();

   
    const resetTimer = () => {
      setupTimer();
    };

    // Eseményfigyelők 
    window.addEventListener("mousemove", resetTimer);
    window.addEventListener("keydown", resetTimer);
    
    
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
      if (intervalRef.current) clearInterval(intervalRef.current);
      window.removeEventListener("mousemove", resetTimer);
      window.removeEventListener("keydown", resetTimer);
    };
  }, [logout, navigate]);
  
  // Idő számítása
  const minutes = Math.floor(timeLeft / 60000);
  const seconds = Math.floor((timeLeft % 60000) / 1000);
  
  return (
    <div className="autolog-timer">
      {minutes}:{seconds < 10 ? '0' : ''}{seconds}
    </div>
  );
}
