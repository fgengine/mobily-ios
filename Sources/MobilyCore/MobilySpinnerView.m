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

#import <MobilyCore/MobilySpinnerView.h>

/*--------------------------------------------------*/

@interface MobilySpinnerView ()

@property(nonatomic, readwrite, assign, getter=isStopped) BOOL stopped;
@property(nonatomic, readwrite, assign, getter=isAnimating) BOOL animating;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

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
    _hidesWhenStopped = NO;
    
    self.backgroundColor = UIColor.clearColor;
    self.hidden = NO;
    self.layer.timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0f;
    
    [self prepareAnimation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma Property

-(void)setSize:(CGFloat)size {
    if(_size != size) {
        _size = size;
        [self invalidateIntrinsicContentSize];
        [self prepareAnimation];
    }
}

- (void)setColor:(UIColor*)color {
    if([_color isEqual:color] == NO) {
        _color = color;
        [self prepareAnimation];
    }
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    if(_hidesWhenStopped != hidesWhenStopped) {
        _hidesWhenStopped = hidesWhenStopped;
        if(_hidesWhenStopped == YES) {
            if(_animating == NO) {
                self.layer.sublayers = nil;
                self.hidden = YES;
            }
        } else {
            self.hidden = NO;
            [self prepareAnimation];
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
        if(self.layer.sublayers.count < 1) {
            [self prepareAnimation];
        }
        CFTimeInterval currentTime = CACurrentMediaTime();
        CFTimeInterval pausedTime = self.layer.timeOffset;
        self.layer.beginTime = [self.layer convertTime:currentTime fromLayer:nil] - pausedTime;;
        self.layer.timeOffset = 0.0f;
        self.layer.speed = 1.0;
    }
}

- (void)stopAnimating {
    if(_animating == YES) {
        _animating = NO;
        if(_hidesWhenStopped == YES) {
            self.layer.sublayers = nil;
            self.hidden = YES;
        }
        self.layer.timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0f;
    }
}

- (void)prepareAnimation {
    self.layer.sublayers = nil;
}

#pragma mark Private

- (void)applicationDidEnterBackground {
    if(_animating == YES) {
        self.layer.sublayers = nil;
    }
}

- (void)applicationWillEnterForeground {
    if(_animating == YES) {
        [self prepareAnimation];
    }
}

@end

/*--------------------------------------------------*/
