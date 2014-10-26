#import "CDVApplication.h"
#import <Cordova/NSArray+Comparisons.h>

#include <sys/types.h>
#include <sys/sysctl.h>

#import <Cordova/CDV.h>
#import "UICKeyChainStore.h"

@interface CDVApplication () {}
@end

@implementation CDVApplication

- (void)init:(CDVInvokedUrlCommand*)command
{
    NSDictionary* deviceProperties = [self deviceProperties];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:deviceProperties];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary*)deviceProperties
{
	// appVersion
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [infoDict objectForKey:@"CFBundleVersion"];

	// deviceID
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuidUserDefaults = [defaults objectForKey:@"uuid"];
        
    NSString *uuid = [UICKeyChainStore stringForKey:@"uuid"];

    if ( uuid && !uuidUserDefaults) {
        [defaults setObject:uuid forKey:@"uuid"];
        [defaults synchronize];
            
    }  else if ( !uuid && !uuidUserDefaults ) {
        NSString *uuidString = [[NSUUID UUID] UUIDString];
            
        [UICKeyChainStore setString:uuidString forKey:@"uuid"];
            
        [defaults setObject:uuidString forKey:@"uuid"];
        [defaults synchronize];
            
        uuid = [UICKeyChainStore stringForKey:@"uuid"];
            
    } else if ( ![uuid isEqualToString:uuidUserDefaults] ) {
        [UICKeyChainStore setString:uuidUserDefaults forKey:@"uuid"];
        uuid = [UICKeyChainStore stringForKey:@"uuid"];
    }

    NSMutableDictionary* devProps = [NSMutableDictionary dictionaryWithCapacity:1];

    [devProps setObject:[uuid] forKey:@"deviceID"];
    [devProps setObject:[ver] forKey:@"appVersion"];

    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView {
	self = (CDVApplication *)[super initWithWebView:theWebView];
	return self;
}

- (void)openSMS:(CDVInvokedUrlCommand*)command {
	
	// MFMessageComposeViewController has been availible since iOS 4.0. There should be no issue with using it straight.
	if(![MFMessageComposeViewController canSendText]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
														message:@"SMS Text not available."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
		
	MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] init];
	composeViewController.messageComposeDelegate = self;

	NSString* body = [command.arguments objectAtIndex:1];
	if (body != nil) {
		[composeViewController setBody:body];
	}

	NSArray* recipients = [command.arguments objectAtIndex:0];
	if (recipients != nil) {
		[composeViewController setRecipients:recipients];
	}

	[self.viewController presentViewController:composeViewController animated:YES completion:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - MFMessageComposeViewControllerDelegate Implementation
// Dismisses the composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	// Notifies users about errors associated with the interface
	int webviewResult = 0;

	switch (result) {
		case MessageComposeResultCancelled:
			webviewResult = 0;
			break;

		case MessageComposeResultSent:
			webviewResult = 1;
			break;

		case MessageComposeResultFailed:
			webviewResult = 2;
			break;

		default:
			webviewResult = 3;
			break;
	}

	[self.viewController dismissViewControllerAnimated:YES completion:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];	// Note: I put this in because it seemed to be missing.
	
	[self writeJavascript:[NSString stringWithFormat:@"window.plugins.Application._didFinishWithResult(%d);", webviewResult]];
}

@end

