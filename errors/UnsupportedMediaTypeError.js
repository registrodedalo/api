function UnsupportedMediaTypeError() {	
	this.statusCode = 400;
	this.code = 10;
	this.message = 'The content type should be JSON';
}

module.exports = UnsupportedMediaTypeError;
