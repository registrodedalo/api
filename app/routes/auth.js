var express = require('express');
var User    = require('../models/user.js');
var errors  = require('../errors');

var router = express.Router();

// Currently logged-in user profile
router.get('/me', function(req, res, next) {
	// Get the user
	User.me(req.user['ID'], function(err, user) {
		if (err) {
			var e;
			if (err == 'userNotFound') {
				e = new errors.SessionError();
			}
			else {
				e = new errors.InternalServerError();
			}
			
			next(e);
			return;
		}
		
		res.sendData(200, user);
	});
});

module.exports = router;
