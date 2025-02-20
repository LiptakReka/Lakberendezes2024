import { TriangleRight, Trophy } from "lucide-react";
import "./Achievement.css";
import { useAchievements } from "../Pages2/UseAchivements";

export default function Achievement(){
    const {achievements}= useAchievements();
    

    return(
        <div className="profile-container">
            <h2 className="profile-title"><Trophy/> Megszerzett achievementek</h2>

            {achievements.length === 0 ? (
                <p className="no-achievements">Még nincs megszerzett achievement</p>
            ):(
                <ul className="achivements-list">
                    {achievements.map((ach,index)=>(
                        <li key={index} className="achievement">
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