function WrongUsernameError() {
	this.statusCode = 401;
	this.code = 1;
	this.message = 'Username not found';
}

module.exports = WrongUsernameError;
