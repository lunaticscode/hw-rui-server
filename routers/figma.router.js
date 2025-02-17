const figmaRouter = require("express").Router();
const {
  getVariablesController,
  saveVariablesController,
} = require("../controllers");
const { authMiddleware } = require("../middlewares/auth.middleware");

figmaRouter.get("/get-variables", authMiddleware, getVariablesController);
figmaRouter.post("/save-variables", authMiddleware, saveVariablesController);

module.exports = figmaRouter;
