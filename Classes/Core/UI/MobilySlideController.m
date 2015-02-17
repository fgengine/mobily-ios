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

#import "MobilySlideController.h"

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilySlideControllerSwipeCellDirection) {
    MobilySlideControllerSwipeCellDirectionUnknown,
    MobilySlideControllerSwipeCellDirectionLeft,
    MobilySlideControllerSwipeCellDirectionRight
};

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilySlideController () < UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readwrite, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, strong) UIView* leftView;
@property(nonatomic, readwrite, strong) UIView* centerView;
@property(nonatomic, readwrite, strong) UIView* rightView;
@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGesture;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* tapGesture;

@property(nonatomic, readwrite, assign) CGFloat swipeLastOffset;
@property(nonatomic, readwrite, assign) CGFloat swipeLastVelocity;
@property(nonatomic, readwrite, assign) CGFloat swipeProgress;
@property(nonatomic, readwrite, assign) CGFloat swipeLeftWidth;
@property(nonatomic, readwrite, assign) CGFloat swipeRightWidth;
@property(nonatomic, readwrite, assign) MobilySlideControllerSwipeCellDirection swipeDirection;

- (CGRect)leftViewFrameByPercent:(CGFloat)percent;
- (CGRect)leftViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent;
- (CGRect)centerViewFrameByPercent:(CGFloat)percent;
- (CGRect)centerViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent;
- (CGRect)rightViewFrameByPercent:(CGFloat)percent;
- (CGRect)rightViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent;

- (void)appendBackgroundController;
- (void)removeBackgroundController;
- (void)appendLeftController;
- (void)removeLeftController;
- (void)appendCenterController;
- (void)removeCenterController;
- (void)appendRightController;
- (void)removeRightController;

- (void)tapGestureHandle:(UITapGestureRecognizer*)tapGesture;
- (void)panGestureHandle:(UIPanGestureRecognizer*)panGesture;

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe;

- (void)willBeganSwipe;
- (void)didBeganSwipe;
- (void)movingSwipe:(CGFloat)progress;
- (void)willEndedSwipe;
- (void)didEndedSwipe;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySlideController

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.swipeThreshold = 2.0f;
    self.swipeSpeed = 1050.0f;
    self.swipeVelocity = 570.0f;
}

- (void)dealloc {
    self.backgroundController = nil;
    self.leftController = nil;
    self.centerController = nil;
    self.rightController = nil;
    self.leftView = nil;
    self.centerView = nil;
    self.rightView = nil;
    self.panGesture = nil;
    self.tapGesture = nil;
}

#pragma mark UIViewController

- (BOOL)shouldAutorotate {
    return _centerController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
    return _centerController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return [_centerController shouldAutorotateToInterfaceOrientation:orientation];
}

- (BOOL)prefersStatusBarHidden {
    return _centerController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _centerController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return _centerController.preferredStatusBarUpdateAnimation;
}

- (void)loadView {
    [super loadView];
    
    self.view.clipsToBounds = YES;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    if(_panGesture != nil) {
        _panGesture.delegate = self;
        [self.view addGestureRecognizer:_panGesture];
    }
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    if(_tapGesture != nil) {
        _tapGesture.delegate = self;
        [self.view addGestureRecognizer:_tapGesture];
    }
    self.centerView = [[UIView alloc] initWithFrame:[self centerViewFrameByPercent:0.0f]];
    if(_centerView != nil) {
        _centerView.translatesAutoresizingMaskIntoConstraints = NO;
        _centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _centerView.layer.masksToBounds = YES;
        
        [self.view addSubview:_centerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_backgroundController != nil) {
        [self appendBackgroundController];
    }
    if(_leftController != nil) {
        [self appendLeftController];
    }
    if(_centerController != nil) {
        [self appendCenterController];
    }
    if(_rightController != nil) {
        [self appendRightController];
    }
}

#pragma mark Property

- (void)setBackgroundController:(UIViewController*)backgroundController {
    [self setBackgroundController:backgroundController animated:NO completed:nil];
}

- (void)setLeftController:(UIViewController*)leftController {
    [self setLeftController:leftController animated:NO completed:nil];
}

- (void)setCenterController:(UIViewController*)centerController {
    [self setCenterController:centerController animated:NO completed:nil];
}

- (void)setRightController:(UIViewController*)rightController {
    [self setRightController:rightController animated:NO completed:nil];
}

#pragma mark Public

- (void)setBackgroundController:(UIViewController*)backgroundController animated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
    if(_backgroundController != backgroundController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if(_backgroundController != nil) {
                [self removeBackgroundController];
            }
            _backgroundController = backgroundController;
            if((_backgroundController != nil) && (self.isViewLoaded == YES)) {
                [self appendBackgroundController];
            }
            if(completed != nil) {
                completed();
            }
        }
    }
}

- (void)setLeftController:(UIViewController*)leftController animated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
    if(_leftController != leftController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if(_leftController != nil) {
                [self removeLeftController];
            }
            _centerController = leftController;
            if((_leftController != nil) && (self.isViewLoaded == YES)) {
                [self appendLeftController];
            }
            if(completed != nil) {
                completed();
            }
        }
    }
}

- (void)setCenterController:(UIViewController*)centerController animated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
    if(_centerController != centerController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if(_centerController != nil) {
                [self removeCenterController];
            }
            _centerController = centerController;
            if((_centerController != nil) && (self.isViewLoaded == YES)) {
                [self appendCenterController];
            }
            if(completed != nil) {
                completed();
            }
        }
    }
}

- (void)setRightController:(UIViewController*)rightController animated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
    if(_rightController != rightController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if(_rightController != nil) {
                [self removeRightController];
            }
            _centerController = rightController;
            if((_rightController != nil) && (self.isViewLoaded == YES)) {
                [self appendRightController];
            }
            if(completed != nil) {
                completed();
            }
        }
    }
}

- (void)showLeftControllerAnimated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
}

- (void)hideLeftControllerAnimated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
}

- (void)showRightControllerAnimated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
}

- (void)hideRightControllerAnimated:(BOOL)animated completed:(MobilySlideControllerBlock)completed {
}

#pragma mark Private

- (CGRect)leftViewFrameByPercent:(CGFloat)percent {
    return [self leftViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)leftViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    return CGRectMake((bounds.origin.x - _leftControllerWidth) + (_leftControllerWidth * percent), bounds.origin.y, _leftControllerWidth, bounds.size.height);
}

- (CGRect)centerViewFrameByPercent:(CGFloat)percent {
    return [self centerViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)centerViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    if(percent > FLT_EPSILON) {
        return CGRectMake(bounds.origin.x + (_leftControllerWidth * percent), bounds.origin.y, bounds.size.width, bounds.size.height);
    } else if(percent < FLT_EPSILON) {
        return CGRectMake((bounds.origin.x + bounds.size.width) - (_leftControllerWidth * (1.0f - percent)), bounds.origin.y, bounds.size.width, bounds.size.height);
    }
    return bounds;
}

- (CGRect)rightViewFrameByPercent:(CGFloat)percent {
    return [self rightViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)rightViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    return CGRectMake((bounds.origin.x + bounds.size.width) - (bounds.size.width * percent), bounds.origin.y, _rightControllerWidth, bounds.size.height);
}

- (void)appendBackgroundController {
    _backgroundController.slideNavigation = self;
    
    [_backgroundController willMoveToParentViewController:self];
    [self addChildViewController:_backgroundController];
    [_backgroundController didMoveToParentViewController:self];
    
    [_backgroundController viewWillAppear:NO];
    _backgroundController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _backgroundController.view.frame = self.view.bounds;
    [self.view addSubview:_backgroundController.view];
    [_backgroundController viewDidAppear:NO];
}

- (void)removeBackgroundController {
    _backgroundController.slideNavigation = nil;
    
    [_backgroundController viewWillDisappear:NO];
    [_backgroundController.view removeFromSuperview];
    [_backgroundController viewDidDisappear:NO];
    
    [_backgroundController willMoveToParentViewController:nil];
    [_backgroundController removeFromParentViewController];
    [_backgroundController didMoveToParentViewController:nil];
}

- (void)appendLeftController {
    _leftController.slideNavigation = self;
    
    [_leftController willMoveToParentViewController:self];
    [self addChildViewController:_leftController];
    [_leftController didMoveToParentViewController:self];
    
    [_leftController viewWillAppear:NO];
    _leftController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _leftController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _leftController.view.frame = self.view.bounds;
    [_leftView addSubview:_leftController.view];
    [_leftController viewDidAppear:NO];
}

- (void)removeLeftController {
    _leftController.slideNavigation = nil;
    
    [_leftController viewWillDisappear:NO];
    [_leftController.view removeFromSuperview];
    [_leftController viewDidDisappear:NO];
    
    [_leftController willMoveToParentViewController:nil];
    [_leftController removeFromParentViewController];
    [_leftController didMoveToParentViewController:nil];
}

- (void)appendCenterController {
    _centerController.slideNavigation = self;
    
    [_centerController willMoveToParentViewController:self];
    [self addChildViewController:_centerController];
    [_centerController didMoveToParentViewController:self];
    
    [_centerController viewWillAppear:NO];
    _centerController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _centerController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _centerController.view.frame = self.view.bounds;
    [_centerView addSubview:_centerController.view];
    [_centerController viewDidAppear:NO];
}

- (void)removeCenterController {
    _centerController.slideNavigation = nil;
    
    [_centerController viewWillDisappear:NO];
    [_centerController.view removeFromSuperview];
    [_centerController viewDidDisappear:NO];
    
    [_centerController willMoveToParentViewController:nil];
    [_centerController removeFromParentViewController];
    [_centerController didMoveToParentViewController:nil];
}

- (void)appendRightController {
    _rightController.slideNavigation = self;
    
    [_rightController willMoveToParentViewController:self];
    [self addChildViewController:_rightController];
    [_rightController didMoveToParentViewController:self];
    
    [_rightController viewWillAppear:NO];
    _rightController.view.translatesAutoresizingMaskIntoConstraints = NO;
    _rightController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _rightController.view.frame = self.view.bounds;
    [_rightView addSubview:_rightController.view];
    [_rightController viewDidAppear:NO];
}

- (void)removeRightController {
    _rightController.slideNavigation = nil;
    
    [_rightController viewWillDisappear:NO];
    [_rightController.view removeFromSuperview];
    [_rightController viewDidDisappear:NO];
    
    [_rightController willMoveToParentViewController:nil];
    [_rightController removeFromParentViewController];
    [_rightController didMoveToParentViewController:nil];
}

- (void)tapGestureHandle:(UITapGestureRecognizer*)tapGesture {
    if(_swipeDecelerating == NO) {
        if(_showedLeftController == YES) {
            [self hideLeftControllerAnimated:YES completed:nil];
        } else if(_showedRightController) {
            [self hideRightControllerAnimated:YES completed:nil];
        }
    }
}

- (void)panGestureHandle:(UIPanGestureRecognizer*)panGesture {
    if(_swipeDecelerating == NO) {
        CGPoint translation = [_panGesture translationInView:self.view];
        CGPoint velocity = [_panGesture velocityInView:self.view];
        switch([_panGesture state]) {
            case UIGestureRecognizerStateBegan: {
                [self willBeganSwipe];
                self.swipeLastOffset = translation.x;
                self.swipeLastVelocity = velocity.x;
                self.swipeLeftWidth = -_leftControllerWidth;
                self.swipeRightWidth = _rightControllerWidth;
                self.swipeDirection = MobilySlideControllerSwipeCellDirectionUnknown;
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat delta = _swipeLastOffset - translation.x;
                if(_swipeDirection == MobilySlideControllerSwipeCellDirectionUnknown) {
                    if((_showedLeftController == YES) && (_leftController != nil) && (delta > _swipeThreshold)) {
                        self.swipeDirection = MobilySlideControllerSwipeCellDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightController == YES) && (_rightController != nil) && (delta < -_swipeThreshold)) {
                        self.swipeDirection = MobilySlideControllerSwipeCellDirectionRight;
                        [self didBeganSwipe];
                    } else if((_showedLeftController == NO) && (_leftController != nil) && (delta < -_swipeThreshold)) {
                        self.swipeDirection = MobilySlideControllerSwipeCellDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightController == NO) && (_rightController != nil) && (delta > _swipeThreshold)) {
                        self.swipeDirection = MobilySlideControllerSwipeCellDirectionRight;
                        [self didBeganSwipe];
                    }
                }
                if(_swipeDirection != MobilySlideControllerSwipeCellDirectionUnknown) {
                    switch(_swipeDirection) {
                        case MobilySlideControllerSwipeCellDirectionUnknown: {
                            break;
                        }
                        case MobilySlideControllerSwipeCellDirectionLeft: {
                            CGFloat localDelta = MIN(MAX(_swipeLeftWidth, delta), -_swipeLeftWidth);
                            [self setSwipeProgress:_swipeProgress - (localDelta / _swipeLeftWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                        case MobilySlideControllerSwipeCellDirectionRight: {
                            CGFloat localDelta = MIN(MAX(-_swipeRightWidth, delta), _swipeRightWidth);
                            [self setSwipeProgress:_swipeProgress + (localDelta / _swipeRightWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                    }
                    self.swipeLastOffset = translation.x;
                    self.swipeLastVelocity = velocity.x;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                [self willEndedSwipe];
                CGFloat swipeProgress = roundf(_swipeProgress - (_swipeLastVelocity / _swipeVelocity));
                CGFloat minSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) ? -1.0f : 0.0f;
                CGFloat maxSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) ? 1.0f :0.0f;
                CGFloat needSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
                switch(_swipeDirection) {
                    case MobilySlideControllerSwipeCellDirectionLeft: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeLeftWidth * ABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    case MobilySlideControllerSwipeCellDirectionRight: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeRightWidth * ABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    default: {
                        [self didEndedSwipe];
                        break;
                    }
                }
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe {
    CGFloat minSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) ? 1.0f :0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_swipeProgress != normalizedSwipeProgress) {
        _swipeProgress = normalizedSwipeProgress;
        
        CGRect bounds = self.view.bounds;
        [UIView animateWithDuration:ABS(speed) / _swipeSpeed
                         animations:^{
                             _leftView.frame = [self leftViewFrameFromBounds:bounds byPercent:normalizedSwipeProgress];
                             _centerView.frame = [self centerViewFrameFromBounds:bounds byPercent:normalizedSwipeProgress];
                             _rightView.frame = [self rightViewFrameFromBounds:bounds byPercent:normalizedSwipeProgress];
                         } completion:^(BOOL finished) {
                             if(endedSwipe == YES) {
                                 [self didEndedSwipe];
                             }
                         }];
    } else {
        if(endedSwipe == YES) {
            [self didEndedSwipe];
        }
    }
}

- (void)willBeganSwipe {
}

- (void)didBeganSwipe {
    self.swipeDragging = YES;
}

- (void)movingSwipe:(CGFloat)progress {
}

- (void)willEndedSwipe {
    self.swipeDragging = NO;
    self.swipeDecelerating = YES;
}

- (void)didEndedSwipe {
    _showedLeftController = (_swipeProgress < 0.0f) ? YES : NO;
    _showedRightController = (_swipeProgress > 0.0f) ? YES : NO;
    self.swipeDecelerating = NO;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer == _tapGesture) {
    } else if(gestureRecognizer == _panGesture) {
        if((_swipeDragging == NO) && (_swipeDecelerating == NO)) {
            CGPoint translation = [_panGesture translationInView:self.view];
            if(fabs(translation.x) >= fabs(translation.y)) {
                if((_showedLeftController == YES) && (_leftController != nil) && (translation.x < 0.0f)) {
                    return YES;
                } else if((_showedRightController == YES) && (_rightController != nil) && (translation.x > 0.0f)) {
                    return YES;
                } else if((_showedLeftController == NO) && (_leftController != nil) && (translation.x > 0.0f)) {
                    return YES;
                } else if((_showedRightController == NO) && (_rightController != nil) && (translation.x < 0.0f)) {
                    return YES;
                }
                return NO;
            }
        }
    }
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

static char const* const slideNavigationKey = "slideNavigationKey";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilySlideController)

- (void)setSlideNavigation:(MobilySlideController*)slideNavigation {
    objc_setAssociatedObject(self, slideNavigationKey, slideNavigation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MobilySlideController*)slideNavigation {
    MobilySlideController* slideNavigation = objc_getAssociatedObject(self, slideNavigationKey);
    if(slideNavigation == nil) {
        slideNavigation = [[self parentViewController] slideNavigation];
    }
    return slideNavigation;
}

@end

/*--------------------------------------------------*/
