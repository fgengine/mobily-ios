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

#import "MobilyTransitionController.h"

/*--------------------------------------------------*/

@implementation MobilyTransitionControllerCards

#pragma mark MobilyTransitionController

- (void)startTransition {
    if([self isReverse] == NO){
        [self startForwardTransition];
    } else {
        [self startReverseTransition];
    }
    
}

- (void)startForwardTransition {
    CGRect frame = self.initialFrameFromViewController;
    CGRect offScreenFrame = frame;
    offScreenFrame.origin.y = offScreenFrame.size.height;
    self.toView.frame = offScreenFrame;
    [self.containerView insertSubview:self.toView aboveSubview:self.fromView];
    CATransform3D t1 = self.firstTransform;
    CATransform3D t2 = [self secondTransformWithView:self.fromView];
    [UIView animateKeyframesWithDuration:self.duration
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.4f animations:^{
                                      self.fromView.layer.transform = t1;
                                      self.fromView.alpha = 0.6f;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.4f animations:^{
                                      self.fromView.layer.transform = t2;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6f relativeDuration:0.2f animations:^{
                                      self.toView.frame = CGRectOffset(self.toView.frame, 0.0f, -30.0f);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
                                      self.toView.frame = frame;
                                  }];
                              } completion:^(BOOL finished) {
                                  [self completeTransition];
                              }];
}

- (void)startReverseTransition {
    CGRect frame = self.initialFrameFromViewController;
    self.toView.frame = frame;
    [self.toView.layer setTransform:CATransform3DScale(CATransform3DIdentity, 0.6f, 0.6f, 1.0f)];
    [self.toView setAlpha:0.6f];
    [self.containerView insertSubview:self.toView belowSubview:self.fromView];
    CGRect frameOffScreen = frame;
    frameOffScreen.origin.y = frame.size.height;
    CATransform3D t1 = self.firstTransform;
    [UIView animateKeyframesWithDuration:self.duration
                                   delay:0.0f
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                                      self.fromView.frame = frameOffScreen;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
                                      self.toView.layer.transform = t1;
                                      self.toView.alpha = 1.0f;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
                                      self.toView.layer.transform = CATransform3DIdentity;
                                  }];
                              } completion:^(BOOL finished) {
                                  if(self.transitionWasCancelled == YES) {
                                      self.toView.layer.transform = CATransform3DIdentity;
                                      self.toView.alpha = 1.0f;
                                  }
                                  [self completeTransition];
                              }];
}

- (CATransform3D)firstTransform {
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0f / -900.0f;
    t1 = CATransform3DScale(t1, 0.95f, 0.95f, 1.0f);
    t1 = CATransform3DRotate(t1, (15.0f * M_PI) / 180.0f, 1.0f, 0.0f, 0.0f);
    return t1;
}

- (CATransform3D)secondTransformWithView:(UIView*)view {
    CATransform3D t1 = self.firstTransform;
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0.0f, view.frame.size.height * -0.08f, 0.0f);
    t2 = CATransform3DScale(t2, 0.8f, 0.8f, 1.0f);
    return t2;
}

@end

/*--------------------------------------------------*/
