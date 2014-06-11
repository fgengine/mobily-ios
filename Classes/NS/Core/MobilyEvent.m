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

#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyEventSelector ()

@property(nonatomic, readwrite, weak) id target;
@property(nonatomic, readwrite, assign) SEL action;
@property(nonatomic, readwrite, weak) NSThread* safeThread;

- (void)safeFireParams:(NSMutableDictionary*)params;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyEventBlock ()

@property(nonatomic, readwrite, copy) MobilyEventBlockType block;
@property(nonatomic, readwrite, assign) dispatch_queue_t safeQueue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyEventSelector

#pragma mark Standart

+ (id)callbackWithTarget:(id)target action:(SEL)action {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithTarget:target action:action thread:nil]);
}

+ (id)callbackWithTarget:(id)target action:(SEL)action inMainThread:(BOOL)inMainThread {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithTarget:target action:action thread:(inMainThread == YES) ? [NSThread mainThread] : nil]);
}

+ (id)callbackWithTarget:(id)target action:(SEL)action inCurrentThread:(BOOL)inCurrentThread {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithTarget:target action:action thread:(inCurrentThread == YES) ? [NSThread currentThread] : nil]);
}

- (id)initWithTarget:(id)target action:(SEL)action thread:(NSThread*)thread {
    self = [super init];
    if(self != nil) {
        [self setTarget:target];
        [self setAction:action];
        [self setSafeThread:thread];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        [self setAction:NSSelectorFromString([coder decodeObjectForKey:@"action"])];
    }
    return self;
}

- (void)dealloc {
    [self setTarget:nil];
    [self setSafeThread:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:NSStringFromSelector(_action) forKey:@"action"];
}

#pragma mark Public

- (id)fireSender:(id)sender object:(id)object {
    id result = nil;
    NSMethodSignature* signature = [_target methodSignatureForSelector:_action];
    if(signature != nil) {
        NSUInteger numberOfArguments = [signature numberOfArguments];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        if(invocation != nil) {
            [invocation setTarget:_target];
            [invocation setSelector:_action];
            if(numberOfArguments > 2) {
                if(sender != nil) {
                    [invocation setArgument:&sender atIndex:2];
                    if(object != nil) {
                        if(numberOfArguments > 3) {
                            [invocation setArgument:&object atIndex:3];
                        }
                    }
                } else {
                    if(object != nil) {
                        [invocation setArgument:&object atIndex:2];
                    }
                }
                [invocation retainArguments];
            }
            if(_safeThread != nil) {
                [self performSelector:@selector(safeFireParams:) onThread:_safeThread withObject:invocation waitUntilDone:YES];
            } else {
                [invocation invoke];
            }
            if([signature methodReturnLength] == sizeof(id)) {
                [invocation getReturnValue:&result];
            }
        }
    }
    return result;
}

#pragma mark Private

- (void)safeFireParams:(NSInvocation*)invocation {
    [invocation invoke];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyEventBlock

#pragma mark Standart

+ (id)callbackWithBlock:(MobilyEventBlockType)block {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithBlock:block queue:nil]);
}

+ (id)callbackWithBlock:(MobilyEventBlockType)block inMainQueue:(BOOL)inMainQueue {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithBlock:block queue:(inMainQueue == YES) ? dispatch_get_main_queue() : nil]);
}

+ (id)callbackWithBlock:(MobilyEventBlockType)block inCurrentQueue:(BOOL)inCurrentQueue {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithBlock:block queue:(inCurrentQueue == YES) ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : nil]);
}

- (id)initWithBlock:(MobilyEventBlockType)block queue:(dispatch_queue_t)queue {
    self = [super init];
    if(self != nil) {
        [self setBlock:block];
        [self setSafeQueue:queue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    [self setBlock:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (void)encodeWithCoder:(NSCoder*)coder {
}

#pragma mark Public

- (id)fireSender:(id)sender object:(id)object {
    if(_safeQueue != nil) {
        dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        if(currentQueue != _safeQueue) {
            __block id result = nil;
            dispatch_async(_safeQueue, ^{
                result = _block(sender, object);
            });
            return result;
        }
    }
    return _block(sender, object);
}

@end

/*--------------------------------------------------*/
