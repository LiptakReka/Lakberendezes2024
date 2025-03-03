import React, { useState, useEffect } from "react";
import axios from "axios";
import "./ProfilePicture.css";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useAchievements } from "../../src/Pages2/Achievement/UseAchivements";
import { enqueueSnackbar } from "notistack";

const ProfilePictureUpload = () => {
    const {unlockAchievement}=useAchievements();
    const [user, setUser] = useState(null);
    const [selectedFile, setSelectedFile] = useState(null);
    const [previewImage, setPreviewImage] = useState("default_profile.png"); 

    useEffect(() => {
        const storedUser = JSON.parse(localStorage.getItem("user"));
        if (storedUser) {
            setUser(storedUser);
            setPreviewImage(
                storedUser.profilePictureUrl && storedUser.profilePictureUrl.trim() !== ""
                    ? `https://localhost:7247${storedUser.profilePictureUrl}`
                    : "default_profile.png"
            );
        }
    }, []);

    
    const handleFileChange = (event) => {
        if (event.target.files.length > 0) {
            setSelectedFile(event.target.files[0]);
            setPreviewImage(URL.createObjectURL(event.target.files[0])); // 🔥 Előnézet frissítése
        }
    };

   
    const handleUpload = async () => {
        if (!selectedFile) {
            toast.warn("Válassz ki egy képet!", { position: "top-center" });
            return;
        }

        const formData = new FormData();
        formData.append("file", selectedFile);
        formData.append("email", user?.email); 

        try {
            const response = await axios.post(
                "https://localhost:7247/api/Users/upload-profile-picture",
                formData,
                { headers: { "Content-Type": "multipart/form-data" } }
            );

            if (!response.data.imageUrl) {
                throw new Error("Nincs kép URL az API válaszában!");
            }

            const newProfileUrl = response.data.imageUrl;
            const updatedUser = { ...user, profilePictureUrl: newProfileUrl };

           
            localStorage.setItem("user", JSON.stringify(updatedUser));
            setUser(updatedUser);

           
            setPreviewImage(`https://localhost:7247${newProfileUrl}`);

            enqueueSnackbar("Profilkép sikeresen feltöltve!", { variant: "success" });
            unlockAchievement("Szépségszalon", "Profilképed megváltozott", "💄");
        } catch (error) {
            console.error("Hiba a kép feltöltésekor:", error);
            enqueueSnackbar("Hiba történt a profilkép feltöltésekor.", { variant: "error" });
        }
    };

    return (
        <div className="profile-upload-container">
            <h3>Profilkép módosítása</h3>
            <img src={previewImage} alt="Profilkép" className="profile-preview" />
            <input type="file" accept="image/*" onChange={handleFileChange} />
            <button onClick={handleUpload}>Feltöltés</button>
        </div>
    );
};

export default ProfilePictureUpload;
