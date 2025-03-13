import { getUserAchievements, addAchievement } from "./AchievementService";
import { createContext, useContext, useState, useEffect, useCallback } from "react";
import { toast } from "react-toastify";

const AchievementContext = createContext();

export function AchievementProvider({ children }) {
    const [achievements, setAchievements] = useState([]);
    const [userId, setUserId] = useState(null);

    // A felhasználó adatainak beállítása
    useEffect(() => {
        const user = JSON.parse(localStorage.getItem("user"));
        if (user && user.id) {
            setUserId(user.id);
        }
    }, []);

    // Achievements lekérése a userId változása esetén
    useEffect(() => {
        if (userId) {
            setAchievements([]);
            getUserAchievements(userId)
                .then(data => setAchievements(data || []))
                .catch(error => console.error("Hiba történt az achievementek lekérdezésekor:", error));
        }
    }, [userId]);

    // useCallback használata, hogy ne hozzunk létre új függvényt minden rendereléskor
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
                    toast.success(`🏆 Achievement feloldva: ${title}`);
                }
            } catch (error) {
                console.error("Hiba történt az achievement mentésekor:", error);
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
        throw new Error('useAchievements must be used within an AchievementProvider');
    }
    return context;
}
