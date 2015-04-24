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

#import <MobilyNavigationController.h>
#import <MobilyTabBarController.h>
#import <MobilySlideController.h>
#import <MobilyController.h>
#import <MobilyEvent.h>

/*--------------------------------------------------*/

#import <MobilyTransitionController.h>

/*--------------------------------------------------*/

@interface MobilyNavigationController () < UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, MobilySlideControllerDelegate >

@property(nonatomic, readwrite, assign) NSUInteger appearedCount;
@property(nonatomic, readwrite, assign, getter=isNeedUpdate) BOOL needUpdate;
@property(nonatomic, readwrite, assign) BOOL updating;

@property(nonatomic, readwrite, strong) UIScreenEdgePanGestureRecognizer* interactiveGesture;

- (void)interactiveGestureHandle:(UIPanGestureRecognizer* __unused)interactiveGesture;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNavigationController

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize interactiveGesture = _interactiveGesture;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionModal);
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionNavigation);
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionInteractive);
MOBILY_DEFINE_VALIDATE_EVENT(EventDidLoad)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidUnload)
MOBILY_DEFINE_VALIDATE_EVENT(EventWillAppear)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidAppear)
MOBILY_DEFINE_VALIDATE_EVENT(EventWillDisappear)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidDisappear)

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString*)nib bundle:(NSBundle*)bundle {
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController*)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.interactiveGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveGestureHandle:)];
    self.transitionInteractive = [MobilyTransitionControllerSlide new];
    self.needUpdate = YES;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds unionWithArrays:self.childViewControllers, nil];
    }
    return [self.childViewControllers unionWithArray:self.viewControllers];
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
    if(self.rootViewController == nil) {
        UIViewController* viewController = [_objectChilds firstObjectIsClass:UIViewController.class];
        if(viewController != nil) {
            self.viewControllers = @[ viewController ];
        }
    }
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Property

- (void)setView:(UIView*)view {
    super.view = view;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if((UIDevice.systemVersion >= 6.0f) && (view == nil)) {
        [self viewDidUnload];
    }
#pragma clang diagnostic pop
}

- (void)setInteractiveGesture:(UIScreenEdgePanGestureRecognizer*)interactiveGesture {
    if(_interactiveGesture != interactiveGesture) {
        if(_interactiveGesture != nil) {
            [self.view removeGestureRecognizer:_interactiveGesture];
        }
        _interactiveGesture = interactiveGesture;
        if(_interactiveGesture != nil) {
            _interactiveGesture.delegate = self;
            _interactiveGesture.edges = UIRectEdgeLeft;
            [self.view addGestureRecognizer:_interactiveGesture];

        }
    }
}

- (BOOL)isAppeared {
    return (_appearedCount > 0);
}

#pragma mark Public

- (void)setNeedUpdate {
    if(_updating == NO) {
        self.updating = YES;
        [self clear];
        if(self.isAppeared == YES) {
            [self update];
        } else {
            self.needUpdate = YES;
        }
        [self.relatedObjects each:^(id object) {
            if([object respondsToSelector:@selector(setNeedUpdate)] == YES) {
                [object setNeedUpdate];
            }
        }];
        self.updating = NO;
    }
}

- (void)update {
}

- (void)clear {
}

#pragma mark UIViewController

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return [self.topViewController shouldAutorotateToInterfaceOrientation:orientation];
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.topViewController.preferredStatusBarUpdateAnimation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.rootViewController == nil) {
        UIViewController* viewController = [_objectChilds firstObjectIsClass:UIViewController.class];
        if(viewController != nil) {
            self.viewControllers = @[ viewController ];
        }
    }
    [_eventDidLoad fireSender:self object:nil];
}

- (void)viewDidUnload {
    [_eventDidUnload fireSender:self object:nil];
    [self setNeedUpdate];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    [_eventWillAppear fireSender:self object:nil];
    self.appearedCount = _appearedCount + 1;
    if(self.isNeedUpdate == YES) {
        self.needUpdate = NO;
        [self clear];
        [self update];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [_eventDidAppear fireSender:self object:nil];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_eventWillDisappear fireSender:self object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_appearedCount > 0) {
        self.appearedCount = _appearedCount - 1;
        [_eventDidDisappear fireSender:self object:nil];
    }
    [super viewDidDisappear:animated];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController* __unused)presented presentingController:(UIViewController* __unused)presenting sourceController:(UIViewController* __unused)source {
    if(_transitionModal != nil) {
        _transitionModal.operation = MobilyTransitionOperationPresent;
    }
    return _transitionModal;
}

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController* __unused)dismissed {
    if(_transitionModal != nil) {
        _transitionModal.operation = MobilyTransitionOperationDismiss;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id< UIViewControllerAnimatedTransitioning > __unused)animator {
    if(_transitionModal != nil) {
        _transitionModal.operation = MobilyTransitionOperationPresent;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id< UIViewControllerAnimatedTransitioning > __unused)animator {
    if(_transitionModal != nil) {
        _transitionModal.operation = MobilyTransitionOperationDismiss;
    }
    return _transitionModal;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:MobilyController.class] == YES) {
        MobilyController* mobilyController = (MobilyController*)viewController;
        [navigationController setNavigationBarHidden:mobilyController.isNavigationBarHidden animated:animated];
    }
}

- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController* __unused)navigationController {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController* __unused)navigationController {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (id< UIViewControllerInteractiveTransitioning >)navigationController:(UINavigationController* __unused)navigationController interactionControllerForAnimationController:(id< UIViewControllerAnimatedTransitioning > __unused)animationController {
    if(animationController == _transitionInteractive) {
        return _transitionInteractive;
    }
    return nil;
}

- (id< UIViewControllerAnimatedTransitioning >)navigationController:(UINavigationController* __unused)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController* __unused)fromViewController toViewController:(UIViewController* __unused)toViewController {
    if((_transitionInteractive != nil) && (_transitionInteractive.isInteractive == YES)) {
        switch(operation) {
            case UINavigationControllerOperationPush: _transitionInteractive.operation = MobilyTransitionOperationPush; break;
            case UINavigationControllerOperationPop: _transitionInteractive.operation = MobilyTransitionOperationPop; break;
            default: break;
        }
        return _transitionInteractive;
    } else if(_transitionNavigation != nil) {
        switch(operation) {
            case UINavigationControllerOperationPush: _transitionNavigation.operation = MobilyTransitionOperationPush; break;
            case UINavigationControllerOperationPop: _transitionNavigation.operation = MobilyTransitionOperationPop; break;
            default: break;
        }
        return _transitionNavigation;
    }
    return nil;
}

#pragma mark Private

- (void)interactiveGestureHandle:(UIPanGestureRecognizer* __unused)interactiveGesture {
    CGPoint translation = [_interactiveGesture translationInView:self.view];
    CGFloat progress = translation.x / self.view.frame.size.width;
    switch(_interactiveGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [_transitionInteractive beginInteractive];
            [self popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [_transitionInteractive updateInteractive:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if((_transitionInteractive.isCancelled == NO) && (progress >= 0.3f)) {
                [_transitionInteractive finishInteractive];
            } else {
                [_transitionInteractive cancelInteractive];
            }
            [_transitionInteractive endInteractive];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(_transitionInteractive != nil) {
        if(_transitionInteractive.isAnimated == NO) {
            if(self.viewControllers.count > 1) {
                if(gestureRecognizer == _interactiveGesture) {
                    return YES;
                } else if(gestureRecognizer == self.interactivePopGestureRecognizer) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

#pragma mark MobilySlideControllerDelegate

- (BOOL)canShowLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(canShowLeftControllerInSlideController:)] == YES) {
        return [controller canShowLeftControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willShowLeftControllerInSlideController:duration:)] == YES) {
        [controller willShowLeftControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didShowLeftControllerInSlideController:)] == YES) {
        [controller didShowLeftControllerInSlideController:slideController];
    }
}

- (void)willHideLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willHideLeftControllerInSlideController:duration:)] == YES) {
        [controller willHideLeftControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didHideLeftControllerInSlideController:)] == YES) {
        [controller didHideLeftControllerInSlideController:slideController];
    }
}

- (BOOL)canShowRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(canShowRightControllerInSlideController:)] == YES) {
        return [controller canShowRightControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willShowRightControllerInSlideController:duration:)] == YES) {
        [controller willShowRightControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didShowRightControllerInSlideController:)] == YES) {
        [controller didShowRightControllerInSlideController:slideController];
    }
}

- (void)willHideRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
        [controller willHideRightControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
        [controller didHideRightControllerInSlideController:slideController];
    }
}

- (BOOL)canShowControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
        return [controller canShowControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
        [controller willShowControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
        [controller didShowControllerInSlideController:slideController];
    }
}

- (void)willHideControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(willHideControllerInSlideController:duration:)] == YES) {
        [controller willHideControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.topViewController;
    if([controller respondsToSelector:@selector(didHideControllerInSlideController:)] == YES) {
        [controller didHideControllerInSlideController:slideController];
    }
}

@end

/*--------------------------------------------------*/
