function InvalidJSONError() {
	this.statusCode = 400;
	this.code = 14;
	this.message = 'Invalid JSON body';
}

module.exports = InvalidJSONError;
