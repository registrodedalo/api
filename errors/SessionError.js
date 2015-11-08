function SessionError() {	
	this.statusCode = 400;
	this.code = 11;
	this.message = 'The Auth-Token header is invalid or the session has expired. Please authenticate again';
}

module.exports = SessionError;
