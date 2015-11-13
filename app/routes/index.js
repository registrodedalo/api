var express = require('express');

var router = express.Router();

var auth = require('./auth.js');
router.use('/auth', auth);

module.exports = router;
