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

#import <MobilyCore/MobilyTransitionController+Private.h>

/*--------------------------------------------------*/

@interface MobilyTransitionControllerCards ()

- (void)_startTransitionForward;
- (void)_startTransitionReverse;
- (CATransform3D)_firstTransform;
- (CATransform3D)_secondTransformWithView:(UIView*)view;

@end

/*--------------------------------------------------*/

@implementation MobilyTransitionControllerCards

#pragma mark Transition

- (void)_startTransition {
    switch(_operation) {
        case MobilyTransitionOperationPresent:
        case MobilyTransitionOperationPush:
            [self _startTransitionForward];
            break;
        case MobilyTransitionOperationDismiss:
        case MobilyTransitionOperationPop:
            [self _startTransitionReverse];
            break;
    }
}

#pragma mark Private

- (void)_startTransitionForward {
    CGRect frame = _initialFrameFromViewController;
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    _toView.frame = offScreenFrame;
    [_containerView insertSubview:_toView aboveSubview:_fromView];
    CATransform3D t1 = [self _firstTransform];
    CATransform3D t2 = [self _secondTransformWithView:_fromView];
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
                                      _fromView.layer.transform = t1;
                                      _fromView.alpha = 0.6f;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
                                      _fromView.layer.transform = t2;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
                                      _toView.frame = CGRectOffset(_toView.frame, 0.0f, -30.0f);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
                                      _toView.frame = frame;
                                  }];
                              } completion:^(BOOL finished __unused) {
                                  [self _completeTransition];
                              }];
}

- (void)_startTransitionReverse {
    CGRect frame = _initialFrameFromViewController;
    _toView.frame = frame;
    _toView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.6f, 0.6f, 1.0f);
    _toView.alpha = 0.6f;
    [_containerView insertSubview:_toView belowSubview:_fromView];
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;
    CATransform3D t1 = [self _firstTransform];
    [UIView animateKeyframesWithDuration:_duration
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                                      _fromView.frame = frameOffScreen;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
                                      _toView.layer.transform = t1;
                                      _toView.alpha = 1.0f;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
                                      _toView.layer.transform = CATransform3DIdentity;
                                  }];
                              } completion:^(BOOL finished __unused) {
                                  if([self isCancelled] == YES) {
                                      _toView.layer.transform = CATransform3DIdentity;
                                      _toView.alpha = 1.0f;
                                  }
                                  [self _completeTransition];
                              }];
}

- (CATransform3D)_firstTransform {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0f / -900.0f;
    t1 = CATransform3DScale(t1, 0.95f, 0.95f, 1.0f);
    t1 = CATransform3DRotate(t1, (15.0f * M_PI) / 180.0f, 1.0f, 0.0f, 0.0f);
    return t1;
}

- (CATransform3D)_secondTransformWithView:(UIView*)view {
    CATransform3D t1 = [self _firstTransform];
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0.0f, view.frame.size.height * -0.08f, 0.0f);
    t2 = CATransform3DScale(t2, 0.8f, 0.8f, 1.0f);
    return t2;
}

@end

/*--------------------------------------------------*/
