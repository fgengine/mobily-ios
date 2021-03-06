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

#import <MobilyCore/MobilyController.h>
#import <MobilyCore/MobilyNavigationController.h>
#import <MobilyCore/MobilyTabBarController.h>
#import <MobilyCore/MobilyContext.h>
#import <MobilyCore/MobilyEvent.h>

/*--------------------------------------------------*/

@interface MobilyController () < UIViewControllerTransitioningDelegate >

@property(nonatomic, readwrite, assign, getter=isAppeared) BOOL appeared;
@property(nonatomic, readwrite, assign, getter=isNeedUpdate) BOOL needUpdate;
@property(nonatomic, readwrite, assign) BOOL updating;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyController

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(StatusBarHidden)
MOBILY_DEFINE_VALIDATE_STATUS_BAR_STYLE(StatusBarStyle)
MOBILY_DEFINE_VALIDATE_STATUS_BAR_ANIMATION(StatusBarAnimation)
MOBILY_DEFINE_VALIDATE_BOOL(NavigationBarHidden)
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionModal);
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
    self.needUpdate = YES;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return self.childViewControllers;
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
    if(view != nil) {
        view.clipsToBounds = YES;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if((UIDevice.moSystemVersion >= 6.0f) && (view == nil)) {
        [self viewDidUnload];
    }
#pragma clang diagnostic pop
}

- (id)app {
    return MobilyContext.application;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if(_statusBarHidden != statusBarHidden) {
        _statusBarHidden = statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if(_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarAnimation:(UIStatusBarAnimation)statusBarAnimation {
    if(_statusBarAnimation != statusBarAnimation) {
        _statusBarAnimation = statusBarAnimation;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

#pragma mark Public

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    if(_navigationBarHidden != navigationBarHidden) {
        _navigationBarHidden = navigationBarHidden;
        
        if(self.isViewLoaded == YES) {
            [self.navigationController setNavigationBarHidden:_navigationBarHidden animated:animated];
        }
    }
}

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

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return _statusBarAnimation;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self moUnloadViewIfPossible];
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
        _transitionModal.operation = MobilyTransitionOperationDismiss;
    }
    return _transitionModal;
}

- (id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id< UIViewControllerAnimatedTransitioning > __unused)animator {
    if(_transitionModal != nil) {
        _transitionModal.operation = MobilyTransitionOperationDismiss;
    }
    return _transitionModal;
}

@end

/*--------------------------------------------------*/
