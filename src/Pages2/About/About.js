import React from 'react';
import './About.css';
import { Award, Gamepad, PaintRollerIcon, Save, ShoppingBagIcon } from 'lucide-react';
import { useNavigate } from 'react-router-dom';


export default function AboutPage() {
  const milestones = [
    { ev: 2024, honap: "Szeptember", title: "A kezdetek", description: "A RoomLab hivatalos elindulása, amikor az alapvető tervezési és bútoráruház-integrációs funkciók elérhetővé váltak." },
    { ev: 2024, honap: "December", title: "Sötét mód", description: "A sötét mód bevezetése, amely javította a felület használhatóságát különböző fényviszonyok között." },
    { ev: 2025, honap: "Január", title: "Achievement rendszer", description: "Gamifikációs elemek bevezetése, amelyek jutalmazták a különböző tevékenységeket a platformon." }
  ];
  const MilestoneItem = ({ ev, honap, title, description, isEven }) => (
    <div className={`milestone-item ${isEven ? 'milestone-even' : 'milestone-odd'}`}>
      <div className="milestone-year"> <Award/>{ev}</div>
      <div className="milestone-content">
        <h3 className="milestone-title">{title} <span className="milestone-month">({honap})</span></h3>
        <p className="milestone-description">{description}</p>
      </div>
    </div>
  );
  const navigate=useNavigate();
  return (
    <div className="about-page">
      <div className="containerd">
        <section className="hero-section">
          <h1 className="main-title">Rólunk</h1>
          <p className="subtext">
            "Tervezz. Álmodj. Valósítsd meg. - RoomLab, ahol az otthonod életre kel."
          </p>
        </section>

        <section className="vision-section section">
          <h2 className="section-title">Küldetésünk</h2>
          <div className="vision-content">
            <div className="vision-text">
              <p>
                A RoomLab küldetése, hogy modernizálja a lakberendezési folyamatot azáltal, hogy egyetlen  platformon egyesíti Magyarország vezető bútorüzleteinek kínálatát. Célunk, hogy felhasználóink szabadon tervezhessék meg álmaik otthonát, különböző stílusú és árfekvésű bútorok kombinálásával, anélkül hogy több áruházat kellene végigjárniuk.
              </p>
              <p>
                Interaktív tervező felületünkön a vásárlók virtuálisan berendezhetik tereiket, valós idejű vizualizációt láthatnak, majd a kiválasztott termékeket közvetlenül az eredeti forgalmazóktól szerezhetik be. Ezzel a megközelítéssel hidat képezünk a kreatív tervezés és a praktikus beszerzés között, időt és energiát megtakarítva ügyfeleinknek, miközben támogatjuk a hazai bútorpiacot.
              </p>
            </div>
            <div className="vision-image">
              <img src="https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80" alt="RoomLab vision" />
            </div>
          </div>
        </section>

        <section className="origin-section section">
          <h2 className="section-title">Történetünk</h2>
          <div className="origin-content">
            <p>
              A RoomLab 2024 szeptemberében kezdte meg működését, eredetileg egy iskolai projektként indulva. Az alapítás inspirációja egy kreatív felismerésből származott: az otthontervezés nemcsak praktikus tevékenység lehet, hanem egyben szórakoztató és élvezetes folyamat is.
            </p>
            <p>
              A koncepció abból a gondolatból született, hogy egyesítsük a játékos, interaktív élményt a valódi lakberendezési igényekkel. Felismerve, hogy az emberek szeretnek szabadon alkotni és személyre szabott tereket létrehozni, a RoomLab olyan platformmá fejlődött, amely lehetővé teszi a felhasználók számára, hogy saját elképzeléseik szerint, kreatívan tervezhessék meg otthonukat, miközben valós termékekkel dolgozhatnak.
            </p>
          </div>
        </section>

        <section className="services-section section">
          <h2 className="section-title">Szolgáltatásaink</h2>
          <div className="services-grid">
            <div className="service-card">
              <h3 className="service-title"> <PaintRollerIcon/>Interaktív tervezési felület</h3>
              <p className="service-description">
                Felhasználóink modern, könnyen kezelhető felületen tervezhetik meg otthonukat, vizuális megjelenítéssel, hogy pontosan láthassák elképzeléseik megvalósulását.
              </p>
            </div>
            
            <div className="service-card">
              <h3 className="service-title"><Save/>Projekt menedzsment</h3>
              <p className="service-description">
                A tervek mentése és betöltése funkció lehetővé teszi a felhasználók számára, hogy bármikor visszatérjenek és folytassák a munkát, vagy több különböző változatot is készítsenek ugyanahhoz a térhez.
              </p>
            </div>
            
            <div className="service-card">
              <h3 className="service-title"><Gamepad/>Gamifikált élmény</h3>
              <p className="service-description">
                Egyedülálló achievement rendszerünk jutalmazza a felhasználói aktivitást - legyen szó az első mentett tervről, profilmódosításról vagy kosártartalom e-mailben történő megosztásáról.
              </p>
            </div>
            
            <div className="service-card">
              <h3 className="service-title"><ShoppingBagIcon/>Kosár és beszerzési segítség</h3>
              <p className="service-description">
                A kiválasztott termékek kosárba helyezhetők, majd a lista kényelmesen elküldhető e-mailben, megkönnyítve a későbbi beszerzést az eredeti forgalmazóktól.
              </p>
            </div>
          </div>
        </section>

        <section className="unique-section section">
          <h2 className="section-title">Ami egyedivé tesz minket</h2>
          <div className="unique-content">
            <div className="unique-item">
              <h3 className="unique-title">Valós bútorüzletek integrációja</h3>
              <p className="unique-description">
                Legfőbb megkülönböztető jellemzőnk, hogy platformunk valódi, elérhető termékeket kínál több magyar bútorüzlet kínálatából. Míg más tervezőprogramok gyakran csak általános modellekkel dolgoznak, a RoomLab-en tervezett terek a valóságban is pontosan úgy valósíthatók meg, ahogy a felhasználó elképzelte.
              </p>
            </div>
            
            <div className="unique-item">
              <h3 className="unique-title">Intelligens szobaalapú kategorizálás</h3>
              <p className="unique-description">
                Bútoraink szobák szerint vannak kategorizálva, ami intuitív és praktikus böngészést tesz lehetővé. Ez a rendszer segíti a felhasználókat, hogy gyorsan megtalálják a megfelelő bútorokat az adott térhez, jelentősen felgyorsítva a tervezési folyamatot.
              </p>
            </div>
            
            <div className="unique-item">
              <h3 className="unique-title">Közvetlen vásárlási útvonal</h3>
              <p className="unique-description">
                Egyedi megoldásunk, hogy a kiválasztott termékek közvetlenül az eredeti forgalmazóktól szerezhetők be, így biztosítva a minőséget és a megbízhatóságot, miközben támogatjuk a hazai bútorpiacot.
              </p>
            </div>
          </div>
        </section>

        <section className="timeline-section section">
          <h2 className="section-title">Mérföldköveink</h2>
          <div className="timeline">
            {milestones.map((milestone, index) => (
              <MilestoneItem 
                key={index} 
                {...milestone} 
                isEven={index % 2 === 0} 
              />
            ))}
          </div>
        </section>

        <section className="values-section section">
          <h2 className="section-title">Értékeink</h2>
          <div className="values-grid">
            <div className="value-card">
              <h3 className="value-title">Felhasználóközpontúság</h3>
              <p className="value-description">
                A kényelmes és élvezetes interakció biztosítása minden felhasználó számára.
              </p>
            </div>
            
            <div className="value-card">
              <h3 className="value-title">Rugalmasság és bővíthetőség</h3>
              <p className="value-description">
                A platform folyamatos fejlesztése és új funkciók integrálása a változó igényeknek megfelelően.
              </p>
            </div>
            
            <div className="value-card">
              <h3 className="value-title">Innovatív megközelítés</h3>
              <p className="value-description">
                Kreatív megoldások keresése a lakberendezés és a technológia ötvözésével.
              </p>
            </div>
            
            <div className="value-card">
              <h3 className="value-title">Élményalapú tervezés</h3>
              <p className="value-description">
                A lakberendezés folyamatának élvezetessé és szórakoztatóvá tétele.
              </p>
            </div>
          </div>
        </section>

        <section className="future-section section">
          <h2 className="section-title">Jövőbeli terveink</h2>
          <div className="future-content">
            <p>
              A jövőbeli terveink között szerepel a RoomLab felületének folyamatos modernizálása és felhasználóbarátabbá tétele, miközben megőrizzük annak szórakoztató és hasznos jellegét. Célunk egy olyan platform kialakítása, amely nemcsak praktikus, hanem élvezetes élményt is nyújt a felhasználóknak.
            </p>
           
              <div className="future-item">
                <h3 className="future-title">UX/UI fejlesztések</h3>
                <p className="future-description">
                  A felhasználói felület továbbfejlesztése az UX/UI alapelvek mentén, hogy intuitívabb és még könnyebben kezelhető legyen.
                </p>
              </div>
              
              <div className="future-item">
                <h3 className="future-title">Mobilbarát kialakítás</h3>
                <p className="future-description">
                  Mobilbarát kialakítás optimalizálása, hogy a felhasználók bármilyen eszközről kényelmesen használhassák a platformot.
                </p>
              </div>
            </div>
        </section>

        <section className="cta-section">
          <h2 className="cta-title">Készen állsz álmaid otthonának megvalósítására?</h2>
          <p className="cta-text">Próbáld ki a RoomLab szolgáltatásait még ma, és alakítsd át otthonodat!</p>
          <button className="cta-button" onClick={()=>navigate("/planner")}>Kezdd el most</button>
        </section>
      </div>
    </div>
  );
}
