var jwt    = require('jsonwebtoken');
var db     = require('../db.js');
var config = require('../config.json');
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
		var platform = payload['t'];
		
		if (isNaN(id)
			|| typeof username !== 'string'
			|| isNaN(jti)
			|| typeof platform !== 'string'
		) {
			callback('tokenError');
			return;
		}
		
		var query = {
			sql: db.queries.get('getUserTokenVersions'),
			values: [id, username]
		};
		
		db.query(query, function(err, res) {
			if (err) {
				callback('serverError');
				return;
			}
			
			if (res.length == 0 || res[0]['TokenVersions'] == null) {
				callback('tokenError');
				return;
			}
			
			// Parse the versions field
			var versions = res[0]['TokenVersions'];
			if (typeof versions === 'string') {
				versions = JSON.parse(versions);
			}
			
			// Example { web: 1 }
			var v = +versions[platform];
			
			// Wrong platform name
			// or token version different from the db one
			if (!v || v != jti) {
				callback('tokenError');
				return;
			}
			else {
				// ** FINALLY **
				callback();
			}
		});
	});
}

module.exports.verify = verify;
