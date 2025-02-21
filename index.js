const express = require("express");
const cors = require("cors");
const limiter = require("express-rate-limit").default;
const helmet = require("helmet");

const app = express();
const { APP_PORT } = require("./consts");
const apiRouter = require("./routers");

const PORT = APP_PORT;

app.use(cors());
app.use(express.static("public"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(helmet());
app.use(
  limiter({
    windowMs: 1000 * 10,
    max: 10,
  })
);
app.use("/api", apiRouter);

app.listen(PORT, () => {
  console.log(`Express Running on ${PORT}`);
});
