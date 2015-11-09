function WrongParameterTypeError(key, type) {	
	this.statusCode = 400;
	this.code = 4;
	this.message = 'The ' + key + ' parameter should be of type ' + type;
}

module.exports = WrongParameterTypeError;
