const responseFormat = require("../utils/responseFormat");
const { writeFileSync } = require("node:fs");
const { cwd } = require("node:process");
const path = require("node:path");

/**
 * @type {ApiController}
 */
const getVariablesController = (req, res) => {
  const headers = req.headers;
  console.log(headers);
  return res.status(200).json(responseFormat({ type: "OK", data: [] }));
};

/**
 * @type {ApiController}
 */
const saveVariablesController = (req, res) => {
  try {
    const tempData = {
      color: {},
      fontSize: {},
      spacing: {},
    };

    for (const originKey in req.body) {
      if (originKey.startsWith("color/")) {
        const processedKey = `--${originKey.split("/").join("-")}`;
        tempData["color"][processedKey] = req.body[originKey];
      }
    }

    writeFileSync(
      path.join(cwd(), "public", "foundations", "color.json"),
      JSON.stringify(tempData["color"])
    );

    res
      .status(201)
      .json(responseFormat({ type: "OK", message: "Success to save." }));
  } catch (err) {
    console.error(err);
    res.status(500).json(
      responseFormat({
        type: "ERROR",
        message: "(!) Fail to save. Please contact to administartor",
      })
    );
  }
};

module.exports = {
  saveVariablesController,
  getVariablesController,
};
