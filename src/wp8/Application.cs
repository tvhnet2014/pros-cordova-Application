using System;
using System.Windows;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Info;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;
using Windows.ApplicationModel;
using System.Xml.Linq;

namespace Cordova.Extension.Commands
{
    public class Application : BaseCommand
    {
        public void getDeviceID(string empty)
        {
           byte[] uniqueIDbytes = (byte[])DeviceExtendedProperties.GetValue("DeviceUniqueId");
           string uniqueID = System.Convert.ToBase64String(uniqueIDbytes);

           this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, uniqueID));
        }
    }
}