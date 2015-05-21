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

#import <MobilyCore/MobilyTimer.h>

/*--------------------------------------------------*/

@interface MobilyTimer ()

@property(nonatomic, readwrite, assign, getter=isDelaying) BOOL delaying;
@property(nonatomic, readwrite, assign, getter=isStarted) BOOL started;
@property(nonatomic, readwrite, assign, getter=isPaused) BOOL paused;
@property(nonatomic, readwrite, assign) NSTimeInterval startTime;
@property(nonatomic, readwrite, assign) NSTimeInterval pauseTime;
@property(nonatomic, readwrite, assign) NSTimeInterval elapsed;
@property(nonatomic, readwrite, assign) NSUInteger repeated;
@property(nonatomic, readwrite, strong) NSTimer* timer;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTimer

#pragma mark Init / Free

+ (instancetype)timerWithInterval:(NSTimeInterval)interval {
    return [[self alloc] initWithInterval:interval];
}

+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval {
    return [[self alloc] initWithDelay:delay interval:interval];
}

+ (instancetype)timerWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    return [[self alloc] initWithInterval:interval repeat:repeat];
}

+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    return [[self alloc] initWithDelay:delay interval:interval repeat:repeat];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval {
    self = [super init];
    if(self != nil) {
        self.interval = interval;
        [self setup];
    }
    return self;
}

- (instancetype)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval {
    self = [super init];
    if(self != nil) {
        self.delay = delay;
        self.interval = interval;
        [self setup];
    }
    return self;
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    self = [super init];
    if(self != nil) {
        self.interval = interval;
        self.repeat = repeat;
        [self setup];
    }
    return self;
}

- (instancetype)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    self = [super init];
    if(self != nil) {
        self.delay = delay;
        self.interval = interval;
        self.repeat = repeat;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [self stop];
}

#pragma mark Public

- (void)start {
    if(_started == NO) {
        self.started = YES;
        self.paused = NO;
        self.elapsed = 0.0f;
        self.repeated = 0;
        if(_delay > 0.0f) {
            self.delaying = YES;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_delay target:self selector:@selector(delayStartHandler) userInfo:nil repeats:NO];
        }
        if(_timer == nil) {
            self.startTime = NSDate.timeIntervalSinceReferenceDate;
            self.delaying = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerHandler) userInfo:nil repeats:(_repeat != 0)];
            if([_delegate respondsToSelector:@selector(timerDidStarted:)] == YES) {
                [_delegate timerDidStarted:self];
            } else if(_startedBlock != nil) {
                _startedBlock();
            }
        }
    }
}

- (void)stop {
    if(_started == YES) {
        self.started = NO;
        self.timer = nil;
        if([_delegate respondsToSelector:@selector(timerDidStoped:)] == YES) {
            [_delegate timerDidStoped:self];
        } else if(_stopedBlock != nil) {
            _stopedBlock();
        }
    }
}

- (void)pause {
    if((_started == YES) && (_paused == NO)) {
        self.pauseTime = NSDate.timeIntervalSinceReferenceDate;
        self.paused = YES;
        self.timer = nil;
        if([_delegate respondsToSelector:@selector(timerDidPaused:)] == YES) {
            [_delegate timerDidPaused:self];
        } else if(_pausedBlock != nil) {
            _pausedBlock();
        }
    }
}

- (void)resume {
    if((_started == YES) && (_paused == YES)) {
        self.paused = NO;
        if(_delaying == YES) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:NSDate.timeIntervalSinceReferenceDate - _delay target:self selector:@selector(delayStartHandler) userInfo:nil repeats:NO];
        }
        if(_timer == nil) {
            self.startTime = NSDate.timeIntervalSinceReferenceDate - (_pauseTime - _startTime);
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerHandler) userInfo:nil repeats:(_repeat != 0)];
            if([_delegate respondsToSelector:@selector(timerDidResumed:)] == YES) {
                [_delegate timerDidResumed:self];
            } else if(_resumedBlock != nil) {
                _resumedBlock();
            }
        }
    }
}

#pragma mark Property

- (void)setDelay:(NSTimeInterval)delay {
    if((_started == NO) && (_delay != delay)) {
        _delay = delay;
    }
}

- (void)setInterval:(NSTimeInterval)interval {
    if((_started == NO) && (_interval != interval)) {
        _interval = interval;
    }
}

- (void)setRepeat:(NSUInteger)repeat {
    if((_started == NO) && (_repeat != repeat)) {
        _repeat = repeat;
    }
}

- (void)setTimer:(NSTimer*)timer {
    if(_timer != timer) {
        if(_timer != nil) {
            [_timer invalidate];
        }
        _timer = timer;
    }
}

- (NSTimeInterval)duration {
    return _interval * _repeat;
}

- (NSTimeInterval)elapsed {
    if((_started == YES) && (_delaying == NO)) {
        self.elapsed = NSDate.timeIntervalSinceReferenceDate - _startTime;
    }
    return _elapsed;
}

#pragma mark Private

- (void)delayStartHandler {
    self.startTime = NSDate.timeIntervalSinceReferenceDate;
    self.delaying = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerHandler) userInfo:nil repeats:(_repeat != 0)];
    if([_delegate respondsToSelector:@selector(timerDidStarted:)] == YES) {
        [_delegate timerDidStarted:self];
    } else if(_startedBlock != nil) {
        _startedBlock();
    }
}

- (void)timerHandler {
    _repeated++;
    if(_repeat == NSNotFound) {
        if([_delegate respondsToSelector:@selector(timerDidRepeat:)] == YES) {
            [_delegate timerDidRepeat:self];
        } else if(_repeatBlock != nil) {
            _repeatBlock();
        }
    } else if(_repeat != 0) {
        if([_delegate respondsToSelector:@selector(timerDidRepeat:)] == YES) {
            [_delegate timerDidRepeat:self];
        } else if(_repeatBlock != nil) {
            _repeatBlock();
        }
        if(_repeated >= _repeat) {
            [self stop];
        }
    } else {
        [self stop];
    }
}

@end

/*--------------------------------------------------*/
