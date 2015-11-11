var mysql   = require('mysql');
var config  = require('../config.json');
var queries = require('./queries');

// Create MySQL connection
var db = mysql.createConnection(config.database);

// Connect
db.connect(function(err) {
	if (err) {
		if (err.errno == 1049) {
			console.error('The database "' + config.database['database'] + '" doesn\'t exist');
		}
		else {
			console.error('Error connecting: ' + err);
		}
		
		return;
	}
	
	console.log('Connected as id ' + db.threadId + ' to database ' + config.database['database']);
});

function query(options, callback) {
	db.query(options, function(err, results, fields) {
		if (err) {
			// TODO: log the error...
			console.error(err);
			callback(true);
			return;
		}
		
		callback(null, results, fields);
	});
}

module.exports.query = query;
module.exports.queries = queries;
