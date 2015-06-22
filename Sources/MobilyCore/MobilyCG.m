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

CGFloat CGFloatNearestMore(CGFloat value, CGFloat step) {
    CGFloat result = step;
    while(result < value) {
        result += step;
    }
    return result;
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGPoint CGPointAdd(CGPoint point, CGFloat value) {
    return CGPointMake(point.x + value, point.y + value);
}

CGPoint CGPointSub(CGPoint point, CGFloat value) {
    return CGPointMake(point.x - value, point.y - value);
}

CGPoint CGPointMul(CGPoint point, CGFloat value) {
    return CGPointMake(point.x * value, point.y * value);
}

CGPoint CGPointDiv(CGPoint point, CGFloat value) {
    return CGPointMake(point.x / value, point.y / value);
}

CGPoint CGPointAddPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint CGPointSubPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

CGPoint CGPointMulPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x * point2.x, point1.y * point2.y);
}

CGPoint CGPointDivPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x / point2.x, point1.y / point2.y);
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGSize CGSizeNearestMore(CGSize size, CGFloat step) {
    return CGSizeMake(CGFloatNearestMore(size.width, step), CGFloatNearestMore(size.height, step));
}

CGSize CGSizeAdd(CGSize size, CGFloat value) {
    return CGSizeMake(size.width + value, size.height + value);
}

CGSize CGSizeSub(CGSize size, CGFloat value) {
    return CGSizeMake(size.width - value, size.height - value);
}

CGSize CGSizeMul(CGSize size, CGFloat value) {
    return CGSizeMake(size.width * value, size.height * value);
}

CGSize CGSizeDiv(CGSize size, CGFloat value) {
    return CGSizeMake(size.width / value, size.height / value);
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGRect CGRectMakeOriginAndSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect CGRectMakeCenterPoint(CGPoint center, CGFloat width, CGFloat height) {
    return CGRectMake(center.x - (width * 0.5f), center.y - (height * 0.5f), width, height);
}

CGRect CGRectAdd(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x + value, rect.origin.y + value, rect.size.width + value, rect.size.height + value);
}

CGRect CGRectSub(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x - value, rect.origin.y - value, rect.size.width - value, rect.size.height - value);
}

CGRect CGRectMul(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x * value, rect.origin.y * value, rect.size.width * value, rect.size.height * value);
}

CGRect CGRectDiv(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x / value, rect.origin.y / value, rect.size.width / value, rect.size.height / value);
}

CGRect CGRectLerp(CGRect rect1, CGRect rect2, CGFloat t) {
    return CGRectMake(
        ((1.0f - t) * rect1.origin.x) + (t * rect2.origin.x),
        ((1.0f - t) * rect1.origin.y) + (t * rect2.origin.y),
        ((1.0f - t) * rect1.size.width) + (t * rect2.size.width),
        ((1.0f - t) * rect1.size.height) + (t * rect2.size.height)
    );
}

CGRect CGRectAspectFillFromBoundsAndSize(CGRect bounds, CGSize size) {
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

CGRect CGRectAspectFitFromBoundsAndSize(CGRect bounds, CGSize size) {
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

CGPoint CGRectGetTopLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectGetTopCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectGetTopRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CGPoint CGRectGetLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
}

CGPoint CGRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint CGRectGetRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
}

CGPoint CGRectGetBottomLeftPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CGPoint CGRectGetBottomCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
}

CGPoint CGRectGetBottomRightPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/