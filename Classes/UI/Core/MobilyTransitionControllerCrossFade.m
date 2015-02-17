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

#import "MobilyTransitionController.h"

/*--------------------------------------------------*/

@implementation MobilyTransitionControllerCrossFade

#pragma mark MobilyTransitionController

- (void)animateTransition:(id< UIViewControllerContextTransitioning >)transitionContext fromVC:(UIViewController*)fromVC toVC:(UIViewController*)toVC fromView:(UIView*)fromView toView:(UIView*)toView {
    UIView* containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if(transitionContext.transitionWasCancelled) {
            fromView.alpha = 1.0;
        } else {
            [fromView removeFromSuperview];
            fromView.alpha = 1.0f;
        }
        [transitionContext completeTransition:(transitionContext.transitionWasCancelled == NO)];
    }];
}

@end

/*--------------------------------------------------*/
