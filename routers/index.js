const figmaRouter = require("./figma.router");

const apiRouter = require("express").Router();
apiRouter.get("/health-check", (req, res) => {
  const { originalUrl, protocol, httpVersion, hostname } = req;

  const reqHeaders = {
    ...req.headers,
    originalUrl,
    protocol,
    httpVersion,
    host: req.get("host"),
    hostname,
  };

  return res.json({ message: "hello world", reqHeaders });
});
apiRouter.use("/figma", figmaRouter);

module.exports = apiRouter;
