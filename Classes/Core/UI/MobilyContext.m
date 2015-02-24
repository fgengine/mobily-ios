/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
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

#import "MobilyContext.h"

/*--------------------------------------------------*/

#define MOBILY_FILE_PRESETS                         @"Presets"
#define MOBILY_FILE_APPLICATION                     @"Application"

/*--------------------------------------------------*/

@interface MobilyContext () < UIApplicationDelegate >

@property(nonatomic, readwrite, strong) MobilyApplication* application;

- (BOOL)loadWithOptions:(NSDictionary*)options;
- (void)unload;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static MobilyApplication* MOBILY_APPLICATION = nil;
static int MOBILY_YARG_COUNT = 0;
static char** MOBILY_YARG_VALUE = nil;
static NSString* MOBILY_ACCESS_KEY = nil;

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyContext

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
    self.application = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
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

- (void)setApplication:(MobilyApplication*)application {
    if(_application != application) {
        _application = application;
        MOBILY_APPLICATION = _application;
    }
}

#pragma mark Public

+ (void)setArgCount:(int)argCount argValue:(char**)argValue {
    MOBILY_YARG_COUNT = argCount;
    MOBILY_YARG_VALUE = argValue;
}

+ (void)setAccessKey:(NSString*)accessKey {
    MOBILY_ACCESS_KEY = accessKey;
}

+ (int)run {
    return UIApplicationMain(MOBILY_YARG_COUNT, MOBILY_YARG_VALUE, nil, NSStringFromClass(MobilyContext.class));
}

+ (id)application {
    return MOBILY_APPLICATION;
}

+ (BOOL)loadWithOptions:(NSDictionary*)options {
    id appDelegate = [UIApplication.sharedApplication delegate];
    if([appDelegate isKindOfClass:MobilyContext.class] == YES) {
        return [(MobilyContext*)appDelegate loadWithOptions:options];
    }
    return NO;
}

+ (void)unload {
    id appDelegate = [UIApplication.sharedApplication delegate];
    if([appDelegate isKindOfClass:MobilyContext.class] == YES) {
        [(MobilyContext*)appDelegate unload];
    }
}

#pragma mark Private

- (BOOL)loadWithOptions:(NSDictionary*)options {
    [MobilyBuilderPreset loadFromFilename:MOBILY_FILE_PRESETS];
    
    id mobilyApplication = [MobilyBuilderForm objectFromFilename:MOBILY_FILE_APPLICATION owner:self];
    if([mobilyApplication isKindOfClass:MobilyApplication.class] == YES) {
        self.application = mobilyApplication;
        if(_application != nil) {
            [_application launchingWithOptions:options];
        }
    } else {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"Failure loading '%@'", MOBILY_FILE_APPLICATION);
#endif
    }
    return (_application != nil);
}

- (void)unload {
    if(_application != nil) {
        [_application terminate];
        self.application = nil;
    }
}

#pragma mark UIApplicationDelegate

- (void)setWindow:(UIWindow*)window {
    [window makeKeyWindow];
}

- (UIWindow*)window {
    return UIApplication.sharedApplication.keyWindow;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options {
    return [self loadWithOptions:options];
}

- (void)applicationWillTerminate:(UIApplication*)application {
    [self unload];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
    [_application receiveMemoryWarning];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
    [_application becomeActive];
}

- (void)applicationWillResignActive:(UIApplication*)application {
    [_application resignActive];
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
    [_application enterForeground];
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    [_application enterBackground];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [_application registerForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [_application failToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)notification {
    [_application receiveRemoteNotification:notification];
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    [_application receiveLocalNotification:notification];
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return [_application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end

/*--------------------------------------------------*/
