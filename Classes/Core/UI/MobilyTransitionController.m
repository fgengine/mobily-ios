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

#define MOBILY_TRANSITION_CONTROLLER_CLASS          @"MobilyTransitionController%@"

/*--------------------------------------------------*/

@implementation NSString (MobilyTransitionController)

- (MobilyTransitionController*)convertToTransitionController {
    static NSCharacterSet* characterSet = nil;
    if(characterSet == nil) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@":-"];
    }
    NSString* validKey = NSString.string;;
    NSArray* components = [self componentsSeparatedByCharactersInSet:characterSet];
    if(components.count > 1) {
        for(NSString* component in components) {
            validKey = [validKey stringByAppendingString:[component stringByUppercaseFirstCharacterString]];
        }
    } else {
        validKey = [self stringByUppercaseFirstCharacterString];
    }
    Class resultClass = nil;
    if(validKey.length > 0) {
        Class defaultClass = NSClassFromString([NSString stringWithFormat:MOBILY_TRANSITION_CONTROLLER_CLASS, validKey]);
        if([defaultClass isSubclassOfClass:MobilyTransitionController.class] == YES) {
            resultClass = defaultClass;
        } else {
            Class customClass = NSClassFromString(self);
            if([customClass isSubclassOfClass:MobilyTransitionController.class] == YES) {
                resultClass = customClass;
            }
        }
    }
    MobilyTransitionController* result = nil;
    if(resultClass != nil) {
        result = [resultClass new];
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyTransitionController ()

@property(nonatomic, readwrite, weak) UIViewController* fromViewController;
@property(nonatomic, readwrite, assign) CGRect initialFrameFromViewController;
@property(nonatomic, readwrite, assign) CGRect finalFrameFromViewController;
@property(nonatomic, readwrite, weak) UIViewController* toViewController;
@property(nonatomic, readwrite, assign) CGRect initialFrameToViewController;
@property(nonatomic, readwrite, assign) CGRect finalFrameToViewController;
@property(nonatomic, readwrite, weak) UIView* containerView;
@property(nonatomic, readwrite, weak) UIView* fromView;
@property(nonatomic, readwrite, weak) UIView* toView;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTransitionController

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.duration = 1.0f;
    self.interactiveCompletionSpeed = 720.0f;
    self.interactiveCompletionSpeed = UIViewAnimationCurveEaseOut;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setTransitionContext:(id< UIViewControllerContextTransitioning >)transitionContext {
    if(_transitionContext != transitionContext) {
        _transitionContext = transitionContext;
        
        self.fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        self.toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        self.containerView = _transitionContext.containerView;
        self.fromView = (UIDevice.systemVersion >= 8.0f) ? [_transitionContext viewForKey:UITransitionContextFromViewKey] : _fromViewController.view;
        self.toView = (UIDevice.systemVersion >= 8.0f) ? [_transitionContext viewForKey:UITransitionContextToViewKey] : _toViewController.view;
    }
}

- (void)setFromViewController:(UIViewController*)fromViewController {
    if(_fromViewController != fromViewController) {
        _fromViewController = fromViewController;
        
        self.initialFrameFromViewController = [_transitionContext initialFrameForViewController:_fromViewController];
        self.finalFrameFromViewController = [_transitionContext finalFrameForViewController:_fromViewController];
    }
}

- (void)setToViewController:(UIViewController*)toViewController {
    if(_toViewController != toViewController) {
        _toViewController = toViewController;
        
        self.initialFrameToViewController = [_transitionContext initialFrameForViewController:_toViewController];
        self.finalFrameToViewController = [_transitionContext finalFrameForViewController:_toViewController];
    }
}

#pragma mark Public

- (BOOL)isAnimated {
    return [_transitionContext isAnimated];
}

- (BOOL)isInteractive {
    return [_transitionContext isInteractive];
}

- (BOOL)transitionWasCancelled {
    return [_transitionContext transitionWasCancelled];
}

- (void)startTransition {
}

- (void)completeTransition {
    [_transitionContext completeTransition:(_transitionContext.transitionWasCancelled == NO)];
}

- (void)startInteractive {
    [self startInteractive];
}

- (void)updateInteractive:(CGFloat)percentComplete {
    [_transitionContext updateInteractiveTransition:percentComplete];
}

- (void)finishInteractive {
    [_transitionContext finishInteractiveTransition];
}

- (void)cancelInteractive {
    [_transitionContext cancelInteractiveTransition];
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id< UIViewControllerContextTransitioning >)transitionContext {
    return _duration;
}

- (void)animateTransition:(id< UIViewControllerContextTransitioning >)transitionContext {
    self.transitionContext = transitionContext;
    [self startTransition];
}

#pragma mark UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id< UIViewControllerContextTransitioning >)transitionContext {
    self.transitionContext = transitionContext;
}

- (CGFloat)completionSpeed {
    return _interactiveCompletionSpeed;
}

- (UIViewAnimationCurve)completionCurve {
    return _interactiveCompletionSpeed;
}

@end

/*--------------------------------------------------*/
