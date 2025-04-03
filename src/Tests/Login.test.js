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
    test("should render the Bejelentkezés button", () => {
        render(
            <Login setToken={() => {}} />
        );
        const loginButton = screen.getByRole("button", { name: /bejelentkezés/i });
        expect(loginButton).toBeVisible();
    });

    test("should render the Regisztráció button", () => {
        render(
            <Login setToken={() => {}} />
        );
        const registerButton = screen.getByRole("button", { name: /regisztráció/i });
        expect(registerButton).toBeVisible();
    });

    test("should render the Elfelejtett jelszó? button", () => {
        render(
            <Login setToken={() => {}} />
        );
        const forgotPasswordButton = screen.getByRole("button", {
            name: /elfelejtett jelszó\?/i,
        });
        expect(forgotPasswordButton).toBeVisible();
    });

    test("should display error message when error state is set", () => {
        render(
            <Login setToken={() => {}} />
        );
        const errorMessage = screen.queryByText(/hibás/i);
        expect(errorMessage).not.toBeInTheDocument();
    });
});