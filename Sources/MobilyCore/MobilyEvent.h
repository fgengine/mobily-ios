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

#import <MobilyCore/MobilyObject.h>

/*--------------------------------------------------*/

typedef id (^MobilyEventBlockType)(id sender, id object);

/*--------------------------------------------------*/

@protocol MobilyEvent < MobilyObject, NSCoding >

- (id)fireSender:(id)sender object:(id)object;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyEventSelector : NSObject< MobilyEvent >

@property(nonatomic, readonly, weak) id target;
@property(nonatomic, readonly, assign) SEL action;

+ (id)eventWithTarget:(id)target action:(SEL)action;
+ (id)eventWithTarget:(id)target action:(SEL)action inMainThread:(BOOL)inMainThread;
+ (id)eventWithTarget:(id)target action:(SEL)action inCurrentThread:(BOOL)inCurrentThread;
- (instancetype)initWithTarget:(id)target action:(SEL)action thread:(NSThread*)thread;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyEventBlock : NSObject< MobilyEvent >

@property(nonatomic, readonly, copy) MobilyEventBlockType block;

+ (id)eventWithBlock:(MobilyEventBlockType)block;
+ (id)eventWithBlock:(MobilyEventBlockType)block inMainQueue:(BOOL)inMainQueue;
+ (id)eventWithBlock:(MobilyEventBlockType)block inCurrentQueue:(BOOL)inCurrentQueue;
- (instancetype)initWithBlock:(MobilyEventBlockType)block queue:(dispatch_queue_t)queue;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyEvents: NSObject< MobilyObject >

@property(nonatomic, readwrite, strong) id defaultGroup;

- (void)setup NS_REQUIRES_SUPER;

- (void)addEventWithTarget:(id)target action:(SEL)action forKey:(id)key;
- (void)addEventWithTarget:(id)target action:(SEL)action forGroup:(id)group forKey:(id)key;
- (void)addEventWithBlock:(MobilyEventBlockType)block forKey:(id)key;
- (void)addEventWithBlock:(MobilyEventBlockType)block forGroup:(id)group forKey:(id)key;
- (void)addEvent:(id< MobilyEvent >)event forKey:(id)key;
- (void)addEvent:(id< MobilyEvent >)event forGroup:(id)group forKey:(id)key;
- (void)removeEventForKey:(id)key;
- (void)removeEventInGroup:(id)group forKey:(id)key;
- (void)removeEventsForGroup:(id)group;
- (void)removeAllEvents;

- (BOOL)containsEventForKey:(id)key;
- (BOOL)containsEventInGroup:(id)group forKey:(id)key;

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (void)fireEventInGroup:(id)group forKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventInGroup:(id)group forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

@end

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_EVENT(name) \
- (id)validate##name:(id)value { \
    if([value isKindOfClass:NSString.class] == YES) { \
        SEL action = NSSelectorFromString(value); \
        if(action != nil) { \
            id target = [self objectForSelector:action]; \
            if(target != nil) { \
                value = [MobilyEventSelector eventWithTarget:target action:action]; \
            } else { \
                NSLog(@"Failure bind event %@=\"%@\"", @#name, value); \
            } \
        } else { \
            NSLog(@"Unknown selector %@=\"%@\"", @#name, value); \
        } \
    } \
    if([value conformsToProtocol:@protocol(MobilyEvent)] == YES) { \
        return value; \
    } \
    return nil; \
}

/*--------------------------------------------------*/
