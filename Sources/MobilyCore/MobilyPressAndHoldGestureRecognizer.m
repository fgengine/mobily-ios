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

#import <MobilyCore/MobilyPressAndHoldGestureRecognizer.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

/*--------------------------------------------------*/

@interface MobilyPressAndHoldGestureRecognizer () {
@protected
    NSMutableArray* _actions;
    NSTimer* _repeatedlyReportTimer;
    CGPoint _beginLocation;
}

- (void)_invokeMethods;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyPressAndHoldGestureRecognizer

#pragma mark Init / Free

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:nil action:NULL];
    if(self) {
        _actions = [NSMutableArray new];
        if((target != nil) && (action != NULL)) {
            [_actions addObject:[MobilyEventSelector eventWithTarget:target action:action]];
        }
        _reportInterval = 0.5f;
        _allowableMovementWhenRecognized = 3.0f;
    }
    return self;
}

#pragma mark Public override

- (void)setState:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateBegan) {
        _repeatedlyReportTimer = [NSTimer scheduledTimerWithTimeInterval:_reportInterval target:self selector:@selector(_invokeMethods) userInfo:nil repeats:YES];
    }
    [super setState:state];
}

- (void)reset {
    if(_repeatedlyReportTimer != nil) {
        [_repeatedlyReportTimer invalidate];
        _repeatedlyReportTimer = nil;
    }
    [super reset];
    if((self.state == UIGestureRecognizerStateCancelled) || (self.state == UIGestureRecognizerStateEnded)) {
        [self _invokeMethods];
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    if((target != nil) && (action != NULL)) {
        [_actions addObject:[MobilyEventSelector eventWithTarget:target action:action]];
    }
}

- (void)removeTarget:(id)target action:(SEL)action {
    [_actions each:^(MobilyEventSelector* event) {
        if((event.target == target) && (event.action == action)) {
            [_actions removeObject:event];
        }
    }];
    [super removeTarget:target action:action];
}

#pragma mark Public override

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    _beginLocation = [touches.anyObject locationInView:self.view];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if((self.state == UIGestureRecognizerStateBegan) || (self.state == UIGestureRecognizerStateChanged)) {
        CGPoint newLocation = [touches.anyObject locationInView:self.view];
        CGFloat dx = newLocation.x - _beginLocation.x;
        CGFloat dy = newLocation.y - _beginLocation.y;
        if(sqrt(dx * dx + dy * dy) > _allowableMovementWhenRecognized) {
            self.state = UIGestureRecognizerStateEnded;
        }
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)_invokeMethods {
    [_actions each:^(MobilyEventSelector* event) {
        [event fireSender:self object:nil];
    }];
}

@end

/*--------------------------------------------------*/
