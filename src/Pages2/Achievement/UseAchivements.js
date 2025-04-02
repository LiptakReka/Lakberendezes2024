import { getUserAchievements, addAchievement } from "./AchievementService";
import { createContext, useContext, useState, useEffect, useCallback } from "react";
import { toast } from "react-toastify";

const AchievementContext = createContext();

export function AchievementProvider({ children }) {
    const [achievements, setAchievements] = useState([]);
    const [userId, setUserId] = useState(null);


    useEffect(() => {
        const user = JSON.parse(localStorage.getItem("user"));
        if (user && user.id) {
            setUserId(user.id);
        }
    }, []);

   
    useEffect(() => {
        if (userId) {
            setAchievements([]);
            getUserAchievements(userId)
                .then(data => setAchievements(data || []))
                .catch(error => console.error("Hiba történt az mérföldkövek lekérdezésekor:", error));
        }
    }, [userId]);

   
    const unlockAchievement = useCallback(async (title, description, icon) => {
        if (!achievements.some(ach => ach.title === title)) {
            const newAchievement = { title, description, icon };
    
            try {
                const user = JSON.parse(localStorage.getItem("user"));
                if (!user || !user.id) return;
                
                const savedAchievement = await addAchievement({
                    ...newAchievement,
                    userId: user.id
                });
                
                if (savedAchievement) {
                    setAchievements(prev => [...prev, savedAchievement]);
                    toast.success(`🏆 Mérföldkő feloldva: ${title}`);
                }
            } catch (error) {
                console.error("Hiba történt a mérföldkő mentésekor:", error);
            }
        }
    }, [achievements]);

    const contextValue = {
        achievements,
        unlockAchievement
    };

    return (
        <AchievementContext.Provider value={contextValue}>
            {children}
        </AchievementContext.Provider>
    );
}

export function useAchievements() {
    const context = useContext(AchievementContext);
    if (context === undefined) {
        throw new Error('nincs jól hasznlálva a hook');
    }
    return context;
}
