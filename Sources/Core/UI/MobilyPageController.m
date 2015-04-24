/*--------------------------------------------------*/

#import <MobilyPageController.h>

/*--------------------------------------------------*/

#define ANIMATION_DURATION                      0.2f

#define THRESHOLD_HORIZONTAL_OFFSET             100.0f
#define THRESHOLD_VERTICAL_OFFSET               120.0f

#define SCALE_MIN                               0.5f
#define SCALE_MAX                               1.0f

/*--------------------------------------------------*/

@interface MobilyPageController () < UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, assign, getter = isAnimating) BOOL animating;
@property(nonatomic, readonly, assign, getter = isAppearedBeforeController) BOOL appearedBeforeController;
@property(nonatomic, readonly, assign, getter = isAppearedAfterController) BOOL appearedAfterController;
@property(nonatomic, readwrite, strong) UIViewController* beforeController;
@property(nonatomic, readwrite, strong) UIViewController* afterController;
@property(nonatomic, readwrite, assign) UIEdgeInsets beforeDecorInsets;
@property(nonatomic, readwrite, assign) UIEdgeInsets afterDecorInsets;
@property(nonatomic, readwrite, assign) CGSize beforeDecorSize;
@property(nonatomic, readwrite, assign) CGSize afterDecorSize;
@property(nonatomic, readwrite, strong) UIView* beforeDecorView;
@property(nonatomic, readwrite, strong) UIView* afterDecorView;
@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGesture;
@property(nonatomic, readwrite, assign) CGPoint panBeganPosition;

- (void)loadBeforeAfterData;

- (CGRect)beforeFrame;
- (CGRect)currentFrame;
- (CGRect)afterFrame;

- (CGRect)beforeDecorFrame;
- (CGRect)beforeDecorFrameFromFrame:(CGRect)currentFrame;
- (CGRect)afterDecorFrame;
- (CGRect)afterDecorFrameFromFrame:(CGRect)currentFrame;

- (void)panGesture:(UIPanGestureRecognizer*)panGesture;

@end

/*--------------------------------------------------*/

@implementation MobilyPageController

- (void)setup {
    [super setup];
    
    [self setDraggingRate:0.5f];
    [self setBounceRate:0.5f];
    [self setEnableScroll:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [_panGesture setDelegate:self];
    [self.view addGestureRecognizer:_panGesture];
    
    if(_controller != nil) {
        [self addChildViewController:_controller];
        _controller.view.frame = self.view.bounds;
        [self.view addSubview:_controller.view];
        [_controller didMoveToParentViewController:self];
        
        [self loadBeforeAfterData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if(_controller != nil) {
        _controller.view.frame = self.currentFrame;
    }
    if(_beforeController != nil) {
        _beforeController.view.frame = self.beforeFrame;
    }
    if(_beforeDecorView != nil) {
        _beforeDecorView.frame = [self beforeDecorFrameFromFrame:self.currentFrame];
    }
    if(_afterController != nil) {
        _afterController.view.frame = self.afterFrame;
    }
    if(_afterDecorView != nil) {
        _afterDecorView.frame = [self afterDecorFrameFromFrame:self.currentFrame];
    }
}

#pragma mark Property

- (void)setController:(UIViewController*)controller {
    if(_controller != controller) {
        if(self.isViewLoaded == YES) {
            if(_controller != nil) {
                [_controller willMoveToParentViewController:nil];
                [_controller.view removeFromSuperview];
                [_controller removeFromParentViewController];
            }
            _controller = controller;
            if(_controller != nil) {
                [self addChildViewController:_controller];
                _controller.view.frame = self.view.bounds;
                [self.view addSubview:_controller.view];
                [_controller didMoveToParentViewController:self];
            }
            [self loadBeforeAfterData];
        } else {
            _controller = controller;
        }
    }
}

- (void)setController:(UIViewController*)controller direction:(MobilyPageControllerDirection)direction animated:(BOOL)animated {
    [self setController:controller direction:direction duration:ANIMATION_DURATION animated:animated];
}

- (void)setController:(UIViewController*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated {
    [self setController:controller direction:direction duration:duration animated:animated notification:NO];
}

- (void)setController:(UIViewController*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated notification:(BOOL)notification {
    if((notification == YES) && ([_delegate respondsToSelector:@selector(pageController:willChangedController:)] == YES)) {
        [_delegate pageController:self willChangedController:controller];
    }
    if((self.isViewLoaded == YES) && (animated == YES)) {
        self.animating = YES;
        self.view.userInteractionEnabled = NO;
        switch(direction) {
            case MobilyPageControllerDirectionReverse:
                self.beforeController = controller;
                _beforeController.view.hidden = NO;
                break;
            case MobilyPageControllerDirectionForward:
                self.afterController = controller;
                _afterController.view.hidden = NO;
                break;
        }
        [UIView animateWithDuration:duration
                         animations:^{
                             switch(direction) {
                                 case MobilyPageControllerDirectionReverse:
                                     _controller.view.frame = self.afterFrame;
                                     _beforeController.view.frame = self.currentFrame;
                                     if(_beforeDecorView != nil) {
                                         _beforeDecorView.frame = [self afterDecorFrameFromFrame:_beforeController.view.frame];
                                     }
                                     break;
                                 case MobilyPageControllerDirectionForward:
                                     _controller.view.frame = self.beforeFrame;
                                     _afterController.view.frame = self.currentFrame;
                                     if(_afterDecorView != nil) {
                                         _afterDecorView.frame = [self beforeDecorFrameFromFrame:_afterController.view.frame];
                                     }
                                     break;
                             }
                         } completion:^(BOOL finished) {
                             switch(direction) {
                                 case MobilyPageControllerDirectionReverse:
                                     _controller.view.frame = self.afterFrame;
                                     _beforeController.view.frame = self.currentFrame;
                                     break;
                                 case MobilyPageControllerDirectionForward:
                                     _controller.view.frame = self.beforeFrame;
                                     _afterController.view.frame = self.currentFrame;
                                     break;
                             }
                             _beforeController.view.hidden = YES;
                             _afterController.view.hidden = YES;
                             self.controller = controller;
                             self.view.userInteractionEnabled = YES;
                             self.animating = NO;
                             if((notification == YES) && ([_delegate respondsToSelector:@selector(pageController:didChangedController:)] == YES)) {
                                 [_delegate pageController:self didChangedController:controller];
                             }
                         }];
    } else {
        self.controller = controller;
        if((notification == YES) && ([_delegate respondsToSelector:@selector(pageController:didChangedController:)] == YES)) {
            [_delegate pageController:self didChangedController:controller];
        }
    }
}

- (void)setBeforeController:(UIViewController*)beforeController {
    if(_beforeController != beforeController) {
        if(_beforeController != nil) {
            [_beforeController willMoveToParentViewController:nil];
            [_beforeController.view removeFromSuperview];
            [_beforeController removeFromParentViewController];
        }
        _beforeController = beforeController;
        if(_beforeController != nil) {
            [self addChildViewController:_beforeController];
            _beforeController.view.frame = self.beforeFrame;
            [self.view addSubview:_beforeController.view];
            [_beforeController didMoveToParentViewController:self];
        }
    }
}

- (void)setAfterController:(UIViewController*)afterController {
    if(_afterController != afterController) {
        if(_afterController != nil) {
            [_afterController willMoveToParentViewController:nil];
            [_afterController.view removeFromSuperview];
            [_afterController removeFromParentViewController];
        }
        _afterController = afterController;
        if(_afterController != nil) {
            [self addChildViewController:_afterController];
            _afterController.view.frame = self.afterFrame;
            [self.view addSubview:_afterController.view];
            [_afterController didMoveToParentViewController:self];
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
            [self.view addSubview:_beforeDecorView];
            [self.view sendSubviewToBack:_beforeDecorView];
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
            [self.view addSubview:_afterDecorView];
            [self.view sendSubviewToBack:_afterDecorView];
        }
    }
}

- (void)loadBeforeAfterData {
    self.beforeController = [_delegate pageController:self controllerBeforeController:_controller];
    self.afterController = [_delegate pageController:self controllerAfterController:_controller];
    if(([_delegate respondsToSelector:@selector(pageController:decorSizeBeforeController:)] == YES) && ([_delegate respondsToSelector:@selector(pageController:decorViewBeforeController:)] == YES)) {
        if([_delegate respondsToSelector:@selector(pageController:decorInsetsBeforeController:)] == YES) {
            self.beforeDecorInsets = [_delegate pageController:self decorInsetsBeforeController:_controller];
        }
        self.beforeDecorSize = [_delegate pageController:self decorSizeBeforeController:_controller];
        self.beforeDecorView = [_delegate pageController:self decorViewBeforeController:_controller];
    }
    if(([_delegate respondsToSelector:@selector(pageController:decorSizeAfterController:)] == YES) && ([_delegate respondsToSelector:@selector(pageController:decorViewAfterController:)] == YES)) {
        if([_delegate respondsToSelector:@selector(pageController:decorInsetsAfterController:)] == YES) {
            self.afterDecorInsets = [_delegate pageController:self decorInsetsAfterController:_controller];
        }
        self.afterDecorSize = [_delegate pageController:self decorSizeAfterController:_controller];
        self.afterDecorView = [_delegate pageController:self decorViewAfterController:_controller];
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
    return self.view.bounds;
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

- (void)panGesture:(UIPanGestureRecognizer*)panGesture {
    CGPoint currentPosition = [panGesture locationInView:self.view];
	switch(panGesture.state) {
		case UIGestureRecognizerStateBegan: {
            _panBeganPosition = currentPosition;
            if(_beforeController == nil) {
                _beforeController.view.hidden = NO;
            }
            if(_afterController == nil) {
                _afterController.view.hidden = NO;
            }
            [self setAnimating:YES];
			break;
        }
		case UIGestureRecognizerStateChanged: {
            CGRect currentFrame = self.currentFrame;
            CGPoint offset = CGPointZero;
            switch(_orientation) {
                case MobilyPageControllerOrientationVertical:
                    offset.y = (currentPosition.y - _panBeganPosition.y) * _draggingRate;
                    if(_beforeController == nil) {
                        if((currentFrame.origin.y + offset.y) > 0.0f) {
                            offset.y = (_bounceRate > 0.0f) ? offset.y * _bounceRate : 0.0f;
                        }
                    }
                    if(_afterController == nil) {
                        if((currentFrame.origin.y + offset.y) < 0.0f) {
                            offset.y = (_bounceRate > 0.0f) ? offset.y * _bounceRate : 0.0f;
                        }
                    }
                    break;
                case MobilyPageControllerOrientationHorizontal:
                    offset.x = (currentPosition.x - _panBeganPosition.x) * _draggingRate;
                    if(_beforeController == nil) {
                        if((currentFrame.origin.x + offset.x) > 0.0f) {
                            offset.x = (_bounceRate > 0.0f) ? offset.x * _bounceRate : 0.0f;
                        }
                    }
                    if(_afterController == nil) {
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
			break;
		}
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled: {
            BOOL needRestore = NO;
            switch(_orientation) {
                case MobilyPageControllerOrientationVertical: {
                    CGFloat delta = currentPosition.y - _panBeganPosition.y;
                    if(delta > THRESHOLD_VERTICAL_OFFSET) {
                        if(_beforeController != nil) {
                            [self setController:_beforeController direction:MobilyPageControllerDirectionReverse duration:ANIMATION_DURATION animated:YES notification:YES];
                        } else {
                            needRestore = YES;
                        }
                    } else if(delta < -THRESHOLD_VERTICAL_OFFSET) {
                        if(_afterController != nil) {
                            [self setController:_afterController direction:MobilyPageControllerDirectionForward duration:ANIMATION_DURATION animated:YES notification:YES];
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
                    if(delta > THRESHOLD_HORIZONTAL_OFFSET) {
                        if(_beforeController != nil) {
                            [self setController:_beforeController direction:MobilyPageControllerDirectionReverse duration:ANIMATION_DURATION animated:YES notification:YES];
                        } else {
                            needRestore = YES;
                        }
                    } else if(delta < -THRESHOLD_HORIZONTAL_OFFSET) {
                        if(_afterController != nil) {
                            [self setController:_afterController direction:MobilyPageControllerDirectionForward duration:ANIMATION_DURATION animated:YES notification:YES];
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
                self.view.userInteractionEnabled = NO;
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
                                     self.view.userInteractionEnabled = YES;
                                 }];
            }
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
        if(_enableScroll == YES) {
            CGPoint translation = [_panGesture translationInView:self.view];
            switch(_orientation) {
                case MobilyPageControllerOrientationVertical:
                    if(fabs(translation.y) >= fabs(translation.x)) {
                        if(translation.y > 0.0f) {
                            result = (_beforeController != nil) || (_bounceRate > 0.0f);
                        } else if(translation.y < 0.0f) {
                            result = (_afterController != nil) || (_bounceRate > 0.0f);
                        } else {
                            result = (_afterController != nil) || (_beforeController != nil);
                        }
                    }
                    break;
                case MobilyPageControllerOrientationHorizontal:
                    if(fabs(translation.x) >= fabs(translation.y)) {
                        if(translation.x > 0.0f) {
                            result = (_beforeController != nil) || (_bounceRate > 0.0f);
                        } else if(translation.x < 0.0f) {
                            result = (_afterController != nil) || (_bounceRate > 0.0f);
                        } else {
                            result = (_afterController != nil) || (_beforeController != nil);
                        }
                    }
                    break;
            }
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/
