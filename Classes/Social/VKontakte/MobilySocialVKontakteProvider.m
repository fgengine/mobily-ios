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

#import "MobilySocialVKontakteProvider.h"
#import "MobilyUI.h"

/*--------------------------------------------------*/

@interface MobilySocialVKontakteProvider () < VKSdkDelegate >

@property(nonatomic, readwrite, strong) NSArray* permissions;
@property(nonatomic, readwrite, copy) MobilySocialProviderSuccessBlock successBlock;
@property(nonatomic, readwrite, copy) MobilySocialProviderFailureBlock failureBlock;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilySocialVKontakteSession ()

@property(nonatomic, readwrite, strong) NSArray* permissions;
@property(nonatomic, readwrite, strong) NSString* accessToken;
@property(nonatomic, readwrite, strong) NSDate* expirationDate;
@property(nonatomic, readwrite, strong) NSString* userId;
@property(nonatomic, readwrite, strong) NSString* email;

- (instancetype)initWithAccessToken:(VKAccessToken*)accessToken;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialVKontakteProvider

#pragma mark Init / Free

- (instancetype)initWithApplicationId:(NSString*)applicationId {
    self = [super initWithName:@"VKontakte"];
    if(self != nil) {
        self.applicationId = applicationId;
    }
    return self;
}

- (void)dealloc {
    self.applicationId = nil;
}

#pragma mark Property

- (void)setApplicationId:(NSString*)applicationId {
    if([_applicationId isEqualToString:applicationId] == NO) {
        _applicationId = applicationId;
        if(_applicationId != nil) {
            [VKSdk initializeWithDelegate:self andAppId:_applicationId];
        }
    }
}

- (void)setSession:(MobilySocialVKontakteSession*)session {
    super.session = session;
}

- (MobilySocialVKontakteSession*)session {
    return super.session;
}

#pragma mark Public

- (void)signinWithPermissions:(NSArray*)permissions success:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    self.permissions = permissions;
    self.successBlock = success;
    self.failureBlock = failure;
    
    if([VKSdk wakeUpSession] == NO) {
        [VKSdk authorize:permissions revokeAccess:YES forceOAuth:YES];
    } else if(self.session != nil) {
        self.session = [[MobilySocialVKontakteSession alloc] initWithAccessToken:[VKSdk getAccessToken]];
        if(_successBlock != nil) {
            _successBlock();
        }
    } else {
        if(_successBlock != nil) {
            _successBlock();
        }
    }
}

#pragma mark MobilySocialManager

+ (Class)sessionClass {
    return MobilySocialVKontakteSession.class;
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if(self.session.isValid == YES) {
        [VKSdk forceLogout];
        self.session = nil;
        if(success != nil) {
            success();
        }
    } else {
        if(failure != nil) {
            failure(nil);
        }
    }
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id __unused)annotation {
    return [VKSdk processOpenURL:url fromApplication:sourceApplication];
}

#pragma mark VKSdkDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError*)captchaError {
    [self vkSdkShouldPresentViewController:[VKCaptchaViewController captchaControllerWithError:captchaError]];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken* __unused)expiredToken {
    if(_failureBlock != nil) {
        _failureBlock(nil);
    }
}

- (void)vkSdkUserDeniedAccess:(VKError*)authorizationError {
    if(_failureBlock != nil) {
        _failureBlock(authorizationError.httpError);
    }
}

- (void)vkSdkShouldPresentViewController:(UIViewController*)controller {
    [[UIApplication.sharedApplication.keyWindow currentViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken*)accessToken {
    if(accessToken != nil) {
        self.session = [[MobilySocialVKontakteSession alloc] initWithAccessToken:accessToken];
        if(_successBlock != nil) {
            _successBlock();
        }
    } else {
        if(_failureBlock != nil) {
            _failureBlock(nil);
        }
    }
}

- (BOOL)vkSdkAuthorizationAllowFallbackToSafari {
    return NO;
}

- (BOOL)vkSdkIsBasicAuthorization {
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialVKontakteSession

#pragma mark Synthesize

@synthesize permissions = _permissions;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize userId = _userId;
@synthesize email = _email;

#pragma mark Init / Free

- (instancetype)initWithAccessToken:(VKAccessToken*)accessToken {
    self = [super init];
    if(self != nil) {
        _permissions = accessToken.permissions;
        _accessToken = accessToken.accessToken;
        if(accessToken.expiresIn.intValue > 0) {
            _expirationDate = [NSDate dateWithTimeIntervalSince1970:accessToken.created + accessToken.expiresIn.intValue];
        } else {
            _expirationDate = [NSDate dateWithTimeIntervalSince1970:accessToken.created + MOBILY_YEAR];
        }
        _userId = accessToken.userId;
        _email = accessToken.email;
    }
    return self;
}

#pragma mark MobilyModel

+ (NSArray*)serializeMap {
    return @[
        @"permissions",
        @"accessToken",
        @"expirationDate",
        @"userId",
        @"email"
    ];
}

#pragma mark MobilySocialSession

- (BOOL)isValid {
    return ([_expirationDate compare:[NSDate date]] == NSOrderedDescending);
}

@end

/*--------------------------------------------------*/
