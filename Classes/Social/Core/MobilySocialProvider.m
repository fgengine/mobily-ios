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

#import "MobilySocialProvider.h"

/*--------------------------------------------------*/

@interface MobilySocialProvider ()

@property(nonatomic, readwrite, strong) NSString* name;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialProvider

#pragma mark Init

- (id)initWithName:(NSString*)name {
    self = [super init];
    if(self != nil) {
        [self setName:name];
    }
    return self;
}

- (void)dealloc {
    [self setManager:nil];
    [self setName:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setManager:(MobilySocialManager*)manager {
    if(_manager != manager) {
        if(_manager != nil) {
            [_manager unregisterProvider:self];
        }
        MOBILY_SAFE_SETTER(_manager, manager);
        if(_manager != nil) {
            [_manager registerProvider:self];
        }
    }
}

#pragma mark Public

- (void)signinSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
}

- (void)logoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return NO;
}

@end

/*--------------------------------------------------*/
