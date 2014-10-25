var exec = require('cordova/exec');

module.exports = {

    getDeviceID: function (success, fail) {
        exec(
            success,
            fail,
            'Application', 'getDeviceID', []);
    },

    getVersion: function (success, fail) {
        exec(
            success,
            fail,
            'Application', 'getVersion', []);
    },

    openSMS: function (phone, message, success, fail) {
        exec(
            success,
            fail,
            'Application', 'openSMS', [phone, message]);
    }

};