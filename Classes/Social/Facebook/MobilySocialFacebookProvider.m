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

#import "MobilySocialFacebookProvider.h"
#import "MobilyUI.h"

/*--------------------------------------------------*/

@interface MobilySocialFacebookProvider ()

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

- (instancetype)initWithName:(NSString*)name {
    self = [super initWithName:name];
    if(self != nil) {
        [self setAllowLoginUI:YES];
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setSession:(MobilySocialFacebookSession*)session {
    [super setSession:session];
}

- (MobilySocialFacebookSession*)session {
    return [super session];
}

#pragma mark Public

- (void)signinWithReadPermissions:(NSArray*)readPermissions success:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    [FBSession openActiveSessionWithReadPermissions:readPermissions allowLoginUI:_allowLoginUI completionHandler:^(FBSession* session, FBSessionState state, NSError* error) {
        if(error == nil) {
            switch(state) {
                case FBSessionStateOpen:
                case FBSessionStateClosed: {
                    [self setSession:[[MobilySocialFacebookSession alloc] initWithReadPermissions:readPermissions facebookSession:session]];
                    if([[self session] isValid] == YES) {
                        if(success != nil) {
                            success();
                        }
                    } else {
                        if(failure != nil) {
                            failure(error);
                        }
                    }
                    break;
                }
                default:
                    break;
            }
        } else {
            if(failure != nil) {
                failure(error);
            }
        }
    }];
}

#pragma mark MobilySocialManager

+ (Class)sessionClass {
    return [MobilySocialFacebookSession class];
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if([[self session] isValid] == YES) {
        [[FBSession activeSession] closeAndClearTokenInformation];
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

- (void)didBecomeActive {
    [[FBSession activeSession] handleDidBecomeActive];
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return [[FBSession activeSession] handleOpenURL:url];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialFacebookSession

#pragma mark Init / Free

- (instancetype)initWithReadPermissions:(NSArray*)readPermissions facebookSession:(FBSession*)facebookSession {
    self = [super init];
    if(self != nil) {
        [self setReadPermissions:readPermissions];
        [self setAccessToken:[[facebookSession accessTokenData] accessToken]];
        [self setExpirationDate:[[facebookSession accessTokenData] expirationDate]];
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
    return ([_expirationDate compare:[NSDate date]] == NSOrderedDescending);
}

@end

/*--------------------------------------------------*/
