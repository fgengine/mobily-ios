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

#import <MobilyCore/MobilyImageCropController.h>
#import <MobilyCore/MobilyTouchView.h>

/*--------------------------------------------------*/

@interface MobilyImageScrollView : UIScrollView {
    CGSize _imageSize;
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@property(nonatomic, readwrite, strong) UIImageView* zoomView;
@property(nonatomic, readwrite, assign) BOOL aspectFill;

- (void)_displayImage:(UIImage*)image;

- (void)_centerZoomView;

@end

/*--------------------------------------------------*/

static const CGFloat MobilyImageCropController_PortraitCircleInsets = 15.0f;
static const CGFloat MobilyImageCropController_PortraitSquareInsets = 20.0f;
static const CGFloat MobilyImageCropController_PortraitTitleLabelVerticalMargin = 64.0f;
static const CGFloat MobilyImageCropController_PortraitButtonsHorizontalMargin = 13.0f;
static const CGFloat MobilyImageCropController_PortraitButtonsVerticalMargin = 21.0f;

static const CGFloat MobilyImageCropController_LandscapeCircleInsets = 45.0f;
static const CGFloat MobilyImageCropController_LandscapeSquareInsets = 45.0f;
static const CGFloat MobilyImageCropController_LandscapeTitleLabelVerticalMargin = 12.0f;
static const CGFloat MobilyImageCropController_LandscapeButtonsHorizontalMargin = 13.0f;
static const CGFloat MobilyImageCropController_LandscapeButtonsVerticalMargin = 12.0f;

static const CGFloat MobilyImageCropController_ResetDuration = 0.4f;
static const CGFloat MobilyImageCropController_ScrollDuration = 0.25f;

/*--------------------------------------------------*/

@interface MobilyImageCropController () < UIScrollViewDelegate, UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, strong) MobilyImageScrollView* scrollView;
@property(nonatomic, readwrite, strong) MobilyTouchView* overlayView;
@property(nonatomic, readwrite, strong) CAShapeLayer* maskLayer;
@property(nonatomic, readwrite, assign) CGRect maskRect;

@property(nonatomic, readwrite, assign) CGFloat scale;

@property(nonatomic, readwrite, strong) UILabel* titleLabel;
@property(nonatomic, readwrite, strong) UIButton* chooseButton;
@property(nonatomic, readwrite, strong) UIButton* cancelButton;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* doubleTapGestureRecognizer;
@property(nonatomic, readwrite, strong) UIRotationGestureRecognizer* rotationGestureRecognizer;

@end

/*--------------------------------------------------*/

@implementation MobilyImageCropController

#pragma mark Init / Free

- (instancetype)initWithImage:(UIImage*)originalImage {
    self = [super init];
    if(self != nil) {
        _originalImage = originalImage;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)originalImage cropMode:(MobilyImageCropMode)cropMode {
    self = [self initWithImage:originalImage];
    if(self != nil) {
        _cropMode = cropMode;
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _cropMode = MobilyImageCropModeCircle;
    _avoidEmptySpaceAroundImage = NO;
    _applyMaskToCroppedImage = NO;
    _rotationEnabled = NO;
}

#pragma mark Load / Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    if([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    */
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.chooseButton];
    
    [self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
}

#pragma mark Layout subviews

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self _updateMaskRect];
    [self _layoutImageScrollView];
    [self _layoutOverlayView];
    [self _updateMaskPath];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(self.scrollView.zoomView == nil) {
        [self _displayImage];
    }
}

#pragma mark Update constraints

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    CGFloat titleLabelVerticalMargin = (isPortrait == YES) ? MobilyImageCropController_PortraitTitleLabelVerticalMargin : MobilyImageCropController_LandscapeTitleLabelVerticalMargin;
    CGFloat buttonsHorizontalMargin = (isPortrait == YES) ? MobilyImageCropController_PortraitButtonsHorizontalMargin : MobilyImageCropController_LandscapeButtonsHorizontalMargin;
    CGFloat buttonsVerticalMargin = (isPortrait == YES) ? MobilyImageCropController_PortraitButtonsVerticalMargin : MobilyImageCropController_LandscapeButtonsVerticalMargin;
    NSDictionary* metrics = @{
        @"scroll_margin" : @(0.0f),
        @"overlay_margin" : @(0.0f),
        @"title_hmargin" : @(0.0f),
        @"title_vmargin" : @(titleLabelVerticalMargin),
        @"buttons_hmargin" : @(buttonsHorizontalMargin),
        @"buttons_vmargin" : @(buttonsVerticalMargin)
    };
    NSDictionary* views = @{
        @"view" : self.view,
        @"scroll" : self.scrollView,
        @"overlay" : self.overlayView,
        @"title" : self.titleLabel,
        @"cancel" : self.cancelButton,
        @"choose" : self.chooseButton,
    };
    [self.view removeConstraints:self.view.constraints];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(==scroll_margin)-[scroll]-(==scroll_margin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(==scroll_margin)-[scroll]-(==scroll_margin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(==overlay_margin)-[overlay]-(==overlay_margin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(==overlay_margin)-[overlay]-(==overlay_margin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(>=title_hmargin)-[title]-(>=title_hmargin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(title_vmargin)-[title]" options:NSLayoutFormatAlignAllTop metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-(>=buttons_hmargin)-[cancel]-(>=0)-[choose]-(>=buttons_hmargin)-[view]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(buttons_vmargin)-[cancel]" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-(buttons_vmargin)-[choose]" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
}

#pragma mark Property

- (void)setCropRect:(CGRect)cropRect {
    CGFloat zoom = 1.0f / self.scrollView.zoomScale;
    CGFloat x = round(cropRect.origin.x / zoom);
    CGFloat y = round(cropRect.origin.y / zoom);
    CGFloat w = round(cropRect.size.width / zoom);
    CGFloat h = round(cropRect.size.height / zoom);
    [self.scrollView scrollRectToVisible:CGRectMake(x, y, w, h) animated:YES];
}

- (CGRect)cropRect {
    CGFloat zoom = 1.0f / self.scrollView.zoomScale;
    CGFloat x = round(self.scrollView.contentOffset.x * zoom);
    CGFloat y = round(self.scrollView.contentOffset.y * zoom);
    CGFloat w = CGRectGetWidth(self.scrollView.bounds) * zoom;
    CGFloat h = CGRectGetHeight(self.scrollView.bounds) * zoom;
    return CGRectIntegral(CGRectMake(x, y, w, h));
}

- (void)setAngle:(CGFloat)angle {
    if(self.angle != angle) {
        self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, (angle - self.angle));
    }
}

- (CGFloat)angle {
    CGAffineTransform transform = self.scrollView.transform;
    return atan2(transform.b, transform.a);
}

- (void)setScale:(CGFloat)scale {
    self.scrollView.zoomScale = scale;
}

- (CGFloat)scale {
    return self.scrollView.zoomScale;
}

- (void)setAvoidEmptySpaceAroundImage:(BOOL)avoidEmptySpaceAroundImage {
    if(_avoidEmptySpaceAroundImage != avoidEmptySpaceAroundImage) {
        _avoidEmptySpaceAroundImage = avoidEmptySpaceAroundImage;
        self.scrollView.aspectFill = avoidEmptySpaceAroundImage;
    }
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    if(_rotationEnabled != rotationEnabled) {
        _rotationEnabled = rotationEnabled;
        self.rotationGestureRecognizer.enabled = rotationEnabled;
    }
}

- (void)setOriginalImage:(UIImage*)originalImage {
    if([_originalImage isEqual:originalImage] == NO) {
        _originalImage = originalImage;
        if((self.isViewLoaded == YES) && (self.view.window != nil)) {
            [self _displayImage];
        }
    }
}

- (void)setMaskPath:(UIBezierPath*)maskPath {
    if([_maskPath isEqual:maskPath] == NO) {
        _maskPath = maskPath;
        
        UIBezierPath* clipPath = [UIBezierPath bezierPathWithRect:self.overlayView.frame];
        clipPath.usesEvenOddFillRule = YES;
        [clipPath appendPath:maskPath];
        
        CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.timingFunction = [CATransaction animationTimingFunction];
        pathAnimation.duration = [CATransaction animationDuration];
        [self.maskLayer addAnimation:pathAnimation forKey:@"path"];

        self.maskLayer.path = [clipPath CGPath];
    }
}

- (MobilyImageScrollView*)scrollView {
    if(_scrollView == nil) {
        _scrollView = [[MobilyImageScrollView alloc] init];
        _scrollView.clipsToBounds = NO;
        _scrollView.aspectFill = self.avoidEmptySpaceAroundImage;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (MobilyTouchView*)overlayView {
    if(_overlayView == nil) {
        _overlayView = [[MobilyTouchView alloc] init];
        _overlayView.receiver = self.scrollView;
        [_overlayView.layer addSublayer:self.maskLayer];
    }
    return _overlayView;
}

- (CAShapeLayer*)maskLayer {
    if(_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = self.maskColor.CGColor;
    }
    return _maskLayer;
}

- (UIColor*)maskColor {
    if(_maskColor == nil) {
        _maskColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _maskColor;
}

- (UILabel*)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = NSLocalizedString(@"Move and Scale", @"Move and Scale label");
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.opaque = NO;
    }
    return _titleLabel;
}

- (UIButton*)cancelButton {
    if(_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        _chooseButton.normalTitle = NSLocalizedString(@"Cancel", @"Cancel button");
        _cancelButton.opaque = NO;
        
        [_cancelButton addTarget:self action:@selector(onCancelButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton*)chooseButton {
    if(_chooseButton == nil) {
        _chooseButton = [[UIButton alloc] init];
        _chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
        _chooseButton.normalTitle = NSLocalizedString(@"Choose", @"Choose button");
        _chooseButton.opaque = NO;
        
        [_chooseButton addTarget:self action:@selector(onChooseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}

- (UITapGestureRecognizer*)doubleTapGestureRecognizer {
    if(_doubleTapGestureRecognizer == nil) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        _doubleTapGestureRecognizer.delegate = self;
    }
    return _doubleTapGestureRecognizer;
}

- (UIRotationGestureRecognizer*)rotationGestureRecognizer {
    if(_rotationGestureRecognizer == nil) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        _rotationGestureRecognizer.delaysTouchesEnded = NO;
        _rotationGestureRecognizer.delegate = self;
        _rotationGestureRecognizer.enabled = self.isRotationEnabled;
    }
    return _rotationGestureRecognizer;
}

#pragma mark Actions

- (void)onCancelButtonTouch:(UIBarButtonItem*)sender {
    [self cancelCrop];
}

- (void)onChooseButtonTouch:(UIBarButtonItem*)sender {
    [self _cropImage];
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)gestureRecognizer {
    [self _reset:YES];
}

- (void)handleRotation:(UIRotationGestureRecognizer*)gestureRecognizer {
    [self setAngle:(self.angle + gestureRecognizer.rotation)];
    gestureRecognizer.rotation = 0;
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:MobilyImageCropController_ScrollDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self _layoutImageScrollView];
        } completion:nil];
    }
}

#pragma mark Private

- (void)_reset:(BOOL)animated {
    if(animated == YES) {
        [UIView beginAnimations:@"reset" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:MobilyImageCropController_ResetDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    [self _resetRotation];
    [self _resetFrame];
    [self _resetZoomScale];
    [self _resetContentOffset];
    if(animated == YES) {
        [UIView commitAnimations];
    }
}

- (void)_resetContentOffset {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect zoomFrame = self.scrollView.zoomView.frame;
    CGPoint contentOffset;
    if(zoomFrame.size.width > boundsSize.width) {
        contentOffset.x = (zoomFrame.size.width - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0.0f;
    }
    if(zoomFrame.size.height > boundsSize.height) {
        contentOffset.y = (zoomFrame.size.height - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0.0f;
    }
    self.scrollView.contentOffset = contentOffset;
}

- (void)_resetFrame {
    [self _layoutImageScrollView];
}

- (void)_resetRotation {
    [self setAngle:0.0];
}

- (void)_resetZoomScale {
    CGSize boundsSize = self.view.bounds.size;
    CGSize imageSize = self.originalImage.size;
    CGFloat zoomScale;
    if(boundsSize.width > boundsSize.height) {
        zoomScale = boundsSize.height / imageSize.height;
    } else {
        zoomScale = boundsSize.width / imageSize.width;
    }
    self.scrollView.zoomScale = zoomScale;
}

- (NSArray*)_intersectionPointsOfLineSegment:(MobilyLineSegment)lineSegment withRect:(CGRect)rect {
    CGPoint tl = MobilyRectGetTopLeftPoint(rect);
    CGPoint tr = MobilyRectGetTopRightPoint(rect);
    CGPoint bl = MobilyRectGetBottomLeftPoint(rect);
    CGPoint br = MobilyRectGetBottomRightPoint(rect);
    MobilyLineSegment ts = MobilyLineSegmentMake(tl, tr);
    MobilyLineSegment rs = MobilyLineSegmentMake(tr, br);
    MobilyLineSegment bs = MobilyLineSegmentMake(br, bl);
    MobilyLineSegment ls = MobilyLineSegmentMake(bl, tl);
    CGPoint p0 = MobilyLineSegmentIntersection(ts, lineSegment);
    CGPoint p1 = MobilyLineSegmentIntersection(rs, lineSegment);
    CGPoint p2 = MobilyLineSegmentIntersection(bs, lineSegment);
    CGPoint p3 = MobilyLineSegmentIntersection(ls, lineSegment);
    NSMutableArray* intersectionPoints = [NSMutableArray array];
    if(MobilyPointIsInfinity(p0) == NO) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p0]];
    }
    if(MobilyPointIsInfinity(p1) == NO) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p1]];
    }
    if(MobilyPointIsInfinity(p2) == NO) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p2]];
    }
    if(MobilyPointIsInfinity(p3) == NO) {
        [intersectionPoints addObject:[NSValue valueWithCGPoint:p3]];
    }
    return intersectionPoints;
}

- (void)_displayImage {
    if(self.originalImage != nil) {
        [self.scrollView _displayImage:self.originalImage];
        [self _reset:NO];
    }
}

- (void)_layoutImageScrollView {
    CGRect frame = CGRectZero;
    switch (self.cropMode) {
        case MobilyImageCropModeSquare: {
            CGFloat angle = self.angle;
            if(angle == 0.0f) {
                frame = self.maskRect;
            } else {
                CGFloat absAlpha = fabs(angle);
                CGRect initialRect = self.maskRect;
                CGPoint leftTopPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y);
                CGPoint leftBottomPoint = CGPointMake(initialRect.origin.x, initialRect.origin.y + initialRect.size.height);
                CGPoint pivot = MobilyRectGetCenterPoint(initialRect);
                MobilyLineSegment leftLineSegment = MobilyLineSegmentMake(leftTopPoint, leftBottomPoint);
                MobilyLineSegment rotatedLeftLineSegment = MobilyLineSegmentRotateAroundPoint(leftLineSegment, pivot, absAlpha);
                NSArray* points = [self _intersectionPointsOfLineSegment:rotatedLeftLineSegment withRect:initialRect];
                if(points.count > 1) {
                    if((absAlpha > M_PI_2) && (absAlpha < M_PI)) {
                        absAlpha = absAlpha - M_PI_2;
                    } else if((absAlpha > (M_PI + M_PI_2)) && (absAlpha < (M_PI + M_PI))) {
                        absAlpha = absAlpha - (M_PI + M_PI_2);
                    }
                    CGFloat sinAlpha = sin(absAlpha);
                    CGFloat cosAlpha = cos(absAlpha);
                    CGFloat hypotenuse = MobilyPointDistance([points[0] CGPointValue], [points[1] CGPointValue]);
                    CGFloat altitude = hypotenuse * sinAlpha * cosAlpha;
                    CGFloat initialWidth = initialRect.size.width;
                    CGFloat targetWidth = initialWidth + altitude * 2;
                    CGFloat scale = targetWidth / initialWidth;
                    CGPoint center = MobilyRectGetCenterPoint(initialRect);
                    frame = MobilyRectScaleAroundPoint(initialRect, center, scale, scale);
                    frame.origin.x = round(CGRectGetMinX(frame));
                    frame.origin.y = round(CGRectGetMinY(frame));
                    frame = CGRectIntegral(frame);
                } else {
                    frame = initialRect;
                }
            }
            break;
        }
        case MobilyImageCropModeCircle: {
            frame = self.maskRect;
            break;
        }
    }
    
    CGAffineTransform transform = self.scrollView.transform;
    self.scrollView.transform = CGAffineTransformIdentity;
    self.scrollView.frame = frame;
    self.scrollView.transform = transform;
}

- (void)_layoutOverlayView {
    CGSize boundsSize = self.view.bounds.size;
    self.overlayView.frame = CGRectMake(0, 0, boundsSize.width * 2.0f, boundsSize.height * 2.0f);
}

- (void)_updateMaskRect {
    CGSize boundsSize = self.view.bounds.size;
    switch(self.cropMode) {
        case MobilyImageCropModeCircle: {
            CGFloat diameter;
            if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation) == YES) {
                diameter = MIN(boundsSize.width, boundsSize.height) - MobilyImageCropController_PortraitCircleInsets * 2;
            } else {
                diameter = MIN(boundsSize.width, boundsSize.height) - MobilyImageCropController_LandscapeCircleInsets * 2;
            }
            self.maskRect = CGRectMake((boundsSize.width - diameter) * 0.5f, (boundsSize.height - diameter) * 0.5f, diameter, diameter);
            break;
        }
        case MobilyImageCropModeSquare: {
            CGFloat length;
            if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation) == YES) {
                length = MIN(boundsSize.width, boundsSize.height) - MobilyImageCropController_PortraitSquareInsets * 2;
            } else {
                length = MIN(boundsSize.width, boundsSize.height) - MobilyImageCropController_LandscapeSquareInsets * 2;
            }
            self.maskRect = CGRectMake((boundsSize.width - length) * 0.5f, (boundsSize.height - length) * 0.5f, length, length);
            break;
        }
    }
}

- (void)_updateMaskPath {
    switch(self.cropMode) {
        case MobilyImageCropModeCircle: {
            self.maskPath = [UIBezierPath bezierPathWithOvalInRect:self.maskRect];
            break;
        }
        case MobilyImageCropModeSquare: {
            self.maskPath = [UIBezierPath bezierPathWithRect:self.maskRect];
            break;
        }
    }
}

- (UIImage*)_croppedImage:(UIImage*)image cropMode:(MobilyImageCropMode)cropMode cropRect:(CGRect)cropRect angle:(CGFloat)angle zoom:(CGFloat)zoom maskPath:(UIBezierPath*)maskPath applyMaskToCroppedImage:(BOOL)applyMaskToCroppedImage {
    CGSize imageSize = image.size;
    CGFloat x = CGRectGetMinX(cropRect);
    CGFloat y = CGRectGetMinY(cropRect);
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    UIImageOrientation imageOrientation = image.imageOrientation;
    if(imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        cropRect.origin.x = y;
        cropRect.origin.y = round(imageSize.width - CGRectGetWidth(cropRect) - x);
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if(imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        cropRect.origin.x = round(imageSize.height - CGRectGetHeight(cropRect) - y);
        cropRect.origin.y = x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if(imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        cropRect.origin.x = round(imageSize.width - CGRectGetWidth(cropRect) - x);
        cropRect.origin.y = round(imageSize.height - CGRectGetHeight(cropRect) - y);
    }
    CGFloat imageScale = image.scale;
    cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformMakeScale(imageScale, imageScale));
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:imageScale orientation:imageOrientation];
    CGImageRelease(croppedCGImage);
    croppedImage = [croppedImage unrotate];
    imageOrientation = croppedImage.imageOrientation;
    if(((cropMode == MobilyImageCropModeSquare) || (applyMaskToCroppedImage == NO)) && (angle == 0.0f)) {
        return croppedImage;
    } else {
        CGSize maskSize = CGRectIntegral(maskPath.bounds).size;
        CGSize contextSize = CGSizeMake(ceil(maskSize.width / zoom), ceil(maskSize.height / zoom));
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, imageScale);
        if(applyMaskToCroppedImage == YES) {
            UIBezierPath* maskPathCopy = [maskPath copy];
            CGFloat scale = 1.0f / zoom;
            [maskPathCopy applyTransform:CGAffineTransformMakeScale(scale, scale)];
            CGPoint translation = CGPointMake(-CGRectGetMinX(maskPathCopy.bounds), -CGRectGetMinY(maskPathCopy.bounds));
            [maskPathCopy applyTransform:CGAffineTransformMakeTranslation(translation.x, translation.y)];
            [maskPathCopy addClip];
        }
        if(angle != 0) {
            croppedImage = [croppedImage rotateToAngleInRadians:angle];
        }
        CGPoint point = CGPointMake(round((contextSize.width - croppedImage.size.width) * 0.5f), round((contextSize.height - croppedImage.size.height) * 0.5f));
        [croppedImage drawAtPoint:point];
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:imageScale orientation:imageOrientation];
        return croppedImage;
    }
}

- (void)_cropImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect cropRect = self.cropRect;
        CGFloat angle = self.angle;
        UIImage* croppedImage = [self _croppedImage:self.originalImage cropMode:self.cropMode cropRect:self.cropRect angle:self.angle zoom:self.scrollView.zoomScale maskPath:self.maskPath applyMaskToCroppedImage:self.applyMaskToCroppedImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_didChoose != nil) {
                _didChoose(self, croppedImage, cropRect, angle);
            }
        });
    });
}

- (void)cancelCrop {
    if(_didCancel != nil) {
        _didCancel(self);
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(__unused UIScrollView*)scrollView {
    return self.scrollView.zoomView;
}

- (void)scrollViewDidZoom:(__unused UIScrollView*)scrollView {
    [self.scrollView _centerZoomView];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

@end

/*--------------------------------------------------*/

@implementation MobilyImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _aspectFill = NO;
        
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
    }
    return self;
}

- (void)didAddSubview:(UIView*)subview {
    [super didAddSubview:subview];
    [self _centerZoomView];
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = CGSizeEqualToSize(frame.size, self.frame.size);
    if(sizeChanging == NO) {
        [self _prepareToResize];
    }
    [super setFrame:frame];
    if(sizeChanging == NO) {
        [self _recoverFromResizing];
    }
    [self _centerZoomView];
}

#pragma mark Private

- (void)_centerZoomView {
    CGSize boundsSize = self.bounds.size;
    CGSize contentSize = self.contentSize;
    if(self.aspectFill == YES) {
        CGFloat top = 0.0f;
        CGFloat left = 0.0f;
        if(contentSize.height < boundsSize.height) {
            top = (boundsSize.height - contentSize.height) * 0.5f;
        }
        if(contentSize.width < boundsSize.width) {
            left = (boundsSize.width - contentSize.width) * 0.5f;
        }
        self.contentInset = UIEdgeInsetsMake(top, left, top, left);
    } else {
        CGRect frameToCenter = self.zoomView.frame;
        if(frameToCenter.size.width < boundsSize.width) {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) * 0.5f;
        } else {
            frameToCenter.origin.x = 0.0f;
        }
        if(CGRectGetHeight(frameToCenter) < contentSize.height) {
            frameToCenter.origin.y = (contentSize.height - frameToCenter.size.height) * 0.5f;
        } else {
            frameToCenter.origin.y = 0.0f;
        }
        self.zoomView.frame = frameToCenter;
    }
}

- (void)_displayImage:(UIImage*)image {
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    self.zoomScale = 1.0;
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    [self _configureForImageSize:image.size];
}

- (void)_configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self _setMaxMinZoomScalesForCurrentBounds];
    [self _setInitialZoomScale];
    [self _setInitialContentOffset];
    self.contentInset = UIEdgeInsetsZero;
}

- (void)_setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width  / _imageSize.width;
    CGFloat yScale = boundsSize.height / _imageSize.height;
    CGFloat minScale;
    if(self.aspectFill == YES) {
        minScale = MAX(xScale, yScale);
    } else {
        minScale = MIN(xScale, yScale);
    }
    CGFloat maxScale = MAX(xScale, yScale);
    CGFloat xImageScale = maxScale * _imageSize.width / boundsSize.width;
    CGFloat yImageScale = maxScale * _imageSize.height / boundsSize.width;
    CGFloat maxImageScale = MAX(xImageScale, yImageScale);
    maxImageScale = MAX(minScale, maxImageScale);
    maxScale = MAX(maxScale, maxImageScale);
    if(minScale > maxScale) {
        minScale = maxScale;
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)_setInitialZoomScale {
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width / _imageSize.width;
    CGFloat yScale = boundsSize.height / _imageSize.height;
    CGFloat scale = MAX(xScale, yScale);
    self.zoomScale = scale;
}

- (void)_setInitialContentOffset {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;
    CGPoint contentOffset;
    if(CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0.0f;
    }
    if(CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0.0f;
    }
    [self setContentOffset:contentOffset];
}

- (void)_prepareToResize {
    CGRect bounds = self.bounds;
    CGPoint boundsCenter = MobilyRectGetCenterPoint(bounds);
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.zoomView];
    _scaleToRestoreAfterResize = self.zoomScale;
    if(_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON) {
        _scaleToRestoreAfterResize = 0;
    }
}

- (void)_recoverFromResizing {
    [self _setMaxMinZoomScalesForCurrentBounds];
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.zoomView];
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width * 0.5f, boundsCenter.y - self.bounds.size.height * 0.5f);
    CGPoint maxOffset = [self _maximumContentOffset];
    CGPoint minOffset = [self _minimumContentOffset];
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    self.contentOffset = offset;
}

- (CGPoint)_maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)_minimumContentOffset {
    return CGPointZero;
}

@end

/*--------------------------------------------------*/
