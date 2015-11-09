function RestError(statusCode, code, message) {
	this.statusCode = statusCode;
	this.code = code;
	this.message = message;
}

module.exports = RestError;
