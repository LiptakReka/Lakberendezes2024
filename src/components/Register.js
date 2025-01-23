import React, { useState } from 'react'


const Register=({setToken , onLoginClick})=>{
   
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullname, setFullname] = useState("");
    const [error, setError] = useState('');
    const [username, setUsername] = useState("")


    const handleregister=async (e)=>{
        e.preventDefault();
        const newUser={
            fullname,
            username,
            password,
            email,
        };

        try{
            const response=await fetch('https://localhost:7247/api/Users/register',{
                method: 'POST',
                headers:{
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(newUser)
            });

            if (response.ok){
                
                alert("Sikeres regisztráció!");
                setFullname('');
                setEmail('');
                setPassword('');
                
            }else{
                const errorData=await response.json();
                console.error("Szerver hiba" + errorData)
                alert("Hiba " + errorData.message || "Ismeretlen hiba")
            }
        }catch(error){
            console.error('Hálózati hiba:', error);
            alert('Nem sikerült kapcsolatot létesíteni a kiszolgálóval.')
            
        }
    };
  return (
    <div className='register-container'>
        <h2>Regisztráció</h2>
    <form onSubmit={handleregister}>
        <div className='form-group'>
            <label>Teljes neved: </label>
            <input type='text' value={fullname} onChange={(e)=>setFullname(e.target.value)} required/>
        </div>
        <div className='form-group'>
            <label>Felhasználó név: </label>
            <input type='text' value={username} onChange={(e)=>setUsername(e.target.value)} required/>
        </div>
        <div className='form-group'>
            <label > E-mail: </label>
            <input type='email' value={email} onChange={(e)=>setEmail(e.target.value)}
            required/>
        </div>
        <div className='form-group'>
            <label> Jelszó: </label>
            <input type="password" value={password} onChange={(e)=> setPassword(e.target.value)} required/>

        </div>


        {error && <p className='error-messages'>{error}</p>}
        <button type='submit'>Regisztráció</button>
        <button onClick={onLoginClick}>Bejelentkezés</button>
    </form>
    </div>
  )
}

export default Register;