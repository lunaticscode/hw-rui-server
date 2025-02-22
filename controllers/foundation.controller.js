const path = require("node:path");
const { cwd } = require("node:process");
const { readFileSync } = require("node:fs");
const responseFormat = require("../utils/responseFormat");

/**
 * @type {ApiController}
 */
const getColorSchemaController = (req, res) => {
  try {
    const filePath = path.join(cwd(), "public", "foundations", "color.json");
    const resultFile = readFileSync(filePath);
    return res.json(
      responseFormat({ type: "OK", data: JSON.parse(resultFile.toString()) })
    );
  } catch (err) {
    console.error(err);
    return res.json(
      responseFormat({
        type: "ERROR",
        message: "(!)Cannot access color-json file.",
      })
    );
  }
};
module.exports = {
  getColorSchemaController,
};
