var fs = require('fs');
var files = fs.readdirSync(__dirname);
var errors = {};

files.forEach(function(file) {
	// Skip self
	if (file == 'index.js') {
		return;
	}
	
	if (file.match(/.*\.js/i)) {
		var mod = require('./' + file);
		var name = file.split('.')[0];
		errors[name] = mod;
	}
});

module.exports = errors;
