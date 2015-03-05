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

#import "MobilyBuilder.h"

/*--------------------------------------------------*/

@class MobilyTransitionController;

/*--------------------------------------------------*/

@interface NSString (MobilyTransitionController)

- (MobilyTransitionController*)convertToTransitionController;

@end

/*--------------------------------------------------*/

@interface MobilyTransitionController : NSObject < UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning >

@property(nonatomic, readwrite, weak) id< UIViewControllerContextTransitioning > transitionContext;
@property(nonatomic, readwrite, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, assign) CGFloat interactiveCompletionSpeed;
@property(nonatomic, readwrite, assign) UIViewAnimationCurve interactiveCompletionCurve;
@property(nonatomic, readwrite, assign, getter=isReverse) BOOL reverse;

@property(nonatomic, readonly, weak) UIViewController* fromViewController;
@property(nonatomic, readonly, assign) CGRect initialFrameFromViewController;
@property(nonatomic, readonly, assign) CGRect finalFrameFromViewController;
@property(nonatomic, readonly, weak) UIViewController* toViewController;
@property(nonatomic, readonly, assign) CGRect initialFrameToViewController;
@property(nonatomic, readonly, assign) CGRect finalFrameToViewController;
@property(nonatomic, readonly, weak) UIView* containerView;
@property(nonatomic, readonly, weak) UIView* fromView;
@property(nonatomic, readonly, weak) UIView* toView;

- (BOOL)isAnimated;
- (BOOL)isInteractive;
- (BOOL)transitionWasCancelled;

- (void)startTransition;
- (void)completeTransition;

- (void)startInteractive;
- (void)updateInteractive:(CGFloat)percentComplete;
- (void)finishInteractive;
- (void)cancelInteractive;

@end

/*--------------------------------------------------*/

@interface MobilyTransitionControllerCrossFade : MobilyTransitionController

@end

/*--------------------------------------------------*/

@interface MobilyTransitionControllerCards : MobilyTransitionController

@end

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(name) \
- (BOOL)validate##name:(inout id*)value error:(out NSError**)error { \
    if([*value isKindOfClass:NSString.class] == YES) { \
        *value = [*value convertToTransitionController]; \
    } \
    return [*value isKindOfClass:MobilyTransitionController.class]; \
}

/*--------------------------------------------------*/
