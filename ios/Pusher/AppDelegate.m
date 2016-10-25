/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTPushNotificationManager.h"
#import "RCTBundleURLProvider.h"
#import "RCTRootView.h"

#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSSNS/AWSSNS.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSURL *jsCodeLocation;

	jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"Pusher"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];

  return YES;
}

// Required to register for notifications
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
	[RCTPushNotificationManager didRegisterUserNotificationSettings:notificationSettings];
}

// Required for the register event.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[self setupAmazonCognito: deviceToken];

	[RCTPushNotificationManager didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// Required for the registrationError event.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	[RCTPushNotificationManager didFailToRegisterForRemoteNotificationsWithError:error];
}
// Required for the notification event.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
{
	[RCTPushNotificationManager didReceiveRemoteNotification:notification];
}
// Required for the localNotification event.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	[RCTPushNotificationManager didReceiveLocalNotification:notification];
}


- (void)setupAmazonCognito:(NSData *)deviceToken {
//	AWSCognitoCredentialsProvider *credentialsProviderz = [[AWSCognitoCredentialsProvider alloc] initWithRegionType: AWSRegionUSWest2
//																																																	 identityPoolId: @"us-west-2:0e988109-ec27-472f-9c8b-1769fae1a804"
//																																																		unauthRoleArn: @"arn:aws:iam::238295105550:role/Cognito_PusherUnauth_Role"
//																																																			authRoleArn: @"arn:aws:iam::238295105550:role/Cognito_PusherAuth_Role"
//																																													identityProviderManager: nil];
//

	AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType: AWSRegionUSWest2
																																																	identityPoolId: @"us-west-2:0e988109-ec27-472f-9c8b-1769fae1a804"];

	AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion: AWSRegionUSWest2
																																			 credentialsProvider: credentialsProvider];

	[AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

	// Retrieve your Amazon Cognito ID
	[[credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask *task) {
		if (task.error) {
			NSLog(@"Error: %@", task.error);
		}
		else {
			// the task result will contain the identity id
			NSString *cognitoId = task.result;
			NSLog(@"CognitoID: %@", cognitoId);
		}
		return nil;
	}];

	NSLog(@"deviceToken: %@", [self deviceTokenAsString: deviceToken]);
}

/* This method converts the device token received from APNS to a string that Amazon SNS Mobile Push can understand (takes out spaces) */
-(NSString*)deviceTokenAsString:(NSData *)deviceTokenData {
	NSString *rawDeviceTring = [NSString stringWithFormat: @"%@", deviceTokenData];
	NSString *noSpaces = [rawDeviceTring stringByReplacingOccurrencesOfString: @" " withString: @""];
	NSString *tmp1 = [noSpaces stringByReplacingOccurrencesOfString: @"<" withString: @""];

	return [tmp1 stringByReplacingOccurrencesOfString: @">" withString: @""];
}

@end
