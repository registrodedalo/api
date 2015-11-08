function MissingFieldError(key) {	
	this.statusCode = 400;
	this.code = 5;
	this.message = 'The ' + key + ' field is missing from the request';
}

module.exports = MissingFieldError;
