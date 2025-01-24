import React, { useEffect, useState } from "react";
import axios from "axios";
import { Form, Button, Container, Card, Alert } from "react-bootstrap";
import "./Login.css";

const Login = ({ setToken, onRegisterClick }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    // Beállítja a bejelentkezési háttér osztályát
    document.body.classList.add("login-background");

    // Ha elhagyja az oldalt, visszaállítja az eredeti hátteret
    return () => {
      document.body.classList.remove("login-background");
    };
  }, []);
  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const response = await axios.post(
        "https://localhost:7247/api/Users/login",
        { email, password }
      );

      if (response.data.token) {
        setToken(response.data.token);
        localStorage.setItem("token", response.data.token);
        setError("");
      }
    } catch (err) {
      setError("Helytelen felhasználónév vagy jelszó.");
    }
    setIsLoading(false);
  };

  return (
    <Container className="d-flex justify-content-center align-items-center vh-100 login-container">
      <Card className="shadow-lg p-4 login-card animate-card">
        <Card.Body>
          <h2 className="text-center mb-4 login-title">Bejelentkezés</h2>
          {error && <Alert variant="danger">{error}</Alert>}
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3">
              <Form.Label>E-mail cím</Form.Label>
              <Form.Control
                type="email"
                placeholder="pl: pelda@gmail.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Jelszó</Form.Label>
              <Form.Control
                type="password"
                placeholder="********"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </Form.Group>
            <Button
              variant="primary"
              type="submit"
              className="w-100 login-btn"
              disabled={isLoading}
            >
              {isLoading ? "Bejelentkezés..." : "Bejelentkezés"}
            </Button>
            <Button
              variant="outline-secondary"
              className="w-100 mt-2 register-btn"
              onClick={onRegisterClick}
            >
              Regisztráció
            </Button>
          </Form>
        </Card.Body>
      </Card>
    </Container>
  );
}

export default Login;
