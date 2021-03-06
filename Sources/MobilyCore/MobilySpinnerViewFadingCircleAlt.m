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

@implementation MobilySpinnerViewFadingCircleAlt

- (void)setup {
    [super setup];
    
    _numberOfCircle = 12;
    _factorCircle = 0.25f;
    _factorRadius = 0.5f;
    _minScale = 0.1f;
    _minOpacity = 0.0f;
}

- (void)prepareAnimation {
    [super prepareAnimation];
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat squareSize = self.size * _factorCircle;
    CGFloat squareSize2 = squareSize * 0.5f;
    CGFloat radius = self.size * _factorRadius;
    CGFloat radius2 = radius - squareSize2;
    for(NSInteger i = 0; i < _numberOfCircle;  i++) {
        CGFloat angle = MOBILY_DEG_TO_RAD * ((360.0f / _numberOfCircle) * i);
        CGFloat x = (radius + (cosf(angle) * radius2)) - squareSize2;
        CGFloat y = (radius - (sinf(angle) * radius2)) - squareSize2;
        
        CALayer* circle = [CALayer layer];
        circle.backgroundColor = self.color.CGColor;
        circle.frame = CGRectMake(x, y, squareSize, squareSize);
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.cornerRadius = radius * 0.25f;
        circle.rasterizationScale = UIScreen.mainScreen.scale;
        circle.shouldRasterize = YES;
        [self.layer addSublayer:circle];

        CAKeyframeAnimation* transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(_minScale, _minScale, 0.0f)]
        ];
        CAKeyframeAnimation* opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[ @(1.0f), @(_minOpacity) ];
        
        CAAnimationGroup* groupAnimation = [[CAAnimationGroup alloc] init];
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.repeatCount = HUGE_VALF;
        groupAnimation.duration = 0.1f * _numberOfCircle;
        groupAnimation.beginTime = beginTime - (groupAnimation.duration - (0.1f * i));
        groupAnimation.animations = @[ transformAnimation, opacityAnimation ];
        [circle addAnimation:groupAnimation forKey:@"group"];
    }
}

@end

/*--------------------------------------------------*/
