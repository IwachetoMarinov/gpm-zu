import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { resolve } from "node:path";

export default defineConfig({
  plugins: [react()],

  base: "/libraries/pos-wizard/dist/",

  build: {
    outDir: "dist",
    emptyOutDir: true,
    cssCodeSplit: false,

    rollupOptions: {
      input: resolve(__dirname, "src/main.tsx"),

      output: {
        entryFileNames: "app.js",
        chunkFileNames: "app.js",

        assetFileNames: (assetInfo) => {
          if (assetInfo.names?.some((name) => name.endsWith(".css"))) {
            return "app.css";
          }

          return "assets/[name][extname]";
        },

        inlineDynamicImports: true,
      },
    },
  },
});