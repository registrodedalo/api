var fs   = require('fs');
var path = require('path');

var cache = {};

// Load all the queries from the current dir (/queries)
var files = fs.readdirSync(__dirname);

files.forEach(function(file) {
	// Only SQL files
	if (file.slice(-4) != '.sql') {
		return;
	}
	
	var queryName = file.split('.')[0];
	
	// Don't load the create query
	if (queryName == 'create') {
		return;
	}
	
	var filePath = path.join(__dirname, file);
	
	// Read the query content
	var content = fs.readFileSync(filePath);
	
	// Save in the cache
	cache[queryName] = content.toString();
});

function get(queryName, get) {
	if (cache[queryName]) {
		return cache[queryName];
	}
	else {
		throw new Error('The query doesn\'t exist');
	}
}

module.exports.get = get;
