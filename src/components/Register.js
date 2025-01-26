import React, { useEffect, useState } from 'react';
import "./Register.css"


const Register=({setToken , onLoginClick})=>{
   
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [fullname, setFullname] = useState("");
    const [error, setError] = useState('');
    const [username, setUsername] = useState("")
    const [success, setSuccess] = useState("");



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
                
                setSuccess("Sikeres regisztráció!");
                setFullname('');
                setEmail('');
                setPassword('');
                
            }else{
                const errorData=await response.json();
                console.error("Szerver hiba" + errorData)
                setError("Hibás adatok "  || "Ismeretlen hiba")
            }
        }catch(error){
            console.error('Hálózati hiba:', error);
            alert('Nem sikerült kapcsolatot létesíteni a kiszolgálóval.')
            
        }
    };
  return (
    <div className="register-container d-flex justify-content-center align-items-center vh-100">
    <div className="register-box p-4 rounded shadow-lg ">
      <h2 className="text-center mb-4">Regisztráció</h2>
      {error && <div className="alert alert-danger">{error}</div>}
      {success && <div className="alert alert-success">{success}</div>}
      <form onSubmit={handleregister}>
        <div className="mb-3">
          <label className="form-label"> 🙍‍♂️Teljes név:</label>
          <input
            type="text"
            className="form-control"
            value={fullname}
            onChange={(e) => setFullname(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label className="form-label"> 🙍‍♂️Felhasználónév: </label>
          <input
            type="text"
            className="form-control"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label className="form-label">📧E-mail: </label>
          <input
            type="email"
            className="form-control"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label className="form-label">🔑Jelszó: </label>
          <input
            type="password"
            className="form-control"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit" className="btn btn-primary w-100">Regisztráció</button>
        <button type="button" className="btn btn-secondary w-100 mt-2" onClick={onLoginClick}>
          Már van fiókod? Bejelentkezés
        </button>
      </form>
    </div>
  </div>
);
};


export default Register;