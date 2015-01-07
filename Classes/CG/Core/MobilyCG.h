/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
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
#ifndef MOBILY_CG
#define MOBILY_CG
/*--------------------------------------------------*/
#import <CoreGraphics/CoreGraphics.h>
/*--------------------------------------------------*/

@interface NSString (MobilyCG)

- (CGPoint)convertToPoint;
- (CGPoint)convertToPointSeparated:(NSString*)separated;
- (CGSize)convertToSize;
- (CGSize)convertToSizeSeparated:(NSString*)separated;
- (CGRect)convertToRect;
- (CGRect)convertToRectSeparated:(NSString*)separated;

@end

/*--------------------------------------------------*/

#define MOBILY_DEG_TO_RAD                           0.0174532925f

/*--------------------------------------------------*/

CGFloat CGFloatNearestMore(CGFloat value, CGFloat step);

/*--------------------------------------------------*/

CGPoint CGPointAdd(CGPoint point, CGFloat value);
CGPoint CGPointSub(CGPoint point, CGFloat value);
CGPoint CGPointMul(CGPoint point, CGFloat value);
CGPoint CGPointDiv(CGPoint point, CGFloat value);
CGPoint CGPointAddPoint(CGPoint point1, CGPoint point2);
CGPoint CGPointSubPoint(CGPoint point1, CGPoint point2);
CGPoint CGPointMulPoint(CGPoint point1, CGPoint point2);
CGPoint CGPointDivPoint(CGPoint point1, CGPoint point2);

/*--------------------------------------------------*/

CGSize CGSizeNearestMore(CGSize size, CGFloat step);
CGSize CGSizeAdd(CGSize size, CGFloat value);
CGSize CGSizeSub(CGSize size, CGFloat value);
CGSize CGSizeMul(CGSize size, CGFloat value);
CGSize CGSizeDiv(CGSize size, CGFloat value);

/*--------------------------------------------------*/

CGRect CGRectMakeCenterPoint(CGPoint center, CGFloat width, CGFloat height);

CGRect CGRectAdd(CGRect rect, CGFloat value);
CGRect CGRectSub(CGRect rect, CGFloat value);
CGRect CGRectMul(CGRect rect, CGFloat value);
CGRect CGRectDiv(CGRect rect, CGFloat value);
CGRect CGRectIntersectionExt(CGRect r1, CGRect r2, CGRect* smallRemainder, CGRect* largeRemainder);
CGRect CGRectAspectFillFromBoundsAndSize(CGRect bounds, CGSize size);
CGRect CGRectAspectFitFromBoundsAndSize(CGRect bounds, CGSize size);

CGPoint CGRectGetTopLeftPoint(CGRect rect);
CGPoint CGRectGetTopCenterPoint(CGRect rect);
CGPoint CGRectGetTopRightPoint(CGRect rect);
CGPoint CGRectGetLeftPoint(CGRect rect);
CGPoint CGRectGetCenterPoint(CGRect rect);
CGPoint CGRectGetRightPoint(CGRect rect);
CGPoint CGRectGetBottomLeftPoint(CGRect rect);
CGPoint CGRectGetBottomCenterPoint(CGRect rect);
CGPoint CGRectGetBottomRightPoint(CGRect rect);

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
