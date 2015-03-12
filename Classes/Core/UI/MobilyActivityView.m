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

#import "MobilyActivityView.h"
#import "MobilySpinnerView.h"

/*--------------------------------------------------*/

@interface MobilyActivityView () {
@protected
    UIView* _panelView;
    MobilySpinnerView* _spinnerView;
    UILabel* _textView;
    NSUInteger _showCount;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MobilyActivityViewMargin                    15.0f
#define MobilyActivityViewSpacing                   8.0f
#define MobilyActivityViewBackgroundColor           [UIColor colorWithWhite:0.1f alpha:0.2f]
#define MobilyActivityViewPanelColor                [UIColor colorWithWhite:0.2f alpha:0.8f]
#define MobilyActivityViewPanelCornerRadius         8.0f
#define MobilyActivityViewSpinnerColor              [UIColor colorWithWhite:1.0f alpha:0.8f]
#define MobilyActivityViewSpinnerSize               42.0f
#define MobilyActivityViewTextColor                 [UIColor colorWithWhite:1.0f alpha:0.8f]
#define MobilyActivityViewTextFont                  [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
#define MobilyActivityViewTextWidth                 NSNotFound
#define MobilyActivityDuration                      0.1f

/*--------------------------------------------------*/

@implementation MobilyActivityView

#pragma mark Init / Free

+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style {
    return [[self alloc] initWithInView:view style:style text:nil textWidth:MobilyActivityViewTextWidth];
}

+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text {
    return [[self alloc] initWithInView:view style:style text:text textWidth:MobilyActivityViewTextWidth];
}

+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text textWidth:(NSUInteger)textWidth {
    return [[self alloc] initWithInView:view style:style text:text textWidth:textWidth];
}

- (instancetype)initWithInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text textWidth:(NSUInteger)textWidth {
    self = [super initWithFrame:view.bounds];
    if(self != nil) {
        _style = style;
        _margin = MobilyActivityViewMargin;
        _spacing = MobilyActivityViewSpacing;
        _textWidth = textWidth;
        
        self.backgroundColor = MobilyActivityViewBackgroundColor;
        self.alpha = 0.0f;
        self.hidden = YES;
        [view addSubview:self];
        
        _panelView = [[UIView alloc] initWithFrame:CGRectZero];
        _panelView.backgroundColor = MobilyActivityViewPanelColor;
        _panelView.cornerRadius = MobilyActivityViewPanelCornerRadius;
        _panelView.clipsToBounds = YES;
        [self addSubview:_panelView];
        
        switch(_style) {
            case MobilyActivityViewStylePlane: _spinnerView = [[MobilySpinnerViewPlane alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleBounce: _spinnerView = [[MobilySpinnerViewBounce alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleWave: _spinnerView = [[MobilySpinnerViewWave alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleWanderingCubes: _spinnerView = [[MobilySpinnerViewWanderingCubes alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStylePulse: _spinnerView = [[MobilySpinnerViewPulse alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleChasingDots: _spinnerView = [[MobilySpinnerViewChasingDots alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleThreeBounce: _spinnerView = [[MobilySpinnerViewThreeBounce alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleCircle: _spinnerView = [[MobilySpinnerViewCircle alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleCircleFlip: _spinnerView = [[MobilySpinnerViewCircleFlip alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyle9CubeGrid: _spinnerView = [[MobilySpinnerView9CubeGrid alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleWordPress: _spinnerView = [[MobilySpinnerViewWordPress alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleFadingCircle: _spinnerView = [[MobilySpinnerViewFadingCircle alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleFadingCircleAlt: _spinnerView = [[MobilySpinnerViewFadingCircleAlt alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleArc: _spinnerView = [[MobilySpinnerViewArc alloc] initWithFrame:CGRectZero]; break;
            case MobilyActivityViewStyleArcAlt: _spinnerView = [[MobilySpinnerViewArcAlt alloc] initWithFrame:CGRectZero]; break;
            default: break;
        }
        if(_spinnerView != nil) {
            _spinnerView.color = MobilyActivityViewSpinnerColor;
            _spinnerView.size = MobilyActivityViewSpinnerSize;
            [_panelView addSubview:_spinnerView];
        }
        _textView = [[UILabel alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = MobilyActivityViewTextColor;
        _textView.font = MobilyActivityViewTextFont;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.numberOfLines = 0;
        [_panelView addSubview:_textView];
        
        _showCount = NSNotFound;
        
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Public override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize spinnerSize = CGSizeMake(self.spinnerSize, self.spinnerSize);
    CGSize textSize = [_textView implicitSizeForWidth:_textWidth];
    CGSize panelSize = CGSizeMake(_margin + MAX(spinnerSize.width, textSize.width) + _margin, _margin + spinnerSize.height + ((_textView.text.length > 0) ? _spacing + textSize.height : 0.0f) + _margin);
    CGFloat spinnerOffset = floorf((panelSize.width - spinnerSize.width) * 0.5f);
    
    _panelView.frame = CGRectMakeCenterPoint(self.frameCenter, panelSize.width, panelSize.height);
    _spinnerView.frame = CGRectMake(spinnerOffset, _margin, spinnerSize.width, spinnerSize.height);
    _textView.frame = CGRectMake(_margin, _margin + spinnerSize.height + _spacing, textSize.width, textSize.height);
}

#pragma mark Property

- (void)setMargin:(CGFloat)margin {
    if(_margin != margin) {
        _margin = margin;
        [self setNeedsLayout];
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if(_spacing != spacing) {
        _spacing = spacing;
        [self setNeedsLayout];
    }
}

- (void)setPanelColor:(UIColor*)panelColor {
    if([_panelView.backgroundColor isEqual:panelColor] == NO) {
        _panelView.backgroundColor = panelColor;
        [self setNeedsLayout];
    }
}

- (UIColor*)panelColor {
    return _panelView.backgroundColor;
}

- (void)setPanelCornerRadius:(CGFloat)panelCornerRadius {
    if(_panelView.cornerRadius != panelCornerRadius) {
        _panelView.cornerRadius = panelCornerRadius;
        [self setNeedsLayout];
    }
}

- (CGFloat)panelCornerRadius {
    return _panelView.cornerRadius;
}

- (void)setSpinnerColor:(UIColor*)spinnerColor {
    if([_spinnerView.color isEqual:spinnerColor] == NO) {
        _spinnerView.color = spinnerColor;
        [self setNeedsLayout];
    }
}

- (UIColor*)spinnerColor {
    return _spinnerView.color;
}

- (void)setSpinnerSize:(CGFloat)spinnerSize {
    if(_spinnerView.size != spinnerSize) {
        _spinnerView.size = spinnerSize;
        [self setNeedsLayout];
    }
}

- (CGFloat)spinnerSize {
    return _spinnerView.size;
}

- (void)setTextColor:(UIColor*)textColor {
    if([_textView.textColor isEqual:textColor] == NO) {
        _textView.textColor = textColor;
        [self setNeedsLayout];
    }
}

- (UIColor*)textColor {
    return _textView.textColor;
}

- (void)setText:(NSString*)text {
    if([_textView.text isEqualToString:text] == NO) {
        _textView.text = text;
        [self setNeedsLayout];
    }
}

- (NSString*)text {
    return _textView.text;
}

- (void)setTextFont:(UIFont*)textFont {
    if([_textView.font isEqual:textFont] == NO) {
        _textView.font = textFont;
        [self setNeedsLayout];
    }
}

- (UIFont*)textFont {
    return _textView.font;
}

- (BOOL)isShowed {
    return (_showCount > 0);
}

#pragma mark Public

- (void)show {
    [self showPrepare:nil complete:nil];
}

- (void)showComplete:(MobilyActivityViewBlock)complete {
    [self showPrepare:nil complete:complete];
}

- (void)showPrepare:(MobilyActivityViewBlock)prepare complete:(MobilyActivityViewBlock)complete {
    if(_showCount == NSNotFound) {
        _showCount = 1;
        [self layoutIfNeeded];
        self.hidden = NO;
        [UIView animateWithDuration:MobilyActivityDuration animations:^{
            if(prepare != nil) {
                prepare();
                [self layoutIfNeeded];
            }
            _panelView.alpha = 1.0f;
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if(complete != nil) {
                complete();
            }
        }];
    } else if(_showCount != NSNotFound) {
        _showCount++;
    }
}

- (void)hide {
    [self hidePrepare:nil complete:nil];
}

- (void)hideComplete:(MobilyActivityViewBlock)complete {
    [self hidePrepare:nil complete:complete];
}

- (void)hidePrepare:(MobilyActivityViewBlock)prepare complete:(MobilyActivityViewBlock)complete {
    if(_showCount == 1) {
        _showCount = NSNotFound;
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:MobilyActivityDuration animations:^{
            if(prepare != nil) {
                prepare();
                [self layoutIfNeeded];
            }
            _panelView.alpha = 0.0f;
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            if(complete != nil) {
                complete();
            }
        }];
    } else if(_showCount != NSNotFound) {
        _showCount--;
    }
}

@end

/*--------------------------------------------------*/
