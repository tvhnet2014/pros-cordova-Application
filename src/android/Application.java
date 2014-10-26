package pros.cordova.application;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.Intent;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaInterface;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.provider.Settings;

public class Application extends CordovaPlugin
{
	public static final String	TAG	= "Application";

	private static String		deviceID;
	private static String		appVersion;

	/**
	 * Constructor.
	 */
	public Application()
	{
	}

	/**
	 * Sets the context of the Command. This can then be used to do things like
	 * get file paths associated with the Activity.
	 * 
	 * @param cordova
	 *            The context of the main Activity.
	 * @param webView
	 *            The CordovaWebView Cordova is running in.
	 */
	public void initialize(CordovaInterface cordova, CordovaWebView webView)
	{
		super.initialize(cordova, webView);

		Application.deviceID = getDeviceID();
		Application.appVersion = getAppVersion();
	}

	/**
	 * Executes the request and returns PluginResult.
	 * 
	 * @param action
	 *            The action to execute.
	 * @param args
	 *            JSONArry of arguments for the plugin.
	 * @param callbackContext
	 *            The callback id used when calling back into JavaScript.
	 * @return True if the action was valid, false if not.
	 */
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException
	{
		if (action.equals("init"))
		{
			JSONObject r = new JSONObject();
			r.put("deviceID", Application.deviceID);
			r.put("appVersion", Application.appVersion);
			callbackContext.success(r);
			return true;
		}
		else if (action.equals("openSMS"))
		{
			try
			{
				String phoneNumber = args.getJSONArray(0).join(";").replace("\"", "");
				String message = args.getString(1);

				// check support
				if (!(this.cordova.getActivity().getPackageManager().hasSystemFeature(PackageManager.FEATURE_TELEPHONY)))
				{
					callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "SMS not supported on this platform"));
					return true;
				}

				Intent sendIntent = new Intent(Intent.ACTION_VIEW);
				sendIntent.putExtra("sms_body", message);
				sendIntent.putExtra("address", phoneNumber);
				sendIntent.setData(Uri.parse("smsto:" + phoneNumber));
				this.cordova.getActivity().startActivity(sendIntent);

				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.NO_RESULT));

				return true;
			}
			catch (JSONException ex)
			{
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
			}
		}
		else
		{
			return false;
		}
		return true;
	}

	/**
	 * Get the device's Universally Unique Identifier (UUID).
	 * 
	 * @return
	 */
	private String getDeviceID()
	{
		return Settings.Secure.getString(this.cordova.getActivity().getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
	}

	/**
	 * Get the App version.
	 * 
	 * @return
	 */
	private String getAppVersion()
	{
		PackageInfo pInfo = null;
		Activity act = this.cordova.getActivity();

		try
		{
			pInfo = act.getPackageManager().getPackageInfo(act.getPackageName(), 0);
		}
		catch (PackageManager.NameNotFoundException e)
		{
		}

		String bundleVersion = "0";
		if (pInfo != null)
		{
			bundleVersion = pInfo.versionName;
		}

		return bundleVersion;
	}
}
