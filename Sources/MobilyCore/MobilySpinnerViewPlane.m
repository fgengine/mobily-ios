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

@implementation MobilySpinnerViewPlane

- (void)prepareAnimation {
    [super prepareAnimation];
    
    CALayer* plane = [CALayer layer];
    plane.frame = CGRectInset(CGRectMake(0.0f, 0.0f, self.size, self.size), 2.0f, 2.0f);
    plane.backgroundColor = self.color.CGColor;
    plane.anchorPoint = CGPointMake(0.5f, 0.5f);
    plane.anchorPointZ = 0.5f;
    plane.shouldRasterize = YES;
    plane.rasterizationScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:plane];

    CAKeyframeAnimation* planeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    planeAnimation.removedOnCompletion = NO;
    planeAnimation.repeatCount = HUGE_VALF;
    planeAnimation.duration = 1.2;
    planeAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
    planeAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
    ];
    planeAnimation.values = @[
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, 0.0f, 0.0f, 0.0f, 0.0f)],
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, M_PI, 0.0f, 1.0f, 0.0f)],
        [NSValue valueWithCATransform3D:MobilyTransform3DRotationWithPerspective(1.0f / 120.0f, M_PI, 0.0f, 0.0f, 1.0f)]
    ];
    [plane addAnimation:planeAnimation forKey:@"plane"];
}

@end

/*--------------------------------------------------*/

