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
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
    NSMutableArray* _queue;
}

@property(nonatomic, readwrite, assign) UIStatusBarStyle statusBarStyle;
@property(nonatomic, readwrite, assign) BOOL statusBarHidden;

- (void)pushView:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed;
- (void)popTopAnimated:(BOOL)animated;
- (void)popAllAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyNotificationView : UIView {
@protected
    __weak MobilyNotificationController* _controller;
    UITapGestureRecognizer* _tapGesture;
    NSTimer* _timer;
@protected
    UIView* _view;
    NSTimeInterval _duration;
    UIStatusBarStyle _statusBarStyle;
    BOOL _statusBarHidden;
    MobilySimpleBlock _pressed;
}

@property(nonatomic, readwrite, weak) MobilyNotificationController* controller;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic, readwrite, strong) NSTimer* timer;

@property(nonatomic, readwrite, strong) UIView* view;
@property(nonatomic, readwrite, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, assign) UIStatusBarStyle statusBarStyle;
@property(nonatomic, readwrite, assign) BOOL statusBarHidden;
@property(nonatomic, readwrite, copy) MobilySimpleBlock pressed;

- (instancetype)initWithController:(MobilyNotificationController*)controller view:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed;

- (void)willShow;
- (void)didShow;
- (void)willHide;
- (void)didHide;

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

- (void)_showView:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed;
- (void)_hideTopAnimated:(BOOL)animated;
- (void)_hideAllAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNotificationWindow

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

@implementation MobilyNotificationController

#pragma mark Synthesize

@synthesize statusBarStyle = _statusBarStyle;
@synthesize statusBarHidden = _statusBarHidden;

#pragma mark Init / Free

- (instancetype)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle {
    self = [super initWithNibName:nibName bundle:bundle];
    if(self != nil) {
        _queue = [NSMutableArray array];
    }
    return self;
}

#pragma mark Property

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if(_statusBarStyle != statusBarStyle) {
        _statusBarStyle = statusBarStyle;
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if(_statusBarHidden != statusBarHidden) {
        _statusBarHidden = statusBarHidden;
        if(UIDevice.systemVersion >= 7.0f) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

#pragma mark Public override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

#pragma mark Public

- (void)pushView:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed {
    [_queue addObject:[[MobilyNotificationView alloc] initWithController:self view:view duration:duration statusBarStyle:statusBarStyle statusBarHidden:statusBarHidden pressed:pressed]];
    if(_queue.count == 1) {
        [self _showNextViewAnimated:YES];
    }
}

- (void)popTopAnimated:(BOOL)animated {
}

- (void)popAllAnimated:(BOOL)animated {
}

#pragma mark Private

- (void)_showNextViewAnimated:(BOOL)animated {
    MobilyNotificationView* view = _queue.firstObject;
    [self.view addSubview:view];
}

- (void)_hideTopViewAnimated:(BOOL)animated {
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyNotificationView

#pragma mark Synthesize

@synthesize controller = _controller;
@synthesize tapGesture = _tapGesture;
@synthesize timer = _timer;
@synthesize view = _view;
@synthesize duration = _duration;
@synthesize statusBarStyle = _statusBarStyle;
@synthesize statusBarHidden = _statusBarHidden;
@synthesize pressed = _pressed;

#pragma mark Init / Free

- (instancetype)initWithController:(MobilyNotificationController*)controller view:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed {
    self = [super initWithFrame:view.bounds];
    if(self != nil) {
        _controller = controller;
        _view = view;
        _view.translatesAutoresizingMaskIntoConstraints = NO;
        _duration = duration;
        _statusBarStyle = statusBarStyle;
        _statusBarHidden = statusBarHidden;
        _pressed = [pressed copy];
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:_view];
}

#pragma mark Public override

#pragma mark Public

- (void)willShow {
}

- (void)didShow {
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(pressed:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
    [self addGestureRecognizer:_tapGesture];
}

- (void)willHide {
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    if(_tapGesture != nil) {
        [self removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
}

- (void)didHide {
}

#pragma mark Actions

- (IBAction)pressed:(id)sender {
    [_controller popTopAnimated:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static NSTimeInterval MobilyNotificationManager_Dutation = 3.0f;
static UIStatusBarStyle MobilyNotificationManager_StatusBarStyle = UIStatusBarStyleDefault;
static BOOL MobilyNotificationManager_StatusBarHidden = NO;

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
        [self.window makeKeyAndVisible];
    }
    return self;
}

#pragma mark Public

+ (void)showView:(UIView*)view {
    [self.shared _showView:view duration:MobilyNotificationManager_Dutation statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:nil];
}

+ (void)showView:(UIView*)view pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:MobilyNotificationManager_Dutation statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:pressed];
}

+ (void)showView:(UIView*)view statusBarStyle:(UIStatusBarStyle)statusBarStyle pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:MobilyNotificationManager_Dutation statusBarStyle:statusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:pressed];
}

+ (void)showView:(UIView*)view statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:MobilyNotificationManager_Dutation statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:statusBarHidden pressed:pressed];
}

+ (void)showView:(UIView*)view duration:(NSTimeInterval)duration {
    [self.shared _showView:view duration:duration statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:nil];
}

+ (void)showView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:duration statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:pressed];
}

+ (void)showView:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:duration statusBarStyle:statusBarStyle statusBarHidden:MobilyNotificationManager_StatusBarHidden pressed:pressed];
}

+ (void)showView:(UIView*)view duration:(NSTimeInterval)duration statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed {
    [self.shared _showView:view duration:duration statusBarStyle:MobilyNotificationManager_StatusBarStyle statusBarHidden:statusBarHidden pressed:pressed];
}

+ (void)hideTopAnimated:(BOOL)animated {
    [self.shared _hideTopAnimated:animated];
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
    }
    return _controller;
}

#pragma mark Private

- (void)_showView:(UIView*)view duration:(NSTimeInterval)duration statusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden pressed:(MobilySimpleBlock)pressed {
    [self.controller pushView:view duration:duration statusBarStyle:statusBarStyle statusBarHidden:statusBarHidden pressed:pressed];
}

- (void)_hideTopAnimated:(BOOL)animated {
    [self.controller popAllAnimated:animated];
}

- (void)_hideAllAnimated:(BOOL)animated {
    [self.controller popAllAnimated:animated];
}

@end

/*--------------------------------------------------*/
