import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Autolog.css';
import { parse } from '@fortawesome/fontawesome-svg-core';

const AutologTime = 2 * 60 * 1000; 

export default function Autolog({ logout }) {
  const navigate = useNavigate();
  const [timeLeft, setTimeLeft] = useState(AutologTime);
  
  useEffect(() => {
    const storedtime=localStorage.getItem("timeleft");
    if(storedtime && Date.now() > parseInt(storedtime,10)){
        logout();
        navigate('/login');
    }else{
        setTimeLeft(AutologTime);
    }
    let timeout = setTimeout(() => {
        logout();
        navigate('/login');
    }, timeLeft);


    const interval = setInterval(() => {
      setTimeLeft(prev => Math.max(0, prev - 1000));
    }, 1000);
    
    const resetTimer = () => {
      clearTimeout(timeout);
      setTimeLeft(AutologTime);
      localStorage.setItem("timeleft",Date.now()+AutologTime);
      timeout = setTimeout(() => {
        logout();
        navigate('/login');
      }, AutologTime);
    };
    
    window.addEventListener("mousemove", resetTimer);
    window.addEventListener("keydown", resetTimer);
    
    return () => {
      clearTimeout(timeout);
      clearInterval(interval);
      window.removeEventListener("mousemove", resetTimer);
      window.removeEventListener("keydown", resetTimer);
    };
  }, [logout, navigate]);
  

  const minutes = Math.floor(timeLeft / 60000);
  const seconds = Math.floor((timeLeft % 60000) / 1000);
  
  return (
    <div className="autolog-timer">
      {minutes}:{seconds < 10 ? '0' : ''}{seconds}
    </div>
  );
}
