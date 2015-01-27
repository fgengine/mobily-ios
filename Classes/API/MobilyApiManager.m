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

#import "MobilyApiManager.h"
#import "MobilyApiProvider.h"

/*--------------------------------------------------*/

@interface MobilyApiManager ()


@property(nonatomic, readwrite, strong) NSMutableArray* mutableProviders;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_API_MANAGER_MAX_CONCURRENT_TASK      5

/*--------------------------------------------------*/

@implementation MobilyApiManager

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
        [self setTaskManager:[[MobilyTaskManager alloc] init]];
        if(_taskManager != nil) {
            [_taskManager setMaxConcurrentTask:MOBILY_API_MANAGER_MAX_CONCURRENT_TASK];
        }
        [self setCache:[MobilyCache shared]];
    }
    return self;
}

- (void)dealloc {
    [self setMutableProviders:nil];
    [self setTaskManager:nil];
    [self setCache:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (NSArray*)providers {
    return [_mutableProviders copy];
}

#pragma mark Public

- (void)registerProvider:(MobilyApiProvider*)provider {
    if([_mutableProviders containsObject:provider] == NO) {
        [_mutableProviders addObject:provider];
        [provider setManager:self];
    }
}

- (void)unregisterProvider:(MobilyApiProvider*)provider {
    if([_mutableProviders containsObject:provider] == YES) {
        [_mutableProviders removeObject:provider];
        [provider setManager:nil];
    }
}

@end

/*--------------------------------------------------*/
