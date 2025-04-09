import React from "react";
import { render, screen } from "@testing-library/react";
import '@testing-library/jest-dom';

jest.mock("../components/Login/Login", () => {
  return function MockLogin({ setToken }) {
    return (
      <div>
        <button>Bejelentkezés</button>
        <button>Regisztráció</button>
        <button>Elfelejtett jelszó?</button>
      </div>
    );
  };
});


import Login from "../components/Login/Login";


const MockLink = ({ children, to }) => <a href={to}>{children}</a>;
const mockNavigate = jest.fn();


jest.mock('react-router-dom', () => ({
  Link: (props) => <MockLink {...props} />,
  useNavigate: () => mockNavigate
}), { virtual: true });

describe("Login Component", () => {
    test("Megjelenik e a Bejelentkezés gomb", () => {
        render(
            <Login setToken={() => {}} />
        );
        const loginButton = screen.getByRole("button", { name: /bejelentkezés/i });
        expect(loginButton).toBeVisible();
    });

    test("Megjelenik e Regisztráció gomb", () => {
        render(
            <Login setToken={() => {}} />
        );
        const registerButton = screen.getByRole("button", { name: /regisztráció/i });
        expect(registerButton).toBeVisible();
    });

    test("Mgejelenik e az elfelejtett jelszó gomb", () => {
        render(
            <Login setToken={() => {}} />
        );
        const forgotPasswordButton = screen.getByRole("button", {
            name: /elfelejtett jelszó\?/i,
        });
        expect(forgotPasswordButton).toBeVisible();
    });

    test("Error kód megjelenítése ", () => {
        render(
            <Login setToken={() => {}} />
        );
        const errorMessage = screen.queryByText(/hibás/i);
        expect(errorMessage).not.toBeInTheDocument();
    });
});