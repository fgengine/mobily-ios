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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyCore/MobilyApplication.h>
#import <MobilyCore/MobilyWindow.h>
#import <MobilyCore/MobilyEvent.h>

/*--------------------------------------------------*/

@interface MobilyApplication ()

@property(nonatomic, readwrite, assign) MobilyApplicationNotificationType notificationType;
@property(nonatomic, readwrite, strong) NSArray* notificationCategories;
@property(nonatomic, readwrite, strong) NSData* deviceToken;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyApplicationNotificationCategory ()

@property(nonatomic, readwrite, strong) NSString* identifier;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyApplicationNotificationAction ()

@property(nonatomic, readwrite, strong) NSString* identifier;
@property(nonatomic, readwrite, strong) NSString* title;
@property(nonatomic, readwrite, assign) UIUserNotificationActivationMode activationMode;
@property(nonatomic, readwrite, assign, getter=isAuthenticationRequired) BOOL authenticationRequired;
@property(nonatomic, readwrite, assign, getter=isDestructive) BOOL destructive;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApplication

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING_BASED(NotificationType, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToApplicationNotificationType]])

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:MobilyApplicationNotificationCategory.class] == YES) {
        self.notificationCategories = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    } else if([objectChild isKindOfClass:UIWindow.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIWindow.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Public

- (BOOL)launchingWithOptions:(NSDictionary* __unused)options {
    MobilyWindow* window = nil;
    if(_notificationType != UIRemoteNotificationTypeNone) {
        if([UIDevice systemVersion] >= 8.0f) {
            UIUserNotificationType notificationType = UIUserNotificationTypeNone;
            if((_notificationType & MobilyApplicationNotificationTypeBadge) != 0) {
                notificationType |= UIUserNotificationTypeBadge;
            }
            if((_notificationType & MobilyApplicationNotificationTypeSound) != 0) {
                notificationType |= UIUserNotificationTypeSound;
            }
            if((_notificationType & MobilyApplicationNotificationTypeAlert) != 0) {
                notificationType |= UIUserNotificationTypeAlert;
            }
            NSMutableSet* categories = [NSMutableSet set];
            for(MobilyApplicationNotificationCategory* category in _notificationCategories) {
                UIMutableUserNotificationCategory* actionCategory = [[UIMutableUserNotificationCategory alloc] init];
                actionCategory.identifier = category.identifier;
                if(category.actions.count > 0) {
                    NSMutableArray* actions = [NSMutableArray array];
                    for(MobilyApplicationNotificationAction* categoryAction in category.actions) {
                        UIMutableUserNotificationAction* action = [[UIMutableUserNotificationAction alloc] init];
                        action.identifier = categoryAction.identifier;
                        action.title = categoryAction.title;
                        action.activationMode = categoryAction.activationMode;
                        action.destructive = categoryAction.destructive;
                        action.authenticationRequired = categoryAction.authenticationRequired;
                        [actions addObject:action];
                    }
                    [actionCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
                }
                [categories addObject:actionCategory];
            }
            UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
            [UIApplication.sharedApplication registerUserNotificationSettings:settings];
        } else {
            UIRemoteNotificationType notificationType = UIRemoteNotificationTypeNone;
            if((_notificationType & MobilyApplicationNotificationTypeBadge) != 0) {
                notificationType |= UIRemoteNotificationTypeBadge;
            }
            if((_notificationType & MobilyApplicationNotificationTypeSound) != 0) {
                notificationType |= UIRemoteNotificationTypeSound;
            }
            if((_notificationType & MobilyApplicationNotificationTypeAlert) != 0) {
                notificationType |= UIRemoteNotificationTypeAlert;
            }
            [UIApplication.sharedApplication registerForRemoteNotificationTypes:notificationType];
        }
    }
    if(_objectChilds.count < 1) {
        window = [MobilyWindow new];
        if(window != nil) {
            window.objectParent = self;
        }
    } else {
        window = [_objectChilds firstObjectIsClass:UIWindow.class];
    }
    if(window != nil) {
        [window makeKeyAndVisible];
    }
    return (window != nil);
}

- (void)terminate {
}

- (void)receiveMemoryWarning {
}

- (void)becomeActive {
}

- (void)resignActive {
}

- (void)enterForeground {
}

- (void)enterBackground {
}

- (void)registerUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings {
}

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    self.deviceToken = deviceToken;
}

- (void)failToRegisterForRemoteNotificationsWithError:(NSError* __unused)error {
}

- (void)receiveRemoteNotification:(NSDictionary* __unused)notification {
}

- (void)receiveLocalNotification:(UILocalNotification* __unused)notification {
}

- (void)handleActionWithIdentifier:(NSString* __unused)identifier forLocalNotification:(UILocalNotification* __unused)notification completionHandler:(void(^)())completionHandler {
    completionHandler();
}

- (void)handleActionWithIdentifier:(NSString* __unused)identifier forRemoteNotification:(NSDictionary* __unused)notification completionHandler:(void(^)())completionHandler {
    completionHandler();
}

- (void)handleEventsForBackgroundURLSession:(NSString*)identifier completionHandler:(void(^)())completionHandler {
}

- (void)handleWatchKitExtensionRequest:(NSDictionary*)userInfo reply:(void(^)(NSDictionary* replyInfo))reply {
}

- (BOOL)openURL:(NSURL* __unused)url sourceApplication:(NSString* __unused)sourceApplication annotation:(id __unused)annotation {
    return NO;
}

#pragma mark Property

- (UIApplicationState)state {
    return UIApplication.sharedApplication.applicationState;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApplicationNotificationCategory

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING(Identifier)

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:MobilyApplicationNotificationAction.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:MobilyApplicationNotificationAction.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Property

- (NSArray*)actions {
    return _objectChilds;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApplicationNotificationAction

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING(Identifier)
MOBILY_DEFINE_VALIDATE_STRING(Title)
MOBILY_DEFINE_VALIDATE_STRING_BASED(ActivationMode, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToUserNotificationActivationMode]])
MOBILY_DEFINE_VALIDATE_BOOL(AuthenticationRequired)
MOBILY_DEFINE_VALIDATE_BOOL(Destructive)

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyApplication)

- (MobilyApplicationNotificationType)convertToApplicationNotificationType {
    return [self convertToApplicationNotificationTypeSeparated:@"|"];
}

- (MobilyApplicationNotificationType)convertToApplicationNotificationTypeSeparated:(NSString*)separated {
    MobilyApplicationNotificationType result = MobilyApplicationNotificationTypeNone;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = MobilyApplicationNotificationTypeBadge | MobilyApplicationNotificationTypeSound | MobilyApplicationNotificationTypeAlert;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        for(NSString* key in keys) {
            NSString* temp = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([temp isEqualToString:@"badge"] == YES) {
                result |= MobilyApplicationNotificationTypeBadge;
            } else if([temp isEqualToString:@"sound"] == YES) {
                result |= MobilyApplicationNotificationTypeSound;
            } else if([temp isEqualToString:@"alert"] == YES) {
                result |= MobilyApplicationNotificationTypeAlert;
            }
        }
    }
    return result;
}


- (UIUserNotificationActivationMode)convertToUserNotificationActivationMode {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"background"] == YES) {
        return UIUserNotificationActivationModeBackground;
    }
    return UIUserNotificationActivationModeForeground;
}

@end

/*--------------------------------------------------*/
