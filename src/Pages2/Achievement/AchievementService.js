import axios from "axios";
import { toast } from "react-hot-toast";

const ApiUrl= process.env.REACT_APP_API_URL + "/Achievement/me";

//A mérfödkövek lekérése
export const getUserAchievements=async()=>{
    try {
        const token =localStorage.getItem("token");
        if(!token) throw new Error("Nincs token");
        const response = await axios.get(ApiUrl,{
            headers:{
                Authorization:token
            }
        });
        return response.data;
    } catch (error) {
        console.error("Error:", error);
        return [];
    }
};

//A mérföldkövek hozzáadása
export const addAchievement=async(achievement)=>{
    try {
        const user=JSON.parse(localStorage.getItem("user"));
        const token=localStorage.getItem("token");
        if(!token){
            throw new Error("Nincs token");
            
        }
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
      
        const response = await axios.post(process.env.REACT_APP_API_URL + `/Achievement/new`, payload,{
            headers:{
                Authorization:token
            }
        });
        return response.data;
        
    } catch (error) {
        
        console.error("Hiba történt a mérföldkövek hozzáadáasakor:", error);
        toast.error("Hiba történt a mérföldkő hozzáadásakor");
    }
}