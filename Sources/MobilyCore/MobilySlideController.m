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

#import <MobilyCore/MobilySlideController.h>

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

@property(nonatomic, readwrite, strong) UIView* backgroundView;
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

- (void)appearBackgroundController;
- (void)disappearBackgroundController;
- (void)appearLeftController;
- (void)disappearLeftController;
- (void)appearCenterController;
- (void)disappearCenterController;
- (void)appearRightController;
- (void)disappearRightController;

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe;

- (void)willBeganSwipe;
- (void)didBeganSwipe;
- (void)movingSwipe:(CGFloat)progress;
- (void)willEndedSwipe;
- (void)didEndedSwipe;

- (void)tapGestureHandle:(UITapGestureRecognizer*)tapGesture;
- (void)panGestureHandle:(UIPanGestureRecognizer*)panGesture;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilySlideController

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    if(UIDevice.moIsIPhone == YES) {
        _swipeThreshold = 2.0f;
        _swipeVelocity = 1050.0f;
        _leftControllerWidth = 280.0f;
        _rightControllerWidth = 280.0f;
    } else if(UIDevice.moIsIPad == YES) {
        _swipeThreshold = 2.0f;
        _swipeVelocity = 3000.0f;
        _leftControllerWidth = 320.0f;
        _rightControllerWidth = 320.0f;
    }

}

- (void)dealloc {
    self.backgroundController = nil;
    self.leftController = nil;
    self.centerController = nil;
    self.rightController = nil;
    self.backgroundView = nil;
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
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.leftView = [[UIView alloc] initWithFrame:[self leftViewFrameByPercent:0.0f]];
    self.centerView = [[UIView alloc] initWithFrame:[self centerViewFrameByPercent:0.0f]];
    self.rightView = [[UIView alloc] initWithFrame:[self rightViewFrameByPercent:0.0f]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_backgroundController != nil) {
        [self appearBackgroundController];
    }
    if(_leftController != nil) {
        [self appearLeftController];
    }
    if(_centerController != nil) {
        [self appearCenterController];
    }
    if(_rightController != nil) {
        [self appearRightController];
    } 
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    _backgroundView.frame = bounds;
    _leftView.frame = [self leftViewFrameFromBounds:bounds byPercent:_swipeProgress];
    _centerView.frame = [self centerViewFrameFromBounds:bounds byPercent:_swipeProgress];
    _rightView.frame = [self rightViewFrameFromBounds:bounds byPercent:_swipeProgress];
}

#pragma mark Property

- (void)setTapGesture:(UITapGestureRecognizer*)tapGesture {
    if(_tapGesture != tapGesture) {
        if(_tapGesture != nil) {
            [self.view removeGestureRecognizer:_tapGesture];
        }
        _tapGesture = tapGesture;
        if(_tapGesture != nil) {
            _tapGesture.delegate = self;
            [self.view addGestureRecognizer:_tapGesture];
        }
    }
}

- (void)setPanGesture:(UIPanGestureRecognizer*)panGesture {
    if(_panGesture != panGesture) {
        if(_panGesture != nil) {
            [self.view removeGestureRecognizer:_panGesture];
        }
        _panGesture = panGesture;
        if(_panGesture != nil) {
            _panGesture.delegate = self;
            [self.view addGestureRecognizer:_panGesture];
        }
    }
}

- (void)setBackgroundView:(UIView*)backgroundView {
    if(_backgroundView != backgroundView) {
        if(_backgroundView != nil) {
            [_backgroundView removeFromSuperview];
        }
        _backgroundView = backgroundView;
        if(_backgroundView != nil) {
            [self.view addSubview:_backgroundView];
        }
    }
}

- (void)setLeftView:(UIView*)leftView {
    if(_leftView != leftView) {
        if(_leftView != nil) {
            [_leftView removeFromSuperview];
        }
        _leftView = leftView;
        if(_leftView != nil) {
            [self.view addSubview:_leftView];
        }
    }
}

- (void)setCenterView:(UIView*)centerView {
    if(_centerView != centerView) {
        if(_centerView != nil) {
            [_centerView removeFromSuperview];
        }
        _centerView = centerView;
        if(_centerView != nil) {
            [self.view addSubview:_centerView];
        }
    }
}

- (void)setRightView:(UIView*)rightView {
    if(_rightView != rightView) {
        if(_rightView != nil) {
            [_rightView removeFromSuperview];
        }
        _rightView = rightView;
        if(_rightView != nil) {
            [self.view addSubview:_rightView];
        }
    }
}

- (void)setBackgroundController:(UIViewController*)backgroundController {
    [self setBackgroundController:backgroundController animated:NO complete:nil];
}

- (void)setLeftController:(UIViewController*)leftController {
    [self setLeftController:leftController animated:NO complete:nil];
}

- (void)setCenterController:(UIViewController*)centerController {
    [self setCenterController:centerController animated:NO complete:nil];
}

- (void)setRightController:(UIViewController*)rightController {
    [self setRightController:rightController animated:NO complete:nil];
}

#pragma mark Public

- (void)setBackgroundController:(UIViewController*)backgroundController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_backgroundController != backgroundController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if((_backgroundController != nil) && (self.isViewLoaded == YES)) {
                [self disappearBackgroundController];
            }
            _backgroundController = backgroundController;
            if((_backgroundController != nil) && (self.isViewLoaded == YES)) {
                [self appearBackgroundController];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)setLeftController:(UIViewController*)leftController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_leftController != leftController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if((_leftController != nil) && (self.isViewLoaded == YES)) {
                [self disappearLeftController];
            }
            _leftController = leftController;
            if((_leftController != nil) && (self.isViewLoaded == YES)) {
                [self appearLeftController];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)setCenterController:(UIViewController*)centerController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_centerController != centerController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if((_centerController != nil) && (self.isViewLoaded == YES)) {
                [self disappearCenterController];
            }
            _centerController = centerController;
            if((_centerController != nil) && (self.isViewLoaded == YES)) {
                [self appearCenterController];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)setRightController:(UIViewController*)rightController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_rightController != rightController) {
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        if(animated == YES) {
        } else {
            if((_rightController != nil) && (self.isViewLoaded == YES)) {
                [self disappearRightController];
            }
            _rightController = rightController;
            if((_rightController != nil) && (self.isViewLoaded == YES)) {
                [self appearRightController];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)showLeftControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_showedLeftController == NO) {
        BOOL allow = YES;
        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if([centerController respondsToSelector:@selector(canShowLeftControllerInSlideController:)] == YES) {
            if([centerController canShowLeftControllerInSlideController:self] == YES) {
                if([leftController respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
                    allow = [leftController canShowControllerInSlideController:self];
                }
            } else {
                allow = NO;
            }
        }
        if(allow == YES) {
            if(self.isViewLoaded == NO) {
                animated = NO;
            }
            _swipeProgress = -1.0f;
            CGRect leftFrame = [self leftViewFrameByPercent:_swipeProgress];
            CGRect centerFrame = [self centerViewFrameByPercent:_swipeProgress];
            CGFloat diffX = MOBILY_FABS(leftFrame.origin.x - centerFrame.origin.x);
            CGFloat diffY = MOBILY_FABS(leftFrame.origin.y - centerFrame.origin.y);
            CGFloat diffW = MOBILY_FABS(leftFrame.size.width - centerFrame.size.width);
            CGFloat diffH = MOBILY_FABS(leftFrame.size.height - centerFrame.size.height);
            CGFloat speed = MAX(MAX(diffX, diffY), MAX(diffW, diffH));
            if(animated == YES) {
                NSTimeInterval duration = speed / _swipeVelocity;
                if([centerController respondsToSelector:@selector(willShowLeftControllerInSlideController:duration:)] == YES) {
                    [centerController willShowLeftControllerInSlideController:self duration:duration];
                }
                if([leftController respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
                    [leftController willShowControllerInSlideController:self duration:duration];
                }
                [UIView animateWithDuration:duration animations:^{
                    _leftView.frame = leftFrame;
                    _centerView.frame = centerFrame;
                } completion:^(BOOL finished __unused) {
                    _leftView.userInteractionEnabled = YES;
                    _centerView.userInteractionEnabled = NO;
                    _showedLeftController = YES;
                    if([centerController respondsToSelector:@selector(didShowLeftControllerInSlideController:)] == YES) {
                        [centerController didShowLeftControllerInSlideController:self];
                    }
                    if([leftController respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
                        [leftController didShowControllerInSlideController:self];
                    }
                    if(complete != nil) {
                        complete();
                    }
                }];
            } else {
                if([centerController respondsToSelector:@selector(willShowLeftControllerInSlideController:duration:)] == YES) {
                    [centerController willShowLeftControllerInSlideController:self duration:0.0f];
                }
                if([leftController respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
                    [leftController willShowControllerInSlideController:self duration:0.0f];
                }
                _leftView.userInteractionEnabled = YES;
                _leftView.frame = leftFrame;
                _centerView.userInteractionEnabled = NO;
                _centerView.frame = centerFrame;
                _showedLeftController = YES;
                if([centerController respondsToSelector:@selector(didShowLeftControllerInSlideController:)] == YES) {
                    [centerController didShowLeftControllerInSlideController:self];
                }
                if([leftController respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
                    [leftController didShowControllerInSlideController:self];
                }
                if(complete != nil) {
                    complete();
                }
            }
        }
    }
}

- (void)hideLeftControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_showedLeftController == YES) {
        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        _swipeProgress = 0.0f;
        CGRect leftFrame = [self leftViewFrameByPercent:_swipeProgress];
        CGRect centerFrame = [self centerViewFrameByPercent:_swipeProgress];
        CGFloat diffX = MOBILY_FABS(leftFrame.origin.x - centerFrame.origin.x);
        CGFloat diffY = MOBILY_FABS(leftFrame.origin.y - centerFrame.origin.y);
        CGFloat diffW = MOBILY_FABS(leftFrame.size.width - centerFrame.size.width);
        CGFloat diffH = MOBILY_FABS(leftFrame.size.height - centerFrame.size.height);
        CGFloat speed = MAX(MAX(diffX, diffY), MAX(diffW, diffH));
        if(animated == YES) {
            NSTimeInterval duration = speed / _swipeVelocity;
            if([centerController respondsToSelector:@selector(willHideLeftControllerInSlideController:duration:)] == YES) {
                [centerController willHideLeftControllerInSlideController:self duration:duration];
            }
            if([leftController respondsToSelector:@selector(willHideControllerInSlideController:duration:)] == YES) {
                [leftController willHideControllerInSlideController:self duration:duration];
            }
            [UIView animateWithDuration:duration animations:^{
                _leftView.frame = leftFrame;
                _centerView.frame = centerFrame;
            } completion:^(BOOL finished __unused) {
                _leftView.userInteractionEnabled = NO;
                _centerView.userInteractionEnabled = YES;
                _showedLeftController = NO;
                if([centerController respondsToSelector:@selector(didHideLeftControllerInSlideController:)] == YES) {
                    [centerController didHideLeftControllerInSlideController:self];
                }
                if([leftController respondsToSelector:@selector(didHideControllerInSlideController:)] == YES) {
                    [leftController didHideControllerInSlideController:self];
                }
                if(complete != nil) {
                    complete();
                }
            }];
        } else {
            if([centerController respondsToSelector:@selector(willHideLeftControllerInSlideController:duration:)] == YES) {
                [centerController willHideLeftControllerInSlideController:self duration:0.0f];
            }
            if([leftController respondsToSelector:@selector(willHideControllerInSlideController:duration:)] == YES) {
                [leftController willHideControllerInSlideController:self duration:0.0f];
            }
            _leftView.userInteractionEnabled = NO;
            _leftView.frame = leftFrame;
            _centerView.userInteractionEnabled = YES;
            _centerView.frame = centerFrame;
            _showedLeftController = NO;
            if([centerController respondsToSelector:@selector(didHideLeftControllerInSlideController:)] == YES) {
                [centerController didHideLeftControllerInSlideController:self];
            }
            if([leftController respondsToSelector:@selector(didHideControllerInSlideController:)] == YES) {
                [leftController didHideControllerInSlideController:self];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

- (void)showRightControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_showedRightController == NO) {
        BOOL allow = YES;
        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if([centerController respondsToSelector:@selector(canShowRightControllerInSlideController:)] == YES) {
            if([centerController canShowRightControllerInSlideController:self] == YES) {
                if([rightController respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
                    allow = [rightController canShowControllerInSlideController:self];
                }
            } else {
                allow = NO;
            }
        }
        if(allow == YES) {
            if(self.isViewLoaded == NO) {
                animated = NO;
            }
            _swipeProgress = 1.0f;
            CGRect rightFrame = [self rightViewFrameByPercent:_swipeProgress];
            CGRect centerFrame = [self centerViewFrameByPercent:_swipeProgress];
            CGFloat diffX = MOBILY_FABS(rightFrame.origin.x - centerFrame.origin.x);
            CGFloat diffY = MOBILY_FABS(rightFrame.origin.y - centerFrame.origin.y);
            CGFloat diffW = MOBILY_FABS(rightFrame.size.width - centerFrame.size.width);
            CGFloat diffH = MOBILY_FABS(rightFrame.size.height - centerFrame.size.height);
            CGFloat speed = MAX(MAX(diffX, diffY), MAX(diffW, diffH));
            if(animated == YES) {
                NSTimeInterval duration = speed / _swipeVelocity;
                if([centerController respondsToSelector:@selector(willShowRightControllerInSlideController:duration:)] == YES) {
                    [centerController willShowRightControllerInSlideController:self duration:duration];
                }
                if([rightController respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
                    [rightController willShowControllerInSlideController:self duration:duration];
                }
                [UIView animateWithDuration:duration animations:^{
                    _rightView.frame = rightFrame;
                    _centerView.frame = centerFrame;
                } completion:^(BOOL finished __unused) {
                    _rightView.userInteractionEnabled = YES;
                    _centerView.userInteractionEnabled = NO;
                    _showedRightController = YES;
                    if([centerController respondsToSelector:@selector(didShowRightControllerInSlideController:)] == YES) {
                        [centerController didShowRightControllerInSlideController:self];
                    }
                    if([rightController respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
                        [rightController didShowControllerInSlideController:self];
                    }
                    if(complete != nil) {
                        complete();
                    }
                }];
            } else {
                if([centerController respondsToSelector:@selector(willShowRightControllerInSlideController:duration:)] == YES) {
                    [centerController willShowRightControllerInSlideController:self duration:0.0f];
                }
                if([rightController respondsToSelector:@selector(willShowControllerInSlideController:duration:)] == YES) {
                    [rightController willShowControllerInSlideController:self duration:0.0f];
                }
                _rightView.userInteractionEnabled = YES;
                _rightView.frame = rightFrame;
                _centerView.userInteractionEnabled = NO;
                _centerView.frame = centerFrame;
                _showedRightController = YES;
                if([centerController respondsToSelector:@selector(didShowRightControllerInSlideController:)] == YES) {
                    [centerController didShowRightControllerInSlideController:self];
                }
                if([rightController respondsToSelector:@selector(didShowControllerInSlideController:)] == YES) {
                    [rightController didShowControllerInSlideController:self];
                }
                if(complete != nil) {
                    complete();
                }
            }
        }
    }
}

- (void)hideRightControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete {
    if(_showedRightController == YES) {
        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if(self.isViewLoaded == NO) {
            animated = NO;
        }
        _swipeProgress = 0.0f;
        CGRect rightFrame = [self rightViewFrameByPercent:_swipeProgress];
        CGRect centerFrame = [self centerViewFrameByPercent:_swipeProgress];
        CGFloat diffX = MOBILY_FABS(rightFrame.origin.x - centerFrame.origin.x);
        CGFloat diffY = MOBILY_FABS(rightFrame.origin.y - centerFrame.origin.y);
        CGFloat diffW = MOBILY_FABS(rightFrame.size.width - centerFrame.size.width);
        CGFloat diffH = MOBILY_FABS(rightFrame.size.height - centerFrame.size.height);
        CGFloat speed = MAX(MAX(diffX, diffY), MAX(diffW, diffH));
        if(animated == YES) {
            NSTimeInterval duration = speed / _swipeVelocity;
            if([centerController respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
                [centerController willHideRightControllerInSlideController:self duration:duration];
            }
            if([rightController respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
                [rightController willHideControllerInSlideController:self duration:duration];
            }
            [UIView animateWithDuration:duration animations:^{
                _rightView.frame = rightFrame;
                _centerView.frame = centerFrame;
            } completion:^(BOOL finished __unused) {
                _rightView.userInteractionEnabled = NO;
                _centerView.userInteractionEnabled = YES;
                _showedRightController = NO;
                if([centerController respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
                    [centerController didHideRightControllerInSlideController:self];
                }
                if([rightController respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
                    [rightController didHideControllerInSlideController:self];
                }
                if(complete != nil) {
                    complete();
                }
            }];
        } else {
            if([centerController respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
                [centerController willHideRightControllerInSlideController:self duration:0.0f];
            }
            if([rightController respondsToSelector:@selector(willHideRightControllerInSlideController:duration:)] == YES) {
                [rightController willHideControllerInSlideController:self duration:0.0f];
            }
            _rightView.userInteractionEnabled = NO;
            _rightView.frame = rightFrame;
            _centerView.userInteractionEnabled = YES;
            _centerView.frame = centerFrame;
            _showedRightController = NO;
            if([centerController respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
                [centerController didHideRightControllerInSlideController:self];
            }
            if([rightController respondsToSelector:@selector(didHideRightControllerInSlideController:)] == YES) {
                [rightController didHideControllerInSlideController:self];
            }
            if(complete != nil) {
                complete();
            }
        }
    }
}

#pragma mark Private

- (CGRect)leftViewFrameByPercent:(CGFloat)percent {
    return [self leftViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)leftViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    return CGRectMake((bounds.origin.x - _leftControllerWidth) + (_leftControllerWidth * -percent), bounds.origin.y, _leftControllerWidth, bounds.size.height);
}

- (CGRect)centerViewFrameByPercent:(CGFloat)percent {
    return [self centerViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)centerViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    if(percent < -MOBILY_EPSILON) {
        return CGRectMake(bounds.origin.x + (_leftControllerWidth * -percent), bounds.origin.y, bounds.size.width, bounds.size.height);
    } else if(percent > MOBILY_EPSILON) {
        return CGRectMake(bounds.origin.x - (_rightControllerWidth * percent), bounds.origin.y, bounds.size.width, bounds.size.height);
    }
    return bounds;
}

- (CGRect)rightViewFrameByPercent:(CGFloat)percent {
    return [self rightViewFrameFromBounds:self.view.bounds byPercent:percent];
}

- (CGRect)rightViewFrameFromBounds:(CGRect)bounds byPercent:(CGFloat)percent {
    return CGRectMake((bounds.origin.x + bounds.size.width) - (_rightControllerWidth * percent), bounds.origin.y, _rightControllerWidth, bounds.size.height);
}

- (void)appearBackgroundController {
    _backgroundController.moSlideController = self;
    
    [self addChildViewController:_backgroundController];
    _backgroundController.view.frame = _backgroundView.bounds;
    [_backgroundView addSubview:_backgroundController.view];
    [_backgroundController didMoveToParentViewController:self];
}

- (void)disappearBackgroundController {
    _backgroundController.moSlideController = nil;
    
    [_backgroundController viewWillDisappear:NO];
    [_backgroundController.view removeFromSuperview];
    [_backgroundController viewDidDisappear:NO];
}

- (void)appearLeftController {
    _leftController.moSlideController = self;
    
    [self addChildViewController:_leftController];
    _leftController.view.frame = _leftView.bounds;
    [_leftView addSubview:_leftController.view];
    [_leftController didMoveToParentViewController:self];
}

- (void)disappearLeftController {
    _leftController.moSlideController = nil;
    
    [_leftController willMoveToParentViewController:nil];
    [_leftController.view removeFromSuperview];
    [_leftController removeFromParentViewController];
}

- (void)appearCenterController {
    _centerController.moSlideController = self;
    
    [self addChildViewController:_centerController];
    _centerController.view.frame = _centerView.bounds;
    [_centerView addSubview:_centerController.view];
    [_centerController didMoveToParentViewController:self];
}

- (void)disappearCenterController {
    _centerController.moSlideController = nil;
    
    [_centerController willMoveToParentViewController:nil];
    [_centerController.view removeFromSuperview];
    [_centerController removeFromParentViewController];
}

- (void)appearRightController {
    _rightController.moSlideController = self;
    
    [self addChildViewController:_rightController];
    _rightController.view.frame = _rightView.bounds;
    [_rightView addSubview:_rightController.view];
    [_rightController didMoveToParentViewController:self];
}

- (void)disappearRightController {
    _rightController.moSlideController = nil;
    
    [_rightController willMoveToParentViewController:nil];
    [_rightController.view removeFromSuperview];
    [_rightController removeFromParentViewController];
}

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe {
    CGFloat minSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) ? 1.0f :0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_swipeProgress != normalizedSwipeProgress) {
        _swipeProgress = normalizedSwipeProgress;
        
        CGRect bounds = self.view.bounds;
        [UIView animateWithDuration:MOBILY_FABS(speed) / _swipeVelocity
                         animations:^{
                             _leftView.frame = [self leftViewFrameFromBounds:bounds byPercent:_swipeProgress];
                             _centerView.frame = [self centerViewFrameFromBounds:bounds byPercent:_swipeProgress];
                             _rightView.frame = [self rightViewFrameFromBounds:bounds byPercent:_swipeProgress];
                         } completion:^(BOOL finished __unused) {
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
    id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
    if([centerController respondsToSelector:@selector(willBeganSwipeInSlideController:)] == YES) {
        [centerController willBeganSwipeInSlideController:self];
    }
}

- (void)didBeganSwipe {
    self.swipeDragging = YES;
    
    id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
    if([centerController respondsToSelector:@selector(didBeganSwipeInSlideController:)] == YES) {
        [centerController didBeganSwipeInSlideController:self];
    }
    if(_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) {
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if([leftController respondsToSelector:@selector(didBeganLeftSwipeInSlideController:)] == YES) {
            [leftController willBeganLeftSwipeInSlideController:self];
            [leftController didBeganLeftSwipeInSlideController:self];
        }
    } else if(_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) {
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if([rightController respondsToSelector:@selector(didBeganRightSwipeInSlideController:)] == YES) {
            [rightController willBeganRightSwipeInSlideController:self];
            [rightController didBeganRightSwipeInSlideController:self];
        }
    }
}

- (void)movingSwipe:(CGFloat)progress {
    id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
    if([centerController respondsToSelector:@selector(movingSwipeInSlideController:progress:)] == YES) {
        [centerController movingSwipeInSlideController:self progress:progress];
    }
    if(_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) {
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if([leftController respondsToSelector:@selector(movingLeftSwipeInSlideController:progress:)] == YES) {
            [leftController movingLeftSwipeInSlideController:self progress:progress];
        }
    } else if(_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) {
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if([rightController respondsToSelector:@selector(movingRightSwipeInSlideController:progress:)] == YES) {
            [rightController movingRightSwipeInSlideController:self progress:progress];
        }
    }
}

- (void)willEndedSwipe {
    self.swipeDragging = NO;
    self.swipeDecelerating = YES;
    
    id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
    if([centerController respondsToSelector:@selector(willEndedSwipeInSlideController:)] == YES) {
        [centerController willEndedSwipeInSlideController:self];
    }
    if(_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) {
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if([leftController respondsToSelector:@selector(willEndedLeftSwipeInSlideController:)] == YES) {
            [leftController willEndedLeftSwipeInSlideController:self];
        }
    } else if(_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) {
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if([rightController respondsToSelector:@selector(willEndedRightSwipeInSlideController:)] == YES) {
            [rightController willEndedRightSwipeInSlideController:self];
        }
    }
}

- (void)didEndedSwipe {
    _showedLeftController = (_swipeProgress < 0.0f) ? YES : NO;
    _showedRightController = (_swipeProgress > 0.0f) ? YES : NO;
    _leftView.userInteractionEnabled = (_showedLeftController == YES) ? YES : NO;
    _centerView.userInteractionEnabled = ((_showedLeftController == YES) || (_showedRightController == YES)) ? NO : YES;
    _rightView.userInteractionEnabled = (_showedRightController == YES) ? YES : NO;
    self.swipeDecelerating = NO;
    
    id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
    if([centerController respondsToSelector:@selector(didEndedSwipeInSlideController:)] == YES) {
        [centerController didEndedSwipeInSlideController:self];
    }
    if(_swipeDirection == MobilySlideControllerSwipeCellDirectionLeft) {
        id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
        if([leftController respondsToSelector:@selector(didEndedLeftSwipeInSlideController:)] == YES) {
            [leftController didEndedLeftSwipeInSlideController:self];
        }
    } else if(_swipeDirection == MobilySlideControllerSwipeCellDirectionRight) {
        id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
        if([rightController respondsToSelector:@selector(didEndedRightSwipeInSlideController:)] == YES) {
            [rightController didEndedRightSwipeInSlideController:self];
        }
    }
}

- (void)tapGestureHandle:(UITapGestureRecognizer* __unused)tapGesture {
    if(_showedLeftController == YES) {
        [self hideLeftControllerAnimated:YES complete:nil];
    } else if(_showedRightController == YES) {
        [self hideRightControllerAnimated:YES complete:nil];
    }
}

- (void)panGestureHandle:(UIPanGestureRecognizer* __unused)panGesture {
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
                        [self setSwipeProgress:needSwipeProgress speed:_swipeLeftWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    case MobilySlideControllerSwipeCellDirectionRight: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeRightWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
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

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer == _tapGesture) {
        CGPoint location = [_tapGesture locationInView:self.view];
        if((_showedLeftController == YES) || (_showedRightController == YES)) {
            if(CGRectContainsPoint(_centerView.frame, location) == YES) {
                return YES;
            }
        }
    } else if(gestureRecognizer == _panGesture) {
        if((_swipeDragging == NO) && (_swipeDecelerating == NO)) {
            BOOL allowPan = NO;
            CGPoint location = [_panGesture locationInView:self.view];
            CGPoint translation = [_panGesture translationInView:self.view];
            if((_showedLeftController == YES) && (_leftController != nil)) {
                if(CGRectContainsPoint(_centerView.frame, location) == YES) {
                    allowPan = YES;
                }
            } else if((_showedRightController == YES) && (_rightController != nil)) {
                if(CGRectContainsPoint(_centerView.frame, location) == YES) {
                    allowPan = YES;
                }
            } else if((_showedLeftController == NO) && (_leftController != nil) && (translation.x > 0.0f)) {
                if(MOBILY_FABS(translation.x) >= MOBILY_FABS(translation.y)) {
                    allowPan = CGRectContainsPoint(_centerView.frame, location);
                    if(allowPan == YES) {
                        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
                        if([centerController respondsToSelector:@selector(canShowLeftControllerInSlideController:)] == YES) {
                            if([centerController canShowLeftControllerInSlideController:self] == YES) {
                                id< MobilySlideControllerDelegate > leftController = ([_leftController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_leftController : nil;
                                if([leftController respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
                                    allowPan = [leftController canShowControllerInSlideController:self];
                                }
                            } else {
                                allowPan = NO;
                            }
                        }
                    }
                }
            } else if((_showedRightController == NO) && (_rightController != nil) && (translation.x < 0.0f)) {
                if(MOBILY_FABS(translation.x) >= MOBILY_FABS(translation.y)) {
                    allowPan = CGRectContainsPoint(_centerView.frame, location);
                    if(allowPan == YES) {
                        id< MobilySlideControllerDelegate > centerController = ([_centerController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_centerController : nil;
                        if([centerController respondsToSelector:@selector(canShowRightControllerInSlideController:)] == YES) {
                            if([centerController canShowRightControllerInSlideController:self] == YES) {
                                id< MobilySlideControllerDelegate > rightController = ([_rightController conformsToProtocol:@protocol(MobilySlideControllerDelegate)] == YES) ? (id< MobilySlideControllerDelegate >)_rightController : nil;
                                if([rightController respondsToSelector:@selector(canShowControllerInSlideController:)] == YES) {
                                    allowPan = [rightController canShowControllerInSlideController:self];
                                }
                            } else {
                                allowPan = NO;
                            }
                        }
                    }
                }
            }
            return allowPan;
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
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilySlideController)

- (void)setMoSlideController:(MobilySlideController*)moSlideController {
    objc_setAssociatedObject(self, @selector(moSlideController), moSlideController, OBJC_ASSOCIATION_ASSIGN);
}

- (MobilySlideController*)moSlideController {
    MobilySlideController* controller = objc_getAssociatedObject(self, @selector(moSlideController));
    if(controller == nil) {
        controller = self.parentViewController.moSlideController;
    }
    return controller;
}

@end

/*--------------------------------------------------*/
