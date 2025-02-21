const nodeResolve = require("@rollup/plugin-node-resolve").default;
const cjs = require("@rollup/plugin-commonjs").default;
const terser = require("@rollup/plugin-terser").default;
const json = require("@rollup/plugin-json").default;

const fs = require("node:fs");
const path = require("node:path");
const { cwd } = require("node:process");

/**
 * @returns {import("rollup").Plugin}
 */
const copyEnv = () => {
  return {
    name: "copy-env",
    closeBundle: () => {
      try {
        const envFilePath = path.join(cwd(), ".env");
        fs.copyFileSync(envFilePath, path.join(cwd(), "dist", ".env"));
      } catch (err) {
        console.error("(!)Failed copy .env file\n\n");
        console.error(err);
      }
    },
  };
};

/**
 * @type {import("rollup").RollupOptions}
 */
const rollupOptions = {
  input: "./index.js",
  output: {
    file: "dist/app.js",
    format: "cjs",
    sourcemap: false,
  },
  plugins: [json(), nodeResolve(), cjs(), terser(), copyEnv()],
};

module.exports = rollupOptions;
