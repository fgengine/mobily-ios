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

CGSize CGSizeNearestMore(CGSize size, CGFloat step) {
    return CGSizeMake(CGFloatNearestMore(size.width, step), CGFloatNearestMore(size.height, step));
}

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

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

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/
