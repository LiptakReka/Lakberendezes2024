import React from 'react'
import { Check, X } from 'lucide-react'
import './Passwordreq.css'

export default function Passwordreq({password, isVisible}) {
    if(!isVisible) return null;

    const req=[
        {
            text:"Minimum 8 karakter",
            met:password.length >=8
        },
        {
            text:"Legalább egy kisbetű",
            met:/[a-z]/.test(password)
        },
        {
            text:"Legalább egy nagybetű",
            met:/[A-Z]/.test(password)
        },
        {
            text:"Legalább egy szám",
            met:/[0-9]/.test(password)
        },
        {
            text:"Legalább egy speciális karakter",
            met:/[^A-Za-z0-9]/.test(password) // Javítva: csak egy záró szögletes zárójel
        }
    ];
  return (
    <div className='password-req'>
        <h3>Jelszó követelmények</h3>
        <ul>
            {req.map((req, index)=>(
                 <li key={index} className={req.met ? 'requirement-met' : 'requirement-not-met'}>
                 {req.met ? <Check size={16} className="check-icon" /> : <X size={16} className="x-icon" />}
                 <span>{req.text}</span>
               </li>
            ))}
        </ul>
    </div>
    
  );
};
