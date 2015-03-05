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

#import "MobilyNavigationController.h"
#import "MobilyTabBarController.h"
#import "MobilyController.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyNavigationController () < UIViewControllerTransitioningDelegate, UINavigationControllerDelegate >

@property(nonatomic, readwrite, assign) NSUInteger appearedCount;
@property(nonatomic, readwrite, assign, getter=isNeedUpdate) BOOL needUpdate;
@property(nonatomic, readwrite, assign) BOOL updating;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNavigationController

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

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
    self.needUpdate = YES;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds unionWithArrays:self.childViewControllers, self.viewControllers, nil];
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

- (BOOL)isAppeared {
    return (_appearedCount > 0);
}

#pragma mark Public

- (void)setNeedUpdate {
    if(_updating == NO) {
        self.updating = YES;
        if((self.isViewLoaded == YES) && (self.isAppeared == YES)) {
            [self clear];
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
    self.appearedCount = _appearedCount - 1;
    [_eventDidDisappear fireSender:self object:nil];
    
    [super viewDidDisappear:animated];
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

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id< UIViewControllerAnimatedTransitioning >)animator {
    if(_transitionModal != nil) {
        _transitionModal.reverse = NO;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id< UIViewControllerAnimatedTransitioning >)animator {
    if(_transitionModal != nil) {
        _transitionModal.reverse = YES;
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

- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController*)navigationController {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController*)navigationController {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (id< UIViewControllerInteractiveTransitioning >)navigationController:(UINavigationController*)navigationController interactionControllerForAnimationController:(id< UIViewControllerAnimatedTransitioning >)animationController {
    return _transitionNavigation;
}

- (id< UIViewControllerAnimatedTransitioning >)navigationController:(UINavigationController*)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    if(_transitionNavigation != nil) {
        switch(operation) {
            case UINavigationControllerOperationPush: _transitionNavigation.reverse = NO; break;
            case UINavigationControllerOperationPop: _transitionNavigation.reverse = YES; break;
            default: break;
        }
        return _transitionNavigation;
    }
    return nil;
}

@end

/*--------------------------------------------------*/
