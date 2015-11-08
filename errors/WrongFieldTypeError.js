function WrongFieldTypeError(key, type) {	
	this.statusCode = 400;
	this.code = 6;
	this.message = 'The ' + key + ' field should be of type ' + type;
}

module.exports = WrongFieldTypeError;
