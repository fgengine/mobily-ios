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

#import "MobilySocialTwitterProvider.h"

/*--------------------------------------------------*/

@interface MobilySocialTwitterProvider ()



@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilySocialTwitterSession ()

@property(nonatomic, readwrite, strong) NSString* authToken;
@property(nonatomic, readwrite, strong) NSString* authTokenSecret;
@property(nonatomic, readwrite, strong) NSString* userId;
@property(nonatomic, readwrite, strong) NSString* userName;
@property(nonatomic, readwrite, strong) NSString* email;

- (id)initWithSession:(TWTRSession*)session;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialTwitterProvider

- (void)signinSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    [[Twitter sharedInstance] startWithConsumerKey:_consumerKey consumerSecret:_consumerSecret];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession* session, NSError* error) {
        if(session != nil) {
            [self setSession:[[MobilySocialTwitterSession alloc] initWithSession:session]];
            if([[self session] isValid] == YES) {
                if(success != nil) {
                    success();
                }
            } else {
                if(failure != nil) {
                    failure(error);
                }
            }
        } else {
            if(failure != nil) {
                failure(error);
            }
        }
    }];
}

- (void)requestEmailSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if([[self session] isValid] == YES) {
        TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
            if(error == nil) {
                [[self session] setEmail:email];
                [[self session] save];
                if(success != nil) {
                    success();
                }
            } else {
                if(failure != nil) {
                    failure(error);
                }
            }
        }];
        [[[[UIApplication sharedApplication] keyWindow] currentViewController] presentViewController:shareEmailViewController animated:YES completion:nil];
    } else {
        if(failure != nil) {
            failure(nil);
        }
    }
}

- (void)logoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if([[self session] isValid] == YES) {
        [[Twitter sharedInstance] logOut];
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
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialTwitterSession

+ (NSArray*)serializeMap {
    return @[
        @"authToken",
        @"authTokenSecret",
        @"userId",
        @"userName",
        @"email"
    ];
}

- (id)initWithSession:(TWTRSession*)session {
    self = [super init];
    if(self != nil) {
        [self setAuthToken:[session authToken]];
        [self setAuthTokenSecret:[session authTokenSecret]];
        [self setUserId:[session userID]];
        [self setUserName:[session userName]];
    }
    return self;
}

- (BOOL)isValid {
    return ([_authToken length] > 0) && ([_authTokenSecret length] > 0) && ([_userId length] > 0);
}

@end

/*--------------------------------------------------*/
