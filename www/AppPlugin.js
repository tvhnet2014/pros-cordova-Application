var channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

channel.createSticky('onCordovaApplicationInfoReady');
// Tell cordova channel to wait on the onCordovaApplicationInfoReady event
channel.waitForInitialization('onCordovaApplicationInfoReady');

/**
 * @constructor
 */
function Application() {
    this.available = false;
    this.appVersion = null;
    this.deviceID = null;

    var me = this;

    channel.onCordovaReady.subscribe(function () {
        me.init(function (info) {
            me.available = true;
            me.appVersion = info.appVersion;
            me.deviceID = info.deviceID;
            channel.onCordovaApplicationInfoReady.fire();
        }, function (e) {
            me.available = false;
            utils.alert("[ERROR] Error initializing Application plugin: " + e);
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


/**
 * openFacebookPage
 *
 * @param {String} facebookPageID
 */
Application.prototype.openFacebookPage = function (facebookPageID, successCallback, errorCallback) {
    exec(
        successCallback,
        errorCallback,
        'Application', 'openFacebookPage', [facebookPageID]);
};

module.exports = new Application();