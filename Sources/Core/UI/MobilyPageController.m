/*--------------------------------------------------*/

#import <MobilyPageController.h>

/*--------------------------------------------------*/

#define ANIMATION_DURATION                          0.2f

#define THRESHOLD_HORIZONTAL_OFFSET                 100.0f
#define THRESHOLD_VERTICAL_OFFSET                   120.0f

#define SCALE_MIN                                   0.5f
#define SCALE_MAX                                   1.0f

/*--------------------------------------------------*/

@interface MobilyPageController () < UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, assign, getter = isAnimating) BOOL animating;
@property(nonatomic, readwrite, assign, getter = isAllowBeforeController) BOOL allowBeforeController;
@property(nonatomic, readwrite, assign, getter = isAllowAfterController) BOOL allowAfterController;
@property(nonatomic, readwrite, strong) UIViewController< MobilyPageControllerDelegate >* animateController;
@property(nonatomic, readwrite, strong) UIView* rootView;
@property(nonatomic, readwrite, assign) UIEdgeInsets beforeDecorInsets;
@property(nonatomic, readwrite, assign) UIEdgeInsets afterDecorInsets;
@property(nonatomic, readwrite, assign) CGSize beforeDecorSize;
@property(nonatomic, readwrite, assign) CGSize afterDecorSize;
@property(nonatomic, readwrite, strong) UIView* beforeDecorView;
@property(nonatomic, readwrite, strong) UIView* afterDecorView;
@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGesture;
@property(nonatomic, readwrite, strong) NSMutableArray* friendlyGestures;
@property(nonatomic, readwrite, assign) CGPoint panBeganPosition;

- (void)loadBeforeAfterData;

- (CGRect)beforeFrame;
- (CGRect)currentFrame;
- (CGRect)afterFrame;

- (CGRect)beforeDecorFrame;
- (CGRect)beforeDecorFrameFromFrame:(CGRect)currentFrame;
- (CGRect)afterDecorFrame;
- (CGRect)afterDecorFrameFromFrame:(CGRect)currentFrame;

- (void)panGestureHandle:(UIPanGestureRecognizer*)panGesture;

@end

/*--------------------------------------------------*/

@implementation MobilyPageController

- (void)setup {
    [super setup];
    
    self.userInteractionEnabled = YES;
    self.draggingRate = 0.5f;
    self.bounceRate = 0.5f;
    
    self.friendlyGestures = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    self.rootView = [[UIView alloc] initWithFrame:self.view.bounds];
    _rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rootView];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    [_panGesture setDelegate:self];
    [_rootView addGestureRecognizer:_panGesture];
    
    if(_controller != nil) {
        _controller.pageController = self;
        if(_controller.parentViewController != self) {
            if(_controller.parentViewController != nil) {
                [_controller willMoveToParentViewController:nil];
                [_controller.view removeFromSuperview];
                [_controller removeFromParentViewController];
            }
            [self addChildViewController:_controller];
            _controller.view.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
            _controller.view.frame = self.currentFrame;
            [_rootView addSubview:_controller.view];
            [_controller didMoveToParentViewController:self];
        }
        [self loadBeforeAfterData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _rootView.frame = self.view.bounds;
    if(_controller != nil) {
        _controller.view.frame = self.currentFrame;
    }
    if(_beforeDecorView != nil) {
        _beforeDecorView.frame = [self beforeDecorFrameFromFrame:self.currentFrame];
    }
    if(_afterDecorView != nil) {
        _afterDecorView.frame = [self afterDecorFrameFromFrame:self.currentFrame];
    }
}

#pragma mark Property

- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller {
    if(_controller != controller) {
        if(self.isViewLoaded == YES) {
            _controller = controller;
            if(_controller != nil) {
                _controller.pageController = self;
                if(_controller.parentViewController != self) {
                    if(_controller.parentViewController != nil) {
                        [_controller willMoveToParentViewController:nil];
                        [_controller.view removeFromSuperview];
                        [_controller removeFromParentViewController];
                    }
                    [self addChildViewController:_controller];
                    _controller.view.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
                    _controller.view.frame = self.currentFrame;
                    [_rootView addSubview:_controller.view];
                    [_controller didMoveToParentViewController:self];
                }
            }
            [self loadBeforeAfterData];
        } else {
            _controller = controller;
        }
    }
}

- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller direction:(MobilyPageControllerDirection)direction animated:(BOOL)animated {
    [self setController:controller direction:direction duration:ANIMATION_DURATION animated:animated];
}

- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated {
    [self setController:controller direction:direction duration:duration animated:animated notification:NO];
}

- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated notification:(BOOL)notification {
    UIViewController< MobilyPageControllerDelegate >* currentController = _controller;
    if(notification == YES) {
        if([currentController respondsToSelector:@selector(willDisappearInPageController:)] == YES) {
            [currentController willDisappearInPageController:self];
        }
        if([controller respondsToSelector:@selector(willAppearInPageController:)] == YES) {
            [controller willAppearInPageController:self];
        }
    }
    if((self.isViewLoaded == YES) && (animated == YES)) {
        self.animating = YES;
        _rootView.userInteractionEnabled = NO;
        self.animateController = controller;
        switch(direction) {
            case MobilyPageControllerDirectionReverse:
                _animateController.view.frame = self.beforeFrame;
                break;
            case MobilyPageControllerDirectionForward:
                _animateController.view.frame = self.afterFrame;
                break;
        }
        [UIView animateWithDuration:duration
                         animations:^{
                             switch(direction) {
                                 case MobilyPageControllerDirectionReverse:
                                     _controller.view.frame = self.afterFrame;
                                     _animateController.view.frame = self.currentFrame;
                                     if(_beforeDecorView != nil) {
                                         _beforeDecorView.frame = [self afterDecorFrameFromFrame:_animateController.view.frame];
                                     }
                                     break;
                                 case MobilyPageControllerDirectionForward:
                                     _controller.view.frame = self.beforeFrame;
                                     _animateController.view.frame = self.currentFrame;
                                     if(_afterDecorView != nil) {
                                         _afterDecorView.frame = [self beforeDecorFrameFromFrame:_animateController.view.frame];
                                     }
                                     break;
                             }
                         } completion:^(BOOL finished) {
                             switch(direction) {
                                 case MobilyPageControllerDirectionReverse:
                                     _controller.view.frame = self.afterFrame;
                                     _animateController.view.frame = self.currentFrame;
                                     break;
                                 case MobilyPageControllerDirectionForward:
                                     _controller.view.frame = self.beforeFrame;
                                     _animateController.view.frame = self.currentFrame;
                                     break;
                             }
                             self.animateController = nil;
                             self.controller = controller;
                             _rootView.userInteractionEnabled = YES;
                             self.animating = NO;
                             if(notification == YES) {
                                 if([controller respondsToSelector:@selector(didAppearInPageController:)] == YES) {
                                     [controller didAppearInPageController:self];
                                 }
                                 if([currentController respondsToSelector:@selector(didDisappearInPageController:)] == YES) {
                                     [currentController didDisappearInPageController:self];
                                 }
                             }
                         }];
    } else {
        self.controller = controller;
        if(notification == YES) {
            if([controller respondsToSelector:@selector(didAppearInPageController:)] == YES) {
                [controller didAppearInPageController:self];
            }
            if([currentController respondsToSelector:@selector(didDisappearInPageController:)] == YES) {
                [currentController didDisappearInPageController:self];
            }
        }
    }
}

- (void)setAnimateController:(UIViewController< MobilyPageControllerDelegate >*)animateController {
    if(_animateController != animateController) {
        _animateController = animateController;
        if(_animateController != nil) {
            if(_animateController.parentViewController != self) {
                if(_animateController.parentViewController != nil) {
                    [_animateController willMoveToParentViewController:nil];
                    [_animateController.view removeFromSuperview];
                    [_animateController removeFromParentViewController];
                }
                [self addChildViewController:_animateController];
                _animateController.view.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
                _animateController.view.frame = self.beforeFrame;
                [_rootView addSubview:_animateController.view];
                [_animateController didMoveToParentViewController:self];
            }
        }
    }
}

- (void)setBeforeDecorView:(UIView*)beforeDecorView {
    if(_beforeDecorView != beforeDecorView) {
        if(_beforeDecorView != nil) {
            [_beforeDecorView removeFromSuperview];
        }
        _beforeDecorView = beforeDecorView;
        if(_beforeDecorView != nil) {
            _beforeDecorView.frame = [self beforeDecorFrameFromFrame:self.currentFrame];
            [_rootView addSubview:_beforeDecorView];
            [_rootView sendSubviewToBack:_beforeDecorView];
        }
    }
}

- (void)setAfterDecorView:(UIView*)afterDecorView {
    if(_afterDecorView != afterDecorView) {
        if(_afterDecorView != nil) {
            [_afterDecorView removeFromSuperview];
        }
        _afterDecorView = afterDecorView;
        if(_afterDecorView != nil) {
            _afterDecorView.frame = [self afterDecorFrameFromFrame:self.currentFrame];
            [_rootView addSubview:_afterDecorView];
            [_rootView sendSubviewToBack:_afterDecorView];
        }
    }
}

- (void)loadBeforeAfterData {
    self.allowBeforeController = [_controller allowBeforeControllerInPageController:self];
    self.allowAfterController = [_controller allowAfterControllerInPageController:self];
    if(([_controller respondsToSelector:@selector(beforeDecorSizeInPageController:)] == YES) && ([_controller respondsToSelector:@selector(beforeDecorViewInPageController:)] == YES)) {
        if([_controller respondsToSelector:@selector(beforeDecorInsetsInPageController:)] == YES) {
            self.beforeDecorInsets = [_controller beforeDecorInsetsInPageController:self];
        }
        self.beforeDecorSize = [_controller beforeDecorSizeInPageController:self];
        self.beforeDecorView = [_controller beforeDecorViewInPageController:self];
    }
    if(([_controller respondsToSelector:@selector(afterDecorSizeInPageController:)] == YES) && ([_controller respondsToSelector:@selector(afterDecorViewInPageController:)] == YES)) {
        if([_controller respondsToSelector:@selector(afterDecorInsetsInPageController:)] == YES) {
            self.afterDecorInsets = [_controller afterDecorInsetsInPageController:self];
        }
        self.afterDecorSize = [_controller afterDecorSizeInPageController:self];
        self.afterDecorView = [_controller afterDecorViewInPageController:self];
    }
}

- (CGRect)beforeFrame {
    CGRect currentFrame = self.currentFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical:
            return CGRectMake(currentFrame.origin.x, currentFrame.origin.y - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
        case MobilyPageControllerOrientationHorizontal:
            return CGRectMake(currentFrame.origin.x - currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }
}

- (CGRect)currentFrame {
    return _rootView.bounds;
}

- (CGRect)afterFrame {
    CGRect currentFrame = self.currentFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical:
            return CGRectMake(currentFrame.origin.x, currentFrame.origin.y + currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
        case MobilyPageControllerOrientationHorizontal:
            return CGRectMake(currentFrame.origin.x + currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }
}

- (CGRect)beforeDecorFrame {
    CGRect result = CGRectZero;
    CGRect beforeFrame = self.beforeFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical:
            result.origin.x = CGRectGetMidX(beforeFrame) - (_beforeDecorSize.width * 0.5f);
            result.origin.y = CGRectGetMaxY(beforeFrame) - _beforeDecorSize.height;
            result.size.width = _beforeDecorSize.width;
            result.size.height = _beforeDecorSize.height;
            break;
        case MobilyPageControllerOrientationHorizontal:
            result.origin.x = CGRectGetMaxX(beforeFrame) - _beforeDecorSize.width;
            result.origin.y = CGRectGetMidY(beforeFrame) - (_beforeDecorSize.height * 0.5f);
            result.size.width = _beforeDecorSize.width;
            result.size.height = _beforeDecorSize.height;
            break;
    }
    result = UIEdgeInsetsInsetRect(result, _beforeDecorInsets);
    result.size.width = MAX(0.0f, result.size.width);
    result.size.height = MAX(0.0f, result.size.height);
    return result;
}

- (CGRect)beforeDecorFrameFromFrame:(CGRect)currentFrame {
    CGRect result = CGRectZero;
    CGRect beforeFrame = self.beforeFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical: {
            CGFloat delta = CGRectGetMinY(currentFrame) - CGRectGetMaxY(beforeFrame);
            CGFloat scale = MAX(SCALE_MIN, MIN(ABS(delta) / _beforeDecorSize.height, SCALE_MAX));
            CGFloat beforeDecorWidth = _beforeDecorSize.width * scale;
            CGFloat beforeDecorHeight = _beforeDecorSize.height * scale;
            result.origin.x = CGRectGetMidX(beforeFrame) - (beforeDecorWidth * 0.5f);
            result.origin.y = (CGRectGetMaxY(beforeFrame) + (delta * 0.5f)) - (beforeDecorHeight * 0.5f);
            result.size.width = beforeDecorWidth;
            result.size.height = beforeDecorHeight;
            break;
        }
        case MobilyPageControllerOrientationHorizontal: {
            CGFloat delta = CGRectGetMinX(currentFrame) - CGRectGetMaxX(beforeFrame);
            CGFloat scale = MAX(SCALE_MIN, MIN(ABS(delta) / _beforeDecorSize.width, SCALE_MAX));
            CGFloat beforeDecorWidth = _beforeDecorSize.width * scale;
            CGFloat beforeDecorHeight = _beforeDecorSize.height * scale;
            result.origin.x = (CGRectGetMaxX(beforeFrame) + (delta * 0.5f)) - (beforeDecorWidth * 0.5f);
            result.origin.y = CGRectGetMidY(beforeFrame) - (beforeDecorHeight * 0.5f);
            result.size.width = beforeDecorWidth;
            result.size.height = beforeDecorHeight;
            break;
        }
    }
    result = UIEdgeInsetsInsetRect(result, _beforeDecorInsets);
    result.size.width = MAX(0.0f, result.size.width);
    result.size.height = MAX(0.0f, result.size.height);
    return result;
}

- (CGRect)afterDecorFrame {
    CGRect result = CGRectZero;
    CGRect afterFrame = self.afterFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical:
            result.origin.x = CGRectGetMidX(afterFrame) - (_afterDecorSize.width * 0.5f);
            result.origin.y = CGRectGetMinY(afterFrame);
            result.size.width = _beforeDecorSize.width;
            result.size.height = _beforeDecorSize.height;
            break;
        case MobilyPageControllerOrientationHorizontal:
            result.origin.x = CGRectGetMinX(afterFrame);
            result.origin.y = CGRectGetMidY(afterFrame) - (_afterDecorSize.height * 0.5f);
            result.size.width = _afterDecorSize.width;
            result.size.height = _afterDecorSize.height;
            break;
    }
    result = UIEdgeInsetsInsetRect(result, _afterDecorInsets);
    result.size.width = MAX(0.0f, result.size.width);
    result.size.height = MAX(0.0f, result.size.height);
    return result;
}

- (CGRect)afterDecorFrameFromFrame:(CGRect)currentFrame {
    CGRect result = CGRectZero;
    CGRect afterFrame = self.afterFrame;
    switch(_orientation) {
        case MobilyPageControllerOrientationVertical: {
            CGFloat delta = CGRectGetMinY(afterFrame) - CGRectGetMaxY(currentFrame);
            CGFloat scale = MAX(SCALE_MIN, MIN(ABS(delta) / _afterDecorSize.height, SCALE_MAX));
            CGFloat afterDecorWidth = _afterDecorSize.width * scale;
            CGFloat afterDecorHeight = _afterDecorSize.height * scale;
            result.origin.x = CGRectGetMidX(afterFrame) - (afterDecorWidth * 0.5f);
            result.origin.y = (CGRectGetMinY(afterFrame) - (delta * 0.5f)) - (afterDecorHeight * 0.5f);
            result.size.width = afterDecorWidth;
            result.size.height = afterDecorHeight;
            break;
        }
        case MobilyPageControllerOrientationHorizontal: {
            CGFloat delta = CGRectGetMinX(afterFrame) - CGRectGetMaxX(currentFrame);
            CGFloat scale = MAX(SCALE_MIN, MIN(ABS(delta) / _afterDecorSize.width, SCALE_MAX));
            CGFloat afterDecorWidth = _afterDecorSize.width * scale;
            CGFloat afterDecorHeight = _afterDecorSize.height * scale;
            result.origin.x = CGRectGetMinX(afterFrame) - (delta * 0.5f) - (afterDecorWidth * 0.5f);
            result.origin.y = CGRectGetMidY(afterFrame) - (afterDecorHeight * 0.5f);
            result.size.width = afterDecorWidth;
            result.size.height = afterDecorHeight;
            break;
        }
    }
    result = UIEdgeInsetsInsetRect(result, _afterDecorInsets);
    result.size.width = MAX(0.0f, result.size.width);
    result.size.height = MAX(0.0f, result.size.height);
    return result;
}

- (void)panGestureHandle:(UIPanGestureRecognizer*)panGesture {
    CGPoint currentPosition = [panGesture locationInView:_rootView];
	switch(panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            _panBeganPosition = currentPosition;
			break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint offset = CGPointZero;
            if(_userInteractionEnabled == YES) {
                switch(_orientation) {
                    case MobilyPageControllerOrientationVertical:
                        offset.y = currentPosition.y - _panBeganPosition.y;
                        break;
                    case MobilyPageControllerOrientationHorizontal:
                        offset.x = currentPosition.x - _panBeganPosition.x;
                        break;
                }
                if(_friendlyGestures.count > 0) {
                    for(UIGestureRecognizer* gesture in _friendlyGestures) {
                        if([gesture.view isKindOfClass:UIScrollView.class] == YES) {
                            UIScrollView* scrollView = (UIScrollView*)gesture.view;
                            if(scrollView.scrollEnabled == YES) {
                                UIEdgeInsets contentInsets = scrollView.contentInset;
                                CGPoint contentOffset = scrollView.contentOffset;
                                CGSize contentSize = scrollView.contentSize;
                                CGRect frame = scrollView.frame;
                                switch(_orientation) {
                                    case MobilyPageControllerOrientationVertical: {
                                        if(((contentOffset.y + contentInsets.top) <= offset.y) && (offset.y > 0.0f)) {
                                            scrollView.contentOffsetY = -contentInsets.top;
                                        } else if(((contentOffset.y + frame.size.height) >= contentSize.height + offset.y) && (offset.y < 0.0f)) {
                                            scrollView.contentOffsetY = (contentSize.height - frame.size.height) + contentInsets.bottom;
                                        } else {
                                            _panBeganPosition.y = currentPosition.y;
                                        }
                                        break;
                                    }
                                    case MobilyPageControllerOrientationHorizontal: {
                                        if(((contentOffset.x + contentInsets.left) <= offset.x) && (offset.x > 0.0f)) {
                                            scrollView.contentOffsetX = -contentInsets.left;
                                        } else if(((contentOffset.x + frame.size.width) >= contentSize.width + offset.x) && (offset.x < 0.0f)) {
                                            scrollView.contentOffsetX = (contentSize.width - frame.size.width) + contentInsets.right;
                                        } else {
                                            _panBeganPosition.x = currentPosition.x;
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                CGRect currentFrame = self.currentFrame;
                switch(_orientation) {
                    case MobilyPageControllerOrientationVertical:
                        offset.y = (currentPosition.y - _panBeganPosition.y) * _draggingRate;
                        if(_allowBeforeController == YES) {
                            if((currentFrame.origin.y + offset.y) > 0.0f) {
                                offset.y = (_bounceRate > 0.0f) ? offset.y * _bounceRate : 0.0f;
                            }
                        }
                        if(_allowAfterController == YES) {
                            if((currentFrame.origin.y + offset.y) < 0.0f) {
                                offset.y = (_bounceRate > 0.0f) ? offset.y * _bounceRate : 0.0f;
                            }
                        }
                        break;
                    case MobilyPageControllerOrientationHorizontal:
                        offset.x = (currentPosition.x - _panBeganPosition.x) * _draggingRate;
                        if(_allowBeforeController == YES) {
                            if((currentFrame.origin.x + offset.x) > 0.0f) {
                                offset.x = (_bounceRate > 0.0f) ? offset.x * _bounceRate : 0.0f;
                            }
                        }
                        if(_allowAfterController == YES) {
                            if((currentFrame.origin.x + offset.x) < 0.0f) {
                                offset.x = (_bounceRate > 0.0f) ? offset.x * _bounceRate : 0.0f;
                            }
                        }
                        break;
                }
                currentFrame = CGRectOffset(currentFrame, floorf(offset.x), floorf(offset.y));
                _controller.view.frame = currentFrame;
                if(_beforeDecorView != nil) {
                    _beforeDecorView.frame = [self beforeDecorFrameFromFrame:currentFrame];
                }
                if(_afterDecorView != nil) {
                    _afterDecorView.frame = [self afterDecorFrameFromFrame:currentFrame];
                }
            } else {
                _panBeganPosition = currentPosition;
            }
			break;
		}
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled: {
            BOOL needRestore = NO;
            switch(_orientation) {
                case MobilyPageControllerOrientationVertical: {
                    CGFloat delta = currentPosition.y - _panBeganPosition.y;
                    if(delta > THRESHOLD_VERTICAL_OFFSET) {
                        if(_allowBeforeController == YES) {
                            UIViewController< MobilyPageControllerDelegate >* controller = nil;
                            if([_controller respondsToSelector:@selector(beforeControllerInPageController:)] == YES) {
                                controller = [_controller beforeControllerInPageController:self];
                            }
                            if(controller != nil) {
                                [self setController:controller direction:MobilyPageControllerDirectionReverse duration:ANIMATION_DURATION animated:YES notification:YES];
                            } else {
                                needRestore = YES;
                            }
                        } else {
                            needRestore = YES;
                        }
                    } else if(delta < -THRESHOLD_VERTICAL_OFFSET) {
                        if(_allowBeforeController == YES) {
                            UIViewController< MobilyPageControllerDelegate >* controller = nil;
                            if([_controller respondsToSelector:@selector(afterControllerInPageController:)] == YES) {
                                controller = [_controller afterControllerInPageController:self];
                            }
                            if(controller != nil) {
                                [self setController:controller direction:MobilyPageControllerDirectionForward duration:ANIMATION_DURATION animated:YES notification:YES];
                            } else {
                                needRestore = YES;
                            }
                        } else {
                            needRestore = YES;
                        }
                    } else {
                        needRestore = YES;
                    }
                    break;
                }
                case MobilyPageControllerOrientationHorizontal: {
                    CGFloat delta = currentPosition.x - _panBeganPosition.x;
                    if(delta > THRESHOLD_VERTICAL_OFFSET) {
                        if(_allowBeforeController == YES) {
                            UIViewController< MobilyPageControllerDelegate >* controller = nil;
                            if([_controller respondsToSelector:@selector(beforeControllerInPageController:)] == YES) {
                                controller = [_controller beforeControllerInPageController:self];
                            }
                            if(controller != nil) {
                                [self setController:controller direction:MobilyPageControllerDirectionReverse duration:ANIMATION_DURATION animated:YES notification:YES];
                            } else {
                                needRestore = YES;
                            }
                        } else {
                            needRestore = YES;
                        }
                    } else if(delta < -THRESHOLD_VERTICAL_OFFSET) {
                        if(_allowBeforeController == YES) {
                            UIViewController< MobilyPageControllerDelegate >* controller = nil;
                            if([_controller respondsToSelector:@selector(afterControllerInPageController:)] == YES) {
                                controller = [_controller afterControllerInPageController:self];
                            }
                            if(controller != nil) {
                                [self setController:controller direction:MobilyPageControllerDirectionForward duration:ANIMATION_DURATION animated:YES notification:YES];
                            } else {
                                needRestore = YES;
                            }
                        } else {
                            needRestore = YES;
                        }
                    } else {
                        needRestore = YES;
                    }
                    break;
                }
            }
            if(needRestore == YES) {
                _rootView.userInteractionEnabled = NO;
                [UIView animateWithDuration:ANIMATION_DURATION
                                 animations:^{
                                     _controller.view.frame = self.currentFrame;
                                     if(_beforeDecorView != nil) {
                                         _beforeDecorView.frame = [self beforeDecorFrameFromFrame:self.currentFrame];
                                     }
                                     if(_afterDecorView != nil) {
                                         _afterDecorView.frame = [self afterDecorFrameFromFrame:self.currentFrame];
                                     }
                                 } completion:^(BOOL finished) {
                                     _rootView.userInteractionEnabled = YES;
                                 }];
            }
            [_friendlyGestures removeAllObjects];
			break;
		}
		default:
			break;
	}
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gesture {
    BOOL result = NO;
    if(gesture == _panGesture) {
        if(_userInteractionEnabled == YES) {
            CGPoint translation = [_panGesture translationInView:_rootView];
            switch(_orientation) {
                case MobilyPageControllerOrientationVertical:
                    if(fabs(translation.y) >= fabs(translation.x)) {
                        if(translation.y > 0.0f) {
                            result = (_allowBeforeController == YES) || (_bounceRate > 0.0f);
                        } else if(translation.y < 0.0f) {
                            result = (_allowAfterController == YES) || (_bounceRate > 0.0f);
                        } else {
                            result = (_allowAfterController == YES) || (_allowBeforeController == YES);
                        }
                    }
                    break;
                case MobilyPageControllerOrientationHorizontal:
                    if(fabs(translation.x) >= fabs(translation.y)) {
                        if(translation.x > 0.0f) {
                            result = (_allowBeforeController == YES) || (_bounceRate > 0.0f);
                        } else if(translation.x < 0.0f) {
                            result = (_allowAfterController == YES) || (_bounceRate > 0.0f);
                        } else {
                            result = (_allowAfterController == YES) || (_allowBeforeController == YES);
                        }
                    }
                    break;
            }
        }
    }
    return result;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGesture {
    if([otherGesture isKindOfClass:UIPanGestureRecognizer.class] == YES) {
        if([otherGesture.view isKindOfClass:UIScrollView.class] == YES) {
            if([_friendlyGestures containsObject:otherGesture] == NO) {
                [_friendlyGestures addObject:otherGesture];
            }
            return YES;
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

static char const* const MobilySlideControllerKey = "MobilySlideControllerKey";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyPageController)

- (void)setPageController:(MobilyPageController*)pageController {
    objc_setAssociatedObject(self, MobilySlideControllerKey, pageController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MobilyPageController*)pageController {
    MobilyPageController* pageController = objc_getAssociatedObject(self, MobilySlideControllerKey);
    if(pageController == nil) {
        pageController = self.parentViewController.pageController;
    }
    return pageController;
}

@end

/*--------------------------------------------------*/
