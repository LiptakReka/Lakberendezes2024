import React, { useState } from 'react'

const Register=()=>{
    const [username, setUsername] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');


    const handleregister=async (e)=>{
        e.preventDefault();
        const newUser={
            username,
            email,
            password,
        };

        try{
            const response=await fetch('http://localhost:5086/api/Users/register',{
                method: 'POST',
                headers:{
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(newUser)
            });

            if (response.ok){
                alert("Sikeres regisztráció!");
                setUsername('');
                setEmail('');
                setPassword('');
            }else{
                const errorData=await response.json();
                alert("Hiba: " + errorData.massage);
            }
        }catch(error){
            console.error('Hálózati hiba:', error);
            alert('Nem sikerült kapcsolatot létesíteni a kiszolgálóval.')
            
        }
    };
  return (
    <div>Register</div>
  )
}
