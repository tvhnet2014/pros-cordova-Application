var exec = require('cordova/exec');

module.exports = {

    getDeviceID: function (success, fail) {
        exec(
            success,
            fail,
            'Application', 'getDeviceID', []);
    },

    openSMS: function (phone, message, success, fail) {
        exec(
            success,
            fail,
            'Application', 'openSMS', [phone, message]);
    }

};