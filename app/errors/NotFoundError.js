function NotFoundError() {
	this.statusCode = 404;
	this.code = 2;
	this.message = 'The requested item was not found';
}

module.exports = NotFoundError;
