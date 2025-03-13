import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
  video: true,
  videoCompression: true,
  // temp: remove when done testing
  env: {
    filepaths: ['examples/three/three-module.json'] // relative path from project root
  },
  defaultCommandTimeout: 8000
});
