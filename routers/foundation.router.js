const { getColorSchemaController } = require("../controllers");

const foundationRouter = require("express").Router();

foundationRouter.get("/color-json", getColorSchemaController);

module.exports = foundationRouter;
