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

#import <MobilyCore/MobilyNotificationManager.h>

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyNotificationWindow : UIWindow {
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyNotificationController : UIViewController {
@protected
    __weak UIWindow* _parentWindow;
    UIStatusBarStyle _statusBarStyle;
    NSMutableArray* _queue;
}

@property(nonatomic, readwrite, weak) UIWindow* parentWindow;
@property(nonatomic, readwrite, assign) UIStatusBarStyle statusBarStyle;

- (MobilyNotificationView*)pushView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilySimpleBlock)pressed;
- (void)popNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated;
- (void)popAllAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyNotificationView () {
@protected
    __weak MobilyNotificationController* _controller;
    UITapGestureRecognizer* _tapGesture;
    NSTimer* _timer;
@protected
    UIView* _view;
    NSLayoutConstraint* _constraintViewCenterX;
    NSLayoutConstraint* _constraintViewCenterY;
    NSLayoutConstraint* _constraintViewWidth;
    NSLayoutConstraint* _constraintViewHeight;
    NSTimeInterval _duration;
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
    MobilyNotificationPressed _pressed;
}

@property(nonatomic, readwrite, weak) MobilyNotificationController* controller;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintControllerTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintControllerLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintControllerRight;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic, readwrite, strong) NSTimer* timer;

@property(nonatomic, readwrite, strong) UIView* view;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintViewCenterX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintViewHeight;
@property(nonatomic, readwrite, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, copy) MobilyNotificationPressed pressed;

- (instancetype)initWithController:(MobilyNotificationController*)controller view:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilyNotificationPressed)pressed;

- (IBAction)pressed:(id)sender;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyNotificationManager () {
@protected
    MobilyNotificationWindow* _window;
    MobilyNotificationController* _controller;
}

@property(nonatomic, readonly, strong) MobilyNotificationWindow* window;
@property(nonatomic, readonly, strong) MobilyNotificationController* controller;

+ (instancetype)shared;

- (MobilyNotificationView*)_showView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilySimpleBlock)pressed;
- (void)_hideNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated;
- (void)_hideAllAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNotificationWindow

#pragma mark Init / Free

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark Public override

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView* view = [super hitTest:point withEvent:event];
    if(view == self.rootViewController.view) {
        view = nil;
    }
    return view;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static NSTimeInterval MobilyNotificationController_ShowDutation = 0.1f;
static NSTimeInterval MobilyNotificationController_HideDutation = 0.2f;

/*--------------------------------------------------*/

@implementation MobilyNotificationController

#pragma mark Synthesize

@synthesize parentWindow = _parentWindow;
@synthesize statusBarStyle = _statusBarStyle;

#pragma mark Init / Free

- (instancetype)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle {
    self = [super initWithNibName:nibName bundle:bundle];
    if(self != nil) {
        _statusBarStyle = UIStatusBarStyleDefault;
        _queue = [NSMutableArray array];
    }
    return self;
}

#pragma mark Property

- (void)setParentWindow:(UIWindow*)parentWindow {
    if(_parentWindow != parentWindow) {
        _parentWindow = parentWindow;
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if(_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

#pragma mark Public override

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(_queue.count > 0) {
        return _statusBarStyle;
    }
    return [_parentWindow.rootViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [_parentWindow.rootViewController prefersStatusBarHidden];
}

- (BOOL)shouldAutorotate {
    return [_parentWindow.rootViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [_parentWindow.rootViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return [_parentWindow.rootViewController shouldAutorotateToInterfaceOrientation:orientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark Public

- (MobilyNotificationView*)pushView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilySimpleBlock)pressed {
    MobilyNotificationView* notificationView = [[MobilyNotificationView alloc] initWithController:self view:view duration:duration pressed:pressed];
    if(notificationView != nil) {
        [_queue insertObject:notificationView atIndex:0];
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        [self _showNotificationView:notificationView animated:YES];
    }
    return notificationView;
}

- (void)popNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated {
    if([_queue containsObject:notificationView] == YES) {
        [self _hideNotificationView:notificationView animated:animated];
        [_queue removeObject:notificationView];
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)popAllAnimated:(BOOL)animated {
    if(_queue.count > 0) {
        [_queue each:^(MobilyNotificationView* notificationView) {
            [self _hideNotificationView:notificationView animated:animated];
            [_queue removeObject:notificationView];
            if(UIDevice.systemVersion >= 7.0f) {
                [self setNeedsStatusBarAppearanceUpdate];
            }
        } options:NSEnumerationReverse];
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

#pragma mark Private

- (void)_showNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated {
    MobilyNotificationView* prevNotificationView = [_queue prevObjectOfObject:notificationView];
    MobilyNotificationView* nextNotificationView = [_queue nextObjectOfObject:notificationView];
    notificationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:notificationView];
    if(animated == YES) {
        if(prevNotificationView != nil) {
            notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:prevNotificationView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        } else {
            notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
    }
    notificationView.constraintControllerLeft = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    notificationView.constraintControllerRight = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    if(nextNotificationView != nil) {
        nextNotificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:nextNotificationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:notificationView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    }
    if(animated == YES) {
        [self.view layoutIfNeeded];
    }
    if(prevNotificationView != nil) {
        notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:prevNotificationView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    } else {
        notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    }
    [notificationView willShow];
    if(animated == YES) {
        [UIView animateWithDuration:MobilyNotificationController_ShowDutation delay:0.0f options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [notificationView didShow];
        }];
    } else {
        [notificationView didShow];
    }
}

- (void)_hideNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated {
    MobilyNotificationView* prevNotificationView = [_queue prevObjectOfObject:notificationView];
    MobilyNotificationView* nextNotificationView = [_queue nextObjectOfObject:notificationView];
    if(prevNotificationView != nil) {
        notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:prevNotificationView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    } else {
        notificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:notificationView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    }
    if(nextNotificationView != nil) {
        if(prevNotificationView != nil) {
            nextNotificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:nextNotificationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:prevNotificationView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        } else {
            nextNotificationView.constraintControllerTop = [NSLayoutConstraint constraintWithItem:nextNotificationView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
    }
    [notificationView willHide];
    if(animated == YES) {
        [UIView animateWithDuration:MobilyNotificationController_HideDutation delay:0.0f options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut) animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            notificationView.constraintControllerTop = nil;
            notificationView.constraintControllerLeft = nil;
            notificationView.constraintControllerRight = nil;
            [notificationView removeFromSuperview];
            [notificationView didHide];
        }];
    } else {
        notificationView.constraintControllerTop = nil;
        notificationView.constraintControllerLeft = nil;
        notificationView.constraintControllerRight = nil;
        [notificationView removeFromSuperview];
        [notificationView didHide];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNotificationView

#pragma mark Synthesize

@synthesize controller = _controller;
@synthesize constraintControllerTop = _constraintControllerTop;
@synthesize constraintControllerLeft = _constraintControllerLeft;
@synthesize constraintControllerRight = _constraintControllerRight;
@synthesize tapGesture = _tapGesture;
@synthesize timer = _timer;
@synthesize view = _view;
@synthesize constraintViewCenterX = _constraintViewCenterX;
@synthesize constraintViewCenterY = _constraintViewCenterY;
@synthesize constraintViewWidth = _constraintViewWidth;
@synthesize constraintViewHeight = _constraintViewHeight;
@synthesize duration = _duration;
@synthesize pressed = _pressed;

#pragma mark Init / Free

- (instancetype)initWithController:(MobilyNotificationController*)controller view:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilyNotificationPressed)pressed {
    self = [super initWithFrame:view.bounds];
    if(self != nil) {
        self.controller = controller;
        self.view = view;
        self.duration = duration;
        self.pressed = [pressed copy];
    }
    return self;
}

#pragma mark Public override

- (void)updateConstraints {
    if(_view != nil) {
        if(_constraintViewCenterX == nil) {
            self.constraintViewCenterX = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        }
        if(_constraintViewCenterY == nil) {
            self.constraintViewCenterY = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintViewWidth == nil) {
            self.constraintViewWidth = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        }
        if(_constraintViewHeight == nil) {
            self.constraintViewHeight = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintViewCenterX = nil;
        self.constraintViewCenterY = nil;
        self.constraintViewWidth = nil;
        self.constraintViewHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintControllerTop, constraintControllerTop, _controller.view, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintControllerLeft, constraintControllerLeft, _controller.view, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintControllerRight, constraintControllerRight, _controller.view, {
}, {
})

- (void)setView:(UIView*)view {
    if(_view != view) {
        if(_view != nil) {
            [_view removeFromSuperview];
        }
        _view = view;
        if(_view != nil) {
            _view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_view];
        }
        [self setNeedsUpdateConstraints];
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintViewCenterX, constraintViewCenterX, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintViewCenterY, constraintViewCenterY, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintViewWidth, constraintViewWidth, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintViewHeight, constraintViewHeight, self, {
}, {
})

- (void)setTimer:(NSTimer*)timer {
    if(_timer != timer) {
        if(_timer != nil) {
            [_timer invalidate];
        }
        _timer = timer;
        if(_timer != nil) {
            [NSRunLoop.mainRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)setTapGesture:(UITapGestureRecognizer*)tapGesture {
    if(_tapGesture != tapGesture) {
        if(_tapGesture != nil) {
            [self removeGestureRecognizer:_tapGesture];
        }
        _tapGesture = tapGesture;
        if(_tapGesture != nil) {
            [self addGestureRecognizer:_tapGesture];
        }
    }
}

#pragma mark Public

- (void)hideAnimated:(BOOL)animated {
    [_controller popNotificationView:self animated:animated];
}

- (void)willShow {
}

- (void)didShow {
    if(_duration > MOBILY_EPSILON) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(hideTimer:) userInfo:nil repeats:NO];
    }
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
}

- (void)willHide {
    self.tapGesture = nil;
    self.timer = nil;
}

- (void)didHide {
}

#pragma mark Actions

- (IBAction)hideTimer:(id)sender {
    [self hideAnimated:YES];
}

- (IBAction)pressed:(id)sender {
    self.timer = nil;
    if(_pressed != nil) {
        _pressed(self);
    } else {
        [self hideAnimated:YES];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static NSTimeInterval MobilyNotificationManager_Dutation = 3.0f;

/*--------------------------------------------------*/

@implementation MobilyNotificationManager

#pragma mark Synthesize

@synthesize window = _window;
@synthesize controller = _controller;

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [self new];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.window.hidden = NO;
    }
    return self;
}

#pragma mark Public

+ (void)setParentWindow:(UIWindow*)parentWindow {
    [[self.shared controller] setParentWindow:parentWindow];
}

+ (UIWindow*)parentWindow {
    return [[self.shared controller] parentWindow];
}

+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    [[self.shared controller] setStatusBarStyle:statusBarStyle];
}

+ (UIStatusBarStyle)statusBarStyle {
    return [[self.shared controller] statusBarStyle];
}

+ (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if(statusBarHidden == YES) {
        [[self.shared window] setWindowLevel:UIWindowLevelStatusBar + 1];
    } else {
        [[self.shared window] setWindowLevel:UIWindowLevelStatusBar - 1];
    }
}

+ (BOOL)statusBarHidden {
    return [[self.shared window] windowLevel] > UIWindowLevelStatusBar;
}

+ (MobilyNotificationView*)showView:(UIView*)view {
    return [self.shared _showView:view duration:MobilyNotificationManager_Dutation pressed:nil];
}

+ (MobilyNotificationView*)showView:(UIView*)view pressed:(MobilyNotificationPressed)pressed {
    return [self.shared _showView:view duration:MobilyNotificationManager_Dutation pressed:pressed];
}

+ (MobilyNotificationView*)showView:(UIView*)view duration:(NSTimeInterval)duration {
    return [self.shared _showView:view duration:duration pressed:nil];
}

+ (MobilyNotificationView*)showView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilyNotificationPressed)pressed {
    return [self.shared _showView:view duration:duration pressed:pressed];
}

+ (void)hideNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated {
}

+ (void)hideAllAnimated:(BOOL)animated {
    [self.shared _hideAllAnimated:animated];
}

#pragma mark Property

- (MobilyNotificationWindow*)window {
    if(_window == nil) {
        _window = [[MobilyNotificationWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _window.windowLevel = UIWindowLevelStatusBar - 1.0f;
        _window.rootViewController = self.controller;
    }
    return _window;
}

- (MobilyNotificationController*)controller {
    if(_controller == nil) {
        _controller = [MobilyNotificationController new];
        _controller.parentWindow = UIApplication.sharedApplication.keyWindow;
    }
    return _controller;
}

#pragma mark Private

- (MobilyNotificationView*)_showView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilySimpleBlock)pressed {
    return [self.controller pushView:view duration:duration pressed:pressed];
}

- (void)_hideNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated {
    [self.controller popNotificationView:notificationView animated:animated];
}

- (void)_hideAllAnimated:(BOOL)animated {
    [self.controller popAllAnimated:animated];
}

@end

/*--------------------------------------------------*/
