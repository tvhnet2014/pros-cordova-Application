var exec = require('cordova/exec');

module.exports = {

    getDeviceID: function (success, fail) {
        exec(
            success,
            fail,
            'Application', 'getDeviceID', []);
    }

};