function NotAcceptableError() {
	this.statusCode = 400;
	this.code = 8;
	this.message = 'The server cannot handle the type specified in the Accept header';
}

module.exports = NotAcceptableError;
