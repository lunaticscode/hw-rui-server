const figmaRouter = require("./figma.router");

const apiRouter = require("express").Router();

apiRouter.use("/figma", figmaRouter);

module.exports = apiRouter;
