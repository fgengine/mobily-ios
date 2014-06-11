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

- (id)initWithMTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskManager

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setQueueManager:[NSOperationQueue new]];
        [self setBackgroundTaskId:UIBackgroundTaskInvalid];
    }
    return self;
}

- (void)dealloc {
    [self setQueueManager:nil];

    MOBILY_SAFE_DEALLOC;
}

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
    MobilyTaskOperation* operation = MOBILY_SAFE_AUTORELEASE([[MobilyTaskOperation alloc] initWithMTaskManager:self task:task]);
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

- (id)init {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setTaskOperation:nil];
    [self setObject:nil];
    [self setStartCallback:nil];
    [self setWorkingCallback:nil];
    [self setCompleteCallback:nil];
    [self setCancelCallback:nil];

    MOBILY_SAFE_DEALLOC;
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

- (id)initWithMTaskManager:(MobilyTaskManager*)taskManager task:(MobilyTask*)task {
    self = [super init];
    if(self != nil) {
        [self setTaskManager:taskManager];
        [self setTask:task];
        
        [_task setTaskOperation:self];
        
        MOBILY_WEAK MobilyTaskOperation* weakSelf = self;
        [self setCompletionBlock:^{
            if([weakSelf isCancelled] == YES) {
                MobilyTaskCancelBlock cancelCallback = [task cancelCallback];
                if(cancelCallback != nil) {
                    @autoreleasepool {
                        cancelCallback(task);
                    }
                }
            } else {
                MobilyTaskCompleteBlock completeCallback = [task completeCallback];
                if(completeCallback != nil) {
                    @autoreleasepool {
                        completeCallback(task);
                    }
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

- (void)main {
    if(_task != nil) {
        MobilyTaskWokingBlock workingCallback = [_task workingCallback];
        if(workingCallback != nil) {
            MobilyTaskStartBlock startCallback = [_task startCallback];
            if(startCallback != nil) {
                if(startCallback(_task) == NO) {
                    [self cancel];
                    return;
                }
            }
            while([self isCancelled] == NO) {
                BOOL work = NO;
                @autoreleasepool {
                    work = workingCallback(_task);
                }
                if(work == NO) {
                    [NSThread sleepForTimeInterval:0.01];
                    continue;
                }
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
