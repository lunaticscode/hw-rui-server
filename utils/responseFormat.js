/**
 * @typedef ResponseFormatArg
 * @property {"OK" | "ERROR"} type
 * @property {string} message
 * @property {any} data
 */

/**
 * @type {(param: ResponseFormatArg) => any}
 */
const responseFormat = ({ type, message = "", data = undefined }) => {
  const format = {
    isError: type === "OK" ? false : true,
    message,
    data,
  };
  if (data === undefined) {
    delete format.data;
  }
  return format;
};

module.exports = responseFormat;
