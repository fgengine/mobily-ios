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

#import "MobilyTransitionController+Private.h"

/*--------------------------------------------------*/

@implementation MobilyTransitionControllerCrossFade

#pragma mark Transition

- (void)_startTransition {
    [_containerView addSubview:_toView];
    [_containerView sendSubviewToBack:_toView];
    
    [UIView animateWithDuration:_duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _fromView.alpha = 0.0f;
                     } completion:^(BOOL finished __unused) {
                         if([self isCancelled] == YES) {
                             _fromView.alpha = 1.0;
                         } else {
                             [_fromView removeFromSuperview];
                             _fromView.alpha = 1.0f;
                         }
                         [self _completeTransition];
                     }];
}

#pragma mark Interactive

- (void)_startInteractive {
    [super _startInteractive];
    
    [_containerView addSubview:_toView];
    [_containerView sendSubviewToBack:_toView];
}

- (void)_updateInteractive:(CGFloat)complete {
    [super _updateInteractive:complete];
    
    _fromView.alpha = 1.0f - complete;
    _toView.alpha = complete;
}

- (void)_finishInteractive {
    [super _finishInteractive];
    
    [UIView animateWithDuration:_duration * _percentComplete
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _fromView.alpha = 0.0f;
                         _toView.alpha = 1.0f;
                     } completion:^(BOOL finished __unused) {
                         _fromView.alpha = 1.0f;
                         _toView.alpha = 1.0f;
                         [_fromView removeFromSuperview];
                         [self _completeInteractive];
                     }];
}

- (void)_cancelInteractive {
    [super _cancelInteractive];
    
    [UIView animateWithDuration:_duration * (1.0f - _percentComplete)
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _fromView.alpha = 1.0f;
                         _toView.alpha = 0.0f;
                     } completion:^(BOOL finished __unused) {
                         _fromView.alpha = 1.0f;
                         _toView.alpha = 1.0f;
                         [_toView removeFromSuperview];
                         [self _completeInteractive];
                     }];
}

@end

/*--------------------------------------------------*/
