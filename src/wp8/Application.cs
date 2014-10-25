using System;
using System.Windows;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Info;
using Microsoft.Phone.Tasks;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;
using Windows.ApplicationModel;
using System.Xml.Linq;

namespace Cordova.Extension.Commands
{
    public class Application : BaseCommand
    {
		public void getDeviceID(string options)
        {
           byte[] uniqueIDbytes = (byte[])DeviceExtendedProperties.GetValue("DeviceUniqueId");
           string uniqueID = System.Convert.ToBase64String(uniqueIDbytes);

           this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, uniqueID));
        }

		public void getVersion(string options)
		{
			string version = "unknown";
			XElement manifestAppElement = XDocument.Load("WMAppManifest.xml").Root.Element("App");

			if (manifestAppElement != null && manifestAppElement.Attribute("Version") != null)
			{
				version = manifestAppElement.Attribute("Version").Value;
			}

			this.DispatchCommandResult(new PluginResult(PluginResult.Status.OK, version));
		}

		public void openSMS(string options)
		{
			string[] optValues = JsonHelper.Deserialize<string[]>(options);
			String number = optValues[0];
			String message = optValues[1];

			SmsComposeTask task = new SmsComposeTask();
			task.Body = message;
			task.To = number;
			task.Show();
		}
    }
}