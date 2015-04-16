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

#import <MobilyObject.h>

/*--------------------------------------------------*/

typedef void(^MobilyTimerBlock)();

/*--------------------------------------------------*/

@protocol MobilyTimerDelegate;

/*--------------------------------------------------*/

@interface MobilyTimer : NSObject < MobilyObject >

@property(nonatomic, readonly, assign, getter=isDelaying) BOOL delaying;
@property(nonatomic, readonly, assign, getter=isStarted) BOOL started;
@property(nonatomic, readonly, assign, getter=isPaused) BOOL paused;
@property(nonatomic, readwrite, assign) NSTimeInterval delay;
@property(nonatomic, readwrite, assign) NSTimeInterval interval;
@property(nonatomic, readwrite, assign) NSUInteger repeat;
@property(nonatomic, readonly, assign) NSTimeInterval elapsed;
@property(nonatomic, readonly, assign) NSUInteger repeated;

@property(nonatomic, readwrite, weak) id< MobilyTimerDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyTimerBlock startedBlock;
@property(nonatomic, readwrite, copy) MobilyTimerBlock repeatBlock;
@property(nonatomic, readwrite, copy) MobilyTimerBlock stopedBlock;
@property(nonatomic, readwrite, copy) MobilyTimerBlock pausedBlock;
@property(nonatomic, readwrite, copy) MobilyTimerBlock resumedBlock;

+ (instancetype)timerWithInterval:(NSTimeInterval)interval;
+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval;
+ (instancetype)timerWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat;
+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat;

- (instancetype)initWithInterval:(NSTimeInterval)interval;
- (instancetype)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval;
- (instancetype)initWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat;
- (instancetype)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat;

- (void)setup NS_REQUIRES_SUPER;

- (void)start;
- (void)stop;

- (void)pause;
- (void)resume;

@end

/*--------------------------------------------------*/

@protocol MobilyTimerDelegate < NSObject >

@optional
-(void)timerDidStarted:(MobilyTimer*)timer;
-(void)timerDidRepeat:(MobilyTimer*)timer;
-(void)timerDidStoped:(MobilyTimer*)timer;
-(void)timerDidResumed:(MobilyTimer*)timer;
-(void)timerDidPaused:(MobilyTimer*)timer;

@end

/*--------------------------------------------------*/
