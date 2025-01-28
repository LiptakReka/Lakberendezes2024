import React, { useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import axios from "axios";
import { Form, Button, Container, Card, Alert } from "react-bootstrap";


const ResetPassword = () => {
    const [searchParams] = useSearchParams();
    const token = searchParams.get("token");
    const email = searchParams.get("email");

    const [password, setPassword] = useState("");
    const [confirmPassword, setConfirmPassword] = useState("");
    const [error, setError] = useState("");
    const [success, setSuccess] = useState(false);
    const navigate = useNavigate();

    const handleResetPassword = async (e) => {
        e.preventDefault();

        if (password !== confirmPassword) {
            setError("A jelszavak nem egyeznek.");
            return;
        }

        try {
            const response = await axios.post("https://localhost:7247/api/Users/reset-password", {
                email,
                token,
                newPassword: password
            });

            if (response.status === 200) {
                setSuccess(true);
                setError("");
                setTimeout(() => navigate("/login"), 3000);
            }
        } catch (err) {
            setError("Hiba történt a jelszó visszaállításakor. Próbáld újra.");
        }
    };

    return (
        <Container className="d-flex justify-content-center align-items-center vh-100">
            <Card className="shadow-lg p-4">
                <Card.Body>
                    <h2 className="text-center mb-4">Jelszó visszaállítás</h2>
                    {success ? (
                        <Alert variant="success">
                            A jelszó sikeresen megváltozott! Átirányítás a bejelentkezéshez...
                        </Alert>
                    ) : (
                        <>
                            {error && <Alert variant="danger">{error}</Alert>}
                            <Form onSubmit={handleResetPassword}>
                                <Form.Group className="mb-3">
                                    <Form.Label>Új jelszó</Form.Label>
                                    <Form.Control
                                        type="password"
                                        placeholder="Új jelszó"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        required
                                    />
                                </Form.Group>
                                <Form.Group className="mb-3">
                                    <Form.Label>Új jelszó megerősítése</Form.Label>
                                    <Form.Control
                                        type="password"
                                        placeholder="Jelszó újra"
                                        value={confirmPassword}
                                        onChange={(e) => setConfirmPassword(e.target.value)}
                                        required
                                    />
                                </Form.Group>
                                <Button variant="primary" type="submit" className="w-100">
                                    Jelszó visszaállítása
                                </Button>
                            </Form>
                        </>
                    )}
                </Card.Body>
            </Card>
        </Container>
    );
};

export default ResetPassword;
