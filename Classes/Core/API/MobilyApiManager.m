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

#import "MobilyApiManager.h"
#import "MobilyApiProvider.h"

/*--------------------------------------------------*/

@interface MobilyApiManager () {
@protected
    NSMutableArray* _providers;
    MobilyTaskManager* _taskManager;
    MobilyCache* _cache;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_API_MANAGER_MAX_CONCURRENT_TASK      5

/*--------------------------------------------------*/

@implementation MobilyApiManager

#pragma mark Synthesize

@synthesize taskManager = _taskManager;
@synthesize cache = _cache;

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [self new];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _taskManager = [MobilyTaskManager new];
        if(_taskManager != nil) {
            _taskManager.maxConcurrentTask = MOBILY_API_MANAGER_MAX_CONCURRENT_TASK;
        }
        _cache = MobilyCache.shared;
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Property

- (NSArray*)providers {
    return [_providers copy];
}

#pragma mark Public

- (void)registerProvider:(MobilyApiProvider*)provider {
    if([_providers containsObject:provider] == NO) {
        [_providers addObject:provider];
        provider.manager = self;
    }
}

- (void)unregisterProvider:(MobilyApiProvider*)provider {
    if([_providers containsObject:provider] == YES) {
        [_providers removeObject:provider];
        provider.manager = nil;
    }
}

@end

/*--------------------------------------------------*/
