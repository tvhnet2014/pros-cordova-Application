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
using Windows.System;

namespace Cordova.Extension.Commands
{
	public class Application : BaseCommand
	{
		public void init(string notUsed)
		{
			string res = String.Format("\"deviceID\":\"{0}\",\"appVersion\":\"{1}\"",
										this.deviceID,
										this.appVersion);

			res = "{" + res + "}";
			//Debug.WriteLine("Result::" + res);
			DispatchCommandResult(new PluginResult(PluginResult.Status.OK, res));
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

		public void openFacebookPage(string options)
		{
			string[] optValues = JsonHelper.Deserialize<string[]>(options);
			String facebookPageID = optValues[0];

			Launcher.LaunchUriAsync(new Uri("fb:pages?id=" + facebookPageID));
		}

		private string deviceID
		{
			get
			{
				byte[] uniqueIDbytes = (byte[])DeviceExtendedProperties.GetValue("DeviceUniqueId");
				return System.Convert.ToBase64String(uniqueIDbytes);
			}
		}

		private string appVersion
		{
			get
			{
				string version = "unknown";
				XElement manifestAppElement = XDocument.Load("WMAppManifest.xml").Root.Element("App");

				if (manifestAppElement != null && manifestAppElement.Attribute("Version") != null)
				{
					version = manifestAppElement.Attribute("Version").Value;
				}

				return version;
			}
		}
	}
}