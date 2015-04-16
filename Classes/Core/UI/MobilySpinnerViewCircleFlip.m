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

#import <Mobily/MobilySpinnerView.h>

/*--------------------------------------------------*/

@implementation MobilySpinnerViewCircleFlip

- (void)prepareAnimation {
    CALayer* circle = [CALayer layer];
    circle.frame = CGRectInset(CGRectMake(0.0f, 0.0f, self.size, self.size), 2.0f, 2.0f);
    circle.backgroundColor = self.color.CGColor;
    circle.cornerRadius = self.size * 0.5f;
    circle.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.anchorPointZ = 0.5;
    circle.shouldRasterize = YES;
    circle.rasterizationScale = UIScreen.mainScreen.scale;
    [self.layer addSublayer:circle];
    
    CAKeyframeAnimation* circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    circleAnimation.removedOnCompletion = NO;
    circleAnimation.repeatCount = HUGE_VALF;
    circleAnimation.duration = 1.2;
    circleAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
    circleAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
    ];
    circleAnimation.values = @[
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, 0.0f, 0.0f, 0.0f, 0.0f)],
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, M_PI, 0.0f, 1.0f, 0.0f)],
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, M_PI, 0.0f, 0.0f, 1.0f)]
    ];
    [circle addAnimation:circleAnimation forKey:@"circle"];
}

@end

/*--------------------------------------------------*/
