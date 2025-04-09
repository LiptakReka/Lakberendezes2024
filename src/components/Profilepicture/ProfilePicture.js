import React, { useState, useEffect } from "react";
import axios from "axios";
import "./ProfilePicture.css";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useAchievements } from "../../Pages2/Achievement/UseAchivements";
import { enqueueSnackbar } from "notistack";

const ProfilePictureUpload = () => {
    const { unlockAchievement } = useAchievements();
    const [user, setUser] = useState(null);
    const [selectedFile, setSelectedFile] = useState(null);
    const [previewImage, setPreviewImage] = useState(
        "https://res.cloudinary.com/dd10jzece/image/upload/v1743009597/profile_pictures/apoghzaa8cj77vnj3d0y.jpg"
    );


    useEffect(() => {
        const fetchProfilePicture = async () => {
            const storedUser = JSON.parse(localStorage.getItem("user"));
            if (!storedUser) return;

            try {
                const token = localStorage.getItem("token");
                const response = await axios.get(
                    `${process.env.REACT_APP_API_URL}/Users/profilepic?email=${storedUser.email}`,
                    {
                        headers: {
                            Authorization: token,
                        },
                    }
                );

                const imageUrl = response.data.profilePictureUrl;
                setPreviewImage(imageUrl); 
                setUser(storedUser);
            } catch (error) {
                console.error("Hiba a profilkép lekérése során:", error);
                setPreviewImage("https://res.cloudinary.com/dd10jzece/image/upload/v1743009597/profile_pictures/apoghzaa8cj77vnj3d0y.jpg");
            }
        };

        fetchProfilePicture();
    }, []);

    // Fájl kiválasztása
    const handleFileChange = (event) => {
        if (event.target.files.length > 0) {
            setSelectedFile(event.target.files[0]);
            setPreviewImage(URL.createObjectURL(event.target.files[0])); // Előnézet
        }
    };

    // Fájl feltöltése
    const handleUpload = async () => {
        if (!selectedFile) {
            toast.warn("Válassz ki egy képet!", { position: "top-center" });
            return;
        }

        const formData = new FormData();
        formData.append("file", selectedFile);
        formData.append("email", user?.email);

        try {
            const token = localStorage.getItem("token");
            const response = await axios.post(
                `${process.env.REACT_APP_API_URL}/Users/upload-profile-picture`,
                formData,
                {
                    headers: {
                        "Content-Type": "multipart/form-data",
                        Authorization: token,
                    },
                }
            );

            if (!response.data.imageUrl) {
                throw new Error("Nincs kép URL az API válaszában!");
            }

            const newProfileUrl = response.data.imageUrl; // Képtárolás URL
            const updatedUser = { ...user, profilePictureUrl: newProfileUrl };

            // Felhasználói adatok 
            localStorage.setItem("user", JSON.stringify(updatedUser));
            setUser(updatedUser);

            // Előnézeti kép
            setPreviewImage(newProfileUrl);

            enqueueSnackbar("Profilkép sikeresen feltöltve!", { variant: "success" });
            unlockAchievement("Szépségszalon", "Profilképed megváltozott", "💄");
        } catch (error) {
            console.error("Hiba a kép feltöltésekor:", error);
            enqueueSnackbar("Hiba történt a profilkép feltöltésekor.", { variant: "error" });
        }
    };

    return (
        <div className="profile-upload-container">
            <img src={previewImage} alt="Profilkép" className="profile-preview" />
            <input type="file" accept="image/*" onChange={handleFileChange} />
            <button onClick={handleUpload}>Feltöltés</button>
        </div>
    );
};

export default ProfilePictureUpload;