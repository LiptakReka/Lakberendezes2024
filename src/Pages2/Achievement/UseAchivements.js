import { getUserAchievements, addAchievement } from "./AchievementService";
import { createContext, useContext, useState, useEffect, useCallback } from "react";
import { toast } from "react-toastify";

const AchievementContext = createContext();

export function AchievementProvider({ children }) {
    const [achievements, setAchievements] = useState([]);
    const [userId, setUserId] = useState(null);
    const [isAuthenticated, setIsAuthenticated] = useState(false);

    // Ellenőrizzük, hogy a felhasználó be van-e jelentkezve
    useEffect(() => {
        const user = JSON.parse(localStorage.getItem("user"));
        const token = localStorage.getItem("token");
        
        if (user && user.id && token) {
            setUserId(user.id);
            setIsAuthenticated(true);
        } else {
            setIsAuthenticated(false);
            setUserId(null);
            setAchievements([]);
        }
    }, []);

    
    useEffect(() => {
        if (userId && isAuthenticated) {
            setAchievements([]);
            getUserAchievements(userId)
                .then(data => setAchievements(data || []))
                .catch(error => {
                    console.error("Hiba történt az mérföldkövek lekérdezésekor:", error);

                    if (error.response && (error.response.status === 401 || error.response.status === 403)) {
                       
                        toast.error("A hitelesítés megszűnt. Kérlek jelentkezz be újra.");
                        localStorage.removeItem("token");
                        localStorage.removeItem("user");
                        setIsAuthenticated(false);
                        setUserId(null);
                    }
                });
        }
    }, [userId, isAuthenticated]);

    const unlockAchievement = useCallback(async (title, description, icon) => {
        if (!isAuthenticated) return;
        
        if (!achievements.some(ach => ach.title === title)) {
            const newAchievement = { title, description, icon };
    
            try {
                const user = JSON.parse(localStorage.getItem("user"));
                const token = localStorage.getItem("token");
                
                if (!user || !user.id || !token) return;
                
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
    }, [achievements, isAuthenticated]);

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
