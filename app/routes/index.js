var models = require('../models');
var express = require('express');

var router = express.Router();

/* Get all users */
router.get('/', function (req, res) {
    models.User.findAll()
        .then(function (users) {
            res.json(users)
        })
});

module.exports = router;
