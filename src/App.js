import React from 'react';
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Navbar1  from './components/Navbar1';
import Home from "./Pages2/Home";
import Planner from "./Pages2/Planner";
import About from "./Pages2/About";
import Contact from "./Pages2/Contact";




const App=() =>{
 
  return (
    <Router>
      <Navbar1 /> 
      <Routes>
        <Route path="/home" element={<Home /> } />
        <Route path="/about" element={<About / >}/>
        <Route path="/planner" element={<Planner />}/>
        <Route path="/contact" element={<Contact />} />
      </Routes>
    </Router>
  );
}

export default App;
