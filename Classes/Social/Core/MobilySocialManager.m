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

#import "MobilySocialManager.h"
#import "MobilySocialProvider.h"

/*--------------------------------------------------*/

@interface MobilySocialManager ()


@property(nonatomic, readwrite, strong) NSMutableArray* mutableProviders;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_API_MANAGER_MAX_CONCURRENT_TASK      5

/*--------------------------------------------------*/

@implementation MobilySocialManager

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [[self alloc] init];
            }
        }
    }
    return shared;
}

#pragma mark Init

- (id)init {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    [self setMutableProviders:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (NSArray*)providers {
    return [_mutableProviders copy];
}

#pragma mark Public

- (void)registerProvider:(MobilySocialProvider*)provider {
    if([_mutableProviders containsObject:provider] == NO) {
        [_mutableProviders addObject:provider];
        [provider setManager:self];
    }
}

- (void)unregisterProvider:(MobilySocialProvider*)provider {
    if([_mutableProviders containsObject:provider] == YES) {
        [_mutableProviders removeObject:provider];
        [provider setManager:nil];
    }
}

- (void)didBecomeActive {
    [_mutableProviders enumerateObjectsUsingBlock:^(MobilySocialProvider* provider, NSUInteger index, BOOL* stop) {
        [provider didBecomeActive];
    }];
}

- (void)willResignActive {
    [_mutableProviders enumerateObjectsUsingBlock:^(MobilySocialProvider* provider, NSUInteger index, BOOL* stop) {
        [provider willResignActive];
    }];
}

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    __block BOOL result = NO;
    [_mutableProviders enumerateObjectsUsingBlock:^(MobilySocialProvider* provider, NSUInteger index, BOOL* stop) {
        if([provider openURL:url sourceApplication:sourceApplication annotation:annotation] == YES) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end

/*--------------------------------------------------*/
