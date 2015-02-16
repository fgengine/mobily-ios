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

#import "MobilyDynamicsDrawerController.h"

/*--------------------------------------------------*/

@interface MobilyDynamicsDrawerController () < UIViewControllerTransitioningDelegate >

@property(nonatomic, readwrite, assign, getter=isAppeared) BOOL appeared;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDynamicsDrawerController

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(NavigationBarHidden)
MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(TransitionModal);
MOBILY_DEFINE_VALIDATE_EVENT(EventDidLoad)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidUnload)
MOBILY_DEFINE_VALIDATE_EVENT(EventWillAppear)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidAppear)
MOBILY_DEFINE_VALIDATE_EVENT(EventWillDisappear)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidDisappear)

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

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
}

- (void)dealloc {
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIViewController class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIViewController class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild]];
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

#pragma mark Public

- (void)showWideLeftDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateOpenWide inDirection:MSDynamicsDrawerDirectionLeft animated:animated allowUserInterruption:YES completion:completion];
}

- (void)showLeftDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:animated allowUserInterruption:YES completion:completion];
}

- (void)hideLeftDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateClosed inDirection:MSDynamicsDrawerDirectionLeft animated:animated allowUserInterruption:YES completion:completion];
}

- (void)showWideRightDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateOpenWide inDirection:MSDynamicsDrawerDirectionRight animated:animated allowUserInterruption:YES completion:completion];
}

- (void)showRightDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:animated allowUserInterruption:YES completion:completion];
}

- (void)hideRightDrawerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setPaneState:MSDynamicsDrawerPaneStateClosed inDirection:MSDynamicsDrawerDirectionRight animated:animated allowUserInterruption:YES completion:completion];
}

#pragma mark Property

- (BOOL)isAppeared {
    return (_appeared > 0);
}

- (void)setLeftDrawerViewController:(UIViewController*)leftDrawerViewController {
    [self setDrawerViewController:leftDrawerViewController forDirection:MSDynamicsDrawerDirectionLeft];
}

- (UIViewController*)leftDrawerViewController {
    return [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft];
}

- (void)setRightDrawerViewController:(UIViewController*)rightDrawerViewController {
    [self setDrawerViewController:rightDrawerViewController forDirection:MSDynamicsDrawerDirectionRight];
}

- (UIViewController*)rightDrawerViewController {
    return [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionRight];
}

#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    if([self paneViewController] != nil) {
        return [[self paneViewController] prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if([self paneViewController] != nil) {
        return [[self paneViewController] preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if([self paneViewController] != nil) {
        return [[self paneViewController] preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self paneViewController] == nil) {
        [self setPaneViewController:[_objectChilds firstObjectIsClass:[UIViewController class]]];
    }
    [_eventDidLoad fireSender:self object:nil];
}

- (void)viewDidUnload {
    [_eventDidUnload fireSender:self object:nil];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_navigationBarHidden == YES) {
        [[self navigationController] setNavigationBarHidden:YES animated:animated];
    }
    [_eventWillAppear fireSender:self object:nil];
    [self setAppeared:_appeared + 1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_eventDidAppear fireSender:self object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_navigationBarHidden == YES) {
        [[self navigationController] setNavigationBarHidden:NO animated:animated];
    }
    [_eventWillDisappear fireSender:self object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self setAppeared:_appeared - 1];
    [_eventDidDisappear fireSender:self object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self unloadViewIfPossible];
}

- (void)setView:(UIView*)view {
    [super setView:view];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if(([UIDevice systemVersion] >= 6.0f) && (view == nil)) {
        [self viewDidUnload];
    }
#pragma clang diagnostic pop
}

#pragma mark UIViewControllerTransitioningDelegate

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source {
    if(_transitionModal != nil) {
        [_transitionModal setReverse:NO];
    }
    return _transitionModal;
}

- (id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController*)dismissed {
    if(_transitionModal != nil) {
        [_transitionModal setReverse:YES];
    }
    return _transitionModal;
}

@end

/*--------------------------------------------------*/
