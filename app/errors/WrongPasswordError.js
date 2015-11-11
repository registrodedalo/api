function WrongPasswordError() {
	this.statusCode = 401;
	this.code = 13;
	this.message = 'Wrong password';
}

module.exports = WrongPasswordError;
