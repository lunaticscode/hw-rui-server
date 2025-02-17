require("dotenv").config();

const APP_PORT = process.env.APP_PORT || 8888;
const API_HEADER_TOKEN = process.env.API_HEADER_TOKEN || "";

module.exports = {
  APP_PORT,
  API_HEADER_TOKEN,
};
