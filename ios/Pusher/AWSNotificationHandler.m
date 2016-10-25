//
//  AWSNotificationHandler.m
//  Pusher
//
//  Created by Bryan O'Malley on 10/25/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "AWSNotificationHandler.h"

#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSSNS/AWSSNS.h>


#define APP_POOL_ID			@"us-west-2:0e988109-ec27-472f-9c8b-1769fae1a804"
#define APP_ARN 				@"arn:aws:sns:us-west-2:238295105550:app/APNS_SANDBOX/Pusher_Sandbox"
#define APP_TOPIC_ARN		@"arn:aws:sns:us-west-2:238295105550:Pusher"



@implementation AWSNotificationHandler


//*******************************************
+ (void)authorize {
#if DEBUG
	[AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
#endif

	AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType: AWSRegionUSWest2
																																																	identityPoolId: APP_POOL_ID];

	AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion: AWSRegionUSWest2
																																			 credentialsProvider: credentialsProvider];

	[AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

}

//*******************************************
+ (NSString *)deviceTokenAsString:(NSData *)deviceTokenData {
	NSString *rawDeviceTring = [NSString stringWithFormat: @"%@", deviceTokenData];
	NSString *noSpaces = [rawDeviceTring stringByReplacingOccurrencesOfString: @" " withString: @""];
	NSString *tmp1 = [noSpaces stringByReplacingOccurrencesOfString: @"<" withString: @""];

	return [tmp1 stringByReplacingOccurrencesOfString: @">" withString: @""];
}

//*******************************************
+ (void)saveDeviceToken:(NSData *)deviceToken andEndpointARN:(NSString *)endpointARN {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults setObject: [AWSNotificationHandler deviceTokenAsString: deviceToken] forKey: @"deviceToken"];
	[defaults setObject: endpointARN forKey: @"endpointARN"];

	[defaults synchronize];
}

//*******************************************
+ (void)subscribeDeviceForPushNotifications:(NSData *)deviceToken {
#if DEBUG
	NSLog( @"Submit the device token [%@] to SNS to receive notifications.", deviceToken );
#endif

	AWSSNSCreatePlatformEndpointInput *platformEndpointRequest = [AWSSNSCreatePlatformEndpointInput new];
	platformEndpointRequest.customUserData = [[UIDevice currentDevice] name];
	platformEndpointRequest.token = [AWSNotificationHandler deviceTokenAsString: deviceToken];
	platformEndpointRequest.platformApplicationArn = APP_ARN;

	AWSSNS *sns = [AWSSNS defaultSNS];
	[[[sns createPlatformEndpoint: platformEndpointRequest] continueWithSuccessBlock:^id(AWSTask *task) {
		AWSSNSCreateEndpointResponse *response = task.result;

		[AWSNotificationHandler saveDeviceToken: deviceToken andEndpointARN: response.endpointArn];

		AWSSNSSubscribeInput *subscribeRequest = [AWSSNSSubscribeInput new];
		subscribeRequest.endpoint = response.endpointArn;
		subscribeRequest.protocols = @"application";
		subscribeRequest.topicArn = APP_TOPIC_ARN;
		return [sns subscribe:subscribeRequest];
	}] continueWithBlock:^id(AWSTask *task) {
		if (task.cancelled) {
			NSLog(@"AWS SNS Task cancelled!");
		}
		else if (task.error) {
			NSLog(@"%s file: %s line: %d - AWS SNS Error occurred: [%@]", __FUNCTION__, __FILE__, __LINE__, task.error);
		}
		else {
			NSLog(@"AWS SNS Task Success.");
		}

		return nil;
	}];
}

@end
