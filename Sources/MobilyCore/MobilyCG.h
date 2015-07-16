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
#ifndef MOBILY_CG
#define MOBILY_CG
/*--------------------------------------------------*/

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

/*--------------------------------------------------*/

#include <tgmath.h>

/*--------------------------------------------------*/

typedef struct {
    CGPoint start;
    CGPoint end;
} MobilyLineSegment;

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
#ifdef CGFLOAT_IS_DOUBLE
#   define MOBILY_EPSILON DBL_EPSILON
#else
#   define MOBILY_EPSILON FLT_EPSILON
#endif

/*--------------------------------------------------*/

CGFloat MobilyFloatNearestMore(CGFloat value, CGFloat step);

/*--------------------------------------------------*/

CG_EXTERN const CGPoint MobilyPointInfinity;

bool MobilyPointIsInfinity(CGPoint point);

CGPoint MobilyPointAdd(CGPoint point, CGFloat value);
CGPoint MobilyPointSub(CGPoint point, CGFloat value);
CGPoint MobilyPointMul(CGPoint point, CGFloat value);
CGPoint MobilyPointDiv(CGPoint point, CGFloat value);
CGPoint MobilyPointAddPoint(CGPoint point1, CGPoint point2);
CGPoint MobilyPointSubPoint(CGPoint point1, CGPoint point2);
CGPoint MobilyPointMulPoint(CGPoint point1, CGPoint point2);
CGPoint MobilyPointDivPoint(CGPoint point1, CGPoint point2);

CGPoint MobilyPointRotateAroundPoint(CGPoint point, CGPoint pivot, CGFloat angle);

CGFloat MobilyPointDistance(CGPoint p1, CGPoint p2);

/*--------------------------------------------------*/

CGSize MobilySizeNearestMore(CGSize size, CGFloat step);
CGSize MobilySizeAdd(CGSize size, CGFloat value);
CGSize MobilySizeSub(CGSize size, CGFloat value);
CGSize MobilySizeMul(CGSize size, CGFloat value);
CGSize MobilySizeDiv(CGSize size, CGFloat value);

/*--------------------------------------------------*/

CGRect MobilyRectMakeOriginAndSize(CGPoint origin, CGSize size);
CGRect MobilyRectMakeCenterPoint(CGPoint center, CGFloat width, CGFloat height);

CGRect MobilyRectAdd(CGRect rect, CGFloat value);
CGRect MobilyRectSub(CGRect rect, CGFloat value);
CGRect MobilyRectMul(CGRect rect, CGFloat value);
CGRect MobilyRectDiv(CGRect rect, CGFloat value);
CGRect MobilyRectLerp(CGRect rect1, CGRect rect2, CGFloat t);
CGRect MobilyRectAspectFillFromBoundsAndSize(CGRect bounds, CGSize size);
CGRect MobilyRectAspectFitFromBoundsAndSize(CGRect bounds, CGSize size);

CGRect MobilyRectScaleAroundPoint(CGRect rect, CGPoint point, CGFloat sx, CGFloat sy);

CGPoint MobilyRectGetTopLeftPoint(CGRect rect);
CGPoint MobilyRectGetTopCenterPoint(CGRect rect);
CGPoint MobilyRectGetTopRightPoint(CGRect rect);
CGPoint MobilyRectGetLeftPoint(CGRect rect);
CGPoint MobilyRectGetCenterPoint(CGRect rect);
CGPoint MobilyRectGetRightPoint(CGRect rect);
CGPoint MobilyRectGetBottomLeftPoint(CGRect rect);
CGPoint MobilyRectGetBottomCenterPoint(CGRect rect);
CGPoint MobilyRectGetBottomRightPoint(CGRect rect);

/*--------------------------------------------------*/

MobilyLineSegment MobilyLineSegmentMake(CGPoint start, CGPoint end);
MobilyLineSegment MobilyLineSegmentRotateAroundPoint(MobilyLineSegment line, CGPoint pivot, CGFloat angle);
CGPoint MobilyLineSegmentIntersection(MobilyLineSegment ls1, MobilyLineSegment ls2);

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
