function UnknownEndpointError() {
	this.statusCode = 404;
	this.code = 9;
	this.message = 'Unknown endpoint requested';
}

module.exports = UnknownEndpointError;
