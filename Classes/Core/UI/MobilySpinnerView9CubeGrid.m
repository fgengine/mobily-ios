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

@implementation MobilySpinnerView9CubeGrid

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat squareSize = self.size / 3;
    for(NSInteger sum = 0; sum < 5; sum++) {
        for(NSInteger x = 0; x < 3; x++) {
            for(NSInteger y = 0; y < 3; y++) {
                if(x + y == sum) {
                    CALayer* square = [CALayer layer];
                    square.frame = CGRectMake(x * squareSize, y * squareSize, squareSize, squareSize);
                    square.backgroundColor = self.color.CGColor;
                    square.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
                    
                    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                    animation.removedOnCompletion = NO;
                    animation.repeatCount = HUGE_VALF;
                    animation.duration = 1.5f;
                    animation.beginTime = beginTime + (0.1f * sum);
                    animation.keyTimes = @[@(0.0f), @(0.4f), @(0.6f), @(1.0f)];
                    animation.timingFunctions = @[
                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                    ];
                    animation.values = @[
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]
                    ];
                    [self.layer addSublayer:square];
                    [square addAnimation:animation forKey:@"square"];
                }
            }
        }
    }
}

@end

/*--------------------------------------------------*/
