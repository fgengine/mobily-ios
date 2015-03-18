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

#import "MobilySocialTwitterProvider.h"
#import "MobilyUI.h"

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

- (instancetype)initWithSession:(TWTRSession*)session;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialTwitterProvider

#pragma mark Init / Free

- (instancetype)initWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret {
    self = [super initWithName:@"Twitter"];
    if(self != nil) {
        self.consumerKey = consumerKey;
        self.consumerSecret = consumerSecret;
    }
    return self;
}

- (void)dealloc {
    self.consumerKey = nil;
    self.consumerSecret = nil;
}

#pragma mark Property

- (void)setSession:(MobilySocialTwitterSession*)session {
    super.session = session;
}

- (MobilySocialTwitterSession*)session {
    return super.session;
}

#pragma mark Public

- (void)signinSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    [Twitter.sharedInstance startWithConsumerKey:_consumerKey consumerSecret:_consumerSecret];
    [Twitter.sharedInstance logInWithCompletion:^(TWTRSession* session, NSError* error) {
        if(session != nil) {
            self.session = [[MobilySocialTwitterSession alloc] initWithSession:session];
            if(self.session.isValid == YES) {
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
    if(self.session.isValid == YES) {
        TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
            if(error == nil) {
                self.session.email = email;
                [self.session save];
                if(success != nil) {
                    success();
                }
            } else {
                if(failure != nil) {
                    failure(error);
                }
            }
        }];
        [[UIApplication.sharedApplication.keyWindow currentViewController] presentViewController:shareEmailViewController animated:YES completion:nil];
    } else {
        if(failure != nil) {
            failure(nil);
        }
    }
}

#pragma mark MobilySocialManager

+ (Class)sessionClass {
    return MobilySocialTwitterSession.class;
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    if(self.session.isValid == YES) {
        [Twitter.sharedInstance logOut];
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

- (BOOL)openURL:(NSURL* __unused)url sourceApplication:(NSString* __unused)sourceApplication annotation:(id __unused)annotation {
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialTwitterSession

#pragma mark Init / Free

- (instancetype)initWithSession:(TWTRSession*)session {
    self = [super init];
    if(self != nil) {
        self.authToken = session.authToken;
        self.authTokenSecret = session.authTokenSecret;
        self.userId = session.userID;
        self.userName = session.userName;
    }
    return self;
}

#pragma mark MobilyModel

+ (NSArray*)serializeMap {
    return @[
        @"authToken",
        @"authTokenSecret",
        @"userId",
        @"userName",
        @"email"
    ];
}

#pragma mark MobilySocialSession

- (BOOL)isValid {
    return (_authToken.length > 0) && (_authTokenSecret.length > 0) && (_userId.length > 0);
}

@end

/*--------------------------------------------------*/
