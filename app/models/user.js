var jwt    = require('jsonwebtoken');
var bcrypt = require('bcrypt');

var db     = require('../db.js');
var config = require('../../config.json');
var secret = config['secret'];

function verify(token, callback) {
	// Decode the token
	jwt.verify(token, secret, function(err, payload) {
		if (err) {
			// Errors: https://github.com/auth0/node-jsonwebtoken#errors--codes
			callback('tokenError');
			return;
		}
		
		// Now get the user
		var id = +payload['id'];
		var username = payload['u'];
		var jti = +payload['jti'];
		var did = payload['did'];
				
		if (isNaN(id)
			|| typeof username !== 'string'
			|| isNaN(jti)
			|| typeof did !== 'string'
		) {
			callback('tokenError');
			return;
		}
		
		var query = {
			sql: db.queries.get('getUserTokenVersions'),
			values: [id, username]
		};
		
		db.query(query, function(err, user) {
			if (err) {
				callback('serverError');
				return;
			}
			
			if (user.length == 0 || user[0]['TokenVersions'] == null) {
				callback('tokenError');
				return;
			}
			
			// Parse the versions field
			var versions = user[0]['TokenVersions'];
			if (typeof versions === 'string') {
				versions = JSON.parse(versions);
			}
			
			// Example { '[DID]': 1 }
			var v = +versions[did];
			
			// Wrong DID
			// or JTI different from the db one
			if (!v || v != jti) {
				callback('tokenError');
				return;
			}
			else {
				// ** FINALLY **
				callback(null, user, did);
			}
		});
	});
}

function authenticate(params, callback) {
	var query = {
		sql: db.queries.get('getUserByUsername'),
		values: [params['username']]
	};
	
	db.query(query, function(err, res) {
		if (err) {
			callback('serverError');
			return;
		}
		
		if (res.length == 0) {
			callback('wrongUsername');
			return;
		}
		
		var user = res[0];
		var hash = user['Password'].toString('ascii');
		
		bcrypt.compare(params['password'], hash, function(err, ok) {
			if (err) {
				console.error(err);
				callback('serverError');
				return;
			}
			
			if (ok === true) {
				generateToken(user, params['did'], callback);
			}
			else {
				callback('wrongPassword');
			}
		});
	});
}

function getRandomIntInclusive(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function generateToken(user, did, callback) {
	if (!did) {
		// Generate a device ID
		did = Date.now().toString() + getRandomIntInclusive(100, 999).toString();
	}
	
	var tokenVersions = JSON.parse(user['TokenVersions']);
	
	if (!tokenVersions) {
		tokenVersions = {};
	}
	
	var jti = 1;
	// Increment the token
	if (typeof tokenVersions[did] === 'number') {
		jti = tokenVersions[did] + 1;
	}
	
	// Save the new token versions in the db
	tokenVersions[did] = jti;
	
	var stringified = JSON.stringify(tokenVersions);
	
	var query = {
		sql: db.queries.get('setTokenVersions'),
		values: [stringified, user['ID']]
	};
		
	db.query(query, function(err) {
		if (err) {
			callback('serverError');
			return;
		}
		
		// Create the token payload
		var payload = {
			id: user['ID'],
			u: user['Username'],
			jti: jti,
			did: did
		};
		
		var options = {
			expiresIn: '15 days'
		};
		
		// Generate the JWT token
		var token = jwt.sign(payload, secret, options);
		
		var yeah = {
			did: did,
			token: token
		};
		callback(null, yeah);
	});
}

module.exports.verify = verify;
module.exports.authenticate = authenticate;
