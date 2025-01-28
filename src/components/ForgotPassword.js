import React, { useState } from "react";
import axios from "axios";
import { Form, Button, Container, Card, Alert } from "react-bootstrap";
import "./Login.css";
import {useNavigate } from "react-router-dom";

const ForgotPassword = ({ onBackToLogin }) => {
    const navigate=useNavigate();
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      await axios.post(
        "https://localhost:7247/api/Users/forgotpass",
        { email }
      );

      setMessage("Ha az e-mail cím létezik, elküldtük a visszaállítási linket.");
      setError("");
    } catch (err) {
      setError("Hiba történt! Próbáld újra később.");
    }
    setIsLoading(false);
  };

  return (
    <Container className="d-flex justify-content-center align-items-center vh-100 login-container">
      <Card className="shadow-lg p-4 login-card animate-card">
        <Card.Body>
          <h2 className="text-center mb-4 login-title">Elfelejtett jelszó</h2>
          {message && <Alert variant="success">{message}</Alert>}
          {error && <Alert variant="danger">{error}</Alert>}
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3">
              <Form.Label>📧 E-mail cím</Form.Label>
              <Form.Control
                type="email"
                placeholder="pl: pelda@gmail.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </Form.Group>
            <Button
              variant="primary"
              type="submit"
              className="w-100 login-btn"
              disabled={isLoading}
            >
              {isLoading ? "Küldés..." : "Küldés"}
            </Button>
            <Button
              variant="outline-secondary"
              className="w-100 mt-2 register-btn"
              onClick={()=>navigate("/login")}
            >
              Vissza a bejelentkezéshez
            </Button>
          </Form>
        </Card.Body>
      </Card>
    </Container>
  );
};

export default ForgotPassword;
