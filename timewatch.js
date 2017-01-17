var Nightmare = require('nightmare');
require('nightmare-iframe-manager')(Nightmare);

var timewatchLogin = function (username, password) {
    return function (nightmare) {
        nightmare
            .goto('https://www.time-and-space.eu/timeandspace/Login.aspx')
            .type('input[name="LoginNameTxtBox"]', username)
            .type('input[name="PasswordTxtBox"]', password)
            .click('input[name="LoginBtn"]')
            .wait(4000)
    };
};

var logTime = function (costCode, analysisCode, timePerDay) {
    return function (nightmare) {
        nightmare
            .enterIFrame('#ifrmTimesheet')
            .enterIFrame('#frmTimeSheet')
            .click('td[id="Grid1_dom"]')
            .type('input[id="txtsabNewLineJob"]', costCode + '\u000d')
            .type('input[id="txtsabNewLineStage"]', analysisCode + '\u000d')
            .type('input[id="TSNewLine_txtTime1"]', timePerDay + '\u000d')
            .type('input[id="TSNewLine_txtTime2"]', timePerDay + '\u000d')
            .type('input[id="TSNewLine_txtTime3"]', timePerDay + '\u000d')
            .type('input[id="TSNewLine_txtTime4"]', timePerDay + '\u000d')
            .type('input[id="TSNewLine_txtTime5"]', timePerDay + '\u000d')
            .click('input[id="btnSaveNew"]')
            .resetFrame()
    };
};

module.exports.run = function (email, password, costcode, analysiscode, hours) {
    return new Promise(function (resolve, reject) {
        var nightmare = Nightmare();
        var date = '2017/01/17'
        nightmare
            .use(timewatchLogin(email, password))
            .use(logTime(costcode, analysiscode, hours))
            .evaluate(function (date) {
                var frame = document.getElementById("ifrmTimesheet").contentWindow;
                frame.SubmitTime(date);
            }, date)
            .wait(2000)
            .end()
            .then(function (result) {
                resolve();
            })
            .catch(function (err) {
                reject(err);
            });
    });
}
