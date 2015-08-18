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

#import <MobilyCore/MobilyTabBarController.h>
#import <MobilyCore/MobilyNavigationController.h>
#import <MobilyCore/MobilySlideController.h>
#import <MobilyCore/MobilyController.h>
#import <MobilyCore/MobilyEvent.h>

/*--------------------------------------------------*/

@interface MobilyTabBarController () < UIViewControllerTransitioningDelegate, UITabBarControllerDelegate, MobilySlideControllerDelegate >

@property(nonatomic, readwrite, assign, getter=isAppeared) BOOL appeared;
@property(nonatomic, readwrite, assign, getter=isNeedUpdate) BOOL needUpdate;
@property(nonatomic, readwrite, assign) BOOL updating;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTabBarController

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(NavigationBarHidden)
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionModal);
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionNavigation);
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

- (void)setup {
    self.delegate = self;
    self.needUpdate = YES;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return self.viewControllers;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
    if(UIDevice.moSystemVersion >= 7.0f) {
        if(self.viewControllers.count < 1) {
            self.viewControllers = [_objectChilds moArrayByObjectClass:UIViewController.class];
        }
        [_eventDidLoad fireSender:self object:nil];
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
    if((UIDevice.moSystemVersion >= 6.0f) && (view == nil)) {
        [self viewDidUnload];
    }
#pragma clang diagnostic pop
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
        [self.relatedObjects moEach:^(id object) {
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
    return self.selectedViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:orientation];
}

- (BOOL)prefersStatusBarHidden {
    return self.selectedViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UIDevice.moSystemVersion < 7.0f) {
        if(self.viewControllers.count < 1) {
            self.viewControllers = [_objectChilds moArrayByObjectClass:UIViewController.class];
        }
        [_eventDidLoad fireSender:self object:nil];
    }
}

- (void)viewDidUnload {
    [_eventDidUnload fireSender:self object:nil];
    [self setNeedUpdate];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];

    if(_navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if(_appeared == NO) {
        [_eventWillAppear fireSender:self object:nil];
        self.appeared = YES;
        if(self.isNeedUpdate == YES) {
            self.needUpdate = NO;
            [self clear];
            [self update];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [_eventDidAppear fireSender:self object:nil];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [_eventWillDisappear fireSender:self object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if(_appeared == YES) {
        self.appeared = NO;
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

#pragma mark UITabBarControllerDelegate
/*
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController {
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray*)viewControllers {
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray*)viewControllers changed:(BOOL)changed {
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray*)viewControllers changed:(BOOL)changed {
}
*/
- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController* __unused)tabBarController {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController* __unused)tabBarController {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (id< UIViewControllerInteractiveTransitioning >)tabBarController:(UITabBarController* __unused)tabBarController interactionControllerForAnimationController:(id< UIViewControllerAnimatedTransitioning > __unused)animationController {
    return _transitionNavigation;
}

- (id< UIViewControllerAnimatedTransitioning >)tabBarController:(UITabBarController* __unused)tabBarController animationControllerForTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    if(_transitionNavigation != nil) {
        NSArray* viewControllers = tabBarController.viewControllers;
        if([viewControllers indexOfObject:fromViewController] > [viewControllers indexOfObject:toViewController]) {
            _transitionModal.operation = MobilyTransitionOperationPush;
        } else {
            _transitionModal.operation = MobilyTransitionOperationPop;
        }
        return _transitionNavigation;
    }
    return nil;
}

#pragma mark MobilySlideControllerDelegate

- (BOOL)canShowLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(canShowLeftControllerInSlideController:)] == YES) {
        return [controller canShowLeftControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willShowLeftControllerInSlideController:duration:)] == YES) {
        [controller willShowLeftControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didShowLeftControllerInSlideController:)] == YES) {
        [controller didShowLeftControllerInSlideController:slideController];
    }
}

- (void)willHideLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willHideLeftControllerInSlideController:duration:)] == YES) {
        [controller willHideLeftControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideLeftControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didHideLeftControllerInSlideController:)] == YES) {
        [controller didHideLeftControllerInSlideController:slideController];
    }
}

- (BOOL)canShowRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(canShowRightControllerInSlideController:)] == YES) {
        return [controller canShowRightControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willShowRightControllerInSlideController:duration:)] == YES) {
        [controller willShowRightControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didShowRightControllerInSlideController:)] == YES) {
        [controller didShowRightControllerInSlideController:slideController];
    }
}

- (void)willHideRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
        [controller willHideRightControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideRightControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
        [controller didHideRightControllerInSlideController:slideController];
    }
}

- (BOOL)canShowControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
        return [controller canShowControllerInSlideController:slideController];
    }
    return (self.viewControllers.count == 1);
}

- (void)willShowControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
        [controller willShowControllerInSlideController:slideController duration:duration];
    }
}

- (void)didShowControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
        [controller didShowControllerInSlideController:slideController];
    }
}

- (void)willHideControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willHideControllerInSlideController:duration:)] == YES) {
        [controller willHideControllerInSlideController:slideController duration:duration];
    }
}

- (void)didHideControllerInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didHideControllerInSlideController:)] == YES) {
        [controller didHideControllerInSlideController:slideController];
    }
}

- (void)willBeganLeftSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willBeganLeftSwipeInSlideController:)] == YES) {
        [controller willBeganLeftSwipeInSlideController:slideController];
    }
}

- (void)didBeganLeftSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didBeganLeftSwipeInSlideController:)] == YES) {
        [controller didBeganLeftSwipeInSlideController:slideController];
    }
}

- (void)movingLeftSwipeInSlideController:(MobilySlideController*)slideController progress:(CGFloat)progress {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(movingLeftSwipeInSlideController:progress:)] == YES) {
        [controller movingLeftSwipeInSlideController:slideController progress:progress];
    }
}

- (void)willEndedLeftSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willEndedLeftSwipeInSlideController:)] == YES) {
        [controller willEndedLeftSwipeInSlideController:slideController];
    }
}

- (void)didEndedLeftSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didEndedLeftSwipeInSlideController:)] == YES) {
        [controller didEndedLeftSwipeInSlideController:slideController];
    }
}

- (void)willBeganRightSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willBeganRightSwipeInSlideController:)] == YES) {
        [controller willBeganRightSwipeInSlideController:slideController];
    }
}

- (void)didBeganRightSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didBeganRightSwipeInSlideController:)] == YES) {
        [controller didBeganRightSwipeInSlideController:slideController];
    }
}

- (void)movingRightSwipeInSlideController:(MobilySlideController*)slideController progress:(CGFloat)progress {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(movingRightSwipeInSlideController:progress:)] == YES) {
        [controller movingRightSwipeInSlideController:slideController progress:progress];
    }
}

- (void)willEndedRightSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willEndedRightSwipeInSlideController:)] == YES) {
        [controller willEndedRightSwipeInSlideController:slideController];
    }
}

- (void)didEndedRightSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didEndedRightSwipeInSlideController:)] == YES) {
        [controller didEndedRightSwipeInSlideController:slideController];
    }
}

- (void)willBeganSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willBeganSwipeInSlideController:)] == YES) {
        [controller willBeganSwipeInSlideController:slideController];
    }
}

- (void)didBeganSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didBeganSwipeInSlideController:)] == YES) {
        [controller didBeganSwipeInSlideController:slideController];
    }
}

- (void)movingSwipeInSlideController:(MobilySlideController*)slideController progress:(CGFloat)progress {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(movingSwipeInSlideController:progress:)] == YES) {
        [controller movingSwipeInSlideController:slideController progress:progress];
    }
}

- (void)willEndedSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(willEndedSwipeInSlideController:)] == YES) {
        [controller willEndedSwipeInSlideController:slideController];
    }
}

- (void)didEndedSwipeInSlideController:(MobilySlideController*)slideController {
    UIViewController< MobilySlideControllerDelegate >* controller = (id)self.selectedViewController;
    if([controller respondsToSelector:@selector(didEndedSwipeInSlideController:)] == YES) {
        [controller didEndedSwipeInSlideController:slideController];
    }
}

@end

/*--------------------------------------------------*/
