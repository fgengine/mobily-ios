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

@implementation MobilySpinnerViewPulse

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CALayer* circle = [CALayer layer];
    circle.frame = CGRectInset(CGRectMake(0.0f, 0.0f, self.size, self.size), 2.0f, 2.0f);
    circle.backgroundColor = self.color.CGColor;
    circle.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.opacity = 1.0f;
    circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5f;
    circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
    [self.layer addSublayer:circle];

    CAKeyframeAnimation* scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)]
    ];
    CAKeyframeAnimation* opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[
        @(1.0f),
        @(0.0f)
    ];
    
    CAAnimationGroup* groupAnimation = [CAAnimationGroup animation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.beginTime = beginTime;
    groupAnimation.repeatCount = HUGE_VALF;
    groupAnimation.duration = 1.0f;
    groupAnimation.animations = @[ scaleAnimation, opacityAnimation ];
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circle addAnimation:groupAnimation forKey:@"circle"];
}

@end

/*--------------------------------------------------*/
