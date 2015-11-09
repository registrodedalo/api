function WrongHeaderError(key) {	
	this.statusCode = 401;
	this.code = 7;
	this.message = 'The ' + key + ' header is invalid';
}

module.exports = WrongHeaderError;
