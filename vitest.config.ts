import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

// Separate Vitest config so Vite type-checking doesn't complain
export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
  },
});
