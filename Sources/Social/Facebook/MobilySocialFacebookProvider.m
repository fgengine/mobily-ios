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

#import <MobilySocialFacebookProvider.h>
#import <MobilyUI.h>

/*--------------------------------------------------*/

#import <FacebookSDK/FacebookSDK.h>

/*--------------------------------------------------*/

@interface MobilySocialFacebookProvider ()

@property(nonatomic, readwrite, strong) NSArray* signinReadPermissions;
@property(nonatomic, readwrite, copy) MobilySocialProviderSuccessBlock signinSuccessBlock;
@property(nonatomic, readwrite, copy) MobilySocialProviderFailureBlock signinFailureBlock;

- (void)sessionStateChanged:(FBSession*)session state:(FBSessionState) state error:(NSError*)error;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilySocialFacebookSession ()

@property(nonatomic, readwrite, strong) NSArray* readPermissions;
@property(nonatomic, readwrite, strong) NSString* accessToken;
@property(nonatomic, readwrite, strong) NSDate* expirationDate;

- (instancetype)initWithReadPermissions:(NSArray*)readPermissions facebookSession:(FBSession*)facebookSession;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialFacebookProvider

#pragma mark Init / Free

- (instancetype)init {
    return [self initWithName:@"Facebook"];
}

- (void)setup {
    [super setup];
    
    _allowLoginUI = YES;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setSession:(MobilySocialFacebookSession*)session {
    super.session = session;
}

- (MobilySocialFacebookSession*)session {
    return super.session;
}

#pragma mark Public

- (void)signinWithReadPermissions:(NSArray*)readPermissions success:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if((FBSession.activeSession.state == FBSessionStateOpen) || (FBSession.activeSession.state == FBSessionStateOpenTokenExtended)) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    self.signinReadPermissions = readPermissions;
    self.signinSuccessBlock = success;
    self.signinFailureBlock = failure;
    FBSession.activeSession = [[FBSession alloc] initWithPermissions:_signinReadPermissions];
    [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession* session, FBSessionState state, NSError* error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

#pragma mark MobilySocialManager

+ (Class)sessionClass {
    return MobilySocialFacebookSession.class;
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if(self.session.isValid == YES) {
        [FBSession.activeSession closeAndClearTokenInformation];
        if(success != nil) {
            success();
        }
    } else {
        if(failure != nil) {
            failure(nil);
        }
    }
}

- (void)didBecomeActive {
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString* __unused)sourceApplication annotation:(id __unused)annotation {
    [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark Private

- (void)sessionStateChanged:(FBSession*)session state:(FBSessionState) state error:(NSError*)error {
    if((error == nil) && (state == FBSessionStateOpen)) {
        self.session = [[MobilySocialFacebookSession alloc] initWithReadPermissions:_signinReadPermissions facebookSession:session];
        if(_signinSuccessBlock != nil) {
            _signinSuccessBlock();
        }
        self.signinReadPermissions = nil;
        self.signinSuccessBlock = nil;
        self.signinFailureBlock = nil;
    } else if((error != nil) || (state == FBSessionStateClosed) || (state == FBSessionStateClosedLoginFailed)) {
        self.session = nil;
        if(_signinFailureBlock != nil) {
            _signinFailureBlock(error);
        }
        self.signinSuccessBlock = nil;
        self.signinFailureBlock = nil;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialFacebookSession

#pragma mark Synthesize

@synthesize readPermissions = _readPermissions;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;

#pragma mark Init / Free

- (instancetype)initWithReadPermissions:(NSArray*)readPermissions facebookSession:(FBSession*)facebookSession {
    self = [super init];
    if(self != nil) {
        _readPermissions = readPermissions;
        _accessToken = facebookSession.accessTokenData.accessToken;
        _expirationDate = facebookSession.accessTokenData.expirationDate;
    }
    return self;
}

#pragma mark MobilyModel

+ (NSArray*)serializeMap {
    return @[
        @"readPermissions",
        @"accessToken",
        @"expirationDate"
    ];
}

#pragma mark MobilySocialSession

- (BOOL)isValid {
    return ([_expirationDate compare:NSDate.date] == NSOrderedDescending);
}

@end

/*--------------------------------------------------*/
