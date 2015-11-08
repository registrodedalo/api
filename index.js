// HTTP server
var express    = require('express');
// Requests logging
var morgan     = require('morgan');
// Express middleware for requests body parsing
var bodyParser = require('body-parser');
// Express middleware for responses GZIP compression
var compress   = require('compression');

// REST errors for responses
var errors     = require('./errors');

// Create the Express application
var app = express();

app.set('x-powered-by', false);


// -----    -----------        ----
// Chain of middlewares starts here
// -----    -----------        ----

// Register request logger (stdout)
app.use(morgan('dev'));

// Enable GZIP compression
app.use(compress());

// Set the Powered-By response header
app.use(function(req, res, next) {
	res.header('Powered-By', 'Dedalo API');
	next();
});

// Allow only JSON bodies
//  --> check Content-Type header
app.use(function(req, res, next) {
	var contentType = req.header('Content-Type');
	
	if (contentType && contentType != 'application/json') {
		next(new errors.UnsupportedMediaTypeError());
	}
	else {
		next();
	}
});

// Make sure only JSON responses are requested
//  --> check Accept header
app.use(function(req, res, next) {
	if (!req.accepts('application/json')) {
		next(new errors.NotAcceptableError());
	}
	else {
		next();
	}
});

// TODO: check auth

// Parse the JSON body, if any
app.use(bodyParser.json());

// Inject sendData function to response object
// for sending JSON responses with a JavaScript object
app.use(function(req, res, next) {
	res.sendData = function(data) {
		// Handle the optional first parameter
		if (arguments.length == 2) {
			var code = arguments[0];
			var data = arguments[1];
		}
		else {
			// Default response code is 200 OK
			var code = 200;
		}
		
		res.status(code);
		
		// Send success response
		var response = {
			data: data
		};
		res.json(response);
	};
	
	next();
});

// Routes
var api = require('./routes');
app.use('/v1', api);

// Not found
app.use(function(req, res, next) {
	var err = new errors.UnknownEndpointError();
	next(err);
});

// Log error to console
// TODO: log with winston
app.use(function(err, req, res, next) {
	console.error(err);
	next(err);
});

// Send response with error
app.use(function(err, req, res, next) {
	if (!err.statusCode) {
		// Set the default status code for errors
		err.statusCode = 500;
	}
	
	res.status(err.statusCode);
	
	// Send error JSON response
	var response = {
		error: {
			code: err['code'],
			message: err['message']
		}
	};
	res.json(response);
});

// Server, start listening
app.listen(3001, function() {
	console.log('Listening on port 3001 :)');
});

// TODO: handle server launch errors
