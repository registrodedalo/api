var jwt    = require('jsonwebtoken');
var bcrypt = require('bcrypt');

var db     = require('../db.js');
var config = require('../../config.json');
var secret = config['secret'];

/**
 * Verify the token sent in the Auth-Token header
 * @param  {String}   token
 * @param  {Function} callback
 */
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
				user['ID'] = id,
				user['Username'] = username;
				
				// ** FINALLY **
				callback(null, user, did);
			}
		});
	});
}

/**
 * Check params['username'] and params['password'],
 * generate a new token for the device (params['did'] optional)
 * 
 * @param  {Object}   params
 * @param  {Function} callback
 */
function authenticate(params, callback) {
	var query = {
		sql: db.queries.get('getUserByUsername'),
		values: [params['username']]
	};
	
	// Get the user, if it exists
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
		
		// Compare the plain-text password and the hash
		bcrypt.compare(params['password'], hash, function(err, ok) {
			if (err) {
				console.error(err);
				callback('serverError');
				return;
			}
			
			if (ok === true) {
				// Yeah :) generate the token
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

/**
 * Generate an Auth-Token, given the user and the device ID (did)
 * @param  {Object}   user
 * @param  {String}   did - Device ID, optional value
 * @param  {Function} callback
 */
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
	// Increment the token version
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
		
		// TODO: decide the expire time
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

/**
 * Return the currently logged-in user profile
 * @param  {Number}   userID - ID of the user
 * @param  {Function} callback
 */
function me(userId, callback) {
	var query = {
		sql: db.queries.get('getUserProfiles'),
		values: [userId, userId, userId, userId]
	};
	
	db.query(query, function(err, users) {
		if (err) {
			callback('serverError');
			return;
		}
		
		if (users.length != 1) {
			callback('userNotFound');
			return;
		}
		
		var user = users[0];
		
		// es.
		// { Username: 'nome.cognome', Nome: 'Nome', Cognome: 'Cognome',
		//   Insegnante: 1, Studente: 0, Collaboratore: 0 }
		var profiles = [];
		if (user['Insegnante'] === 1) profiles.push('insegnante');
		if (user['Studente'] === 1) profiles.push('studente');
		if (user['Collaboratore'] === 1) profiles.push('collaboratore');
		
		var res = {
			username: user['Username'],
			profili: profiles,
			nome: user['Nome'],
			cognome: user['Cognome']
		};
		
		callback(null, res);
	});
}

module.exports.verify = verify;
module.exports.authenticate = authenticate;
module.exports.me = me;
