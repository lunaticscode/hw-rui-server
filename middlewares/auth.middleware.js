const { API_HEADER_TOKEN } = require("../consts");
const responseFormat = require("../utils/responseFormat");

/**
 * @type {ApiMiddleware}
 */
const authMiddleware = (req, res, next) => {
  if (
    req.headers["hw-rui-token"] &&
    req.headers["hw-rui-token"] === API_HEADER_TOKEN
  ) {
    return next();
  }
  return res.status(401).json(responseFormat("ERROR", "(!) Invalid token."));
};

module.exports = {
  authMiddleware,
};
