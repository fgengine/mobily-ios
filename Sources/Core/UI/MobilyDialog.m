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

#import <MobilyDialog+Private.h>

/*--------------------------------------------------*/

@interface MobilyDialog ()


@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialog

+ (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [MobilyDialogWindow.shared pushDialogController:viewController animated:animated complete:complete];
}

+ (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [MobilyDialogWindow.shared popDialogControllerAnimated:animated complete:complete];
}

+ (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [MobilyDialogWindow.shared popAllDialogControllerAnimated:animated complete:complete];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogWindow

#pragma mark Synthesize

@synthesize dialogController = _dialogController;
@synthesize lastWindow = _lastWindow;
@synthesize active = _active;

#pragma mark Singleton

+ (instancetype)shared {
    static id result = nil;
    if(result == nil) {
        result = [self new];
    }
    return result;
}

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.rootViewController = [[MobilyDialogController alloc] initWithDialogWindow:self];
    self.windowLevel = UIWindowLevelAlert - 1;
    self.hidden = NO;
}

#pragma mark Property

- (void)setRootViewController:(UIViewController*)rootViewController {
    super.rootViewController = rootViewController;
    if([rootViewController isKindOfClass:[MobilyDialogController class]] == YES) {
        _dialogController = (MobilyDialogController*)rootViewController;
    } else {
        _dialogController = nil;
    }
}

#pragma mark Private

- (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [_dialogController pushDialogController:viewController animated:animated complete:complete];
}

- (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [_dialogController popDialogControllerAnimated:animated complete:^{
        if(complete != nil) {
            complete();
        }
    }];
}

- (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    [_dialogController popAllDialogControllerAnimated:animated complete:^{
        if(complete != nil) {
            complete();
        }
    }];
}

- (void)setActive:(BOOL)active {
    if(_active != active) {
        if(_active == YES) {
            if(_lastWindow != nil) {
                [_lastWindow makeKeyWindow];
                _lastWindow = nil;
            }
            [self endEditing:YES];
            self.hidden = YES;
        }
        _active = active;
        if(_active == YES) {
            _lastWindow = UIApplication.sharedApplication.keyWindow;
            if(_lastWindow != nil) {
                [_lastWindow endEditing:YES];
            }
            [self makeKeyWindow];
            self.hidden = NO;
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogController

#pragma make Synthesize

@synthesize dialogWindow = _dialogWindow;
@synthesize dialogBackgroundView = _dialogBackgroundView;
@synthesize dialogViews = _dialogViews;

#pragma mark Init / Free

- (instancetype)initWithDialogWindow:(MobilyDialogWindow*)dialogWindow {
    self = [super init];
    if(self != nil) {
        _dialogWindow = dialogWindow;
        _dialogViews = [NSMutableArray array];
    }
    return self;
}

#pragma mark Load

- (void)loadView {
    self.view = [[MobilyDialogBackgroundView alloc] initWithDialogController:self];
}

#pragma mark Property

- (void)setView:(UIView*)view {
    super.view = view;
    if([view isKindOfClass:[MobilyDialogBackgroundView class]] == YES) {
        _dialogBackgroundView = (MobilyDialogBackgroundView*)view;
    } else {
        _dialogBackgroundView = nil;
    }
}

#pragma mark Private

- (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    MobilyDialogView* dialogView = [[MobilyDialogView alloc] initWithDialogController:self viewController:viewController];
    if(dialogView != nil) {
        MobilyDialogView* lastDialogView = _dialogViews.lastObject;
        [_dialogViews addObject:dialogView];
        if(lastDialogView != nil) {
            [lastDialogView pushAnimated:animated complete:^{
                [dialogView presentAnimated:animated complete:^{
                    if(complete != nil) {
                        complete();
                    }
                }];
            }];
        } else {
            _dialogWindow.active = YES;
            [dialogView presentAnimated:animated complete:^{
                if(complete != nil) {
                    complete();
                }
            }];
        }
    }
}

- (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    MobilyDialogView* lastDialogView = _dialogViews.lastObject;
    if(lastDialogView != nil) {
        [lastDialogView dismissAnimated:animated complete:^{
            [_dialogViews removeObject:lastDialogView];
            MobilyDialogView* nextDialogView = _dialogViews.lastObject;
            if(nextDialogView != nil) {
                [nextDialogView popAnimated:animated complete:^{
                    if(complete != nil) {
                        complete();
                    }
                }];
            } else {
                _dialogWindow.active = NO;
                if(complete != nil) {
                    complete();
                }
            }
        }];
    }
}

- (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if(_dialogViews.count > 0) {
        MobilyDialogView* firstDialogView = _dialogViews.firstObject;
        MobilyDialogView* lastDialogView = _dialogViews.lastObject;
        if(firstDialogView != lastDialogView) {
            [lastDialogView dismissAnimated:animated complete:^{
                [_dialogViews removeObject:lastDialogView];
                [_dialogViews each:^(MobilyDialogView* dialogView) {
                    [dialogView popAnimated:(dialogView == firstDialogView) complete:^{
                        [dialogView dismissAnimated:(dialogView == firstDialogView) complete:^{
                            [_dialogViews removeObject:dialogView];
                            if(dialogView == firstDialogView) {
                                _dialogWindow.active = NO;
                                if(complete != nil) {
                                    complete();
                                }
                            }
                        }];
                    }];
                } options:NSEnumerationReverse];
            }];
        } else {
            [lastDialogView dismissAnimated:animated complete:^{
                [_dialogViews removeObject:lastDialogView];
                _dialogWindow.active = NO;
                if(complete != nil) {
                    complete();
                }
            }];
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogBackgroundView

#pragma make Synthesize

@synthesize dialogController = _dialogController;

#pragma mark Init / Free

- (instancetype)initWithDialogController:(MobilyDialogController*)dialogController {
    self = [super initWithFrame:CGRectZero];
    if(self != nil) {
        _dialogController = dialogController;
    }
    return self;
}

- (void)applyStyle:(MobilyDialogStyle*)style {
    self.blurEnabled = style.backgroundBlurred;
    self.blurRadius = style.backgroundBlurRadius;
    self.blurIterations = style.backgroundBlurIterations;
    self.backgroundColor = style.backgroundColor;
    self.alpha = style.backgroundAlpha;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogView

#pragma make Synthesize

@synthesize dialogController = _dialogController;
@synthesize viewController = _viewController;
@synthesize style = _style;
@synthesize presented = _presented;
@synthesize blocked = _blocked;

#pragma mark Init / Free

- (instancetype)initWithDialogController:(MobilyDialogController*)dialogController viewController:(UIViewController*)viewController {
    self = [super initWithFrame:CGRectZero];
    if(self != nil) {
        self.dialogController = dialogController;
        self.viewController = viewController;
        self.style = [[MobilyDialogStyle alloc] initWithDialogView:self];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark Public override

- (void)updateConstraints {
    [self removeConstraints:self.constraints];
    if(_viewController != nil) {
        NSDictionary* metrics = @{
            @"margin" : @(3.0f)
        };
        NSDictionary* views = @{
            @"view": self,
            @"viewController": _viewController.view,
        };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[viewController]-(margin)-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[viewController]-(margin)-|" options:0 metrics:metrics views:views]];
    }
    [super updateConstraints];
}

#pragma mark Property

- (void)setDialogController:(MobilyDialogController*)dialogController {
    if(_dialogController != dialogController) {
        _dialogController = dialogController;
        if((_dialogController != nil) && (_viewController != nil)) {
            [_dialogController addChildViewController:_viewController];
            _viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            _viewController.view.frame = self.bounds;
            [self addSubview:_viewController.view];
            [_viewController didMoveToParentViewController:_dialogController];
        }
        [self setNeedsUpdateConstraints];
    }
}

- (void)setViewController:(UIViewController*)viewController {
    if(_viewController != viewController) {
        if(_viewController != nil) {
            [_viewController willMoveToParentViewController:nil];
            [_viewController.view removeFromSuperview];
            [_viewController removeFromParentViewController];
            _viewController.dialogView = nil;
        }
        _viewController = viewController;
        if((_dialogController != nil) && (_viewController != nil)) {
            _viewController.dialogView = self;
            [_dialogController addChildViewController:_viewController];
            _viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
            _viewController.view.frame = self.bounds;
            [self addSubview:_viewController.view];
            [_viewController didMoveToParentViewController:_dialogController];
        }
        [self setNeedsUpdateConstraints];
    }
}

- (void)setPresented:(BOOL)presented {
    if(_presented != presented) {
        _presented = presented;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setBlocked:(BOOL)blocked {
    if(_blocked != blocked) {
        _blocked = blocked;
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
}

#pragma mark Public

- (void)presentAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if((_presented == NO) && (_blocked == NO)) {
        [_dialogController.view addSubview:self];
        [self layoutIfNeeded];
        self.presented = YES;
        if(animated == YES) {
            [UIView animateWithDuration:_style.duration
                                  delay:0.0f
                 usingSpringWithDamping:_style.damping
                  initialSpringVelocity:_style.velocity
                                options:0
                             animations:^{
                                 [_dialogController.dialogBackgroundView applyStyle:_style];
                                 [_dialogController.view layoutIfNeeded];
                                 [self applyStyle:_style];
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete();
                                 }
                             }];
        } else {
            [_dialogController.dialogBackgroundView applyStyle:_style];
            [_dialogController.view layoutIfNeeded];
            [self applyStyle:_style];
            [self layoutIfNeeded];
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)dismissAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if((_presented == YES) && (_blocked == NO)) {
        self.presented = NO;
        if(animated == YES) {
            [UIView animateWithDuration:_style.duration
                                  delay:0.0f
                 usingSpringWithDamping:_style.damping
                  initialSpringVelocity:_style.velocity
                                options:0
                             animations:^{
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                                 if(complete != nil) {
                                     complete();
                                 }
                             }];
        } else {
            [self removeFromSuperview];
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)pushAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if((_presented == YES) && (_blocked == NO)) {
        self.blocked = YES;
        if(animated == YES) {
            [UIView animateWithDuration:_style.duration
                                  delay:0.0f
                 usingSpringWithDamping:_style.damping
                  initialSpringVelocity:_style.velocity
                                options:0
                             animations:^{
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete();
                                 }
                             }];
        } else {
            [self layoutIfNeeded];
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)popAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if((_presented == YES) && (_blocked == YES)) {
        self.blocked = NO;
        if(animated == YES) {
            [UIView animateWithDuration:_style.duration
                                  delay:0.0f
                 usingSpringWithDamping:_style.damping
                  initialSpringVelocity:_style.velocity
                                options:0
                             animations:^{
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete();
                                 }
                             }];
        } else {
            [self layoutIfNeeded];
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)applyStyle:(MobilyDialogStyle*)style {
    self.backgroundColor = style.dialogColor;
    self.alpha = style.dialogAlpha;
    self.cornerRadius = style.dialogCornerRadius;
    self.borderWidth = style.dialogBorderWidth;
    self.borderColor = style.dialogBorderColor;
    self.shadowColor = style.dialogShadowColor;
    self.shadowOpacity = style.dialogShadowOpacity;
    self.shadowOffset = style.dialogShadowOffset;
    self.shadowRadius = style.dialogShadowRadius;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogStyle

#pragma make Synthesize

@synthesize dialogView = _dialogView;
@synthesize duration = _duration;
@synthesize damping = _damping;
@synthesize velocity = _velocity;
@synthesize backgroundBlurred = _backgroundBlurred;
@synthesize backgroundBlurRadius = _backgroundBlurRadius;
@synthesize backgroundBlurIterations = _backgroundBlurIterations;
@synthesize backgroundColor = _backgroundColor;
@synthesize backgroundAlpha = _backgroundAlpha;
@synthesize dialogColor = _dialogColor;
@synthesize dialogAlpha = _dialogAlpha;
@synthesize dialogCornerRadius = _dialogCornerRadius;
@synthesize dialogBorderWidth = _dialogBorderWidth;
@synthesize dialogBorderColor = _dialogBorderColor;
@synthesize dialogShadowColor = _dialogShadowColor;
@synthesize dialogShadowOpacity = _dialogShadowOpacity;
@synthesize dialogShadowOffset = _dialogShadowOffset;
@synthesize dialogShadowRadius = _dialogShadowRadius;

#pragma mark Init / Free

- (instancetype)initWithDialogView:(MobilyDialogView*)dialogView {
    self = [super init];
    if(self != nil) {
        _dialogView = dialogView;
        _duration = 0.3f;
        _damping = 0.1f;
        _velocity = 1.0f;
        _backgroundBlurred = YES;
        _backgroundBlurRadius = 20.0f;
        _backgroundBlurIterations = 4;
        _backgroundColor = nil;
        _backgroundAlpha = 1.0f;
        
        _dialogColor = [UIColor whiteColor];
        _dialogAlpha = 1.0f;
        _dialogCornerRadius = 4.0f;
        _dialogBorderWidth = 0.0f;
        _dialogBorderColor = nil;
        _dialogShadowColor = [UIColor blackColor];
        _dialogShadowOpacity = 0.5f;
        _dialogShadowOffset = CGSizeMake(4.0f, 4.0f);
        _dialogShadowRadius = 8.0f;
    }
    return self;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

static char const* const MobilyDialogKey = "MobilyDialogKey";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyDialog)

- (void)setDialogView:(MobilyDialogView*)dialogView {
    objc_setAssociatedObject(self, MobilyDialogKey, dialogView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MobilyDialogView*)dialogView {
    MobilyDialogView* dialogView = objc_getAssociatedObject(self, MobilyDialogKey);
    if(dialogView == nil) {
        dialogView = self.parentViewController.dialogView;
    }
    return dialogView;
}

@end

/*--------------------------------------------------*/
