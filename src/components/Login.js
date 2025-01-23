import React, { useState } from 'react'
import axios from "axios";
import "./Login.css"



const Login=({setToken , onRegisterClick})=> {

    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");

    const handleSubmit=async (e) =>{
        e.preventDefault();
        try {
            const response=await axios.post("https://localhost:7247/api/Users/login",{
                email,
                password,
            });

        if(response.data.token){
            setToken(response.data.token);
            localStorage.setItem("token" , response.data.token);
            console.log("Sikeres bejelentkezés")
            setError("")
        }
        } catch (err) {
            console.error(err);
            setError("Helytelen felhasználónév vagy jelszó.")
            
        }
    };
  return (
    <div className='login-container'>
        <h2>Bejelentkezés</h2>
    <form onSubmit={handleSubmit}>
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
        <button type='submit'>Bejelentkezés</button>
        <button  type="button" onClick={onRegisterClick}>Regisztráció</button>
    </form>
    </div>
  )
}

export default Login;
