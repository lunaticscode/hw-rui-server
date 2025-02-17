const express = require("express");
const cors = require("cors");
const { APP_PORT } = require("./consts");
const apiRouter = require("./routers");
const app = express();
const PORT = APP_PORT;

app.use(cors());
app.use(express.static("public"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use("/api", apiRouter);

app.listen(PORT, () => {
  console.log(`Express Running on ${PORT}`);
});

// module.exports = app;
