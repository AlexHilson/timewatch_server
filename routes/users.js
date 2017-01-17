var models = require('../models'),
    express = require('express'),
    util = require('util'),
    bodyParser = require('body-parser'),
    expressValidator = require('express-validator'),
    Promise = require('bluebird'),
    timewatch = require('../timewatch'),
    router = express.Router();

router.use(bodyParser.json());
router.use(expressValidator());

/* Create user */
router.post('/', function (req, res) {
    req.checkBody('username', 'Missing username').notEmpty();
    req.checkBody('email', 'Missing Timewatch email').notEmpty();
    req.checkBody('password', 'Missing Timewatch password').notEmpty();

    req.getValidationResult().then(function (result) {
        if (!result.isEmpty()) {
            res.status(400).send('There have been validation errors: ' + util.inspect(result.array()));
            return
        }
        models.User.create({
            username: req.body.username
        }).then(function (user) {
            models.Timewatch.create({
                UserId: user.get('id'),
                email: req.body.email,
                password: req.body.password,
            })
        }).catch(function (err) {
            res.status(400).send(err.toString());
        }).then(function () {
            res.redirect('/')
        })
    })
});

/* Get user */
router.get('/:userid', function (req, res) {
    models.User.findById(
        req.params.userid, {include: [models.Task]})
        .then(function (user) {
            res.json(user)
        })
});

/* Create task for user */
router.post('/:userid/tasks', function (req, res) {
    req.checkBody('cost_code', 'Missing task cost_code').notEmpty();
    req.checkBody('analysis_code', 'Missing task analysis_code').notEmpty();
    req.checkBody('hours_per_day', 'Missing task hours_per_day').notEmpty();

    req.getValidationResult().then(function (result) {
        if (!result.isEmpty()) {
            res.status(400).send('There have been validation errors: ' + util.inspect(result.array()));
            return
        }
        models.Task.create({
            cost_code: req.body.cost_code,
            analysis_code: req.body.analysis_code,
            hours_per_day: req.body.hours_per_day,
            UserId: req.params.userid
        }).catch(function (err) {
            res.status(400).send(err.toString());
        }).then(function () {
            res.redirect('/users/' + req.params.userid);
        })
    })
});

/* Submit weekly timesheet */
router.post('/:userid/submit', function (req, res) {
    models.User.findById(req.params.userid, {
        include: [models.Timewatch, models.Task]
    }).then(function (user) {
        var tasks = user.Tasks;
        var creds = user.Timewatch;
        console.log(creds.email);
        console.log(creds.password);
        Promise.map(tasks, function (task) {
            return timewatch.run(
                creds.email, creds.password, task.cost_code, task.analysis_code, task.hours_per_day);
        }, {concurrency: 1}).then(function () {
            res.send('success!')
        }).catch(function (err) {
            res.status(400).json(err);
        })
    })
});

module.exports = router;



