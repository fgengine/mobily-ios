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

@implementation MobilySpinnerViewFadingCircle

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat squareSize = self.size / 6.0f;
    CGFloat squareSize2 = squareSize * 0.5f;
    CGFloat radius = self.size * 0.5f;
    CGFloat radius2 = radius - squareSize2;
    for(NSInteger i = 0; i < 12; i++) {
        CGFloat angle = i * (M_PI_2 / 3.0f);
        CGFloat x = (radius + (sinf(angle) * radius2)) - squareSize2;
        CGFloat y = (radius - (cosf(angle) * radius2)) - squareSize2;
        
        CALayer* square = [CALayer layer];
        square.frame = CGRectMake(x, y, squareSize, squareSize);
        square.transform = CATransform3DRotate(CATransform3DIdentity, angle, 0.0f, 0.0f, 1.0f);
        square.anchorPoint = CGPointMake(0.5f, 0.5f);
        square.backgroundColor = self.color.CGColor;
        square.opacity = 0.0f;
        [self.layer addSublayer:square];

        CAKeyframeAnimation* squareAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        squareAnimation.removedOnCompletion = NO;
        squareAnimation.repeatCount = HUGE_VALF;
        squareAnimation.duration = 1.0;
        squareAnimation.beginTime = beginTime + (0.084 * i);
        squareAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        squareAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
        squareAnimation.values = @[@(1.0), @(0.0), @(0.0)];
        [square addAnimation:squareAnimation forKey:@"square"];
    }
}

@end

/*--------------------------------------------------*/
