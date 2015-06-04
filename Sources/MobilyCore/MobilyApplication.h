/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import <MobilyCore/MobilyBuilder.h>

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyApplicationNotificationType) {
    MobilyApplicationNotificationTypeNone = 0,
    MobilyApplicationNotificationTypeBadge = 1 << 0,
    MobilyApplicationNotificationTypeSound = 1 << 1,
    MobilyApplicationNotificationTypeAlert = 1 << 2,
};

/*--------------------------------------------------*/

@interface MobilyApplication : NSObject < MobilyBuilderObject >

@property(nonatomic, readonly, assign) MobilyApplicationNotificationType notificationType;
@property(nonatomic, readonly, strong) NSArray* notificationCategories;
@property(nonatomic, readonly, assign) UIApplicationState state;
@property(nonatomic, readonly, strong) NSData* deviceToken;

- (void)setup NS_REQUIRES_SUPER;

- (BOOL)launchingWithOptions:(NSDictionary*)options;
- (void)terminate;
- (void)receiveMemoryWarning;
- (void)becomeActive;
- (void)resignActive;
- (void)enterForeground;
- (void)enterBackground;
- (void)registerUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings;
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;
- (void)failToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)receiveRemoteNotification:(NSDictionary*)notification;
- (void)receiveLocalNotification:(UILocalNotification*)notification;
- (void)handleActionWithIdentifier:(NSString*)identifier forLocalNotification:(UILocalNotification*)notification completionHandler:(void(^)())completionHandler;
- (void)handleActionWithIdentifier:(NSString*)identifier forRemoteNotification:(NSDictionary*)notification completionHandler:(void(^)())completionHandler;
- (void)handleEventsForBackgroundURLSession:(NSString*)identifier completionHandler:(void(^)())completionHandler;
- (void)handleWatchKitExtensionRequest:(NSDictionary*)userInfo reply:(void(^)(NSDictionary* replyInfo))reply;

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation;

@end

/*--------------------------------------------------*/

@interface MobilyApplicationNotificationCategory : NSObject < MobilyBuilderObject >

@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, strong) NSArray* actions;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

@interface MobilyApplicationNotificationAction : NSObject < MobilyBuilderObject >

@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, strong) NSString* title;
@property(nonatomic, readonly, assign) UIUserNotificationActivationMode activationMode;
@property(nonatomic, readonly, assign, getter=isAuthenticationRequired) BOOL authenticationRequired;
@property(nonatomic, readonly, assign, getter=isDestructive) BOOL destructive;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

@interface NSString (MobilyApplication)

- (MobilyApplicationNotificationType)convertToApplicationNotificationType;
- (MobilyApplicationNotificationType)convertToApplicationNotificationTypeSeparated:(NSString*)separated;

- (UIUserNotificationActivationMode)convertToUserNotificationActivationMode;

@end

/*--------------------------------------------------*/
