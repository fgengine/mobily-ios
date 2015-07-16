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

#include <MobilyCore/MobilyCG.h>

/*--------------------------------------------------*/

#include <math.h>

/*--------------------------------------------------*/

@implementation NSString (MobilyCG)

- (CGPoint)convertToPoint {
    return [self convertToPointSeparated:@";"];
}

- (CGPoint)convertToPointSeparated:(NSString*)separated {
    CGPoint result = CGPointZero;
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch(array.count) {
        case 1: {
            result.x = [[formatter numberFromString:array[0]] floatValue];
            result.y = result.x;
            break;
        }
        case 2: {
            result.x = [[formatter numberFromString:array[0]] floatValue];
            result.y = [[formatter numberFromString:array[1]] floatValue];
            break;
        }
        default:
            break;
    }
    return result;
}

- (CGSize)convertToSize {
    return [self convertToSizeSeparated:@";"];
}

- (CGSize)convertToSizeSeparated:(NSString*)separated {
    CGSize result = CGSizeZero;
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch(array.count) {
        case 1: {
            result.width = [[formatter numberFromString:array[0]] floatValue];
            result.height = result.width;
            break;
        }
        case 2: {
            result.width = [[formatter numberFromString:array[0]] floatValue];
            result.height = [[formatter numberFromString:array[1]] floatValue];
            break;
        }
        default:
            break;
    }
    return result;
}

- (CGRect)convertToRect {
    return [self convertToRectSeparated:@";"];
}

- (CGRect)convertToRectSeparated:(NSString*)separated {
    CGRect result = CGRectZero;
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch(array.count) {
        case 1: {
            result.size.width = [[formatter numberFromString:array[0]] floatValue];
            result.size.height = result.size.width;
            break;
        }
        case 2: {
            result.size.width = [[formatter numberFromString:array[0]] floatValue];
            result.size.height = [[formatter numberFromString:array[1]] floatValue];
            break;
        }
        case 3: {
            result.origin.x = [[formatter numberFromString:array[0]] floatValue];
            result.origin.y = [[formatter numberFromString:array[1]] floatValue];
            result.size.width = [[formatter numberFromString:array[2]] floatValue];
            result.size.height = result.size.width;
            break;
        }
        case 4: {
            result.origin.x = [[formatter numberFromString:array[0]] floatValue];
            result.origin.y = [[formatter numberFromString:array[1]] floatValue];
            result.size.width = [[formatter numberFromString:array[2]] floatValue];
            result.size.height = [[formatter numberFromString:array[3]] floatValue];
            break;
        }
        default:
            break;
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGFloat MobilyFloatNearestMore(CGFloat value, CGFloat step) {
    CGFloat result = step;
    while(result < value) {
        result += step;
    }
    return result;
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

const CGPoint MobilyPointInfinity = { INFINITY, INFINITY };

bool MobilyPointIsInfinity(CGPoint point) {
    return CGPointEqualToPoint(point, MobilyPointInfinity);
}

CGPoint MobilyPointAdd(CGPoint point, CGFloat value) {
    return CGPointMake(point.x + value, point.y + value);
}

CGPoint MobilyPointSub(CGPoint point, CGFloat value) {
    return CGPointMake(point.x - value, point.y - value);
}

CGPoint MobilyPointMul(CGPoint point, CGFloat value) {
    return CGPointMake(point.x * value, point.y * value);
}

CGPoint MobilyPointDiv(CGPoint point, CGFloat value) {
    return CGPointMake(point.x / value, point.y / value);
}

CGPoint MobilyPointAddPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint MobilyPointSubPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

CGPoint MobilyPointMulPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x * point2.x, point1.y * point2.y);
}

CGPoint MobilyPointDivPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x / point2.x, point1.y / point2.y);
}

CGPoint MobilyPointRotateAroundPoint(CGPoint point, CGPoint pivot, CGFloat angle) {
    point = CGPointApplyAffineTransform(point, CGAffineTransformMakeTranslation(-pivot.x, -pivot.y));
    point = CGPointApplyAffineTransform(point, CGAffineTransformMakeRotation(angle));
    point = CGPointApplyAffineTransform(point, CGAffineTransformMakeTranslation(pivot.x, pivot.y));
    return point;
}

CGFloat MobilyPointDistance(CGPoint p1, CGPoint p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGSize MobilySizeNearestMore(CGSize size, CGFloat step) {
    return CGSizeMake(MobilyFloatNearestMore(size.width, step), MobilyFloatNearestMore(size.height, step));
}

CGSize MobilySizeAdd(CGSize size, CGFloat value) {
    return CGSizeMake(size.width + value, size.height + value);
}

CGSize MobilySizeSub(CGSize size, CGFloat value) {
    return CGSizeMake(size.width - value, size.height - value);
}

CGSize MobilySizeMul(CGSize size, CGFloat value) {
    return CGSizeMake(size.width * value, size.height * value);
}

CGSize MobilySizeDiv(CGSize size, CGFloat value) {
    return CGSizeMake(size.width / value, size.height / value);
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGRect MobilyRectMakeOriginAndSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect MobilyRectMakeCenterPoint(CGPoint center, CGFloat width, CGFloat height) {
    return CGRectMake(center.x - (width * 0.5f), center.y - (height * 0.5f), width, height);
}

CGRect MobilyRectAdd(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x + value, rect.origin.y + value, rect.size.width + value, rect.size.height + value);
}

CGRect MobilyRectSub(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x - value, rect.origin.y - value, rect.size.width - value, rect.size.height - value);
}

CGRect MobilyRectMul(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x * value, rect.origin.y * value, rect.size.width * value, rect.size.height * value);
}

CGRect MobilyRectDiv(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x / value, rect.origin.y / value, rect.size.width / value, rect.size.height / value);
}

CGRect MobilyRectLerp(CGRect rect1, CGRect rect2, CGFloat t) {
    return CGRectMake(
        ((1.0f - t) * rect1.origin.x) + (t * rect2.origin.x),
        ((1.0f - t) * rect1.origin.y) + (t * rect2.origin.y),
        ((1.0f - t) * rect1.size.width) + (t * rect2.size.width),
        ((1.0f - t) * rect1.size.height) + (t * rect2.size.height)
    );
}

CGRect MobilyRectAspectFillFromBoundsAndSize(CGRect bounds, CGSize size) {
    CGFloat iw = floorf(size.width);
    CGFloat ih = floorf(size.height);
    CGFloat bw = floorf(bounds.size.width);
    CGFloat bh = floorf(bounds.size.height);
    CGFloat fw = bw / iw;
    CGFloat fh = bh / ih;
    CGFloat scale = (fw > fh) ? fw : fh;
    CGFloat rw = iw * scale;
    CGFloat rh = ih * scale;
    CGFloat rx = (bw - rw) * 0.5f;
    CGFloat ry = (bh - rh) * 0.5f;
    return CGRectMake(bounds.origin.x + rx, bounds.origin.y + ry, rw, rh);
}

CGRect MobilyRectAspectFitFromBoundsAndSize(CGRect bounds, CGSize size) {
    CGFloat iw = floorf(size.width);
    CGFloat ih = floorf(size.height);
    CGFloat bw = floorf(bounds.size.width);
    CGFloat bh = floorf(bounds.size.height);
    CGFloat fw = bw / iw;
    CGFloat fh = bh / ih;
    CGFloat scale = (fw < fh) ? fw : fh;
    CGFloat rw = iw * scale;
    CGFloat rh = ih * scale;
    CGFloat rx = (bw - rw) * 0.5f;
    CGFloat ry = (bh - rh) * 0.5f;
    return CGRectMake(bounds.origin.x + rx, bounds.origin.y + ry, rw, rh);
}

CGRect MobilyRectScaleAroundPoint(CGRect rect, CGPoint point, CGFloat sx, CGFloat sy) {
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeTranslation(-point.x, -point.y));
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(sx, sy));
    rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeTranslation(point.x, point.y));
    return rect;
}

CGPoint MobilyRectGetTopLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
}

CGPoint MobilyRectGetTopCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
}

CGPoint MobilyRectGetTopRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CGPoint MobilyRectGetLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
}

CGPoint MobilyRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint MobilyRectGetRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
}

CGPoint MobilyRectGetBottomLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CGPoint MobilyRectGetBottomCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
}

CGPoint MobilyRectGetBottomRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

MobilyLineSegment MobilyLineSegmentMake(CGPoint start, CGPoint end) {
    return (MobilyLineSegment){ start, end };
}

MobilyLineSegment MobilyLineSegmentRotateAroundPoint(MobilyLineSegment line, CGPoint pivot, CGFloat angle) {
    return MobilyLineSegmentMake(MobilyPointRotateAroundPoint(line.start, pivot, angle), MobilyPointRotateAroundPoint(line.end, pivot, angle));
}

CGPoint MobilyLineSegmentIntersection(MobilyLineSegment ls1, MobilyLineSegment ls2) {
    CGFloat x1 = ls1.start.x, y1 = ls1.start.y;
    CGFloat x2 = ls1.end.x, y2 = ls1.end.y;
    CGFloat x3 = ls2.start.x, y3 = ls2.start.y;
    CGFloat x4 = ls2.end.x, y4 = ls2.end.y;
    CGFloat numeratorA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
    CGFloat numeratorB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
    CGFloat denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
    if((fabs(numeratorA) < MOBILY_EPSILON) && (fabs(numeratorB) < MOBILY_EPSILON) && (fabs(denominator) < MOBILY_EPSILON)) {
        return CGPointMake((x1 + x2) * 0.5, (y1 + y2) * 0.5);
    }
    if(fabs(denominator) < MOBILY_EPSILON) {
        return MobilyPointInfinity;
    }
    CGFloat uA = numeratorA / denominator;
    CGFloat uB = numeratorB / denominator;
    if((uA < 0) || (uA > 1) || (uB < 0) || (uB > 1)) {
        return MobilyPointInfinity;
    }
    return CGPointMake(x1 + uA * (x2 - x1), y1 + uA * (y2 - y1));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/
