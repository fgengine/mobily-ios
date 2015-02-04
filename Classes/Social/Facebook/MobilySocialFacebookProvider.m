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

/*--------------------------------------------------*/

@interface MobilySocialFacebookProvider ()



@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialFacebookProvider

#pragma mark Init

- (id)initWithName:(NSString*)name {
    self = [super initWithName:name];
    if(self != nil) {
        [self setAllowLoginUI:YES];
    }
    return self;
}

- (id)initWithReadPermissions:(NSArray*)readPermissions {
    self = [self initWithName:@"Facebook"];
    if(self != nil) {
        [self setReadPermissions:readPermissions];
    }
    return self;
}

- (void)dealloc {
    [self setReadPermissions:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (void)signinSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    [FBSession openActiveSessionWithReadPermissions:_readPermissions allowLoginUI:_allowLoginUI completionHandler:^(FBSession* session, FBSessionState state, NSError* error) {
        if(error == nil) {
            switch(state) {
                case FBSessionStateOpen:
                case FBSessionStateClosed: {
                    if(success != nil) {
                        success();
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

- (void)logoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
    FBSession* session = [FBSession activeSession];
    if(session != nil) {
        [session closeAndClearTokenInformation];
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
