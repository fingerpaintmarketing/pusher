/*!

 @brief A convenience class for handling interactions with the Amazon SNS service

 @author Bryan O'Malley

 @copyright Copyright (c) 2016 Fingerpaint Marketing. All rights reserved.

 @date 10-25-2016
 
 */

#import <Foundation/Foundation.h>


/*!

 @interface AWSNotificationHandler

 @brief Handle interactions with the Amazon SNS service

 */
@interface AWSNotificationHandler : NSObject

/*!

@brief Handles the Amazon Cognito authorization for the pool

*/
+ (void)authorize;

/*!

 @brief Conver the device token from NSData to an NSString

 @param	deviceToken The apple provided device token for this hardware

 */
+ (NSString *)deviceTokenAsString:(NSData *)deviceTokenData;

/*!

 @brief Save the importent tokens we get as part of the process so we have them later

 @param	deviceToken The apple provided device token for this hardware

 @param	endpointARN The unique identifier for this device on the Amazon SNS system

 */
+ (void)saveDeviceToken:(NSData *)deviceToken andEndpointARN:(NSString *)endpointARN;

/*!

 @brief Subscribe this device to the topic for our app

 @param	deviceToken The apple provided device token for this hardware

 */
+ (void)subscribeDeviceForPushNotifications:(NSData *)deviceToken;

@end
