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

@implementation MobilySpinnerViewWave

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime() + 1.2f;
    CGFloat barWidth = self.size / 5.0f;
    for(NSInteger i = 0; i < 5; i++) {
        CALayer* bar = [CALayer layer];
        bar.backgroundColor = self.color.CGColor;
        bar.frame = CGRectMake(barWidth * i, 0.0f, barWidth - 3.0f, self.size);
        bar.transform = CATransform3DMakeScale(1.0f, 0.3f, 0.0f);
        [self.layer addSublayer:bar];

        CAKeyframeAnimation* barAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        barAnimation.removedOnCompletion = NO;
        barAnimation.beginTime = beginTime - (1.2f - (0.1f * i));
        barAnimation.duration = 1.2f;
        barAnimation.repeatCount = HUGE_VALF;
        barAnimation.keyTimes = @[ @(0.0f), @(0.2f), @(0.4f), @(1.0f) ];
        barAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
        barAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 0.4f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 0.4f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 0.4f, 0.0f)]
        ];

        [bar addAnimation:barAnimation forKey:@"bar"];
    }
}

@end

/*--------------------------------------------------*/
