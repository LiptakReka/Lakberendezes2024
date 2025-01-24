import React from 'react'
import{ Link} from 'react-router-dom';
import "./Home.css";


export default function Home() {
  return (
   
    <div className='home-container'>
      <section className='hero'>
      <div className='hero-section'>
        <h1 className='hero-title'>Tervezd meg álmaid otthonát!</h1>
        <p className='hero-subtitle'>Interaktív lakberendezési eszközök, modern megjelenés, és közvetlen vásárlási lehetőség.</p>

        <div className='hero-buttons'>
          <Link to="/planner" className='hero-btn start-btn'>Kezdj tervezni</Link>
          <Link to="/about" className='hero-btn learn-btn'>Tudj meg többet</Link>
        </div>
      </div>
      </section>
      
      <section className='features'>
      <div className='feature-card feature-left'>
          <img src='room.jpg' alt='Szoba tervezés' />
          <div className='feature-text'>
          <h3>Szoba tervezés</h3>
          <p>Hozd létre a tökéletes otthont a digitális lakberendezési eszközeinkkel.</p>
          </div>
        </div>
        <div className='feature-card feature-right'>
          <img src='furniture.jpg' alt='Bútor választás'/>
          <div className='feature-text'>
          <h3>Bútor választás</h3>
          <p>Böngéssz stílusos bútorok között, amelyek passzolnak a terveidhez.</p>
        </div>
          </div>
        <div className='feature-card feature-left'>
          <img src='shopping.jpg' alt='Vásárlás' />
          <div className='feature-text'>
          <h3>Vásárlás</h3>
          <p>Kapcsold össze terveidet a vásárlással - egyszerűen és gyorsan.</p>
        </div>
          </div>
      </section>
      
      <footer className='footer'>
        <p>Copyright &copy; 2025 RoomLab Minden jog fenntartva.</p>
      </footer>
    </div>
  );
};
