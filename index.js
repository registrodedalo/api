#! /usr/bin/env node

var program = require('commander');

program
	.version(require('./package.json').version)
	.command('run', 'Start the API server')
	.command('db', 'Create the database structure for Dedalo')
	.parse(process.argv);
