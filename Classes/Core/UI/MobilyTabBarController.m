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

#import "MobilyTabBarController.h"
#import "MobilyNavigationController.h"
#import "MobilyController.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyTabBarController () < UIViewControllerTransitioningDelegate, UITabBarControllerDelegate >

@property(nonatomic, readwrite, assign, getter=isAppeared) BOOL appeared;

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
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

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
    if(UIDevice.systemVersion >= 7.0f) {
        if(self.viewControllers.count < 1) {
            self.viewControllers = [_objectChilds arrayByObjectClass:UIViewController.class];
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

- (BOOL)isAppeared {
    return (_appeared > 0);
}

#pragma mark Public

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
    
    if(UIDevice.systemVersion < 7.0f) {
        if(self.viewControllers.count < 1) {
            self.viewControllers = [_objectChilds arrayByObjectClass:UIViewController.class];
        }
        [_eventDidLoad fireSender:self object:nil];
    }
}

- (void)viewDidUnload {
    [_eventDidUnload fireSender:self object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if(_navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [_eventWillAppear fireSender:self object:nil];
    self.appeared = _appeared + 1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_eventDidAppear fireSender:self object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_navigationBarHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [_eventWillDisappear fireSender:self object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.appeared = _appeared - 1;
    [_eventDidDisappear fireSender:self object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)setView:(UIView*)view {
    super.view = view;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if((UIDevice.systemVersion >= 6.0f) && (view == nil)) {
        [self viewDidUnload];
    }
#pragma clang diagnostic pop
}

#pragma mark UIViewControllerTransitioningDelegate

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source {
    if(_transitionModal != nil) {
        _transitionModal.reverse = NO;
    }
    return _transitionModal;
}

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController*)dismissed {
    if(_transitionModal != nil) {
        _transitionModal.reverse = YES;
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
- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController*)tabBarController {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController*)tabBarController {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (id< UIViewControllerInteractiveTransitioning >)tabBarController:(UITabBarController*)tabBarController interactionControllerForAnimationController:(id< UIViewControllerAnimatedTransitioning >)animationController {
    return nil;
}

- (id< UIViewControllerAnimatedTransitioning >)tabBarController:(UITabBarController*)tabBarController animationControllerForTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    if(_transitionNavigation != nil) {
        NSArray* viewControllers = tabBarController.viewControllers;
        _transitionNavigation.reverse = [viewControllers indexOfObject:fromViewController] < [viewControllers indexOfObject:toViewController];
        return _transitionNavigation;
    }
    return nil;
}

@end

/*--------------------------------------------------*/