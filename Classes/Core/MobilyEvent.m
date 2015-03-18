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

@implementation MobilyEventSelector

#pragma mark Init / Free

+ (id)eventWithTarget:(id)target action:(SEL)action {
    return [[self alloc] initWithTarget:target action:action thread:nil];
}

+ (id)eventWithTarget:(id)target action:(SEL)action inMainThread:(BOOL)inMainThread {
    return [[self alloc] initWithTarget:target action:action thread:(inMainThread == YES) ? [NSThread mainThread] : nil];
}

+ (id)eventWithTarget:(id)target action:(SEL)action inCurrentThread:(BOOL)inCurrentThread {
    return [[self alloc] initWithTarget:target action:action thread:(inCurrentThread == YES) ? [NSThread currentThread] : nil];
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        self.action = NSSelectorFromString([coder decodeObjectForKey:@"action"]);
        [self setup];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action thread:(NSThread*)thread {
    self = [super init];
    if(self != nil) {
        self.target = target;
        self.action = action;
        self.safeThread = thread;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.target = nil;
    self.safeThread = nil;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:NSStringFromSelector(_action) forKey:@"action"];
}

#pragma mark Public

- (id)fireSender:(id)sender object:(id)object {
    id result = nil;
    NSMethodSignature* signature = [_target methodSignatureForSelector:_action];
    if(signature != nil) {
        NSUInteger numberOfArguments = signature.numberOfArguments;
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        if(invocation != nil) {
            invocation.target = _target;
            invocation.selector = _action;
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
            if(signature.methodReturnLength == sizeof(id)) {
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

@interface MobilyEventBlock ()

@property(nonatomic, readwrite, copy) MobilyEventBlockType block;
@property(nonatomic, readwrite, assign) dispatch_queue_t safeQueue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyEventBlock

#pragma mark Init / Free

+ (id)eventWithBlock:(MobilyEventBlockType)block {
    return [[self alloc] initWithBlock:block queue:nil];
}

+ (id)eventWithBlock:(MobilyEventBlockType)block inMainQueue:(BOOL)inMainQueue {
    return [[self alloc] initWithBlock:block queue:(inMainQueue == YES) ? dispatch_get_main_queue() : nil];
}

+ (id)eventWithBlock:(MobilyEventBlockType)block inCurrentQueue:(BOOL)inCurrentQueue {
    return [[self alloc] initWithBlock:block queue:(inCurrentQueue == YES) ? dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) : nil];
}

- (instancetype)initWithCoder:(NSCoder* __unused)coder {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithBlock:(MobilyEventBlockType)block queue:(dispatch_queue_t)queue {
    self = [super init];
    if(self != nil) {
        self.block = block;
        self.safeQueue = queue;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.block = nil;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder* __unused)coder {
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
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyEvents ()

@property(nonatomic, readwrite, strong) NSMutableDictionary* groupsEvents;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyEvents

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.groupsEvents = NSMutableDictionary.dictionary;
}

- (void)dealloc {
    self.groupsEvents = nil;
}

#pragma mark Public

- (void)addEventWithTarget:(id)target action:(SEL)action forKey:(id)key {
    [self addEventWithTarget:target action:action forGroup:[NSNull null] forKey:key];
}

- (void)addEventWithTarget:(id)target action:(SEL)action forGroup:(id)group forKey:(id)key {
    [self addEvent:[MobilyEventSelector eventWithTarget:target action:action] forGroup:group forKey:key];
}

- (void)addEventWithBlock:(MobilyEventBlockType)block forKey:(id)key {
    [self addEventWithBlock:block forGroup:[NSNull null] forKey:key];
}

- (void)addEventWithBlock:(MobilyEventBlockType)block forGroup:(id)group forKey:(id)key {
    [self addEvent:[MobilyEventBlock eventWithBlock:block] forGroup:group forKey:key];
}

- (void)addEvent:(id< MobilyEvent >)event forKey:(id)key {
    [self addEvent:event forGroup:[NSNull null] forKey:key];
}

- (void)addEvent:(id< MobilyEvent >)event forGroup:(id)group forKey:(id)key {
    NSMutableDictionary* events = _groupsEvents[group];
    if(events == nil) {
        events = [NSMutableDictionary dictionaryWithObject:event forKey:key];
        _groupsEvents[group] = events;
    } else {
        events[key] = event;
    }
}

- (void)removeEventForKey:(id)key {
    [self removeEventInGroup:[NSNull null] forKey:key];
}

- (void)removeEventInGroup:(id)group forKey:(id)key {
    NSMutableDictionary* events = _groupsEvents[group];
    if(events != nil) {
        [events removeObjectForKey:key];
    }
}

- (void)removeEventsForGroup:(id)group {
    [_groupsEvents removeObjectForKey:group];
}

- (void)removeAllEvents {
    [_groupsEvents removeAllObjects];
}

- (BOOL)containsEventForKey:(id)key {
    return [self containsEventInGroup:[NSNull null] forKey:key];
}

- (BOOL)containsEventInGroup:(id)group forKey:(id)key {
    NSMutableDictionary* events = _groupsEvents[group];
    if(events != nil) {
        return (events[key] != nil);
    }
    return NO;
}

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    [self fireEventInGroup:[NSNull null] forKey:key bySender:sender byObject:object orDefault:nil];
}

- (void)fireEventInGroup:(id)group forKey:(id)key bySender:(id)sender byObject:(id)object {
    [self fireEventInGroup:group forKey:key bySender:sender byObject:object orDefault:nil];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [self fireEventInGroup:[NSNull null] forKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (id)fireEventInGroup:(id)group forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    id< MobilyEvent > event = nil;
    NSMutableDictionary* events = _groupsEvents[group];
    if(events != nil) {
        event = events[key];
    }
    if(event != nil) {
        return [event fireSender:sender object:object];
    }
    return orDefault;
}

@end

/*--------------------------------------------------*/
