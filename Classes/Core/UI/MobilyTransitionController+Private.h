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

#import <Mobily/MobilyTransitionController.h>

/*--------------------------------------------------*/

@interface MobilyTransitionController () {
@protected
    __weak id< UIViewControllerContextTransitioning > _transitionContext;
    MobilyTransitionOperation _operation;
    NSTimeInterval _duration;
    CGFloat _percentComplete;
    CGFloat _completionSpeed;
    UIViewAnimationCurve _completionCurve;
    BOOL _interactive;
    
    __weak UIViewController* _fromViewController;
    CGRect _initialFrameFromViewController;
    CGRect _finalFrameFromViewController;
    __weak UIViewController* _toViewController;
    CGRect _initialFrameToViewController;
    CGRect _finalFrameToViewController;
    UIView* _containerView;
    UIView* _fromView;
    UIView* _toView;
}

- (void)_prepareTransitionContext;

- (void)_startTransition;
- (void)_completeTransition;

- (void)_startInteractive;
- (void)_updateInteractive:(CGFloat)percentComplete;
- (void)_finishInteractive;
- (void)_cancelInteractive;
- (void)_completeInteractive;

@end

/*--------------------------------------------------*/
