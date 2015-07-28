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

#import <MobilyCore/MobilyDialogController.h>
#import <MobilyCore/MobilyBlurView.h>

/*--------------------------------------------------*/

@interface MobilyDialogController () < UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, strong) UIWindow* presentedWindow;
@property(nonatomic, readwrite, weak) UIWindow* presentingWindow;
@property(nonatomic, readwrite, strong) UIViewController* presentingController;

@property(nonatomic, readwrite, strong) MobilyBlurView* backgroundView;
@property(nonatomic, readwrite, strong) UIViewController* contentController;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewCenterX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewHeight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewMinWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewMinHeight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewMaxWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintContentViewMaxHeight;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* tapGesture;

@end

/*--------------------------------------------------*/

@implementation MobilyDialogController

#pragma mark Synthesize

@synthesize presentedWindow = _presentedWindow;
@synthesize presentingWindow = _presentingWindow;
@synthesize presentingController = _presentingController;
@synthesize backgroundView = _backgroundView;
@synthesize contentController = _contentController;
@synthesize constraintContentViewCenterX = _constraintContentViewCenterX;
@synthesize constraintContentViewCenterY = _constraintContentViewCenterY;
@synthesize constraintContentViewWidth = _constraintContentViewWidth;
@synthesize constraintContentViewHeight = _constraintContentViewHeight;
@synthesize constraintContentViewMinWidth = _constraintContentViewMinWidth;
@synthesize constraintContentViewMinHeight = _constraintContentViewMinHeight;
@synthesize constraintContentViewMaxWidth = _constraintContentViewMaxWidth;
@synthesize constraintContentViewMaxHeight = _constraintContentViewMaxHeight;
@synthesize tapGesture = _tapGesture;
@synthesize animationDuration = _animationDuration;
@synthesize backgroundBlurred = _backgroundBlurred;
@synthesize backgroundBlurRadius = _backgroundBlurRadius;
@synthesize backgroundBlurIterations = _backgroundBlurIterations;
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundTintColor = _backgroundTintColor;
@synthesize backgroundAlpha = _backgroundAlpha;
@synthesize contentSize = _contentSize;
@synthesize contentMinSize = _contentMinSize;
@synthesize contentMaxSize = _contentMaxSize;
@synthesize touchedOutsideContent = _touchedOutsideContent;
@synthesize dismiss = _dismiss;

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

- (instancetype)initWithContentController:(UIViewController*)contentController {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        _contentController = contentController;
        _contentController.moDialogController = self;
        [self setup];
    }
    return self;
}

- (void)setup {
    _animationDuration = 0.4f;
    _backgroundBlurred = YES;
    _backgroundBlurRadius = 20.0f;
    _backgroundBlurIterations = 4;
    _backgroundColor = nil;
    _backgroundTintColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    _backgroundAlpha = 1.0f;
}

#pragma mark Property

- (void)setPresentingController:(UIViewController*)presentingController {
    if(_presentingController != presentingController) {
        _presentingController = presentingController;
        if(self.isViewLoaded == YES) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)setPresentedWindow:(UIWindow*)presentedWindow {
    if(_presentedWindow != presentedWindow) {
        if((_presentingWindow != nil) && (_presentedWindow != nil)) {
            [_presentingWindow makeKeyAndVisible];
        }
        _presentedWindow = presentedWindow;
        if(_presentedWindow != nil) {
            _presentedWindow.windowLevel = _presentingWindow.windowLevel + 0.01f;
            _presentedWindow.backgroundColor = [UIColor clearColor];
            _presentedWindow.rootViewController = self;
            [_presentedWindow makeKeyAndVisible];
            [_presentedWindow layoutIfNeeded];
        }
    }
}

- (void)setBackgroundView:(MobilyBlurView*)backgroundView {
    if(_backgroundView != backgroundView) {
        if(_backgroundView != nil) {
            [_backgroundView removeFromSuperview];
        }
        _backgroundView = backgroundView;
        if(_backgroundView != nil) {
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            _backgroundView.underlyingView = _presentingWindow.rootViewController.view;
            _backgroundView.blurEnabled = _backgroundBlurred;
            _backgroundView.blurRadius = _backgroundBlurRadius;
            _backgroundView.blurIterations = _backgroundBlurIterations;
            _backgroundView.backgroundColor = _backgroundColor;
            _backgroundView.tintColor = _backgroundTintColor;
            _backgroundView.alpha = _backgroundAlpha;
            [self.view addSubview:_backgroundView];
        }
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewCenterX, constraintContentViewCenterX, self.view, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewCenterY, constraintContentViewCenterY, self.view, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewWidth, constraintContentViewWidth, self.view, {
}, {
    _constraintContentViewWidth.constant = _contentSize.width;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewHeight, constraintContentViewHeight, self.view, {
}, {
    _constraintContentViewHeight.constant = _contentSize.height;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewMinWidth, constraintContentViewMinWidth, self.view, {
}, {
    _constraintContentViewMinWidth.constant = _contentMinSize.width;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewMinHeight, constraintContentViewMinHeight, self.view, {
}, {
    _constraintContentViewMinHeight.constant = _contentMinSize.height;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewMaxWidth, constraintContentViewMaxWidth, self.view, {
}, {
    _constraintContentViewMaxWidth.constant = _contentMaxSize.width;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintContentViewMaxHeight, constraintContentViewMaxHeight, self.view, {
}, {
    _constraintContentViewMaxHeight.constant = _contentMaxSize.height;
})

- (void)setTapGesture:(UITapGestureRecognizer*)tapGesture {
    if(_tapGesture != tapGesture) {
        if(_tapGesture != nil) {
            [self.view removeGestureRecognizer:_tapGesture];
        }
        _tapGesture = tapGesture;
        if(_tapGesture != nil) {
            [self.view addGestureRecognizer:_tapGesture];
            _tapGesture.delegate = self;
        }
        
    }
}

- (void)setBackgroundBlurred:(BOOL)backgroundBlurred {
    if(_backgroundBlurred != backgroundBlurred) {
        _backgroundBlurred = backgroundBlurred;
        if(self.isViewLoaded == YES) {
            _backgroundView.blurEnabled = _backgroundBlurred;
        }
    }
}

- (void)setBackgroundBlurRadius:(CGFloat)backgroundBlurRadius {
    if(_backgroundBlurRadius != backgroundBlurRadius) {
        _backgroundBlurRadius = backgroundBlurRadius;
        if(self.isViewLoaded == YES) {
            _backgroundView.blurRadius = _backgroundBlurRadius;
        }
    }
}

- (void)setBackgroundBlurIterations:(NSUInteger)backgroundBlurIterations {
    if(_backgroundBlurIterations != backgroundBlurIterations) {
        _backgroundBlurIterations = backgroundBlurIterations;
        if(self.isViewLoaded == YES) {
            _backgroundView.blurIterations = _backgroundBlurIterations;
        }
    }
}

- (void)setBackgroundColor:(UIColor*)backgroundColor {
    if([_backgroundColor isEqual:backgroundColor] == NO) {
        _backgroundColor = backgroundColor;
        if(self.isViewLoaded == YES) {
            _backgroundView.backgroundColor = _backgroundColor;
        }
    }
}

- (void)setBackgroundTintColor:(UIColor*)backgroundTintColor {
    if([_backgroundTintColor isEqual:backgroundTintColor] == NO) {
        _backgroundTintColor = backgroundTintColor;
        if(self.isViewLoaded == YES) {
            _backgroundView.tintColor = _backgroundTintColor;
        }
    }
}

- (void)setContentSize:(CGSize)contentSize {
    if(CGSizeEqualToSize(_contentSize, contentSize) == NO) {
        _contentSize = contentSize;
        if(self.isViewLoaded == YES) {
            [self _updateConstraintContentView];
        }
    }
}

- (void)setContentMinSize:(CGSize)contentMinSize {
    if(CGSizeEqualToSize(_contentMinSize, contentMinSize) == NO) {
        _contentMinSize = contentMinSize;
        if(self.isViewLoaded == YES) {
            [self _updateConstraintContentView];
        }
    }
}

- (void)setContentMaxSize:(CGSize)contentMaxSize {
    if(CGSizeEqualToSize(_contentMaxSize, contentMaxSize) == NO) {
        _contentMaxSize = contentMaxSize;
        if(self.isViewLoaded == YES) {
            [self _updateConstraintContentView];
        }
    }
}

#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    if(self.presentingController != nil) {
        return [self.presentingController prefersStatusBarHidden];
    }
    return [self.contentController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(self.presentingController != nil) {
        return [self.presentingController preferredStatusBarStyle];
    }
    return [self.contentController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if(self.presentingController != nil) {
        return [self.presentingController preferredStatusBarUpdateAnimation];
    }
    return [self.contentController preferredStatusBarUpdateAnimation];
}

- (BOOL)shouldAutorotate {
    if(self.presentingController != nil) {
        return [self.presentingController shouldAutorotate];
    }
    return [self.contentController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    if(self.presentingController != nil) {
        return [self.presentingController supportedInterfaceOrientations];
    }
    return [self.contentController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(self.presentingController != nil) {
        return [self.presentingController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    return [self.contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedBackground:)];
    self.backgroundView = [[MobilyBlurView alloc] initWithFrame:self.view.bounds];
    
    [self addChildViewController:self.contentController];
    self.contentController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentController.view.frame = self.view.bounds;
    [self.view addSubview:self.contentController.view];
    [self.contentController didMoveToParentViewController:self];
    
    [self _updateConstraintContentView];
}

#pragma mark Public

- (void)presentController:(UIViewController*)controller withCompletion:(MobilySimpleBlock)completion {
    self.presentingWindow = UIApplication.sharedApplication.keyWindow;
    self.presentingController = controller;
    self.presentedWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 0.0;
    
    self.backgroundView.blurRadius = (_backgroundBlurred == YES) ? 0.0f : _backgroundBlurRadius;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundView.blurRadius = (_backgroundBlurred == YES) ? _backgroundBlurRadius : _backgroundBlurRadius;
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.tapGesture.enabled = YES;
        if(completion != nil) {
            completion();
        }
    }];
}

- (void)presentWithCompletion:(MobilySimpleBlock)completion {
    [self presentController:UIApplication.sharedApplication.keyWindow.rootViewController withCompletion:completion];
}

- (void)dismissWithCompletion:(MobilySimpleBlock)completion {
    self.tapGesture.enabled = NO;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundView.blurRadius = (_backgroundBlurred == YES) ? 0.0f : _backgroundBlurRadius;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.presentedWindow = nil;
        if(self.dismiss != nil) {
            self.dismiss(self);
        }
        if(completion != nil) {
            completion();
        }
    }];
}

#pragma mark Private

- (void)_updateConstraintContentView {
    self.constraintContentViewCenterX = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    self.constraintContentViewCenterY = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    if(_contentSize.width > MOBILY_EPSILON) {
        self.constraintContentViewWidth = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        self.constraintContentViewMinWidth = nil;
        self.constraintContentViewMaxWidth = nil;
    } else {
        if(_contentMinSize.width > MOBILY_EPSILON) {
            self.constraintContentViewMinWidth = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        } else {
            self.constraintContentViewMinWidth = nil;
        }
        if(_contentMaxSize.width > MOBILY_EPSILON) {
            self.constraintContentViewMaxWidth = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        } else {
            self.constraintContentViewMaxWidth = nil;
        }
        self.constraintContentViewWidth = nil;
    }
    if(_contentSize.height > MOBILY_EPSILON) {
        self.constraintContentViewHeight = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        self.constraintContentViewMinHeight = nil;
        self.constraintContentViewMaxHeight = nil;
    } else {
        if(_contentMinSize.height > MOBILY_EPSILON) {
            self.constraintContentViewMinHeight = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        } else {
            self.constraintContentViewMinHeight = nil;
        }
        if(_contentMaxSize.height > MOBILY_EPSILON) {
            self.constraintContentViewMaxHeight = [NSLayoutConstraint constraintWithItem:self.contentController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        } else {
            self.constraintContentViewMaxHeight = nil;
        }
        self.constraintContentViewHeight = nil;
    }
}

#pragma mark Actions

- (IBAction)pressedBackground:(id)sender {
    if(self.touchedOutsideContent != nil) {
        self.touchedOutsideContent(self);
    } else {
        [self dismissWithCompletion:nil];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return (CGRectContainsPoint(self.contentController.view.bounds, [touch locationInView:self.contentController.view]) == NO);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyDialogController)

- (void)setMoDialogController:(MobilyDialogController*)moDialogController {
    objc_setAssociatedObject(self, @selector(moDialogController), moDialogController, OBJC_ASSOCIATION_ASSIGN);
}

- (MobilyDialogController*)moDialogController {
    MobilyDialogController* controller = objc_getAssociatedObject(self, @selector(moDialogController));
    if(controller == nil) {
        controller = self.parentViewController.moDialogController;
    }
    return controller;
}

@end

/*--------------------------------------------------*/
