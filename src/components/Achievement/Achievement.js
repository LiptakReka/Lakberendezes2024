import { TriangleRight, Trophy } from "lucide-react";
import "./Achievement.css";
import { useAchievements } from "../Pages2/UseAchivements";


export default function Achievement(){
    //Importáljuk  a useAchievements függvényt a UseAchivements.js-ből
    const {achievements}= useAchievements();
    

    return(
        //Visszaadjuk a megszerzett achievementeket
        <div className="profile-container">
            <h2 className="profile-title"><Trophy/> Megszerzett achievementek</h2>

            {achievements.length === 0 ? (
                <p className="no-achievements">Még nincs megszerzett achievement</p>
            ):(
                <ul className="achivements-list">
                    //Végigmegyünk az achievementeken és kiírjuk őket
                    {achievements.map((ach,index)=>(
                        <li key={index} className="achievement">
                            //Ha az achievementnek van ikonja akkor azt jelenítjük meg, ha nincs akkor egy háromszög  ikont
                            <span className="achivement-icon">{ach.icon && typeof ach.icon ==="string" ? ach.icon : <TriangleRight/>}</span>
                            <div>
                                <h4>{ach.title}</h4>
                                <p>{ach.descreption}</p>
                            </div>
                        </li>
                    ))}
                </ul>
            
            )}
        </div>
    )
}