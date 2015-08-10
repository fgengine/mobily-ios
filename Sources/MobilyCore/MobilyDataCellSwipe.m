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

#import <MobilyCore/MobilyDataCell+Private.h>

/*--------------------------------------------------*/

@implementation MobilyDataCellSwipe

#pragma mark Synthesize

@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize swipeEnabled = _swipeEnabled;
@synthesize swipeStyle = _swipeStyle;
@synthesize swipeThreshold = _swipeThreshold;
@synthesize swipeVelocity = _swipeVelocity;
@synthesize swipeSpeed = _swipeSpeed;
@synthesize swipeDragging = _swipeDragging;
@synthesize swipeDecelerating = _swipeDecelerating;
@synthesize showedLeftSwipeView = _showedLeftSwipeView;
@synthesize leftSwipeEnabled = _leftSwipeEnabled;
@synthesize leftSwipeView = _leftSwipeView;
@synthesize leftSwipeOffset = _leftSwipeOffset;
@synthesize leftSwipeSize = _leftSwipeSize;
@synthesize leftSwipeStretchSize = _leftSwipeStretchSize;
@synthesize leftSwipeStretchMinThreshold = _leftSwipeStretchMinThreshold;
@synthesize leftSwipeStretchMaxThreshold = _leftSwipeStretchMaxThreshold;
@synthesize showedRightSwipeView = _showedRightSwipeView;
@synthesize rightSwipeEnabled = _rightSwipeEnabled;
@synthesize rightSwipeView = _rightSwipeView;
@synthesize rightSwipeOffset = _rightSwipeOffset;
@synthesize rightSwipeSize = _rightSwipeSize;
@synthesize rightSwipeStretchSize = _rightSwipeStretchSize;
@synthesize rightSwipeStretchMinThreshold = _rightSwipeStretchMinThreshold;
@synthesize rightSwipeStretchMaxThreshold = _rightSwipeStretchMaxThreshold;
@synthesize constraintLeftSwipeViewOffsetX = _constraintLeftSwipeViewOffsetX;
@synthesize constraintLeftSwipeViewCenterY = _constraintLeftSwipeViewCenterY;
@synthesize constraintLeftSwipeViewWidth = _constraintLeftSwipeViewWidth;
@synthesize constraintLeftSwipeViewHeight = _constraintLeftSwipeViewHeight;
@synthesize constraintRightSwipeViewOffsetX = _constraintRightSwipeViewOffsetX;
@synthesize constraintRightSwipeViewCenterY = _constraintRightSwipeViewCenterY;
@synthesize constraintRightSwipeViewWidth = _constraintRightSwipeViewWidth;
@synthesize constraintRightSwipeViewHeight = _constraintRightSwipeViewHeight;
@synthesize panSwipeLastOffset = _panSwipeLastOffset;
@synthesize panSwipeLastVelocity = _panSwipeLastVelocity;
@synthesize panSwipeProgress = _panSwipeProgress;
@synthesize panSwipeLeftWidth = _panSwipeLeftWidth;
@synthesize panSwipeRightWidth = _panSwipeRightWidth;
@synthesize panSwipeDirection = _panSwipeDirection;

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerPanGestureRecognizer:)];
    
    _swipeEnabled = YES;
    _swipeStyle = MobilyDataSwipeCellStyleLeaves;
    _swipeThreshold = 2.0f;
    _swipeSpeed = 1050.0f;
    _swipeVelocity = 570.0f;
    _leftSwipeEnabled = YES;
    _leftSwipeSize = -1.0f;
    _leftSwipeStretchSize = 128.0f;
    _leftSwipeStretchMinThreshold = 0.2f;
    _leftSwipeStretchMaxThreshold = 0.4f;
    _rightSwipeEnabled = YES;
    _rightSwipeSize = -1.0f;
    _rightSwipeStretchSize = 128.0f;
    _rightSwipeStretchMinThreshold = 0.2f;
    _rightSwipeStretchMaxThreshold = 0.4f;
    _rootOffsetOfCenter = [self _rootViewOffsetOfCenterBySwipeProgress:0.0f];
    _leftSwipeOffset = [self _leftViewOffsetBySwipeProgress:0.0f];
    _rightSwipeOffset = [self _rightViewOffsetBySwipeProgress:0.0f];
}

- (void)dealloc {
}

#pragma mark UIView

- (void)updateConstraints {
    if(_leftSwipeView != nil) {
        if(_leftSwipeSize >= 0.0f) {
            if(_constraintLeftSwipeViewWidth == nil) {
                self.constraintLeftSwipeViewWidth = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_leftSwipeSize];
            }
        } else {
            self.constraintLeftSwipeViewWidth = nil;
        }
        if(_constraintLeftSwipeViewOffsetX == nil) {
            self.constraintLeftSwipeViewOffsetX = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:_leftSwipeOffset];
        }
        if(_constraintLeftSwipeViewCenterY == nil) {
            self.constraintLeftSwipeViewCenterY = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintLeftSwipeViewHeight == nil) {
            self.constraintLeftSwipeViewHeight = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintLeftSwipeViewOffsetX = nil;
        self.constraintLeftSwipeViewCenterY = nil;
        self.constraintLeftSwipeViewWidth = nil;
        self.constraintLeftSwipeViewHeight = nil;
    }
    if(_rightSwipeView != nil) {
        if(_rightSwipeSize >= 0.0f) {
            if(_constraintRightSwipeViewWidth == nil) {
                self.constraintRightSwipeViewWidth = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_rightSwipeSize];
            }
        } else {
            self.constraintRightSwipeViewWidth = nil;
        }
        if(_constraintRightSwipeViewOffsetX == nil) {
            self.constraintRightSwipeViewOffsetX = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:_rightSwipeOffset];
        }
        if(_constraintRightSwipeViewCenterY == nil) {
            self.constraintRightSwipeViewCenterY = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintRightSwipeViewHeight == nil) {
            self.constraintRightSwipeViewHeight = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintRightSwipeViewOffsetX = nil;
        self.constraintRightSwipeViewCenterY = nil;
        self.constraintRightSwipeViewWidth = nil;
        self.constraintRightSwipeViewHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property

- (NSArray*)orderedSubviews {
    NSMutableArray* result = NSMutableArray.array;
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStands:
        case MobilyDataSwipeCellStyleStretch: {
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            if(self.rootView != nil) {
                [result addObject:self.rootView];
            }
            break;
        }
        case MobilyDataSwipeCellStyleLeaves:
        case MobilyDataSwipeCellStylePushes: {
            if(self.rootView != nil) {
                [result addObject:self.rootView];
            }
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            break;
        }
    }
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if(editing == NO) {
        [self hideAnySwipeViewAnimated:animated];
    }
}

- (void)setRootView:(UIView*)rootView {
    super.rootView = rootView;
    
    self.rootOffsetOfCenter = [self _rootViewOffsetOfCenterBySwipeProgress:0.0f];
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer {
    if(_panGestureRecognizer != panGestureRecognizer) {
        if(_panGestureRecognizer != nil) {
            [_rootView removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer = panGestureRecognizer;
        if(_panGestureRecognizer != nil) {
            _panGestureRecognizer.delaysTouchesBegan = YES;
            _panGestureRecognizer.delaysTouchesEnded = YES;
            _panGestureRecognizer.delegate = self;
            [_rootView addGestureRecognizer:_panGestureRecognizer];
        }
    }
}

- (void)setSwipeStyle:(MobilyDataSwipeCellStyle)swipeStyle {
    if(_swipeStyle != swipeStyle) {
        self.constraintLeftSwipeViewOffsetX = nil;
        self.constraintLeftSwipeViewCenterY = nil;
        self.constraintLeftSwipeViewWidth = nil;
        self.constraintLeftSwipeViewHeight = nil;
        self.constraintRightSwipeViewOffsetX = nil;
        self.constraintRightSwipeViewCenterY = nil;
        self.constraintRightSwipeViewWidth = nil;
        self.constraintRightSwipeViewHeight = nil;
        _swipeStyle = swipeStyle;
        [self moSetSubviews:self.orderedSubviews];
        self.rootOffsetOfCenter = [self _rootViewOffsetOfCenterBySwipeProgress:0.0f];
        self.leftSwipeOffset = [self _leftViewOffsetBySwipeProgress:0.0f];
        self.rightSwipeOffset = [self _rightViewOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setShowedLeftSwipeView:(BOOL)showedSwipeLeft {
    [self setShowedLeftSwipeView:showedSwipeLeft animated:NO];
}

- (void)setLeftSwipeView:(UIView*)leftSwipeView {
    if(_leftSwipeView != leftSwipeView) {
        if(_leftSwipeView != nil) {
            [_leftSwipeView removeFromSuperview];
        }
        _leftSwipeView = leftSwipeView;
        if(_leftSwipeView != nil) {
            _leftSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self moSetSubviews:self.orderedSubviews];
        }
        self.leftSwipeOffset = [self _leftViewOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftSwipeViewOffsetX, constraintLeftSwipeViewOffsetX, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftSwipeViewCenterY, constraintLeftSwipeViewCenterY, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftSwipeViewWidth, constraintLeftSwipeViewWidth, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftSwipeViewHeight, constraintLeftSwipeViewHeight, self, {
}, {
})

- (void)setLeftSwipeOffset:(CGFloat)leftSwipeOffset {
    if(_leftSwipeOffset != leftSwipeOffset) {
        _leftSwipeOffset = leftSwipeOffset;
        if(_constraintLeftSwipeViewOffsetX != nil) {
            _constraintLeftSwipeViewOffsetX.constant = _leftSwipeOffset;
        }
    }
}

- (void)setLeftSwipeSize:(CGFloat)leftSwipeSize {
    if(_leftSwipeSize != leftSwipeSize) {
        _leftSwipeSize = leftSwipeSize;
        if(_leftSwipeSize < 0.0f) {
            [self setNeedsUpdateConstraints];
        } else if(_constraintLeftSwipeViewWidth != nil) {
            _constraintLeftSwipeViewWidth.constant = _leftSwipeSize;
        }
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView {
    [self setShowedRightSwipeView:showedRightSwipeView animated:NO];
}

- (void)setRightSwipeView:(UIView*)rightSwipeView {
    if(_rightSwipeView != rightSwipeView) {
        if(_rightSwipeView != nil) {
            [_rightSwipeView removeFromSuperview];
        }
        _rightSwipeView = rightSwipeView;
        if(_rightSwipeView != nil) {
            _rightSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self moSetSubviews:self.orderedSubviews];
        }
        self.rightSwipeOffset = [self _rightViewOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightSwipeViewOffsetX, constraintRightSwipeViewOffsetX, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightSwipeViewCenterY, constraintRightSwipeViewCenterY, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightSwipeViewWidth, constraintRightSwipeViewWidth, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightSwipeViewHeight, constraintRightSwipeViewHeight, self, {
}, {
})

- (void)setRightSwipeOffset:(CGFloat)rightSwipeOffset {
    if(_rightSwipeOffset != rightSwipeOffset) {
        _rightSwipeOffset = rightSwipeOffset;
        if(_constraintRightSwipeViewOffsetX != nil) {
            _constraintRightSwipeViewOffsetX.constant = _rightSwipeOffset;
        }
    }
}

- (void)setRightSwipeSize:(CGFloat)rightSwipeSize {
    if(_rightSwipeSize != rightSwipeSize) {
        _rightSwipeSize = rightSwipeSize;
        if(_rightSwipeSize < 0.0f) {
            [self setNeedsUpdateConstraints];
        } else if(_constraintRightSwipeViewWidth != nil) {
            _constraintRightSwipeViewWidth.constant = _rightSwipeSize;
        }
    }
}

#pragma mark Public

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated {
    if(_showedLeftSwipeView != showedLeftSwipeView) {
        _showedLeftSwipeView = showedLeftSwipeView;
        _showedRightSwipeView = NO;
        
        CGFloat needSwipeProgress = (showedLeftSwipeView == YES) ? -1.0f : 0.0f;
        [self _updateSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? _leftSwipeView.moFrameWidth * MOBILY_FABS(needSwipeProgress - _panSwipeProgress) : MOBILY_EPSILON
                    endedSwipe:NO];
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated {
    if(_showedRightSwipeView != showedRightSwipeView) {
        _showedRightSwipeView = showedRightSwipeView;
        _showedLeftSwipeView = NO;
        
        CGFloat needSwipeProgress = (_showedRightSwipeView == YES) ? 1.0f : 0.0f;
        [self _updateSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? _rightSwipeView.moFrameWidth * MOBILY_FABS(needSwipeProgress - _panSwipeProgress) : MOBILY_EPSILON
                    endedSwipe:NO];
    }
}

- (void)hideAnySwipeViewAnimated:(BOOL)animated {
    [self setShowedLeftSwipeView:NO animated:animated];
    [self setShowedRightSwipeView:NO animated:animated];
}

- (void)willBeganSwipe {
}

- (void)didBeganSwipe {
    self.swipeDragging = YES;
}

- (void)movingSwipe:(CGFloat __unused)progress {
}

- (void)willEndedSwipe:(CGFloat __unused)progress {
    self.swipeDragging = NO;
    self.swipeDecelerating = YES;
}

- (void)didEndedSwipe:(CGFloat)progress {
    _showedLeftSwipeView = (progress < 0.0f) ? YES : NO;
    _showedRightSwipeView = (progress > 0.0f) ? YES : NO;
    self.swipeDecelerating = NO;

    [self.item setEditing:((_showedLeftSwipeView == YES) || (_showedRightSwipeView == YES)) animated:YES];
}

- (CGFloat)endedSwipeProgress:(CGFloat)progress {
    CGFloat minProgress = (_panSwipeDirection == MobilyDataCellSwipeDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxProgress = (_panSwipeDirection == MobilyDataCellSwipeDirectionRight) ? 1.0f : 0.0f;
    if(_swipeStyle == MobilyDataSwipeCellStyleStretch) {
        if(progress < 0.0f) {
            if(_panSwipeDirection == MobilyDataCellSwipeDirectionLeft) {
                if(progress < -_leftSwipeStretchMaxThreshold) {
                    progress = -1.0f;
                } else if(progress < -_leftSwipeStretchMinThreshold) {
                    progress = -(_leftSwipeStretchSize / _rootView.moFrameWidth);
                } else {
                    progress = 0.0f;
                }
            } else {
                progress = 0.0f;
            }
        } else if(progress > 0.0f) {
            if(_panSwipeDirection == MobilyDataCellSwipeDirectionRight) {
                if(progress > _rightSwipeStretchMaxThreshold) {
                    progress = 1.0f;
                } else if(progress > _rightSwipeStretchMinThreshold) {
                    progress = (_rightSwipeStretchSize / _rootView.moFrameWidth);
                } else {
                    progress = 0.0f;
                }
            } else {
                progress = 0.0f;
            }
        }
    } else {
        progress = roundf(progress);
    }
    return MIN(MAX(minProgress, progress), maxProgress);
}

#pragma mark Private override

- (void)_pressed {
    if(_showedLeftSwipeView == YES) {
        [self setShowedLeftSwipeView:NO animated:YES];
    } else if(_showedRightSwipeView == YES) {
        [self setShowedRightSwipeView:NO animated:YES];
    } else {
        [super _pressed];
    }
}

- (void)_longPressed {
    if(_showedLeftSwipeView == YES) {
        [self setShowedLeftSwipeView:NO animated:YES];
    } else if(_showedRightSwipeView == YES) {
        [self setShowedRightSwipeView:NO animated:YES];
    } else {
        [super _longPressed];
    }
}

#pragma mark Private

- (UIOffset)_rootViewOffsetOfCenterBySwipeProgress:(CGFloat)swipeProgress {
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStands:
        case MobilyDataSwipeCellStyleLeaves:
            if(swipeProgress < 0.0f) {
                return UIOffsetMake(_leftSwipeView.moFrameWidth * -swipeProgress, 0.0f);
            } else if(swipeProgress > 0.0f) {
                return UIOffsetMake(-_rightSwipeView.moFrameWidth * swipeProgress, 0.0f);
            }
            break;
        case MobilyDataSwipeCellStyleStretch:
            if(swipeProgress < 0.0f) {
                return UIOffsetMake(_rootView.moFrameWidth * -swipeProgress, 0.0f);
            } else if(swipeProgress > 0.0f) {
                return UIOffsetMake(-_rootView.moFrameWidth * swipeProgress, 0.0f);
            }
            break;
        case MobilyDataSwipeCellStylePushes:
            break;
    }
    return UIOffsetMake(0.0f, 0.0f);
}

- (CGFloat)_leftViewOffsetBySwipeProgress:(CGFloat)swipeProgress {
    CGFloat leftWidth = _leftSwipeView.moFrameWidth;
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStands:
            return 0.0f;
        case MobilyDataSwipeCellStyleLeaves:
        case MobilyDataSwipeCellStylePushes:
            if(swipeProgress < 0.0f) {
                return -leftWidth + (leftWidth * (-swipeProgress));
            }
            break;
        case MobilyDataSwipeCellStyleStretch:
            return 0.0f;
    }
    return -leftWidth;
}

- (CGFloat)_leftViewSizeBySwipeProgress:(CGFloat)swipeProgress {
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStretch:
            if(swipeProgress < 0.0f) {
                return _rootView.moFrameWidth * -swipeProgress;
            }
            return 0.0f;
        default:
            break;
    }
    return -1.0f;
}

- (CGFloat)_rightViewOffsetBySwipeProgress:(CGFloat)swipeProgress {
    CGFloat rigthWidth = _rightSwipeView.moFrameWidth;
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStands:
            return 0.0f;
        case MobilyDataSwipeCellStyleLeaves:
        case MobilyDataSwipeCellStylePushes:
            if(swipeProgress > 0.0f) {
                return rigthWidth * (1.0f - swipeProgress);
            }
            break;
        case MobilyDataSwipeCellStyleStretch:
            return 0.0f;
    }
    return rigthWidth;
}

- (CGFloat)_rightViewSizeBySwipeProgress:(CGFloat)swipeProgress {
    switch(_swipeStyle) {
        case MobilyDataSwipeCellStyleStretch:
            if(swipeProgress > 0.0f) {
                return _rootView.moFrameWidth * swipeProgress;
            }
            return 0.0f;
        default:
            break;
    }
    return -1.0f;
}

- (void)_updateSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe {
    CGFloat minSwipeProgress = (_panSwipeDirection == MobilyDataCellSwipeDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_panSwipeDirection == MobilyDataCellSwipeDirectionRight) ? 1.0f : 0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_panSwipeProgress != normalizedSwipeProgress) {
        _panSwipeProgress = normalizedSwipeProgress;
        self.rootOffsetOfCenter = [self _rootViewOffsetOfCenterBySwipeProgress:_panSwipeProgress];
        self.leftSwipeOffset = [self _leftViewOffsetBySwipeProgress:_panSwipeProgress];
        self.leftSwipeSize = [self _leftViewSizeBySwipeProgress:_panSwipeProgress];
        self.rightSwipeOffset = [self _rightViewOffsetBySwipeProgress:_panSwipeProgress];
        self.rightSwipeSize = [self _rightViewSizeBySwipeProgress:_panSwipeProgress];
        [self setNeedsUpdateConstraints];
        
        if(endedSwipe == YES) {
            [self willEndedSwipe:_panSwipeProgress];
        }
        [UIView animateWithDuration:MOBILY_FABS(speed) / _swipeSpeed
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self movingSwipe:_panSwipeProgress];
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished __unused) {
                             if(endedSwipe == YES) {
                                 [self didEndedSwipe:_panSwipeProgress];
                             }
                         }];
    } else {
        if(endedSwipe == YES) {
            [self willEndedSwipe:_panSwipeProgress];
            [self didEndedSwipe:_panSwipeProgress];
        }
    }
}

- (void)_handlerPanGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    if(_swipeDecelerating == NO) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        CGPoint velocity = [gestureRecognizer velocityInView:self];
        switch([gestureRecognizer state]) {
            case UIGestureRecognizerStateBegan: {
                [self willBeganSwipe];
                self.panSwipeLastOffset = translation.x;
                self.panSwipeLastVelocity = velocity.x;
                switch(_swipeStyle) {
                    case MobilyDataSwipeCellStyleStands:
                    case MobilyDataSwipeCellStyleLeaves:
                    case MobilyDataSwipeCellStylePushes:
                        self.panSwipeLeftWidth = -_leftSwipeView.moFrameWidth;
                        self.panSwipeRightWidth = _rightSwipeView.moFrameWidth;
                        break;
                    case MobilyDataSwipeCellStyleStretch:
                        self.panSwipeLeftWidth = (_leftSwipeView != nil) ? -_rootView.moFrameWidth : 0.0f;
                        self.panSwipeRightWidth = (_rightSwipeView != nil) ? _rootView.moFrameWidth : 0.0f;
                        break;
                }
                self.panSwipeDirection = MobilyDataCellSwipeDirectionUnknown;
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat delta = _panSwipeLastOffset - translation.x;
                if(_panSwipeDirection == MobilyDataCellSwipeDirectionUnknown) {
                    if((_leftSwipeEnabled == YES) && (_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.panSwipeDirection = MobilyDataCellSwipeDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_rightSwipeEnabled == YES) && (_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.panSwipeDirection = MobilyDataCellSwipeDirectionRight;
                        [self didBeganSwipe];
                    } else if((_leftSwipeEnabled == YES) && (_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.panSwipeDirection = MobilyDataCellSwipeDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_rightSwipeEnabled == YES) && (_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.panSwipeDirection = MobilyDataCellSwipeDirectionRight;
                        [self didBeganSwipe];
                    }
                }
                if(_panSwipeDirection != MobilyDataCellSwipeDirectionUnknown) {
                    if(_panSwipeDirection == MobilyDataCellSwipeDirectionLeft) {
                        CGFloat localDelta = MIN(MAX(_panSwipeLeftWidth, delta), -_panSwipeLeftWidth);
                        [self _updateSwipeProgress:_panSwipeProgress - (localDelta / _panSwipeLeftWidth) speed:localDelta endedSwipe:NO];
                        [self movingSwipe:_panSwipeProgress];
                    } else if(_panSwipeDirection == MobilyDataCellSwipeDirectionRight) {
                        CGFloat localDelta = MIN(MAX(-_panSwipeRightWidth, delta), _panSwipeRightWidth);
                        [self _updateSwipeProgress:_panSwipeProgress + (localDelta / _panSwipeRightWidth) speed:localDelta endedSwipe:NO];
                        [self movingSwipe:_panSwipeProgress];
                    }
                    self.panSwipeLastOffset = translation.x;
                    self.panSwipeLastVelocity = velocity.x;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                CGFloat swipeProgress = [self endedSwipeProgress:_panSwipeProgress - (_panSwipeLastVelocity / _swipeVelocity)];
                if(_panSwipeDirection == MobilyDataCellSwipeDirectionLeft) {
                    [self _updateSwipeProgress:swipeProgress speed:_panSwipeLeftWidth * MOBILY_FABS(swipeProgress - _panSwipeProgress) endedSwipe:YES];
                } else if(_panSwipeDirection == MobilyDataCellSwipeDirectionRight) {
                    [self _updateSwipeProgress:swipeProgress speed:_panSwipeRightWidth * MOBILY_FABS(swipeProgress - _panSwipeProgress) endedSwipe:YES];
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
    BOOL result = [super gestureRecognizerShouldBegin:gestureRecognizer];
    if(result == YES) {
        if(gestureRecognizer == _panGestureRecognizer) {
            if((_swipeEnabled == YES) && (_swipeDragging == NO) && (_swipeDecelerating == NO)) {
                if([self.item.view shouldBeganEditItem:self.item] == YES) {
                    CGPoint translation = [_panGestureRecognizer translationInView:self];
                    CGFloat absX = MOBILY_FABS(translation.x);
                    CGFloat absY = MOBILY_FABS(translation.y);
                    if(absX >= absY) {
                        if((_leftSwipeEnabled == YES) && (_leftSwipeView != nil)) {
                            return YES;
                        } else if((_rightSwipeEnabled == YES) && (_rightSwipeView != nil)) {
                            return YES;
                        }
                    }
                }
            }
            return NO;
        }
    }
    return result;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    if((gestureRecognizer == _panGestureRecognizer) && ([self.rootView.gestureRecognizers containsObject:otherGestureRecognizer] == NO)) {
        return NO;
    }
    return [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end

/*--------------------------------------------------*/
