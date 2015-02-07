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

- (id)initWithAccessToken:(VKAccessToken*)accessToken;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialVKontakteProvider

#pragma mark Init / Free

- (id)initWithApplicationId:(NSString*)applicationId {
    self = [super initWithName:@"VKontakte"];
    if(self != nil) {
        [self setApplicationId:applicationId];
    }
    return self;
}

- (void)dealloc {
    [self setApplicationId:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setApplicationId:(NSString*)applicationId {
    if([_applicationId isEqualToString:applicationId] == NO) {
        MOBILY_SAFE_SETTER(_applicationId, applicationId);
        if(_applicationId != nil) {
            [VKSdk initializeWithDelegate:self andAppId:_applicationId];
        }
    }
}

- (void)setSession:(MobilySocialVKontakteSession*)session {
    [super setSession:session];
}

- (MobilySocialVKontakteSession*)session {
    return [super session];
}

#pragma mark Public

+ (Class)sessionClass {
    return [MobilySocialVKontakteSession class];
}

- (void)signinWithPermissions:(NSArray*)permissions success:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    [self setPermissions:permissions];
    [self setSuccessBlock:success];
    [self setFailureBlock:failure];
    
    if([VKSdk wakeUpSession] == NO) {
        [VKSdk authorize:permissions revokeAccess:YES forceOAuth:YES];
    }
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if([[self session] isValid] == YES) {
        [VKSdk forceLogout];
        [self setSession:nil];
        if(success != nil) {
            success();
        }
    } else {
        if(failure != nil) {
            failure(nil);
        }
    }
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return [VKSdk processOpenURL:url fromApplication:sourceApplication];
}

#pragma mark VKSdkDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError*)captchaError {
    [self vkSdkShouldPresentViewController:[VKCaptchaViewController captchaControllerWithError:captchaError]];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken*)expiredToken {
    if(_failureBlock != nil) {
        _failureBlock(nil);
    }
}

- (void)vkSdkUserDeniedAccess:(VKError*)authorizationError {
    if(_failureBlock != nil) {
        _failureBlock([authorizationError httpError]);
    }
}

- (void)vkSdkShouldPresentViewController:(UIViewController*)controller {
    [[[[UIApplication sharedApplication] keyWindow] currentViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken*)accessToken {
    if(accessToken != nil) {
        [self setSession:[[MobilySocialVKontakteSession alloc] initWithAccessToken:accessToken]];
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

+ (NSArray*)serializeMap {
    return @[
        @"permissions",
        @"accessToken",
        @"expirationDate",
        @"userId",
        @"email"
    ];
}

- (id)initWithAccessToken:(VKAccessToken*)accessToken {
    self = [super init];
    if(self != nil) {
        [self setPermissions:[accessToken permissions]];
        [self setAccessToken:[accessToken accessToken]];
        [self setExpirationDate:[NSDate dateWithTimeIntervalSince1970:[accessToken created] + [[accessToken expiresIn] intValue]]];
        [self setUserId:[accessToken userId]];
        [self setEmail:[accessToken email]];
    }
    return self;
}

- (BOOL)isValid {
    return ([_expirationDate compare:[NSDate date]] == NSOrderedDescending);
}

@end

/*--------------------------------------------------*/
