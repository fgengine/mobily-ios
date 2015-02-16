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

#import "MobilyTaskManager.h"

/*--------------------------------------------------*/

@interface MobilyTaskManager ()

@property(nonatomic, readwrite, strong) NSOperationQueue* queueManager;
@property(nonatomic, readwrite, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property(nonatomic, readwrite, assign) NSUInteger updateCount;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@class MobilyTaskOperation;

/*--------------------------------------------------*/

@interface MobilyTask ()

@property(nonatomic, readwrite, weak) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, weak) MobilyTaskOperation* taskOperation;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyTaskOperation : NSOperation

@property(nonatomic, readwrite, weak) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, strong) MobilyTask* task;

- (instancetype)initWithTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskManager

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setQueueManager:[NSOperationQueue new]];
        [self setBackgroundTaskId:UIBackgroundTaskInvalid];
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [self setQueueManager:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)setMaxConcurrentTask:(NSUInteger)maxConcurrentTask {
    [self updating];
    [_queueManager setMaxConcurrentOperationCount:maxConcurrentTask];
    [self updated];
}

- (NSUInteger)maxConcurrentTask {
    return [_queueManager maxConcurrentOperationCount];
}

- (void)addTask:(MobilyTask*)task {
    [self addTask:task priority:MobilyTaskPriorityNormal];
}

- (void)addTask:(MobilyTask*)task priority:(MobilyTaskPriority)priority {
    [self updating];
    MobilyTaskOperation* operation = MOBILY_SAFE_AUTORELEASE([[MobilyTaskOperation alloc] initWithTaskManager:self task:task]);
    if(operation != nil) {
        [operation setQueuePriority:(NSOperationQueuePriority)priority];
        [_queueManager addOperation:operation];
    }
    [self updated];
}

- (void)cancelTask:(MobilyTask*)task {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger idx, BOOL* stop) {
        if([task isEqual:[operation task]] == YES) {
            [operation cancel];
            *stop = YES;
        }
    }];
    [self updated];
}

- (void)cancelAllTasks {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger idx, BOOL* stop) {
        [operation cancel];
    }];
    [self updated];
}

- (void)enumirateTasksUsingBlock:(MobilyTaskManagerEnumBlock)block {
    [self updating];
    [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger idx, BOOL* stop) {
        block([operation task], stop);
    }];
    [self updated];
}

- (NSArray*)tasks {
    NSMutableArray* result = [NSMutableArray array];
    if(result != nil) {
        [self updating];
        [[_queueManager operations] enumerateObjectsUsingBlock:^(MobilyTaskOperation* operation, NSUInteger idx, BOOL* stop) {
            [result addObject:[operation task]];
        }];
        [self updated];
    }
    return MOBILY_SAFE_AUTORELEASE([result copy]);
}

- (NSUInteger)countTasks {
    [self updating];
    NSUInteger result = [_queueManager operationCount];
    [self updated];
    return result;
}

- (void)updating {
    if(_updateCount == 0) {
        [_queueManager setSuspended:YES];
    }
    _updateCount++;
}

- (void)updated {
    if(_updateCount == 1) {
        [_queueManager setSuspended:NO];
    }
    _updateCount--;
}

- (void)wait {
    [_queueManager waitUntilAllOperationsAreFinished];
}

- (void)startBackgroundSession {
    if(_backgroundTaskId == UIBackgroundTaskInvalid) {
        _backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self cancelAllTasks];
            [self stopBackgroundSession];
        }];
    }
}

- (void)stopBackgroundSession {
    if(_backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskId];
        _backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTask

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setTaskOperation:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (BOOL)isCanceled {
    return [_taskOperation isCancelled];
}

- (BOOL)willStart {
    return YES;
}

- (void)working {
}

- (void)didComplete {
}

- (void)didCancel {
}

- (void)cancel {
    if(_taskOperation != nil) {
        [_taskOperation cancel];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskOperation

#pragma mark Init / Free

- (instancetype)initWithTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task {
    self = [super init];
    if(self != nil) {
        [self setTaskManager:taskManager];
        [self setTask:task];
        
        [_task setTaskOperation:self];
        
        [self setCompletionBlock:^{
            if([task isCanceled] == YES) {
                @autoreleasepool {
                    [task didCancel];
                }
            } else {
                @autoreleasepool {
                    [task didComplete];
                }
            }
            [task setTaskOperation:nil];
        }];
    }
    return self;
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setTask:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark NSOperation

- (void)main {
    if(_task != nil) {
        if([_task willStart] == NO) {
            [self cancel];
            return;
        }
        while([self isCancelled] == NO) {
            @autoreleasepool {
                [_task working];
            }
            if([_task isNeedRework] == YES) {
                [NSThread sleepForTimeInterval:0.01];
            } else {
                break;
            }
        }
    }
}

- (void)cancel {
    [super cancel];
    
    [_task setTaskOperation:nil];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskHttpQuery

#pragma mark Init / Free

- (void)dealloc {
    [self setHttpQuery:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyTask

- (BOOL)willStart {
    return (_httpQuery != nil);
}

- (void)working {
    [_httpQuery start];
}

- (void)cancel {
    if(_httpQuery != nil) {
        [_httpQuery cancel];
    }
    [super cancel];
}

@end

/*--------------------------------------------------*/
