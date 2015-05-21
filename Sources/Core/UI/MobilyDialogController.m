/*--------------------------------------------------*/

#import <MobilyDialogController.h>
#import <MobilyBlurView.h>

/*--------------------------------------------------*/

@interface MobilyDialogController () < UIGestureRecognizerDelegate > {
@protected
    UIWindow* _presentingWindow;
    UIWindow* _previousWindow;
    __weak UIViewController* _presentingViewController;
    UIViewController* _contentViewController;
    UITapGestureRecognizer* _tapGesture;
    MobilyBlurView* _backgroundView;
    UIView* _rootContainerView;
    UIView* _containerView;
    UIView* _contentView;
    CGRect _contentHiddenFrame;
}

- (void)_adjustFramesForBounds:(CGRect)windowBounds contentSize:(CGSize)contentSize animated:(BOOL)animated;
- (void)_adjustFramesForBounds:(CGRect)mainBounds contentSize:(CGSize)contentSize;
- (void)_adjustHiddenRectsForBounds:(CGRect)mainBounds;
- (CGRect)_mainBoundsForOrientation:(UIInterfaceOrientation)orientation;
- (void)_notificationDidBecomeActive:(NSNotification*)notification;

@end

/*--------------------------------------------------*/

@implementation MobilyDialogController

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

- (instancetype)initWithViewController:(UIViewController*)viewController presentationStyle:(MobilyDialogControllerPresentationStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        _presentationStyle = style;
        _contentViewController = viewController;
        _contentViewController.dialogController = self;
        [self setup];
    }
    return self;
}

- (void)setup {
    _animationDuration = 0.4f;
    _presentationRect = CGRectZero;
    _previousWindow = UIApplication.sharedApplication.keyWindow;
    _backgroundBlurred = YES;
    _backgroundBlurRadius = 20.0f;
    _backgroundBlurIterations = 4;
    _backgroundColor = nil;
    _backgroundTintColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    _contentColor = [UIColor whiteColor];
    _contentAlpha = 1.0f;
    _contentCornerRadius = 4.0f;
    _contentBorderWidth = 0.0f;
    _contentBorderColor = nil;
    _contentShadowColor = [UIColor blackColor];
    _contentShadowOpacity = 0.8f;
    _contentShadowOffset = CGSizeZero;
    _contentShadowRadius = 4.0f;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_notificationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Property

- (void)setPresentationRect:(CGRect)presentationRect {
    if(CGRectEqualToRect(_presentationRect, presentationRect) == NO) {
        _presentationRect = presentationRect;
        if([self isViewLoaded] == YES) {
            [self _adjustFramesForBounds:self.view.bounds contentSize:_presentationRect.size];
        }
    }
}

#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    if(_presentingViewController != nil) {
        return [_presentingViewController prefersStatusBarHidden];
    }
    return [_contentViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(_presentingViewController != nil) {
        return [_presentingViewController preferredStatusBarStyle];
    }
    return [_contentViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if(_presentingViewController != nil) {
        return [_presentingViewController preferredStatusBarUpdateAnimation];
    }
    return [_contentViewController preferredStatusBarUpdateAnimation];
}

- (BOOL)shouldAutorotate {
    if(_presentingViewController != nil) {
        return [_presentingViewController shouldAutorotate];
    }
    return [_contentViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    if(_presentingViewController != nil) {
        return [_presentingViewController supportedInterfaceOrientations];
    }
    return [_contentViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(_presentingViewController != nil) {
        return [_presentingViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    return [_contentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self _adjustFramesForBounds:self.view.bounds contentSize:_contentView.frame.size animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched:)];
    [self.view addGestureRecognizer:_tapGesture];
    _tapGesture.delegate = self;
    
    _backgroundView = [[MobilyBlurView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundView.underlyingView = _previousWindow;
    _backgroundView.blurEnabled = _backgroundBlurred;
    _backgroundView.blurRadius = _backgroundBlurRadius;
    _backgroundView.blurIterations = _backgroundBlurIterations;
    _backgroundView.backgroundColor = _backgroundColor;
    _backgroundView.tintColor = _backgroundTintColor;
    _backgroundView.alpha = _backgroundAlpha;
    [self.view addSubview:_backgroundView];
    
    _rootContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _rootContainerView.backgroundColor = [UIColor clearColor];
    _rootContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _rootContainerView.clipsToBounds = YES;
    _rootContainerView.shadowColor = _contentShadowColor;
    _rootContainerView.shadowOpacity = _contentShadowOpacity;
    _rootContainerView.shadowOffset = _contentShadowOffset;
    _rootContainerView.shadowRadius = _contentShadowRadius;
    [self.view addSubview:_rootContainerView];
    
    [self addChildViewController:_contentViewController];
    _contentView =_contentViewController.view;
    
    CGRect childBounds = _contentView.bounds;
    _containerView = [[UIView alloc] initWithFrame:childBounds];
    switch(_presentationStyle) {
        case MobilyDialogControllerPresentationStyleTop:
        case MobilyDialogControllerPresentationStyleUnderNavBar:
            _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case MobilyDialogControllerPresentationStyleBottom:
        case MobilyDialogControllerPresentationStyleUnderToolbar:
            _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
        case MobilyDialogControllerPresentationStyleCentered:
            _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
    }
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.cornerRadius = _contentCornerRadius;
    _containerView.clipsToBounds = YES;
    [_rootContainerView addSubview:_containerView];
    
    _contentView.frame = _containerView.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor = _contentColor;
    _contentView.alpha = _contentAlpha;
    _contentView.cornerRadius = _contentCornerRadius;
    _contentView.borderWidth = _contentBorderWidth;
    _contentView.borderColor = _contentBorderColor;
    [_containerView addSubview:_contentView];
    
    CGRect mainBounds = [self _mainBoundsForOrientation:self.interfaceOrientation];
    self.view.frame = mainBounds;
    [self _adjustFramesForBounds:mainBounds contentSize:childBounds.size];
}

#pragma mark Public

- (void)presentFromViewController:(UIViewController*)viewController withCompletion:(MobilySimpleBlock)completion {
    _presentingViewController = viewController;
    
    _presentingWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _presentingWindow.windowLevel = _previousWindow.windowLevel + 0.01f;
    _presentingWindow.autoresizingMask = UIViewAutoresizingNone;
    _presentingWindow.rootViewController = self;
    [_presentingWindow makeKeyAndVisible];

    [self _adjustFramesForBounds:self.view.bounds contentSize:_contentView.bounds.size animated:NO];
    
    CGRect containerOriginFrame = _containerView.frame;
    _containerView.frame = _contentHiddenFrame;
    if(_presentationStyle == MobilyDialogControllerPresentationStyleCentered) {
        self.view.alpha = 0.0;
        _backgroundView.alpha = 1.0;
    } else {
        self.view.alpha = 1.0;
        _backgroundView.alpha = 0.0;
    }
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         _containerView.frame = containerOriginFrame;
                         _backgroundView.alpha = 1.0;
                         self.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         _tapGesture.enabled = YES;
                         _containerView.userInteractionEnabled = YES;
                         if(completion != nil) {
                             completion();
                         }
                     }];
}

- (void)presentWithCompletion:(MobilySimpleBlock)completion {
    [self presentFromViewController:nil withCompletion:completion];
}

- (void)dismissWithCompletion:(MobilySimpleBlock)completion {
    _tapGesture.enabled = NO;
    _containerView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         _containerView.frame = _contentHiddenFrame;
                         _backgroundView.alpha = 0.0;
                         if(_presentationStyle == MobilyDialogControllerPresentationStyleCentered) {
                             self.view.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished) {
                         [_contentViewController.view removeFromSuperview];
                         [_contentViewController removeFromParentViewController];
                         _presentingWindow.hidden = YES;
                         [_previousWindow makeKeyAndVisible];
                         if(completion)
                         {
                             completion();
                         }
                     }];
}

- (void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated {
    [self _adjustFramesForBounds:self.view.bounds contentSize:newSize animated:YES];
}

#pragma mark Private

- (void)_adjustFramesForBounds:(CGRect)windowBounds contentSize:(CGSize)contentSize animated:(BOOL)animated {
    if(animated == YES) {
        [UIView animateWithDuration:_animationDuration animations:^{
            [self _adjustFramesForBounds:windowBounds contentSize:contentSize];
        }];
    } else {
        [self _adjustFramesForBounds:windowBounds contentSize:contentSize];
    }
}

- (void)_adjustFramesForBounds:(CGRect)mainBounds contentSize:(CGSize)contentSize {
    CGFloat insetFromEdge = _slideInset;
    if(_horizontalJustification == MobilyDialogControllerHorizontalJustificationFull) {
        contentSize.width = CGRectGetWidth(mainBounds);
    }
    UIViewController* rootViewController = _previousWindow.rootViewController;
    switch(_presentationStyle) {
        case MobilyDialogControllerPresentationStyleUnderNavBar: {
            CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
            CGFloat statusBarHeight = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation) ? statusBarFrame.size.height : statusBarFrame.size.width;
            CGFloat navBarHeight = 0;
            if([rootViewController isKindOfClass:[UINavigationController class]] == YES) {
                navBarHeight = ((UINavigationController*)rootViewController).navigationBar.frame.size.height;
            }
            insetFromEdge = statusBarHeight + navBarHeight;
            break;
        }
        case MobilyDialogControllerPresentationStyleUnderToolbar: {
            CGFloat toolbarHeight = 0;
            if([rootViewController isKindOfClass:[UINavigationController class]] == YES) {
                toolbarHeight = ((UINavigationController*)rootViewController).toolbar.frame.size.height;
            }
            insetFromEdge = toolbarHeight;
            break;
        }
        default:
            break;
    }
    CGRect tintRect = mainBounds;
    if(insetFromEdge > 0.0) {
        switch(_presentationStyle) {
            case MobilyDialogControllerPresentationStyleTop:
            case MobilyDialogControllerPresentationStyleUnderNavBar:
                tintRect.size.height -= insetFromEdge;
                tintRect.origin.y += insetFromEdge;
                break;
            case MobilyDialogControllerPresentationStyleBottom:
            case MobilyDialogControllerPresentationStyleUnderToolbar:
                tintRect.size.height -= insetFromEdge;
                break;
            default:
                break;
        }
    }
    CGRect _containerViewRect = tintRect;
    _containerViewRect.size = contentSize;
    switch(_horizontalJustification) {
        case MobilyDialogControllerHorizontalJustificationCentered:
            _containerViewRect.origin.x = CGRectGetMidX(tintRect) - roundf(0.5 * contentSize.width);
            break;
        case MobilyDialogControllerHorizontalJustificationLeft:
        case MobilyDialogControllerHorizontalJustificationFull:
            _containerViewRect.origin.x = CGRectGetMinX(tintRect);
            break;
        case MobilyDialogControllerHorizontalJustificationRight:
            _containerViewRect.origin.x = CGRectGetMaxX(tintRect) - contentSize.width;
            break;
    }
    switch(_presentationStyle) {
        case MobilyDialogControllerPresentationStyleTop:
        case MobilyDialogControllerPresentationStyleUnderNavBar:
            _containerViewRect.origin.y = 0.0;
            break;
        case MobilyDialogControllerPresentationStyleBottom:
        case MobilyDialogControllerPresentationStyleUnderToolbar:
            _containerViewRect.origin.y = CGRectGetMaxY(tintRect) - contentSize.height;
            break;
        case MobilyDialogControllerPresentationStyleCentered:
            _containerViewRect.origin.y = CGRectGetMidY(tintRect) - roundf(0.5 * contentSize.height);
            break;
    }
    _backgroundView.frame = tintRect;
    _rootContainerView.frame = tintRect;
    _containerView.frame = _containerViewRect;
    
    CGRect blurBgndRect;
    blurBgndRect.size = mainBounds.size;
    blurBgndRect.origin.x = -_containerViewRect.origin.x;
    blurBgndRect.origin.y = -_containerViewRect.origin.y;
    _contentView.frame = _containerView.bounds;
    
    if(_contentShadowColor != nil) {
        _rootContainerView.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_containerView.frame cornerRadius:_contentCornerRadius];
    }
    
    [self _adjustHiddenRectsForBounds:mainBounds];
}

- (void)_adjustHiddenRectsForBounds:(CGRect)mainBounds {
    _contentHiddenFrame = _containerView.frame;
    switch(_presentationStyle) {
        case MobilyDialogControllerPresentationStyleTop:
        case MobilyDialogControllerPresentationStyleUnderNavBar:
            _contentHiddenFrame.origin.y = -CGRectGetHeight(_containerView.frame);
            break;
        case MobilyDialogControllerPresentationStyleBottom:
        case MobilyDialogControllerPresentationStyleUnderToolbar:
            _contentHiddenFrame.origin.y = CGRectGetMaxY(_rootContainerView.bounds);
            break;
        default:
            break;
    }
}

- (CGRect)_mainBoundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect mainBounds = _presentingWindow.bounds;
    if(UIInterfaceOrientationIsLandscape(orientation) == YES) {
        CGFloat h = mainBounds.size.height;
        mainBounds.size.height = mainBounds.size.width;
        mainBounds.size.width = h;
    }
    return mainBounds;
}

- (void)_notificationDidBecomeActive:(NSNotification*)notification {
    [_presentingWindow makeKeyAndVisible];
}

#pragma mark Actions

- (IBAction)backgroundTouched:(id)sender {
    if(_touchedOutsideContent != nil) {
        _touchedOutsideContent(self);
    } else {
        [self dismissWithCompletion:nil];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return (CGRectContainsPoint(_contentViewController.view.bounds, [touch locationInView:_contentViewController.view]) == NO);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

static char const* const MobilyDialogControllerKey = "MobilyDialogControllerKey";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyDialogController)

- (void)setDialogController:(MobilyDialogController*)dialogController {
    objc_setAssociatedObject(self, MobilyDialogControllerKey, dialogController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MobilyDialogController*)dialogController {
    MobilyDialogController* dialogController = objc_getAssociatedObject(self, MobilyDialogControllerKey);
    if(dialogController == nil) {
        dialogController = self.parentViewController.dialogController;
    }
    return dialogController;
}

@end

/*--------------------------------------------------*/
