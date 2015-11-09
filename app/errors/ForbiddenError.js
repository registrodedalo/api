function ForbiddenError() {
	this.statusCode = 402;
	this.code = 3;
	this.message = 'The user doesn\'t have enough permissions to access this resource';
}

module.exports = ForbiddenError;
