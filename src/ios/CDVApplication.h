#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface CDVApplication : CDVPlugin <MFMessageComposeViewControllerDelegate>
{}
	
- (void)init:(CDVInvokedUrlCommand*)command;

- (void)openSMS:(CDVInvokedUrlCommand*)command;

@end