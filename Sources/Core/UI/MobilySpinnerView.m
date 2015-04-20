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

#import <MobilySpinnerView.h>

/*--------------------------------------------------*/

@interface MobilySpinnerView ()

@property(nonatomic, readwrite, assign, getter=isStopped) BOOL stopped;
@property(nonatomic, readwrite, assign, getter=isAnimating) BOOL animating;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

- (void)applyAnimation;
- (void)pauseLayers;
- (void)resumeLayers;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MobilySpinnerViewSize                       42.0f
#define MobilySpinnerViewColor                      [UIColor colorWithWhite:1.0f alpha:0.8f]

/*--------------------------------------------------*/

@implementation MobilySpinnerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _size = MobilySpinnerViewSize;
    _color = MobilySpinnerViewColor;
    _hidesWhenStopped = YES;
    
    self.backgroundColor = UIColor.clearColor;
    [self applyAnimation];
    [self sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma Property

-(void)setSize:(CGFloat)size {
    if(_size != size) {
        _size = size;
        [self applyAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setColor:(UIColor*)color {
    if([_color isEqual:color] == NO) {
        _color = color;
        
        CGColorRef colorRef = _color.CGColor;
        for(CALayer* layer in self.layer.sublayers) {
            layer.backgroundColor = colorRef;
        }
    }
}

#pragma mark Public override

- (CGSize)sizeThatFits:(CGSize __unused)size {
    return CGSizeMake(_size, _size);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_size, _size);
}

#pragma mark Public

- (void)startAnimating {
    if(_animating == NO) {
        _animating = YES;
        self.hidden = NO;
        [self resumeLayers];
    }
}

- (void)stopAnimating {
    if(_animating == YES) {
        _animating = NO;
        if(_hidesWhenStopped == YES) {
            self.hidden = YES;
        }
        [self pauseLayers];
    }
}

- (void)prepareAnimation {
}

#pragma mark Private

- (void)applicationDidEnterBackground {
    if(_animating == YES) {
        [self pauseLayers];
    }
}

- (void)applicationWillEnterForeground {
    if(_animating == YES) {
        [self resumeLayers];
    }
}

- (void)applyAnimation {
    self.layer.sublayers = nil;
    [self prepareAnimation];
}

- (void)pauseLayers {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.timeOffset = pausedTime;
    self.layer.speed = 0.0f;
}

- (void)resumeLayers {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0.0f;
    self.layer.beginTime = 0.0f;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

@end

/*--------------------------------------------------*/
