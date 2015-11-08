function MissingHeaderError(key) {	
	this.statusCode = 400;
	this.code = 7;
	this.message = 'The ' + key + ' header is missing from the request';
}

module.exports = MissingHeaderError;
