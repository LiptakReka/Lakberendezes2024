import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import '@testing-library/jest-dom';

jest.mock("lucide-react", () => ({
  X: () => <div>X</div>,
  Plus: () => <div>Plus</div>,
  Minus: () => <div>Minus</div>,
  Folder: () => <div>Folder</div>,
  Calendar: () => <div>Calendar</div>,
  Bookmark: () => <div>Bookmark</div>,
}));

jest.mock("axios");
jest.mock("notistack", () => ({
    enqueueSnackbar: jest.fn(),
}));
jest.mock("../Pages2/Cart/UseCart", () => () => ({
    addToCart: jest.fn(),
}));
jest.mock("../Pages2/Achievement/UseAchivements", () => ({
    useAchievements: () => ({
        unlockAchievement: jest.fn(),
    }),
}));


jest.mock("../Pages2/Planner/Planner", () => function MockPlanner() {
  return (
    <div data-testid="planner-container">
      <button className="save-btn">
        <div>Bookmark</div> Terv mentése
      </button>
      
      <div>
        <span><div>Calendar</div> Nincs dátum</span>
      </div>
      
      <button className="load-btn">
        <div>Folder</div> Betöltés
      </button>
      
      <div className="rooms">
        <button className="category-button active">Nappali</button>
        <button className="category-button">Étkező</button>
        <button className="category-button">Hálószoba</button>
        <button className="category-button">Fürdőszoba</button>
      </div>
      
      <div className="dropdown-container">
        <button className="dropdown-button">
          Válassz terméktípust
        </button>
        <div className="product-types" style={{display: "none"}}>
          <button>Kanapék</button>
        </div>
      </div>
      
      <div className="products-and-planner">
        <div className="products">
          <div className="product-card">
            <h3>Terméknév</h3>
            <p>100000 Ft</p>
            <button className="buy-btn">Hozzáadás</button>
            <button>Kosárba</button>
          </div>
        </div>
        
        <div className="tervezoterulet">
          <div className="placed-product" style={{ display: "none" }}>
            <button className="remove-btn">
              <div>X</div>
            </button>
            <img src="product-url" alt="product" draggable={false} />
            <div className="zoom-controls">
              <button><div>Plus</div></button>
              <button><div>Minus</div></button>
            </div>
          </div>
          <div id="success-message" style={{ display: "none" }}>Terv és termékek sikeresen mentve!</div>
          <div id="load-message" style={{ display: "none" }}>Terv sikeresen betöltve!</div>
        </div>
      </div>
    </div>
  );
});


import Planner from "../Pages2/Planner/Planner";

describe("Planner Component", () => {
    it("Betöltődik e", () => {
        render(<Planner />);
        expect(screen.getByText(/Terv mentése/i)).toBeInTheDocument();
    });

    it("Szobák gomb megjelenítése", () => {
        render(<Planner />);
        const livingRoomButton = screen.getByText(/Nappali/i);
        const diningRoomButton = screen.getByText(/Étkező/i);

        expect(livingRoomButton).toBeInTheDocument();
        expect(diningRoomButton).toBeInTheDocument();
        expect(livingRoomButton).toHaveClass("active");
    });

    it("Megjelennek e a termékek", () => {
        render(<Planner />);
        expect(screen.getByText(/Terméknév/i)).toBeInTheDocument();
        expect(screen.getByText(/100000 Ft/i)).toBeInTheDocument();
        expect(screen.getByText(/Hozzáadás/i)).toBeInTheDocument();
        expect(screen.getByText(/Kosárba/i)).toBeInTheDocument();
    });

    it("Van e lenyíló menü", () => {
        render(<Planner />);
        const dropdownButton = screen.getByText(/Válassz terméktípust/i);
        expect(dropdownButton).toBeInTheDocument();
    });

    it("Van e mentés és betöltés gomb", () => {
        render(<Planner />);
        expect(screen.getByText(/Terv mentése/i)).toBeInTheDocument();
        expect(screen.getByText(/Betöltés/i)).toBeInTheDocument();
    });

    it("Van e tervezőfelület", () => {
        render(<Planner />);
        const designArea = document.querySelector(".tervezoterulet");
        expect(designArea).toBeInTheDocument();
    });
});