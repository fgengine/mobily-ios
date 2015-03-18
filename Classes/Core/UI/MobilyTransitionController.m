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

#import "MobilyTransitionController+Private.h"

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

@implementation MobilyTransitionController

@synthesize transitionContext = _transitionContext;
@synthesize operation = _operation;
@synthesize duration = _duration;
@synthesize percentComplete = _percentComplete;
@synthesize completionSpeed = _completionSpeed;
@synthesize completionCurve = _completionCurve;
@synthesize interactive = _interactive;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _operation = MobilyTransitionOperationPresent;
    _duration = 0.3f;
    _completionSpeed = 720.0f;
    _completionSpeed = UIViewAnimationCurveEaseOut;
    _initialFrameFromViewController = CGRectNull;
    _finalFrameFromViewController = CGRectNull;
    _initialFrameToViewController = CGRectNull;
    _finalFrameToViewController = CGRectNull;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setTransitionContext:(id< UIViewControllerContextTransitioning >)transitionContext {
    if(_transitionContext != transitionContext) {
        _transitionContext = transitionContext;
        [self _prepareTransitionContext];
    }
}

#pragma mark Public

- (BOOL)isAnimated {
    return [_transitionContext isAnimated];
}

- (BOOL)isCancelled {
    return [_transitionContext transitionWasCancelled];
}

- (void)beginInteractive {
    _interactive = YES;
}

- (void)updateInteractive:(CGFloat)percentComplete {
    if((_interactive == YES) && (_percentComplete != percentComplete)) {
        _percentComplete = percentComplete;
        [self _updateInteractive:percentComplete];
    }
}

- (void)finishInteractive {
    if(_interactive == YES) {
        [self _finishInteractive];
    }
}

- (void)cancelInteractive {
    if(_interactive == YES) {
        [self _cancelInteractive];
    }
}

- (void)endInteractive {
    _interactive = NO;
}

#pragma mark Private

- (void)_prepareTransitionContext {
    _fromViewController = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _initialFrameFromViewController = [_transitionContext initialFrameForViewController:_fromViewController];
    _finalFrameFromViewController = [_transitionContext finalFrameForViewController:_fromViewController];
    _toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    _initialFrameToViewController = [_transitionContext initialFrameForViewController:_toViewController];
    _finalFrameToViewController = [_transitionContext finalFrameForViewController:_toViewController];
    _containerView = _transitionContext.containerView;
    _fromView = (UIDevice.systemVersion >= 8.0f) ? [_transitionContext viewForKey:UITransitionContextFromViewKey] : _fromViewController.view;
    _toView = (UIDevice.systemVersion >= 8.0f) ? [_transitionContext viewForKey:UITransitionContextToViewKey] : _toViewController.view;
}

- (void)_startTransition {
}

- (void)_completeTransition {
    [_transitionContext completeTransition:([_transitionContext transitionWasCancelled] == NO)];
}

- (void)_startInteractive {
}

- (void)_updateInteractive:(CGFloat __unused)percentComplete {
    [_transitionContext updateInteractiveTransition:percentComplete];
}

- (void)_finishInteractive {
    [_transitionContext finishInteractiveTransition];
}

- (void)_cancelInteractive {
    [_transitionContext cancelInteractiveTransition];
}

- (void)_completeInteractive {
    [_transitionContext completeTransition:([_transitionContext transitionWasCancelled] == NO)];
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id< UIViewControllerContextTransitioning > __unused)transitionContext {
    return _duration;
}

- (void)animateTransition:(id< UIViewControllerContextTransitioning >)transitionContext {
    self.transitionContext = transitionContext;
    [self _startTransition];
}

- (void)animationEnded:(BOOL __unused)transitionCompleted {
}

#pragma mark UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id< UIViewControllerContextTransitioning >)transitionContext {
    if((_interactive == YES) && ([transitionContext isInteractive] == YES)) {
        self.transitionContext = transitionContext;
        [self _startInteractive];
    } else {
        [self animateTransition:transitionContext];
    }
}

- (CGFloat)completionSpeed {
    return _completionSpeed;
}

- (UIViewAnimationCurve)completionCurve {
    return _completionSpeed;
}

@end

/*--------------------------------------------------*/
