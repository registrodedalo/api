function WrongCredentialsError() {	
	this.statusCode = 401;
	this.code = 1;
	this.message = 'Wrong username and/or password';
}

module.exports = WrongCredentialsError;
