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

#import "MobilyUI.h"
#import "MobilyCG.h"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyUI)

- (CGSize)implicitSizeWithFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self implicitSizeWithFont:font forSize:CGSizeMake(NSIntegerMax, NSIntegerMax) lineBreakMode:lineBreakMode];
}

- (CGSize)implicitSizeWithFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self implicitSizeWithFont:font forSize:CGSizeMake(width, NSIntegerMax) lineBreakMode:lineBreakMode];
}

- (CGSize)implicitSizeWithFont:(UIFont*)font forSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if([UIDevice systemVersion] >= 7.0) {
        NSMutableParagraphStyle* paragraphStyle = MOBILY_SAFE_AUTORELEASE([NSMutableParagraphStyle new]);
        [paragraphStyle setLineBreakMode:lineBreakMode];
        NSDictionary* attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle };
        CGRect textRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if(textRect.size.height < [font lineHeight]) {
            textRect.size.height = [font lineHeight];
        }
        return CGSizeMake(floorf(textRect.size.width), floorf(textRect.size.height));
    }
#endif
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    if(size.height < [font lineHeight]) {
        size.height = [font lineHeight];
    }
#pragma clang diagnostic pop
    return CGSizeMake(floorf(size.width), floorf(size.height));
}

- (UIEdgeInsets)convertToEdgeInsets {
    return [self convertToEdgeInsetsSeparated:@";"];
}

- (UIEdgeInsets)convertToEdgeInsetsSeparated:(NSString*)separated {
    UIEdgeInsets result = UIEdgeInsetsZero;
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch([array count]) {
        case 1: {
            result.top = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.left = result.bottom = result.right = result.top;
            break;
        }
        case 2: {
            result.top = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.left = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
            result.bottom = result.top;
            result.right = result.left;
            break;
        }
        case 4: {
            result.top = [[formatter numberFromString:[array objectAtIndex:0]] floatValue];
            result.left = [[formatter numberFromString:[array objectAtIndex:1]] floatValue];
            result.bottom = [[formatter numberFromString:[array objectAtIndex:2]] floatValue];
            result.right = [[formatter numberFromString:[array objectAtIndex:3]] floatValue];
            break;
        }
        default:
            break;
    }
    return result;
}

- (UIBezierPath*)convertToBezierPath {
    return [self convertToBezierPathSeparated:@";"];
}

- (UIBezierPath*)convertToBezierPathSeparated:(NSString*)separated {
    return nil;
}

- (UIFont*)convertToFont {
    return [self convertToFontSeparated:@";"];
}

- (UIFont*)convertToFontSeparated:(NSString*)separated {
    UIFont* result = nil;
    NSArray* array = [self componentsSeparatedByString:separated];
    if([array count] > 0) {
        static NSNumberFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        switch([array count]) {
            case 1: {
                result = [UIFont fontWithName:[array objectAtIndex:0] size:[UIFont systemFontSize]];
                break;
            }
            case 2: {
                result = [UIFont fontWithName:[array objectAtIndex:0] size:[[formatter numberFromString:[array objectAtIndex:1]] floatValue]];
                break;
            }
            default:
                break;
        }
    }
    return result;
}

- (UIImage*)convertToImage {
    return [self convertToImageSeparated:@";" edgeInsetsSeparated:@";"];
}

- (UIImage*)convertToImageSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated {
    UIImage* result = nil;
    NSArray* array = [self componentsSeparatedByString:separated];
    switch([array count]) {
        case 1: {
            result = [UIImage imageNamed:self];
            break;
        }
        default:{
            NSString* pattern = [NSString stringWithFormat:@"([A-Za-z0-9-_]+)[%@]+\\[([0-9%@ ]*)\\]", separated, edgeInsetsSeparated];
            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
            NSArray* matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
            if([matches count] > 0) {
                NSTextCheckingResult* match = [matches objectAtIndex:0];
                if([match numberOfRanges] == 3) {
                    NSString* imageName = [self substringWithRange:[match rangeAtIndex:1]];
                    result = [UIImage imageNamed:imageName];
                    if(result != nil) {
                        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
                        NSString* imageInsets = [self substringWithRange:[match rangeAtIndex:2]];
                        if(imageInsets != nil) {
                            [imageInsets convertToEdgeInsetsSeparated:edgeInsetsSeparated];
                        }
                        result = [result resizableImageWithCapInsets:edgeInsets];
                    }
                }
            }
            break;
        }
    }
    return result;
}

- (NSArray*)convertToImages {
    return [self convertToImagesSeparated:@";" edgeInsetsSeparated:@";" frameSeparated:@"|"];
}

- (NSArray*)convertToImagesSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated frameSeparated:(NSString*)frameSeparated {
    NSMutableArray* result = [NSMutableArray array];
    NSArray* array = [self componentsSeparatedByString:frameSeparated];
    if([array count] > 0) {
        [array enumerateObjectsUsingBlock:^(NSString* frame, NSUInteger index, BOOL* stop) {
            UIImage* image = [frame convertToImageSeparated:separated edgeInsetsSeparated:edgeInsetsSeparated];
            if(image != nil) {
                [result addObject:image];
            }
        }];
    }
    return result;
}

- (UIRemoteNotificationType)convertToRemoteNotificationType {
    return [self convertToRemoteNotificationTypeSeparated:@"|"];
}

- (UIRemoteNotificationType)convertToRemoteNotificationTypeSeparated:(NSString*)separated {
    __block UIRemoteNotificationType result = UIRemoteNotificationTypeNone;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        [keys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger index, BOOL* stop) {
            NSString* temp = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([temp isEqualToString:@"badge"] == YES) {
                result |= UIRemoteNotificationTypeBadge;
            } else if([temp isEqualToString:@"sound"] == YES) {
                result |= UIRemoteNotificationTypeSound;
            } else if([temp isEqualToString:@"alert"] == YES) {
                result |= UIRemoteNotificationTypeAlert;
            } else if([temp isEqualToString:@"news-stand"] == YES) {
                result |= UIRemoteNotificationTypeNewsstandContentAvailability;
            }
        }];
    }
    return result;
}

- (UIInterfaceOrientationMask)convertToInterfaceOrientationMask {
    return [self convertToInterfaceOrientationMaskSeparated:@"|"];
}

- (UIInterfaceOrientationMask)convertToInterfaceOrientationMaskSeparated:(NSString*)separated {
    __block UIInterfaceOrientationMask result = 0;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIInterfaceOrientationMaskAll;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        [keys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger index, BOOL* stop) {
            NSString* temp = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([temp isEqualToString:@"portrait"] == YES) {
                result |= UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
            } else if([temp isEqualToString:@"landscape"] == YES) {
                result |= UIInterfaceOrientationMaskLandscape;
            } else if([temp isEqualToString:@"portrait-down"] == YES) {
                result |= UIInterfaceOrientationMaskPortrait;
            } else if([temp isEqualToString:@"portrait-up"] == YES) {
                result |= UIInterfaceOrientationMaskPortraitUpsideDown;
            } else if([temp isEqualToString:@"landscape-left"] == YES) {
                result |= UIInterfaceOrientationMaskLandscapeLeft;
            } else if([temp isEqualToString:@"landscape-right"] == YES) {
                result |= UIInterfaceOrientationMaskLandscapeRight;
            }
        }];
    }
    return result;
}

- (UIStatusBarStyle)convertToStatusBarStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIStatusBarStyleDefault;
    } else if([temp isEqualToString:@"light-content"] == YES) {
        return UIStatusBarStyleLightContent;
    } else if([temp isEqualToString:@"black-opaque"] == YES) {
        return UIStatusBarStyleBlackTranslucent;
    } else if([temp isEqualToString:@"black-opaque"] == YES) {
        return UIStatusBarStyleBlackOpaque;
    }
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)convertToStatusBarAnimation {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"fade"] == YES) {
        return UIStatusBarAnimationFade;
    } else if([temp isEqualToString:@"slide"] == YES) {
        return UIStatusBarAnimationSlide;
    }
    return UIStatusBarAnimationNone;
}

- (UIViewAutoresizing)convertToViewAutoresizing {
    return [self convertToViewAutoresizingSeparated:@"|"];
}

- (UIViewAutoresizing)convertToViewAutoresizingSeparated:(NSString*)separated {
    __block UIViewAutoresizing result = UIViewAutoresizingNone;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        [keys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger index, BOOL* stop) {
            NSString* temp = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([temp isEqualToString:@"size"] == YES) {
                result |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            } else if([temp isEqualToString:@"width"] == YES) {
                result |= UIViewAutoresizingFlexibleWidth;
            } else if([temp isEqualToString:@"height"] == YES) {
                result |= UIViewAutoresizingFlexibleHeight;
            } else if([temp isEqualToString:@"top"] == YES) {
                result |= UIViewAutoresizingFlexibleBottomMargin;
            } else if([temp isEqualToString:@"bottom"] == YES) {
                result |= UIViewAutoresizingFlexibleTopMargin;
            } else if([temp isEqualToString:@"left"] == YES) {
                result |= UIViewAutoresizingFlexibleRightMargin;
            } else if([temp isEqualToString:@"right"] == YES) {
                result |= UIViewAutoresizingFlexibleLeftMargin;
            }
        }];
    }
    return result;
}

- (UIViewContentMode)convertToViewContentMode {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"stretch"] == YES) {
        return UIViewContentModeScaleToFill;
    } else if([temp isEqualToString:@"aspect-fill"] == YES) {
        return UIViewContentModeScaleAspectFill;
    } else if([temp isEqualToString:@"aspect-fit"] == YES) {
        return UIViewContentModeScaleAspectFit;
    } else if([temp isEqualToString:@"center"] == YES) {
        return UIViewContentModeCenter;
    } else if([temp isEqualToString:@"center"] == YES) {
        return UIViewContentModeCenter;
    } else if([temp isEqualToString:@"left"] == YES) {
        return UIViewContentModeLeft;
    } else if([temp isEqualToString:@"right"] == YES) {
        return UIViewContentModeRight;
    } else if([temp isEqualToString:@"top"] == YES) {
        return UIViewContentModeTop;
    } else if([temp isEqualToString:@"top-left"] == YES) {
        return UIViewContentModeTopLeft;
    } else if([temp isEqualToString:@"top-right"] == YES) {
        return UIViewContentModeTopRight;
    } else if([temp isEqualToString:@"bottom"] == YES) {
        return UIViewContentModeBottom;
    } else if([temp isEqualToString:@"bottom-left"] == YES) {
        return UIViewContentModeBottomLeft;
    } else if([temp isEqualToString:@"bottom-right"] == YES) {
        return UIViewContentModeBottomRight;
    }
    return UIViewContentModeScaleToFill;
}

- (UIControlContentHorizontalAlignment)convertToControlContentHorizontalAlignment {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"center"] == YES) {
        return UIControlContentHorizontalAlignmentCenter;
    } else if([temp isEqualToString:@"left"] == YES) {
        return UIControlContentHorizontalAlignmentLeft;
    } else if([temp isEqualToString:@"right"] == YES) {
        return UIControlContentHorizontalAlignmentRight;
    } else if([temp isEqualToString:@"fill"] == YES) {
        return UIControlContentHorizontalAlignmentFill;
    }
    return UIControlContentHorizontalAlignmentCenter;
}

- (UIControlContentVerticalAlignment)convertToControlContentVerticalAlignment {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"center"] == YES) {
        return UIControlContentVerticalAlignmentCenter;
    } else if([temp isEqualToString:@"top"] == YES) {
        return UIControlContentVerticalAlignmentTop;
    } else if([temp isEqualToString:@"bottom"] == YES) {
        return UIControlContentVerticalAlignmentBottom;
    } else if([temp isEqualToString:@"fill"] == YES) {
        return UIControlContentVerticalAlignmentFill;
    }
    return UIControlContentVerticalAlignmentCenter;
}

- (UITextAutocapitalizationType)convertToTextAutocapitalizationType {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"none"] == YES) {
        return UITextAutocapitalizationTypeNone;
    } else if([temp isEqualToString:@"words"] == YES) {
        return UITextAutocapitalizationTypeWords;
    } else if([temp isEqualToString:@"sentences"] == YES) {
        return UITextAutocapitalizationTypeSentences;
    } else if([temp isEqualToString:@"all"] == YES) {
        return UITextAutocapitalizationTypeAllCharacters;
    }
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)convertToTextAutocorrectionType {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UITextAutocorrectionTypeDefault;
    } else if([temp isEqualToString:@"yes"] == YES) {
        return UITextAutocorrectionTypeYes;
    } else if([temp isEqualToString:@"no"] == YES) {
        return UITextAutocorrectionTypeNo;
    }
    return UITextAutocorrectionTypeDefault;
}

- (UITextSpellCheckingType)convertToTestSpellCheckingType {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UITextSpellCheckingTypeDefault;
    } else if([temp isEqualToString:@"yes"] == YES) {
        return UITextSpellCheckingTypeYes;
    } else if([temp isEqualToString:@"no"] == YES) {
        return UITextSpellCheckingTypeNo;
    }
    return UITextSpellCheckingTypeDefault;
}

- (UIKeyboardType)convertToKeyboardType {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIKeyboardTypeDefault;
    } else if([temp isEqualToString:@"ascii"] == YES) {
        return UIKeyboardTypeASCIICapable;
    } else if([temp isEqualToString:@"url"] == YES) {
        return UIKeyboardTypeURL;
    } else if([temp isEqualToString:@"number"] == YES) {
        return UIKeyboardTypeNumberPad;
    } else if([temp isEqualToString:@"number-punctuation"] == YES) {
        return UIKeyboardTypeNumbersAndPunctuation;
    } else if([temp isEqualToString:@"phone"] == YES) {
        return UIKeyboardTypePhonePad;
    } else if([temp isEqualToString:@"name-phone"] == YES) {
        return UIKeyboardTypeNamePhonePad;
    } else if([temp isEqualToString:@"email-address"] == YES) {
        return UIKeyboardTypeEmailAddress;
    } else if([temp isEqualToString:@"decimal"] == YES) {
        return UIKeyboardTypeDecimalPad;
    } else if([temp isEqualToString:@"twitter"] == YES) {
        return UIKeyboardTypeTwitter;
    } else if([temp isEqualToString:@"web-search"] == YES) {
        return UIKeyboardTypeWebSearch;
    }
    return UIKeyboardTypeDefault;
}

- (UIReturnKeyType)convertToReturnKeyType {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIReturnKeyDefault;
    } else if([temp isEqualToString:@"go"] == YES) {
        return UIReturnKeyGo;
    } else if([temp isEqualToString:@"google"] == YES) {
        return UIReturnKeyGoogle;
    } else if([temp isEqualToString:@"join"] == YES) {
        return UIReturnKeyJoin;
    } else if([temp isEqualToString:@"next"] == YES) {
        return UIReturnKeyNext;
    } else if([temp isEqualToString:@"route"] == YES) {
        return UIReturnKeyRoute;
    } else if([temp isEqualToString:@"search"] == YES) {
        return UIReturnKeySearch;
    } else if([temp isEqualToString:@"send"] == YES) {
        return UIReturnKeySend;
    } else if([temp isEqualToString:@"yahoo"] == YES) {
        return UIReturnKeyYahoo;
    } else if([temp isEqualToString:@"done"] == YES) {
        return UIReturnKeyDone;
    } else if([temp isEqualToString:@"emergency-call"] == YES) {
        return UIReturnKeyEmergencyCall;
    }
    return UIReturnKeyDefault;
}

- (UIBaselineAdjustment)convertToBaselineAdjustment {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"baselines"] == YES) {
        return UIBaselineAdjustmentAlignBaselines;
    } else if([temp isEqualToString:@"centers"] == YES) {
        return UIBaselineAdjustmentAlignCenters;
    } else if([temp isEqualToString:@"none"] == YES) {
        return UIBaselineAdjustmentNone;
    }
    return UIBaselineAdjustmentAlignBaselines;
}

- (UIScrollViewIndicatorStyle)convertToScrollViewIndicatorStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIScrollViewIndicatorStyleDefault;
    } else if([temp isEqualToString:@"black"] == YES) {
        return UIScrollViewIndicatorStyleBlack;
    } else if([temp isEqualToString:@"white"] == YES) {
        return UIScrollViewIndicatorStyleWhite;
    }
    return UIScrollViewIndicatorStyleDefault;
}

- (UIScrollViewKeyboardDismissMode)convertToScrollViewKeyboardDismissMode {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"none"] == YES) {
        return UIScrollViewKeyboardDismissModeNone;
    } else if([temp isEqualToString:@"drag"] == YES) {
        return UIScrollViewKeyboardDismissModeOnDrag;
    } else if([temp isEqualToString:@"interactive"] == YES) {
        return UIScrollViewKeyboardDismissModeInteractive;
    }
    return UIScrollViewKeyboardDismissModeNone;
}

- (UIBarStyle)convertToBarStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIBarStyleDefault;
    } else if([temp isEqualToString:@"black"] == YES) {
        return UIBarStyleBlack;
    } else if([temp isEqualToString:@"black-opaque"] == YES) {
        return UIBarStyleBlackOpaque;
    } else if([temp isEqualToString:@"black-translucent"] == YES) {
        return UIBarStyleBlackTranslucent;
    }
    return UIBarStyleDefault;
}

- (UITabBarItemPositioning)convertToTabBarItemPositioning {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"automatic"] == YES) {
        return UITabBarItemPositioningAutomatic;
    } else if([temp isEqualToString:@"fill"] == YES) {
        return UITabBarItemPositioningFill;
    } else if([temp isEqualToString:@"centered"] == YES) {
        return UITabBarItemPositioningCentered;
    }
    return UITabBarItemPositioningAutomatic;
}

- (UISearchBarStyle)convertToSearchBarStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UISearchBarStyleDefault;
    } else if([temp isEqualToString:@"minimal"] == YES) {
        return UISearchBarStyleMinimal;
    } else if([temp isEqualToString:@"prominent"] == YES) {
        return UISearchBarStyleProminent;
    }
    return UISearchBarStyleDefault;
}

- (UIProgressViewStyle)convertToProgressViewStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIProgressViewStyleDefault;
    } else if([temp isEqualToString:@"bar"] == YES) {
        return UIProgressViewStyleBar;
    }
    return UIProgressViewStyleDefault;
}

- (UITextBorderStyle)convertToTextBorderStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"none"] == YES) {
        return UITextBorderStyleNone;
    } else if([temp isEqualToString:@"line"] == YES) {
        return UITextBorderStyleLine;
    } else if([temp isEqualToString:@"bezer"] == YES) {
        return UITextBorderStyleBezel;
    } else if([temp isEqualToString:@"rounded"] == YES) {
        return UITextBorderStyleRoundedRect;
    }
    return UITextBorderStyleNone;
}

@end

/*--------------------------------------------------*/

BOOL MobilyColorHSBEqualToColorHSB(MobilyColorHSB color1, MobilyColorHSB color2) {
    if((color1.hue == color2.hue) && (color1.saturation == color2.saturation) && (color1.brightness == color2.brightness)) {
        return YES;
    }
    return NO;
}

/*--------------------------------------------------*/

@implementation UIColor (MobilyUI)

+ (UIColor*)colorWithString:(NSString*)string {
    UIColor* result = nil;
    NSRange range = [string rangeOfString:@"#"];
    if((range.location != NSNotFound) && (range.length > 0)) {
        CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
        NSString* colorString = [[string stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        switch ([colorString length]) {
            case 6: // #RRGGBB
                red = [self colorComponentFromString:colorString start:0 length:2];
                green = [self colorComponentFromString:colorString start:2 length:2];
                blue = [self colorComponentFromString:colorString start:4 length:2];
                break;
            case 8: // #RRGGBBAA
                red = [self colorComponentFromString:colorString start:0 length:2];
                green = [self colorComponentFromString:colorString start:2 length:2];
                blue = [self colorComponentFromString:colorString start:4 length:2];
                alpha = [self colorComponentFromString:colorString start:6 length:2];
                break;
        }
        result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return result;
}

+ (CGFloat)colorComponentFromString:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length {
    unsigned result = 0;
    NSString* part = [string substringWithRange:NSMakeRange(start, length)];
    if(part != nil) {
        NSScanner* scaner = [NSScanner scannerWithString:part];
        if(scaner != nil) {
            [scaner scanHexInt:&result];
        }
    }
    return ((CGFloat)result / 255.0f);
}

- (MobilyColorHSB)hsb {
    MobilyColorHSB hsb;
    hsb.hue = 0.0f;
    hsb.saturation = 0.0f;
    hsb.brightness = 0.0f;
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor]));
    if((model == kCGColorSpaceModelMonochrome) || (model == kCGColorSpaceModelRGB)) {
        const CGFloat* c = CGColorGetComponents([self CGColor]);
        CGFloat x = fminf(fminf(c[0], c[1]), c[2]);
        CGFloat b = fmaxf(fmaxf(c[0], c[1]), c[2]);
        if(b == x) {
            hsb.hue = 0.0f;
            hsb.saturation = 0.0f;
            hsb.brightness = b;
        } else {
            CGFloat f = (c[0] == x) ? c[1] - c[2] : ((c[1] == x) ? c[2] - c[0] : c[0] - c[1]);
            NSInteger i = (c[0] == x) ? 3 : ((c[1] == x) ? 5 : 1);
            hsb.hue = ((i - f /(b - x)) / 6.0f);
            hsb.saturation = (b - x)/b;
            hsb.brightness = b;
        }
    }
    return hsb;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIImage (MobilyUI)

+ (UIImage*)imageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets {
    UIImage* result = [self imageNamed:name];
    if(result != nil) {
        result = [result resizableImageWithCapInsets:capInsets];
    }
    return result;
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIImage* result = nil;
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    if(colourSpace != NULL) {
        CGRect drawRect = CGRectAspectFitFromBoundsAndSize(CGRectMake(0.0f, 0.0f, size.width, size.height), [self size]);
        drawRect.size.width = floorf(drawRect.size.width);
        drawRect.size.height = floorf(drawRect.size.height);
        
        CGContextRef context = CGBitmapContextCreate(NULL, drawRect.size.width, drawRect.size.height, 8, drawRect.size.width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
        if(context != NULL) {
            CGContextClearRect(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height));
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height), [self CGImage]);
            
            CGImageRef image = CGBitmapContextCreateImage(context);
            if(image != NULL) {
                result = [UIImage imageWithCGImage:image scale:[self scale] orientation:[self imageOrientation]];
                CGImageRelease(image);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colourSpace);
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINib (MobilyUI)

+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class {
    return [self viewWithNibName:nibName withClass:class withOwner:nil];
}

+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class withOwner:(id)owner {
    UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
    if(nib != nil) {
        return [nib instantiateWithClass:class owner:owner options:nil];
    }
    return nil;
}

+ (UINib*)nibWithBaseName:(NSString*)baseName bundle:(NSBundle*)bundle {
    if(bundle == nil) {
        bundle = [NSBundle mainBundle];
    }
    NSString* nib = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([UIDevice isIPhone] == YES) {
        NSString* iPhoneName = [NSString stringWithFormat:@"%@%@", baseName, @"-iPhone"];
        if([fileManager fileExistsAtPath:[bundle pathForResource:iPhoneName ofType:nil]] == YES) {
            nib = iPhoneName;
        }
    } else if([UIDevice isIPad] == YES) {
        NSString* iPadName = [NSString stringWithFormat:@"%@%@", baseName, @"-iPad"];
        if([fileManager fileExistsAtPath:[bundle pathForResource:iPadName ofType:nil]] == YES) {
            nib = iPadName;
        }
    }
    if(nib == nil) {
        if([fileManager fileExistsAtPath:[bundle pathForResource:baseName ofType:nil]] == YES) {
            nib = baseName;
        }
    }
    if(nib != nil) {
        return [self nibWithNibName:nib bundle:bundle];
    }
    return nil;
}

+ (UINib*)nibWithClass:(Class)class bundle:(NSBundle*)bundle {
    return [self nibWithBaseName:NSStringFromClass(class) bundle:bundle];
}

- (id)instantiateWithClass:(Class)class owner:(id)owner options:(NSDictionary*)options {
    id result = nil;
    NSArray* content = [self instantiateWithOwner:owner options:nil];
    [content enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL* stop) {
        if([item isKindOfClass:class] == YES) {
            item = result;
            *stop = YES;
        }
    }];
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static UIResponder* MOBILY_CURRENT_FIRST_RESPONDER = nil;

/*--------------------------------------------------*/

@implementation UIResponder (MobilyUI)

+ (id)currentFirstResponder {
    MOBILY_CURRENT_FIRST_RESPONDER = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return MOBILY_CURRENT_FIRST_RESPONDER;
}

- (void)findFirstResponder:(id)sender {
    MOBILY_CURRENT_FIRST_RESPONDER = self;
}

+ (UIResponder*)prevResponderFromView:(UIView*)view withSuperview:(UIView*)superview {
    if(superview == nil) {
        return nil;
    }
    NSArray* subviews = [superview subviews];
    NSInteger viewIndex = [subviews indexOfObject:view];
    NSInteger beginIndex = [subviews count] - 1;
    NSInteger endIndex = -1;
    if(viewIndex > 0) {
        if(viewIndex != NSNotFound) {
            beginIndex = viewIndex - 1;
        }
        for(NSInteger i = beginIndex; i > endIndex; i--) {
            UIView* subview = [subviews objectAtIndex:i];
            if([subview canBecomeFirstResponder] == YES) {
                return subview;
            }
        }
    }
    return [self prevResponderFromView:view withSuperview:[superview superview]];
}

+ (UIResponder*)nextResponderFromView:(UIView*)view withSuperview:(UIView*)superview {
    if(superview == nil) {
        return nil;
    }
    NSArray* subviews = [superview subviews];
    NSInteger viewIndex = [subviews indexOfObject:view];
    NSInteger beginIndex = 0;
    NSInteger endIndex = [subviews count];
    if(viewIndex != NSNotFound) {
        beginIndex = viewIndex + 1;
    }
    for(NSInteger i = beginIndex; i < endIndex; i++) {
        UIView* subview = [subviews objectAtIndex:i];
        if([subview canBecomeFirstResponder] == YES) {
            return subview;
        }
    }
    return [self nextResponderFromView:view withSuperview:[superview superview]];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIWindow (MobilyUI)

#pragma mark NSKeyValueCoding

#pragma mark Property

- (UIViewController*)currentViewController {
    UIViewController* viewController = [self rootViewController];
    while([viewController presentedViewController] != nil) {
        viewController = [viewController presentedViewController];
    }
    return viewController;
}

#ifdef __IPHONE_7_0

- (UIViewController*)viewControllerForStatusBarStyle {
    UIViewController* currentViewController = [self currentViewController];
    while([currentViewController childViewControllerForStatusBarStyle] != nil) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController*)viewControllerForStatusBarHidden {
    UIViewController* currentViewController = [self currentViewController];
    while ([currentViewController childViewControllerForStatusBarHidden] != nil) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}

#endif

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIView (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(UserInteractionEnabled)
MOBILY_DEFINE_VALIDATE_RECT(Frame)
MOBILY_DEFINE_VALIDATE_POINT(FramePosition)
MOBILY_DEFINE_VALIDATE_POINT(FrameCenter)
MOBILY_DEFINE_VALIDATE_SIZE(FrameSize)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameSX)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameSY)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameCX)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameCY)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameEX)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameEY)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameWidth)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameHeight)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameLeft)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameRight)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameTop)
MOBILY_DEFINE_VALIDATE_NUMBER(FrameBottom)
MOBILY_DEFINE_VALIDATE_NUMBER(CornerRadius)
MOBILY_DEFINE_VALIDATE_NUMBER(BorderWidth)
MOBILY_DEFINE_VALIDATE_COLOR(BorderColor)
MOBILY_DEFINE_VALIDATE_COLOR(ShadowColor)
MOBILY_DEFINE_VALIDATE_NUMBER(ShadowOpacity);
MOBILY_DEFINE_VALIDATE_SIZE(ShadowOffset);
MOBILY_DEFINE_VALIDATE_NUMBER(ShadowRadius);
MOBILY_DEFINE_VALIDATE_BEZIER_PATH(ShadowPath);
MOBILY_DEFINE_VALIDATE_RECT(Bounds)
MOBILY_DEFINE_VALIDATE_POINT(Center)
MOBILY_DEFINE_VALIDATE_NUMBER(ContentScaleFactor)
MOBILY_DEFINE_VALIDATE_BOOL(MultipleTouchEnabled)
MOBILY_DEFINE_VALIDATE_BOOL(AutoresizesSubviews)
MOBILY_DEFINE_VALIDATE_AUTORESIZING(AutoresizingMask)
MOBILY_DEFINE_VALIDATE_BOOL(ClipsToBounds)
MOBILY_DEFINE_VALIDATE_COLOR(BackgroundColor)
MOBILY_DEFINE_VALIDATE_NUMBER(Alpha)
MOBILY_DEFINE_VALIDATE_BOOL(Opaque)
MOBILY_DEFINE_VALIDATE_BOOL(ClearsContextBeforeDrawing)
MOBILY_DEFINE_VALIDATE_BOOL(Hidden)
MOBILY_DEFINE_VALIDATE_CONTENT_MODE(ContentMode)
MOBILY_DEFINE_VALIDATE_RECT(ContentStretch)
MOBILY_DEFINE_VALIDATE_COLOR(TintColor);

#pragma mark Property

- (void)setFramePosition:(CGPoint)framePosition {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(framePosition.x, framePosition.y, frame.size.width, frame.size.height)];
}

- (CGPoint)framePosition {
    return [self frame].origin;
}

- (void)setFrameCenter:(CGPoint)frameCenter {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frameCenter.x - (frame.size.width * 0.5f), frameCenter.y - (frame.size.height * 0.5f), frame.size.width, frame.size.height)];
}

- (CGPoint)frameCenter {
    CGRect frame = [self frame];
    return CGPointMake(frame.origin.x + (frame.size.width * 0.5f), frame.origin.y + (frame.size.height * 0.5f));
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frameSize.width, frameSize.height)];
}

- (CGSize)frameSize {
    return [self frame].size;
}

- (void)setFrameSX:(CGFloat)frameSX {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frameSX, frame.origin.y, frame.size.width, frame.size.height)];
}

- (CGFloat)frameSX {
    return CGRectGetMinX([self frame]);
}

- (void)setFrameCX:(CGFloat)frameCX {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frameCX - (frame.size.width * 0.5f), frame.origin.y, frame.size.width, frame.size.height)];
}

- (CGFloat)frameCX {
    return CGRectGetMidX([self frame]);
}

- (void)setFrameEX:(CGFloat)frameEX {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frameEX - frame.origin.x, frame.size.height)];
}

- (CGFloat)frameEX {
    return CGRectGetMaxX([self frame]);
}

- (void)setFrameSY:(CGFloat)frameSY {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frameSY, frame.size.width, frame.size.height)];
}

- (CGFloat)frameSY {
    return CGRectGetMinY([self frame]);
}

- (void)setFrameCY:(CGFloat)frameCY {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frameCY - (frame.size.height * 0.5f), frame.size.width, frame.size.height)];
}

- (CGFloat)frameCY {
    return CGRectGetMidY([self frame]);
}

- (void)setFrameEY:(CGFloat)frameEY {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameEY - frame.origin.y)];
}

- (CGFloat)frameEY {
    return CGRectGetMaxY([self frame]);
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frameWidth, frame.size.height)];
}

- (CGFloat)frameWidth {
    return CGRectGetWidth([self frame]);
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight)];
}

- (CGFloat)frameHeight {
    return CGRectGetHeight([self frame]);
}

- (void)setFrameLeft:(CGFloat)frameLeft {
    CGRect frame = [self frame];
    CGFloat offset = frameLeft;
    CGFloat size = frame.size.width - (frameLeft - frame.origin.x);
    [self setFrame:CGRectMake(offset, frame.origin.y, size, frame.size.height)];
}

- (CGFloat)frameLeft {
    CGRect frame = [self frame];
    return frame.origin.x;
}

- (void)setFrameRight:(CGFloat)frameRight {
    CGRect frame = [self frame];
    CGRect bounds = [[self superview] bounds];
    CGFloat offset = frame.origin.x;
    CGFloat size = bounds.size.width - (frame.origin.x + frameRight);
    [self setFrame:CGRectMake(offset, frame.origin.y, size, frame.size.height)];
}

- (CGFloat)frameRight {
    CGRect frame = [self frame];
    CGRect bounds = [[self superview] bounds];
    return bounds.size.width - (frame.origin.x + frame.size.width);
}

- (void)setFrameTop:(CGFloat)frameTop {
    CGRect frame = [self frame];
    CGFloat offset = frameTop;
    CGFloat size = frame.size.height - (frameTop - frame.origin.y);
    [self setFrame:CGRectMake(frame.origin.x, offset, frame.size.width, size)];
}

- (CGFloat)frameTop {
    CGRect frame = [self frame];
    return frame.origin.y;
}

- (void)setFrameBottom:(CGFloat)frameBottom {
    CGRect frame = [self frame];
    CGRect bounds = [[self superview] bounds];
    CGFloat offset = frame.origin.y;
    CGFloat size = bounds.size.height - (frame.origin.y + frameBottom);
    [self setFrame:CGRectMake(frame.origin.x, offset, frame.size.width, size)];
}

- (CGFloat)frameBottom {
    CGRect frame = [self frame];
    CGRect bounds = [[self superview] bounds];
    return bounds.size.height - (frame.origin.y + frame.size.height);
}

- (CGPoint)boundsPosition {
    return [self bounds].origin;
}

- (CGSize)boundsSize {
    return [self bounds].size;
}

- (CGPoint)boundsCenter {
    CGRect bounds = [self bounds];
    return CGPointMake(bounds.origin.x + (bounds.size.width * 0.5f), bounds.origin.y + (bounds.size.height * 0.5f));
}

- (CGFloat)boundsCX {
    return CGRectGetMidX([self bounds]);
}

- (CGFloat)boundsCY {
    return CGRectGetMidY([self bounds]);
}

- (CGFloat)boundsWidth {
    return CGRectGetWidth([self bounds]);
}

- (CGFloat)boundsHeight {
    return CGRectGetHeight([self bounds]);
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [[self layer] setCornerRadius:cornerRadius];
}

- (CGFloat)cornerRadius {
    return [[self layer] cornerRadius];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [[self layer] setBorderWidth:borderWidth];
}

- (CGFloat)borderWidth {
    return [[self layer] borderWidth];
}

- (void)setBorderColor:(UIColor*)borderColor {
    [[self layer] setBorderColor:[borderColor CGColor]];
}

- (UIColor*)borderColor {
    return [UIColor colorWithCGColor:[[self layer] borderColor]];
}

- (void)setShadowColor:(UIColor*)shadowColor {
    [[self layer] setShadowColor:[shadowColor CGColor]];
}

- (UIColor*)shadowColor {
    return [UIColor colorWithCGColor:[[self layer] shadowColor]];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [[self layer] setShadowOpacity:shadowOpacity];
}

- (CGFloat)shadowOpacity {
    return [[self layer] shadowOpacity];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    [[self layer] setShadowOffset:shadowOffset];
}

- (CGSize)shadowOffset {
    return [[self layer] shadowOffset];
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [[self layer] setShadowRadius:shadowRadius];
}

- (CGFloat)shadowRadius {
    return [[self layer] shadowRadius];
}

- (void)setShadowPath:(UIBezierPath*)shadowPath {
    [[self layer] setShadowPath:[shadowPath CGPath]];
}

- (UIBezierPath*)shadowPath {
    return [UIBezierPath bezierPathWithCGPath:[[self layer] shadowPath]];
}

- (void)setSubviews:(NSArray*)subviews {
    [[self subviews] enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
        [view removeFromSuperview];
    }];
    [subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
        [self addSubview:view];
    }];
}

- (void)removeAllSubviews {
    [[self subviews] enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
        [view removeFromSuperview];
    }];
}

- (void)blinkBackgroundColor:(UIColor*)color duration:(NSTimeInterval)duration timeout:(NSTimeInterval)timeout {
    UIColor* prevColor = [self backgroundColor];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self setBackgroundColor:color];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:duration
                                               delay:timeout
                                             options:0
                                          animations:^{
                                              [self setBackgroundColor:prevColor];
                                          }
                                          completion:nil];
                     }];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIScrollView (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_POINT(СontentOffset)
MOBILY_DEFINE_VALIDATE_SIZE(ContentSize)
MOBILY_DEFINE_VALIDATE_EDGE_INSETS(ContentInset)
MOBILY_DEFINE_VALIDATE_BOOL(DirectionalLockEnabled)
MOBILY_DEFINE_VALIDATE_BOOL(Bounces)
MOBILY_DEFINE_VALIDATE_BOOL(AlwaysBounceVertical)
MOBILY_DEFINE_VALIDATE_BOOL(AlwaysBounceHorizontal)
MOBILY_DEFINE_VALIDATE_BOOL(PagingEnabled)
MOBILY_DEFINE_VALIDATE_BOOL(ScrollEnabled)
MOBILY_DEFINE_VALIDATE_BOOL(ShowsHorizontalScrollIndicator)
MOBILY_DEFINE_VALIDATE_BOOL(ShowsVerticalScrollIndicator)
MOBILY_DEFINE_VALIDATE_EDGE_INSETS(ScrollIndicatorInsets)
MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_INDICATOR_STYLE(IndicatorStyle)
MOBILY_DEFINE_VALIDATE_NUMBER(DecelerationRate)
MOBILY_DEFINE_VALIDATE_BOOL(DelaysContentTouches)
MOBILY_DEFINE_VALIDATE_BOOL(CanCancelContentTouches)
MOBILY_DEFINE_VALIDATE_NUMBER(MinimumZoomScale)
MOBILY_DEFINE_VALIDATE_NUMBER(MaximumZoomScale)
MOBILY_DEFINE_VALIDATE_NUMBER(ZoomScale)
MOBILY_DEFINE_VALIDATE_NUMBER(BouncesZoom)
MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_KEYBOARD_DISMISS_MODE(KeyboardDismissMode)

#pragma mark Public

- (CGSize)contentSizeFromSubviews {
    CGRect rect = CGRectZero;
    for(UIView* view in [self subviews]) {
        rect = CGRectUnion(rect, [view frame]);
    }
    return rect.size;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UITabBar (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_COLOR(TintColor)
MOBILY_DEFINE_VALIDATE_COLOR(BarTintColor)
MOBILY_DEFINE_VALIDATE_COLOR(SelectedImageTintColor)
MOBILY_DEFINE_VALIDATE_IMAGE(BackgroundImage)
MOBILY_DEFINE_VALIDATE_IMAGE(SelectionIndicatorImage)
MOBILY_DEFINE_VALIDATE_IMAGE(ShadowImage)
MOBILY_DEFINE_VALIDATE_TAB_BAR_ITEM_POSITIONING(ItemPositioning);
MOBILY_DEFINE_VALIDATE_NUMBER(ItemWidth)
MOBILY_DEFINE_VALIDATE_NUMBER(ItemSpacing)
MOBILY_DEFINE_VALIDATE_BAR_STYLE(BarStyle)
MOBILY_DEFINE_VALIDATE_BOOL(Translucent)
MOBILY_DEFINE_VALIDATE_NUMBER(SelectedItemIndex)

#pragma mark Property

- (void)setSelectedItemIndex:(NSUInteger)index {
    [self setSelectedItem:[[self items] objectAtIndex:index]];
}

- (NSUInteger)selectedItemIndex {
    return [[self items] indexOfObject:[self selectedItem]];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINavigationBar (MobilyUI)

#pragma mark NSKeyValueCoding

#pragma mark Property

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UILabel (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING(Text)
MOBILY_DEFINE_VALIDATE_FONT(Font)
MOBILY_DEFINE_VALIDATE_COLOR(TextColor)
MOBILY_DEFINE_VALIDATE_COLOR(ShadowColor)
MOBILY_DEFINE_VALIDATE_SIZE(ShadowOffset)
MOBILY_DEFINE_VALIDATE_TEXT_ALIGNMENT(TextAlignment)
MOBILY_DEFINE_VALIDATE_LINE_BREAKMODE(LineBreakMode)
MOBILY_DEFINE_VALIDATE_COLOR(HighlightedTextColor)
MOBILY_DEFINE_VALIDATE_BOOL(Highlighted)
MOBILY_DEFINE_VALIDATE_BOOL(Enabled)
MOBILY_DEFINE_VALIDATE_NUMBER(NumberOfLines)
MOBILY_DEFINE_VALIDATE_BOOL(AdjustsFontSizeToFitWidth)
MOBILY_DEFINE_VALIDATE_BOOL(AdjustsLetterSpacingToFitWidth)
MOBILY_DEFINE_VALIDATE_NUMBER(MinimumFontSize)
MOBILY_DEFINE_VALIDATE_BASELINE_ADJUSTMENT(BaselineAdjustment)
MOBILY_DEFINE_VALIDATE_NUMBER(MinimumScaleFactor)
MOBILY_DEFINE_VALIDATE_NUMBER(PreferredMaxLayoutWidth)

#pragma mark Public

- (CGSize)implicitSize {
    return [self implicitSizeForSize:CGSizeMake(NSIntegerMax, NSIntegerMax)];
}

- (CGSize)implicitSizeForWidth:(CGFloat)width {
    return [self implicitSizeForSize:CGSizeMake(width, NSIntegerMax)];
}

- (CGSize)implicitSizeForSize:(CGSize)size {
    return [[self text] implicitSizeWithFont:[self font] forSize:size lineBreakMode:[self lineBreakMode]];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIButton (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_EDGE_INSETS(ContentEdgeInsets)
MOBILY_DEFINE_VALIDATE_EDGE_INSETS(TitleEdgeInsets)
MOBILY_DEFINE_VALIDATE_BOOL(ReversesTitleShadowWhenHighlighted)
MOBILY_DEFINE_VALIDATE_EDGE_INSETS(ImageEdgeInsets)
MOBILY_DEFINE_VALIDATE_BOOL(AdjustsImageWhenHighlighted)
MOBILY_DEFINE_VALIDATE_BOOL(AdjustsImageWhenDisabled)
MOBILY_DEFINE_VALIDATE_BOOL(ShowsTouchWhenHighlighted)
MOBILY_DEFINE_VALIDATE_COLOR(TintColor)

MOBILY_DEFINE_VALIDATE_STRING(NormalTitle)
MOBILY_DEFINE_VALIDATE_COLOR(NormalTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(NormalTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(NormalImage)
MOBILY_DEFINE_VALIDATE_IMAGE(NormalBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(HighlightedTitle)
MOBILY_DEFINE_VALIDATE_COLOR(HighlightedTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(HighlightedTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(HighlightedImage)
MOBILY_DEFINE_VALIDATE_IMAGE(HighlightedBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(DisabledTitle)
MOBILY_DEFINE_VALIDATE_COLOR(DisabledTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(DisabledTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(DisabledImage)
MOBILY_DEFINE_VALIDATE_IMAGE(DisabledBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(SelectedTitle)
MOBILY_DEFINE_VALIDATE_COLOR(SelectedTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(SelectedTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(SelectedImage)
MOBILY_DEFINE_VALIDATE_IMAGE(SelectedBackgroundImage)

#pragma mark Property

- (void)setNormalTitle:(NSString*)normalTitle {
    [self setTitle:normalTitle forState:UIControlStateNormal];
}

- (NSString*)normalTitle {
    return [self titleForState:UIControlStateNormal];
}

- (void)setNormalTitleColor:(UIColor*)normalTitleColor {
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (UIColor*)normalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setNormalTitleShadowColor:(UIColor*)normalTitleShadowColor {
    [self setTitleShadowColor:normalTitleShadowColor forState:UIControlStateNormal];
}

- (UIColor*)normalTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateNormal];
}

- (void)setNormalImage:(UIImage*)normalImage {
    [self setImage:normalImage forState:UIControlStateNormal];
}

- (UIImage*)normalImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setNormalBackgroundImage:(UIImage*)normalBackgroundImage {
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
}

- (UIImage*)normalBackgroundImage {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setHighlightedTitle:(NSString*)highlightedTitle {
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

- (NSString*)highlightedTitle {
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setHighlightedTitleColor:(UIColor*)highlightedTitleColor {
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (UIColor*)highlightedTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setHighlightedTitleShadowColor:(UIColor*)highlightedTitleShadowColor {
    [self setTitleShadowColor:highlightedTitleShadowColor forState:UIControlStateHighlighted];
}

- (UIColor*)highlightedTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateHighlighted];
}

- (void)setHighlightedImage:(UIImage*)highlightedImage {
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (UIImage*)highlightedImage {
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setHighlightedBackgroundImage:(UIImage*)highlightedBackgroundImage {
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (UIImage*)highlightedBackgroundImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setDisabledTitle:(NSString*)disabledTitle {
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}

- (NSString*)disabledTitle {
    return [self titleForState:UIControlStateDisabled];
}

- (void)setDisabledTitleColor:(UIColor*)disabledTitleColor {
    [self setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
}

- (UIColor*)disabledTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setDisabledTitleShadowColor:(UIColor*)disabledTitleShadowColor {
    [self setTitleShadowColor:disabledTitleShadowColor forState:UIControlStateDisabled];
}

- (UIColor*)disabledTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateDisabled];
}

- (void)setDisabledImage:(UIImage*)disabledImage {
    [self setImage:disabledImage forState:UIControlStateDisabled];
}

- (UIImage*)disabledImage {
    return [self imageForState:UIControlStateDisabled];
}

- (void)setDisabledBackgroundImage:(UIImage*)disabledBackgroundImage {
    [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled];
}

- (UIImage*)disabledBackgroundImage {
    return [self backgroundImageForState:UIControlStateDisabled];
}

- (void)setSelectedTitle:(NSString*)selectedTitle {
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (NSString*)selectedTitle {
    return [self titleForState:UIControlStateSelected];
}

- (void)setSelectedTitleColor:(UIColor*)selectedTitleColor {
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor*)selectedTitleColor {
    return [self titleColorForState:UIControlStateSelected];
}

- (void)setSelectedTitleShadowColor:(UIColor*)selectedTitleShadowColor {
    [self setTitleShadowColor:selectedTitleShadowColor forState:UIControlStateSelected];
}

- (UIColor*)selectedTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateSelected];
}

- (void)setSelectedImage:(UIImage*)selectedImage {
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (UIImage*)selectedImage {
    return [self imageForState:UIControlStateSelected];
}

- (void)setSelectedBackgroundImage:(UIImage*)selectedBackgroundImage {
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
}

- (UIImage*)selectedBackgroundImage {
    return [self backgroundImageForState:UIControlStateSelected];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING(Title)

#pragma mark Property

- (UIView*)topView {
    UIViewController* viewController = self;
    while([viewController parentViewController] != nil) {
        viewController = [viewController parentViewController];
    }
    return [viewController view];
}

#pragma mark Public

- (void)loadViewIfNeed {
    if([self isViewLoaded] == NO) {
        [self loadView];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINavigationController (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(NavigationBarHidden)
MOBILY_DEFINE_VALIDATE_BOOL(ToolbarHidden)
MOBILY_DEFINE_VALIDATE_BOOL(Translucent)
MOBILY_DEFINE_VALIDATE_COLOR(TintColor)
MOBILY_DEFINE_VALIDATE_COLOR(BarTintColor)
MOBILY_DEFINE_VALIDATE_IMAGE(ShadowImage)
//MOBILY_DEFINE_VALIDATE_TEXT_ATTRIBUTES(TitleTextAttributes)
MOBILY_DEFINE_VALIDATE_IMAGE(BackIndicatorImage)
MOBILY_DEFINE_VALIDATE_IMAGE(BackIndicatorTransitionMaskImage)

#pragma mark Property

- (void)setTranslucent:(BOOL)translucent {
    [[self navigationBar] setTranslucent:translucent];
}

- (BOOL)isTranslucent {
    return [[self navigationBar] isTranslucent];
}

- (void)setTintColor:(UIColor*)tintColor {
    [[self navigationBar] setTintColor:tintColor];
}

- (UIColor*)tintColor {
    return [[self navigationBar] tintColor];
}

- (void)setBarTintColor:(UIColor*)barTintColor {
    [[self navigationBar] setBarTintColor:barTintColor];
}

- (UIColor*)barTintColor {
    return [[self navigationBar] barTintColor];
}

- (void)setShadowImage:(UIImage*)shadowImage {
    [[self navigationBar] setShadowImage:shadowImage];
}

- (UIImage*)shadowImage {
    return [[self navigationBar] shadowImage];
}

- (void)setTitleTextAttributes:(NSDictionary*)titleTextAttributes {
    [[self navigationBar] setTitleTextAttributes:titleTextAttributes];
}

- (NSDictionary*)titleTextAttributes {
    return [[self navigationBar] titleTextAttributes];
}

- (void)setBackIndicatorImage:(UIImage*)backIndicatorImage {
    [[self navigationBar] setBackIndicatorImage:backIndicatorImage];
}

- (UIImage*)backIndicatorImage {
    return [[self navigationBar] backIndicatorImage];
}

- (void)setBackIndicatorTransitionMaskImage:(UIImage*)backIndicatorTransitionMaskImage {
    [[self navigationBar] setBackIndicatorTransitionMaskImage:backIndicatorTransitionMaskImage];
}

- (UIImage*)backIndicatorTransitionMaskImage {
    return [[self navigationBar] backIndicatorTransitionMaskImage];
}

- (UIViewController*)rootViewController {
    NSArray* viewControllers = [self viewControllers];
    if([viewControllers count] > 0) {
        return [viewControllers objectAtIndex:0];
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINavigationItem (MobilyUI)

#pragma mark NSKeyValueCoding

#pragma mark Property

- (void)setLeftBarView:(UIView*)view animated:(BOOL)animated {
    UIBarButtonItem* item = MOBILY_SAFE_AUTORELEASE([[UIBarButtonItem alloc] initWithCustomView:view]);
    [self setLeftBarButtonItem:item animated:animated];
}

- (void)setRightBarView:(UIView*)view animated:(BOOL)animated {
    UIBarButtonItem* item = MOBILY_SAFE_AUTORELEASE([[UIBarButtonItem alloc] initWithCustomView:view]);
    [self setRightBarButtonItem:item animated:animated];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIDevice (MobilyUI)

+ (CGFloat)systemVersion {
    static CGFloat version = 0.0f;
    if(version == 0.0f) {
        version = [[[self currentDevice] systemVersion] floatValue];
    }
    return version;
}

+ (BOOL)isIPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isIPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

@end

/*--------------------------------------------------*/
