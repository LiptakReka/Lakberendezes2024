import axios from "axios";
import { toast } from "react-hot-toast";

const ApiUrl="https://localhost:7247/api/Achievement/me";

export const getUserAchievements=async()=>{
    try {
        const token =localStorage.getItem("token");
        if(!token) throw new Error("Nincs token");
        const response = await axios.get(`${ApiUrl}`,{
            headers:{
                Authorization: `Bearer ${token}`
            }
        });
        return response.data;
    } catch (error) {
        console.error("Error:", error);
        return [];
    }
};


export const addAchievement=async(achievement)=>{
    try {
        const user=JSON.parse(localStorage.getItem("user"));
        if(!user || !user.id){
            console.error("Nincs felhasználói azonosító");
            toast.error("Nincs felhasználói azonosító");
            return;
        }
        const payload={
            user_Id:user.id || "nincs felhasználói azonosító",
            title:achievement.title || "Nincs megadott cím",
            description:typeof achievement.description==="string" ?achievement.description : "Nincs megadott leírás",
            icon : typeof achievement.icon === "string" ? achievement.icon : "nincs megadvaa ikon",
        };
        console.log("Achievementek:", payload);
        const response = await axios.post(`https://localhost:7247/api/Achievement/new`, payload,{
            headers:{
                Authorization: `Bearer ${localStorage.getItem("token")}`
            }
        });
        return response.data;
        
    } catch (error) {
        
        console.error("Hiba történt az achievement hozzáadáasakor:", error);
        toast.error("Hiba történt az achievement hozzáadásakor");
    }
}