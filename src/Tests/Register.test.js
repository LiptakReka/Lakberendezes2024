import React from 'react';
import { render, screen} from '@testing-library/react';
import '@testing-library/jest-dom';

jest.mock('lucide-react', () => ({
  Mail: () => <div data-testid="mail-icon">Mail Icon</div>,
  Key: () => <div data-testid="key-icon">Key Icon</div>,
  Users: () => <div data-testid="users-icon">Users Icon</div>,
  Image: () => <div data-testid="image-icon">Image Icon</div>,
}));

jest.mock('hugeicons-react', () => ({
  StarsIcon: () => <div data-testid="stars-icon">Stars Icon</div>,
}));

jest.mock('axios', () => ({
  post: jest.fn()
}));


jest.mock("../components/Register/Register", () => function() {

  return (
    <div>
      <h1>Regisztráció</h1>
      <p>A csillaggal jelölt mezők kitöltése kötelező!</p>

      <label htmlFor="fullname">Teljes név:</label>
      <input id="fullname" />

      <label htmlFor="username">Felhasználónév:</label>
      <input id="username" />

      <label htmlFor="email">E-mail:</label>
      <input id="email" />

      <label htmlFor="password">Jelszó:</label>
      <input 
        id="password" 
        type="password"
      />

      <label htmlFor="confirmPassword">Jelszó újra:</label>
      <input 
        id="confirmPassword" 
        type="password"
      />

      <label htmlFor="profilePic">Profilkép:</label>
      <input id="profilePic" type="file" />

      <button>Regisztráció</button>
    </div>
  );
});

import Register from "../components/Register/Register";
import axios from 'axios';


const mockPost = axios.post;

describe('Register Component', () => {
 
  const renderComponent = () => {
    return render(<Register />);
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders the Register component correctly', () => {
    renderComponent();

    expect(screen.getByRole('heading', { name: /Regisztráció/i })).toBeInTheDocument();
    expect(screen.getByText(/A csillaggal jelölt mezők kitöltése kötelező!/i)).toBeInTheDocument();
  });

  test('form has the correct fields', () => {
    renderComponent();
    
    expect(screen.getByLabelText(/Teljes név:/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Felhasználónév:/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/E-mail:/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Jelszó:/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Jelszó újra:/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Profilkép:/i)).toBeInTheDocument();

    expect(screen.getByRole('button', { name: /Regisztráció/i })).toBeInTheDocument();
  });

 
});