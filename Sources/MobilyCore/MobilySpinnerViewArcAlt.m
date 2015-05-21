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

@implementation MobilySpinnerViewArcAlt

- (void)prepareAnimation {
    [super prepareAnimation];
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGRect frame  = CGRectInset(CGRectMake(0.0f, 0.0f, self.size, self.size), 2.0f, 2.0f);
    CGFloat radius = CGRectGetWidth(frame) / 2.0f;
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    CALayer* arc = [CALayer layer];
    arc.frame = CGRectMake(0.0f, 0.0f, self.size, self.size);
    arc.backgroundColor = self.color.CGColor;
    arc.anchorPoint = CGPointMake(0.5f, 0.5f);
    arc.cornerRadius = self.size * 0.5f;
    [self.layer addSublayer:arc];

    CAShapeLayer* mask = [CAShapeLayer layer];
    mask.frame = CGRectMake(0.0f, 0.0f, self.size, self.size);
    mask.path = [[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0.0f endAngle:M_PI * 2.0f clockwise:YES] CGPath];
    mask.strokeColor = UIColor.blackColor.CGColor;
    mask.fillColor = UIColor.clearColor.CGColor;
    mask.lineWidth = 2.0f;
    mask.cornerRadius = self.size * 0.5f;
    mask.anchorPoint = CGPointMake(0.5f, 0.5f);
    arc.mask = mask;

    CAKeyframeAnimation* strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.repeatCount = HUGE_VALF;
    strokeStartAnimation.duration = 1.2f;
    strokeStartAnimation.beginTime = beginTime;
    strokeStartAnimation.keyTimes = @[@(0.0f), @(0.6f), @(1.0f)];
    strokeStartAnimation.values = @[@(0.0f), @(0.0f), @(1.0f)];
    strokeStartAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
    ];
    [mask addAnimation:strokeStartAnimation forKey:@"circle-start"];
    
    CAKeyframeAnimation* strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.repeatCount = HUGE_VALF;
    strokeEndAnimation.duration = 1.2f;
    strokeEndAnimation.beginTime = beginTime;
    strokeEndAnimation.keyTimes = @[@(0.0f), @(0.4f), @(1.0f)];
    strokeEndAnimation.values = @[@(0.0f), @(1.0f), @(1.0f)];
    strokeEndAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
    ];
    [mask addAnimation:strokeEndAnimation forKey:@"circle-end"];
}

@end

/*--------------------------------------------------*/

