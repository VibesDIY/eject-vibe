import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import App from "./App";

describe("App", () => {
  it("renders the heading", () => {
    render(<App />);
    const heading = screen.getByRole("heading", {
      name: /vite \+ react/i,
    });
    expect(heading).toBeTruthy();
  });
});
