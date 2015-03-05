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

#import "MobilySpinnerView.h"

/*--------------------------------------------------*/

@implementation MobilySpinnerViewCircle

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat circleSize = self.size * 0.25f;
    CGFloat circleSize2 = circleSize * 0.5f;
    CGFloat radius = self.size * 0.5f;
    CGFloat radius2 = radius - circleSize2;
    for(NSInteger i = 0; i < 8; i++) {
        CGFloat angle = i * M_PI_4;
        CGFloat x = (radius + (sinf(angle) * radius2)) - circleSize2;
        CGFloat y = (radius - (cosf(angle) * radius2)) - circleSize2;
        
        CALayer* circle = [CALayer layer];
        circle.frame = CGRectMake(x, y, circleSize, circleSize);
        circle.backgroundColor = self.color.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.cornerRadius = circleSize * 0.5f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        [self.layer addSublayer:circle];
  
        CAKeyframeAnimation* circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        circleAnimation.removedOnCompletion = NO;
        circleAnimation.repeatCount = HUGE_VALF;
        circleAnimation.duration = 1.0f;
        circleAnimation.beginTime = beginTime + (0.125f * i);
        circleAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
        circleAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
        circleAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]
        ];
        [circle addAnimation:circleAnimation forKey:@"circle"];
    }
}

@end

/*--------------------------------------------------*/
