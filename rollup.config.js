const nodeResolve = require("@rollup/plugin-node-resolve").default;
const cjs = require("@rollup/plugin-commonjs").default;
const terser = require("@rollup/plugin-terser").default;
const json = require("@rollup/plugin-json").default;

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
  plugins: [json(), nodeResolve(), cjs(), terser()],
};

module.exports = rollupOptions;
