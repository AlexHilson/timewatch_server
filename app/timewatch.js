var Nightmare = require('nightmare');
require('nightmare-iframe-manager')(Nightmare);

var timewatchLogin = function (username, password) {
    return function (nightmare) {
        nightmare
            .goto('https://www.time-and-space.eu/timeandspace/Login.aspx')
            .type('input[name="LoginNameTxtBox"]', username)
            .type('input[name="PasswordTxtBox"]', password)
            .click('input[name="LoginBtn"]')
            .wait(7000)
    };
};

var logTime = function (costCode, analysisCode, timePerDay, date) {
    return function (nightmare) {
        var input_box = 'input[id="TSNewLine_txtTime' + date.getDay() + '"]';
        nightmare
            .enterIFrame('#ifrmTimesheet')
            .enterIFrame('#frmTimeSheet')
            .click('td[id="Grid1_dom"]')
            .type('input[id="txtsabNewLineJob"]', costCode + '\u000d')
            .type('input[id="txtsabNewLineStage"]', analysisCode + '\u000d')
            .type(input_box, timePerDay + '\u000d')
            .click('input[id="btnSaveNew"]')
            .resetFrame()
    };
};

var submitTime = function () {
    return function (nightmare) {
        nightmare.evaluate(function () {
            /* We should be able to pass a date in here, but for now we
            can only submit for the current day. This will also submit all days prior,
            so it's not really a big deal. */
            var date = Date();
            var frame = document.getElementById("ifrmTimesheet").contentWindow;
            frame.SubmitTime(date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDay());
        });
    };
};

/*
Separating 'submit' and 'log' is causing Timewatch to unpublish days. Until
I can work this out we need to log + submit all in one go, limiting us to
a single job per day.
*/
module.exports.run = function (email, password, cost_code, analysis_code, hours, date) {
    return new Promise(function (resolve, reject) {
        var nightmare = Nightmare({typeInterval: 50});
        nightmare
            .use(timewatchLogin(email, password))
            .use(logTime(cost_code, analysis_code, '7.5', date))
            .use(submitTime())
            .wait(1000)
            .end()
            .then(function() {
                resolve();
            })
            .catch(function (err) {
                reject(err);
            })
    })
};


module.exports.submit = function (email, password, date) {
    return new Promise(function (resolve, reject) {
        var nightmare = Nightmare({typeInterval: 50});
        var submit_date = date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDay();
        nightmare
            .use(timewatchLogin(email, password))
            .evaluate(function (submit_date) {
                var frame = document.getElementById("ifrmTimesheet").contentWindow;
                frame.SubmitTime(submit_date);
            }, submit_date)
            .wait(2000)
            .end()
            .then(function () {
                resolve();
            })
            .catch(function (err) {
                reject(err);
            })
    })
};

module.exports.log = function (email, password, cost_code, analysis_code, hours, date) {
    return new Promise(function (resolve, reject) {
        var nightmare = Nightmare({typeInterval: 50});
        nightmare
            .use(timewatchLogin(email, password))
            .use(logTime(cost_code, analysis_code, hours, date))
            .end()
            .then(function () {
                resolve()
            })
            .catch(function (err) {
                reject(err)
            })
    })
};
