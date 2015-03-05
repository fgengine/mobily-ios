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

#import "MobilySocialProvider.h"

/*--------------------------------------------------*/

@interface MobilySocialProvider ()

@property(nonatomic, readwrite, strong) NSString* name;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialProvider

#pragma mark Init / Free

- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if(self != nil) {
        self.name = name;
        if([NSUserDefaults.standardUserDefaults objectForKey:self.userDefaultsKey] != nil) {
            self.session = [[self.class.sessionClass alloc] initWithUserDefaultsKey:self.userDefaultsKey];
            if([_session isKindOfClass:MobilySocialSession.class] == YES) {
                if(((MobilySocialSession*)_session).isValid == NO) {
                    self.session = nil;
                }
            }
        }
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.manager = nil;
    self.name = nil;
    self.session = nil;
}

#pragma mark Property

- (void)setManager:(MobilySocialManager*)manager {
    if(_manager != manager) {
        if(_manager != nil) {
            [_manager unregisterProvider:self];
        }
        _manager = manager;
        if(_manager != nil) {
            [_manager registerProvider:self];
        }
    }
}

- (void)setSession:(id)session {
    if(_session != session) {
        if(_session != nil) {
            [_session erase];
        }
        _session = session;
        if(_session != nil) {
            if([_session isKindOfClass:MobilyModel.class] == YES) {
                ((MobilyModel*)_session).userDefaultsKey = self.userDefaultsKey;
            }
            [_session save];
        }
    }
}

- (NSString*)userDefaultsKey {
    return [NSString stringWithFormat:@"MobilySocialSession-%@", _name];
}

#pragma mark Public

+ (Class)sessionClass {
    return MobilySocialSession.class;
}

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure {
}

- (void)didBecomeActive {
}

- (void)willResignActive {
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySocialSession

#pragma mark MobilyModel

+ (NSArray*)serializeMap {
    return @[
    ];
}

@end

/*--------------------------------------------------*/
