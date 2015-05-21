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

#import <MobilyCore/MobilyHttpQuery.h>

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyTaskPriority) {
	MobilyTaskPriorityLow,
	MobilyTaskPriorityNormal,
	MobilyTaskPriorityHigh
};

/*--------------------------------------------------*/

@class MobilyTask;

/*--------------------------------------------------*/

typedef void (^MobilyTaskManagerEnumBlock)(id task, BOOL* stop);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyTaskManager : NSObject < MobilyObject >

@property(nonatomic, readwrite, assign) NSUInteger maxConcurrentTask;

- (void)setup NS_REQUIRES_SUPER;

- (void)addTask:(MobilyTask*)task;
- (void)addTask:(MobilyTask*)task priority:(MobilyTaskPriority)priority;
- (void)cancelTask:(MobilyTask*)task;
- (void)cancelAllTasks;

- (void)enumirateTasksUsingBlock:(MobilyTaskManagerEnumBlock)block;
- (NSArray*)tasks;
- (NSUInteger)countTasks;

- (void)updating;
- (void)updated;

- (void)wait;

- (void)startBackgroundSession;
- (void)stopBackgroundSession;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyTask : NSObject < MobilyObject >

@property(nonatomic, readonly, assign, getter=isNeedRework) BOOL needRework;
@property(nonatomic, readonly, assign, getter=isCanceled) BOOL cancel;

- (void)setup NS_REQUIRES_SUPER;

- (void)setNeedRework;

- (BOOL)willStart NS_REQUIRES_SUPER;
- (void)working NS_REQUIRES_SUPER;
- (void)didComplete NS_REQUIRES_SUPER;
- (void)didCancel NS_REQUIRES_SUPER;

- (void)cancel;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyTaskHttpQuery : MobilyTask < MobilyHttpQueryDelegate > {
@protected
    MobilyHttpQuery* _httpQuery;
}

@property(nonatomic, readwrite, strong) MobilyHttpQuery* httpQuery;

@end

/*--------------------------------------------------*/
