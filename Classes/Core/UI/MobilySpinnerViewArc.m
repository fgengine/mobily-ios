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

#import "MobilySpinnerView.h"

/*--------------------------------------------------*/

@implementation MobilySpinnerViewArc

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGRect frame  = CGRectInset(CGRectMake(0.0f, 0.0f, self.size, self.size), 2.0f, 2.0f);
    CGFloat radius = CGRectGetWidth(frame) / 2.0f;
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));

    CALayer* circle = [CALayer layer];
    circle.frame = CGRectMake(0.0f, 0.0f, self.size, self.size);
    circle.backgroundColor = self.color.CGColor;
    circle.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.cornerRadius = self.size * 0.5f;
    [self.layer addSublayer:circle];

    CAShapeLayer* mask = [CAShapeLayer layer];
    mask.frame = CGRectMake(0.0f, 0.0f, self.size, self.size);
    mask.path = [[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0.0f endAngle:((M_PI * 2.0f) / 360.0f) * 300.0f clockwise:YES] CGPath];
    mask.strokeColor = UIColor.blackColor.CGColor;
    mask.fillColor = UIColor.clearColor.CGColor;
    mask.lineWidth = 2.0f;
    mask.cornerRadius = self.size * 0.5f;
    mask.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.mask = mask;

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.duration = 0.8f;
    animation.beginTime = beginTime;
    animation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
    animation.values = @[
        [NSNumber numberWithDouble:0.0f],
		[NSNumber numberWithDouble:M_PI],
		[NSNumber numberWithDouble:M_PI * 2.0f]
    ];

    [circle addAnimation:animation forKey:@"circle"];
}

@end

/*--------------------------------------------------*/
