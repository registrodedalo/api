function InternalServerError() {
	this.statusCode = 500;
	this.code = 12;
	this.message = 'Server error. Something went wrong querying the database';
}

module.exports = InternalServerError;
