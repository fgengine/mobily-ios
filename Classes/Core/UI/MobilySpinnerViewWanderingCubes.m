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

@implementation MobilySpinnerViewWanderingCubes

- (void)prepareAnimation {
    NSTimeInterval beginTime = CACurrentMediaTime();
    CGFloat cubeSize = floor(self.size / 3.0f);
    CGFloat widthMinusCubeSize = self.size - cubeSize;
    for(NSInteger i = 0; i < 2; i++) {
        CALayer* cube = [CALayer layer];
        cube.backgroundColor = self.color.CGColor;
        cube.frame = CGRectMake(0.0f, 0.0f, cubeSize, cubeSize);
        cube.anchorPoint = CGPointMake(0.5f, 0.5f);
        cube.rasterizationScale = UIScreen.mainScreen.scale;
        cube.shouldRasterize = YES;
        [self.layer addSublayer:cube];
        
        CAKeyframeAnimation* cubeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        cubeAnimation.removedOnCompletion = NO;
        cubeAnimation.beginTime = beginTime - (i * 0.9f);
        cubeAnimation.duration = 1.8f;
        cubeAnimation.repeatCount = HUGE_VALF;
        cubeAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
        cubeAnimation.keyTimes = @[ @(0.0f), @(0.25f), @(0.50f), @(0.75f), @(1.0f)];

        CATransform3D t0 = CATransform3DIdentity;
        CATransform3D t1 = CATransform3DMakeTranslation(widthMinusCubeSize, 0.0f, 0.0f);
        t1 = CATransform3DRotate(t1, -90.0f * MOBILY_DEG_TO_RAD, 0.0f, 0.0f, 1.0f);
        t1 = CATransform3DScale(t1, 0.5f, 0.5f, 1.0f);
        CATransform3D t2 = CATransform3DMakeTranslation(widthMinusCubeSize, widthMinusCubeSize, 0.0f);
        t2 = CATransform3DRotate(t2, -180.0f * MOBILY_DEG_TO_RAD, 0.0f, 0.0f, 1.0f);
        t2 = CATransform3DScale(t2, 1.0f, 1.0f, 1.0f);
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, widthMinusCubeSize, 0.0f);
        t3 = CATransform3DRotate(t3, -270.0f * MOBILY_DEG_TO_RAD, 0.0f, 0.0f, 1.0f);
        t3 = CATransform3DScale(t3, 0.5f, 0.5f, 1.0f);
        CATransform3D t4 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t4 = CATransform3DRotate(t4, -360.0f * MOBILY_DEG_TO_RAD, 0.0f, 0.0f, 1.0f);
        t4 = CATransform3DScale(t4, 1.0f, 1.0f, 1.0f);
        
        cubeAnimation.values = @[
            [NSValue valueWithCATransform3D:t0],
            [NSValue valueWithCATransform3D:t1],
            [NSValue valueWithCATransform3D:t2],
            [NSValue valueWithCATransform3D:t3],
            [NSValue valueWithCATransform3D:t4]
        ];
        [cube addAnimation:cubeAnimation forKey:@"cube"];
    }
}

@end

/*--------------------------------------------------*/
