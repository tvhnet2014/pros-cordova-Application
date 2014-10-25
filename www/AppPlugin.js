var appChannel = require('cordova/channel'),
    appUtils = require('cordova/utils'),
    exec = require('cordova/exec');

appChannel.createSticky('onCordovaInfoReady');
// Tell cordova channel to wait on the CordovaInfoReady event
appChannel.waitForInitialization('onCordovaInfoReady');

/**
 * @constructor
 */
function Application() {
    this.available = false;
    this.appVersion = null;
    this.deviceID = null;

    var me = this;

    appChannel.onCordovaReady.subscribe(function () {
        me.init(function (info) {
            me.available = true;
            me.appVersion = info.appVersion;
            me.deviceID = info.deviceID;
            appChannel.onCordovaInfoReady.fire();
        }, function (e) {
            me.available = false;
            appUtils.alert("[ERROR] Error initializing Application plugin: " + e);
        });
    });
}

/**
 * init
 *
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Application.prototype.init = function (successCallback, errorCallback) {
    exec(
        successCallback,
        errorCallback,
        "Application", "init", []);
};

/**
 * openSMS
 *
 * @param {String} phone Phone number
 * @param {String} message Body text
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Application.prototype.openSMS = function (phone, message, successCallback, errorCallback) {
    exec(
        successCallback,
        errorCallback,
        'Application', 'openSMS', [phone, message]);
};

module.exports = new Application();