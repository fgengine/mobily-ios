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

#include "MobilyCG.h"

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
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch([array count]) {
        case 1: {
            result.x = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.y = result.x;
            break;
        }
        case 2: {
            result.x = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.y = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
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
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch([array count]) {
        case 1: {
            result.width = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.height = result.width;
            break;
        }
        case 2: {
            result.width = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.height = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
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
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch([array count]) {
        case 1: {
            result.size.width = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.size.height = result.size.width;
            break;
        }
        case 2: {
            result.size.width = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.size.height = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
            break;
        }
        case 3: {
            result.origin.x = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.origin.y = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
            result.size.width = [[formatter numberFromString:[array objectAtIndex:2]] floatValue];
            result.size.height = result.size.width;
            break;
        }
        case 4: {
            result.origin.x = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.origin.y = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
            result.size.width = [[formatter numberFromString:[array objectAtIndex:2]] floatValue];
            result.size.height = [[formatter numberFromString:[array objectAtIndex:3]] floatValue];
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

CGPoint CGPointMul(CGPoint point, CGFloat value) {
    return CGPointMake(point.x * value, point.y * value);
}

CGPoint CGPointDiv(CGPoint point, CGFloat value) {
    return CGPointMake(point.x / value, point.y / value);
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

CGSize CGSizeNearestMore(CGSize size, CGFloat step) {
    return CGSizeMake(CGFloatNearestMore(size.width, step), CGFloatNearestMore(size.height, step));
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

CGRect CGRectMul(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x * value, rect.origin.y * value, rect.size.width * value, rect.size.height * value);
}

CGRect CGRectDiv(CGRect rect, CGFloat value) {
    return CGRectMake(rect.origin.x / value, rect.origin.y / value, rect.size.width / value, rect.size.height / value);
}

CGRect CGRectIntersectionExt(CGRect r1, CGRect r2, CGRect* smallRemainder, CGRect* largeRemainder) {
    CGRect intersection = CGRectIntersection(r1, r2);
    if(CGRectIsNull(intersection) == NO) {
        CGFloat r1sx = CGRectGetMinX(r1);
        CGFloat r1sy = CGRectGetMinY(r1);
        CGFloat r1ex = CGRectGetMaxX(r1);
        CGFloat r1ey = CGRectGetMaxY(r1);
        CGFloat r2sx = CGRectGetMinX(r2);
        CGFloat r2sy = CGRectGetMinY(r2);
        CGFloat r2ex = CGRectGetMaxX(r2);
        CGFloat r2ey = CGRectGetMaxY(r2);
        CGFloat dsx = ABS(r1sx - r2sx);
        CGFloat dsy = ABS(r1sy - r2sy);
        CGFloat dex = ABS(r1ex - r2ex);
        CGFloat dey = ABS(r1ey - r2ey);
        if(smallRemainder != NULL) {
            CGFloat sx = (dsx <= dex) ? r1sx : r2ex;
            CGFloat sy = (dsy <= dey) ? r1sy : r2ey;
            CGFloat ex = (dsx >= dex) ? r1ex : r2sx;
            CGFloat ey = (dsy >= dey) ? r1ey : r2sy;
            *smallRemainder = CGRectMake(sx, sy, ex - sx, ey - sy);
        }
        if(largeRemainder != NULL) {
            CGFloat sx = (dsx >= dex) ? r1sx : r2ex;
            CGFloat sy = (dsy >= dey) ? r1sy : r2ey;
            CGFloat ex = (dsx <= dex) ? r1ex : r2sx;
            CGFloat ey = (dsy <= dey) ? r1ey : r2sy;
            *largeRemainder = CGRectMake(sx, sy, ex - sx, ey - sy);
        }
    }
    return intersection;
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

CGPoint CGRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/
