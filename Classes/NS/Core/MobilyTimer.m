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

#import "MobilyTimer.h"

/*--------------------------------------------------*/

@interface MobilyTimer ()

@property(nonatomic, readwrite, assign, getter=isDelaying) BOOL delaying;
@property(nonatomic, readwrite, assign, getter=isStarted) BOOL started;
@property(nonatomic, readwrite, assign) NSTimeInterval startTime;
@property(nonatomic, readwrite, assign) NSTimeInterval elapsed;
@property(nonatomic, readwrite, assign) NSUInteger repeated;
@property(nonatomic, readwrite, strong) NSTimer* timer;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTimer

#pragma mark Public

+ (instancetype)timerWithInterval:(NSTimeInterval)interval {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithInterval:interval]);
}

+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithDelay:delay interval:interval]);
}

+ (instancetype)timerWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithInterval:interval repeat:repeat]);
}

+ (instancetype)timerWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithDelay:delay interval:interval repeat:repeat]);
}

- (id)initWithInterval:(NSTimeInterval)interval {
    self = [super init];
    if(self != nil) {
        [self setInterval:interval];
    }
    return self;
}

- (id)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval {
    self = [super init];
    if(self != nil) {
        [self setDelay:delay];
        [self setInterval:interval];
    }
    return self;
}

- (id)initWithInterval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    self = [super init];
    if(self != nil) {
        [self setInterval:interval];
        [self setRepeat:repeat];
    }
    return self;
}

- (id)initWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval repeat:(NSUInteger)repeat {
    self = [super init];
    if(self != nil) {
        [self setDelay:delay];
        [self setInterval:interval];
        [self setRepeat:repeat];
    }
    return self;
}

- (void)dealloc {
    [self stop];
    
    MOBILY_SAFE_DEALLOC;
}

- (void)start {
    if(_started == NO) {
        [self setStarted:YES];
        [self setElapsed:0.0f];
        [self setRepeated:0];
        if(_delay > 0.0f) {
            [self setDelaying:YES];
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:_delay target:self selector:@selector(delayStartHandler) userInfo:nil repeats:NO]];
        } else {
            [self setStartTime:[NSDate timeIntervalSinceReferenceDate]];
            [self setDelaying:NO];
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerHandler) userInfo:nil repeats:(_repeat != 0)]];
            if(_startBlock != nil) {
                _startBlock();
            }
        }
    }
}

- (void)stop {
    if(_started == YES) {
        [self setStarted:NO];
        [self setTimer:nil];
        if(_stopBlock != nil) {
            _stopBlock();
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
        MOBILY_SAFE_SETTER(_timer, timer);
    }
}

- (NSTimeInterval)elapsed {
    if((_started == YES) && (_delaying == NO)) {
        [self setElapsed:[NSDate timeIntervalSinceReferenceDate] - _started];
    }
    return _elapsed;
}

#pragma mark Private

- (void)delayStartHandler {
    [self setStartTime:[NSDate timeIntervalSinceReferenceDate]];
    [self setDelaying:NO];
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(timerHandler) userInfo:nil repeats:(_repeat != 0)]];
    if(_startBlock != nil) {
        _startBlock();
    }
}

- (void)timerHandler {
    _repeated++;
    if(_repeat == NSNotFound) {
        if(_repeatBlock != nil) {
            _repeatBlock();
        }
    } else if(_repeat != 0) {
        if(_repeat != _repeated) {
            if(_repeatBlock != nil) {
                _repeatBlock();
            }
        } else {
            [self stop];
        }
    } else {
        [self stop];
    }
}

@end

/*--------------------------------------------------*/