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

#import "MobilyController.h"
#import "MobilyNavigationController.h"
#import "MobilyTabBarController.h"
#import "MobilyContext.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyController () < UIViewControllerTransitioningDelegate >

@property(nonatomic, readwrite, assign, getter=isAppeared) BOOL appeared;
@property(nonatomic, readwrite, assign, getter = isNeedUpdate) BOOL needUpdate;

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
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds relativeComplements:self.childViewControllers, nil];
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

- (id)app {
    return MobilyContext.application;
}

- (BOOL)isAppeared {
    return (_appeared > 0);
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
    if((self.isViewLoaded == YES) && ([self isAppeared] == YES)) {
        [self update];
    } else {
        self.needUpdate = YES;
    }
    [self.relatedObjects each:^(id object) {
        if([object respondsToSelector:@selector(setNeedUpdate)] == YES) {
            [object setNeedUpdate];
        }
    }];
}

- (void)update {
    [self.relatedObjects each:^(id object) {
        if([object respondsToSelector:@selector(update)] == YES) {
            [object update];
        }
    }];
}

- (void)clear {
    [self.relatedObjects each:^(id object) {
        if([object respondsToSelector:@selector(clear)] == YES) {
            [object clear];
        }
    }];
    [self setNeedUpdate];
}

#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
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
    
    [_eventWillAppear fireSender:self object:nil];
    self.appeared = _appeared + 1;
    if([self isNeedUpdate] == YES) {
        self.needUpdate = NO;
        [self update];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_eventDidAppear fireSender:self object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_eventWillDisappear fireSender:self object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.appeared = _appeared - 1;
    [_eventDidDisappear fireSender:self object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self unloadViewIfPossible];
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

@end

/*--------------------------------------------------*/
