import { getUserAchievements, addAchievement } from "./AchievementService";
import { createContext, useContext, useState, useEffect } from "react";
import { toast } from "react-toastify";

const AchievementContext = createContext();

export function AchievementProvider({ children }) {
    const [achievements, setAchievements] = useState([]);

    useEffect(() => {
        const user = JSON.parse(localStorage.getItem("user"));
        if (user && user.id) {
            getUserAchievements(user.id)
            .then(data => setAchievements(data || []))
            .catch(error => console.error("Hiba történt az achievementek lekérdezésekor:", error));
        }
    }, []);

    const unlockAchievement = async (title, description, icon) => {
        if (!achievements.some(ach => ach.title === title)) {
            const newAchievement = { title, description, icon };
    
            try {
                const savedAchievement = await addAchievement(newAchievement);
                
                if (savedAchievement) {
                    setAchievements(prev => [...prev, savedAchievement]); // 🔥 Helyes frissítés
                    toast.success(`🏆 Achievement feloldva: ${title}`);
                }
            } catch (error) {
                console.error("Hiba történt az achievement mentésekor:", error);
            }
        }
    };
    

    return (
        <AchievementContext.Provider value={{ achievements, unlockAchievement }}>
            {children}
        </AchievementContext.Provider>
    );
}


export function useAchievements() {
    return useContext(AchievementContext);
}
