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

#import <MobilyCore/MobilyUI.h>
#import <MobilyCore/MobilyCG.h>
#import <MobilyCore/MobilyImageView.h>

/*--------------------------------------------------*/

#import <MobilyCore/MobilySlideController.h>
#import <MobilyCore/MobilyPageController.h>
#import <MobilyCore/MobilyDataView.h>

/*--------------------------------------------------*/

#import <sys/utsname.h>

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyUI)

- (CGSize)moImplicitSizeWithFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self moImplicitSizeWithFont:font forSize:CGSizeMake(NSIntegerMax, NSIntegerMax) lineBreakMode:lineBreakMode];
}

- (CGSize)moImplicitSizeWithFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self moImplicitSizeWithFont:font forSize:CGSizeMake(width, NSIntegerMax) lineBreakMode:lineBreakMode];
}

- (CGSize)moImplicitSizeWithFont:(UIFont*)font forSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if(UIDevice.moSystemVersion >= 7.0) {
        NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary* attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle };
        CGRect textRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        if(textRect.size.height < font.lineHeight) {
            textRect.size.height = font.lineHeight;
        }
        return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
    }
#endif
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    if(size.height < font.lineHeight) {
        size.height = font.lineHeight;
    }
#pragma clang diagnostic pop
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (UIEdgeInsets)moConvertToEdgeInsets {
    return [self moConvertToEdgeInsetsSeparated:@";"];
}

- (UIEdgeInsets)moConvertToEdgeInsetsSeparated:(NSString*)separated {
    UIEdgeInsets result = UIEdgeInsetsZero;
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    NSArray* array = [self componentsSeparatedByString:separated];
    switch(array.count) {
        case 1: {
            result.top = [[formatter numberFromString:array[0]] floatValue];
            result.left = result.bottom = result.right = result.top;
            break;
        }
        case 2: {
            result.top = [[formatter numberFromString:array[0]] floatValue];
            result.left = [[formatter numberFromString:array[1]] floatValue];
            result.bottom = result.top;
            result.right = result.left;
            break;
        }
        case 4: {
            result.top = [[formatter numberFromString:array[0]] floatValue];
            result.left = [[formatter numberFromString:array[1]] floatValue];
            result.bottom = [[formatter numberFromString:array[2]] floatValue];
            result.right = [[formatter numberFromString:array[3]] floatValue];
            break;
        }
        default:
            break;
    }
    return result;
}

- (UIBezierPath*)moConvertToBezierPath {
    return [self moConvertToBezierPathSeparated:@";"];
}

- (UIBezierPath*)moConvertToBezierPathSeparated:(NSString*)separated {
    return nil;
}

- (UIFont*)moConvertToFont {
    return [self moConvertToFontSeparated:@";"];
}

- (UIFont*)moConvertToFontSeparated:(NSString*)separated {
    UIFont* result = nil;
    NSArray* array = [self componentsSeparatedByString:separated];
    if(array.count > 0) {
        static NSNumberFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
        }
        switch(array.count) {
            case 1: {
                result = [UIFont fontWithName:array[0] size:UIFont.systemFontSize];
                break;
            }
            case 2: {
                result = [UIFont fontWithName:array[0] size:[[formatter numberFromString:array[1]] floatValue]];
                break;
            }
            default:
                break;
        }
    }
    return result;
}

- (UIImage*)moConvertToImage {
    return [self moConvertToImageSeparated:@";" edgeInsetsSeparated:@";"];
}

- (UIImage*)moConvertToImageSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated {
    UIImage* result = nil;
    NSArray* array = [self componentsSeparatedByString:separated];
    switch(array.count) {
        case 1: {
            result = [UIImage imageNamed:self];
            break;
        }
        default:{
            NSString* pattern = [NSString stringWithFormat:@"([A-Za-z0-9-_]+)[%@]+\\[([0-9%@ ]*)\\]", separated, edgeInsetsSeparated];
            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
            NSArray* matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
            if(matches.count > 0) {
                NSTextCheckingResult* match = matches[0];
                if(match.numberOfRanges == 3) {
                    NSString* imageName = [self substringWithRange:[match rangeAtIndex:1]];
                    result = [UIImage imageNamed:imageName];
                    if(result != nil) {
                        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
                        NSString* imageInsets = [self substringWithRange:[match rangeAtIndex:2]];
                        if(imageInsets != nil) {
                            [imageInsets moConvertToEdgeInsetsSeparated:edgeInsetsSeparated];
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

- (NSArray*)moConvertToImages {
    return [self moConvertToImagesSeparated:@";" edgeInsetsSeparated:@";" frameSeparated:@"|"];
}

- (NSArray*)moConvertToImagesSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated frameSeparated:(NSString*)frameSeparated {
    NSMutableArray* result = NSMutableArray.array;
    NSArray* array = [self componentsSeparatedByString:frameSeparated];
    if(array.count > 0) {
        for(NSString* frame in array) {
            UIImage* image = [frame moConvertToImageSeparated:separated edgeInsetsSeparated:edgeInsetsSeparated];
            if(image != nil) {
                [result addObject:image];
            }
        }
    }
    return result;
}

- (UIRemoteNotificationType)moConvertToRemoteNotificationType {
    return [self moConvertToRemoteNotificationTypeSeparated:@"|"];
}

- (UIRemoteNotificationType)moConvertToRemoteNotificationTypeSeparated:(NSString*)separated {
    UIRemoteNotificationType result = UIRemoteNotificationTypeNone;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        for(NSString* key in keys) {
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
        }
    }
    return result;
}

- (UIInterfaceOrientationMask)moConvertToInterfaceOrientationMask {
    return [self moConvertToInterfaceOrientationMaskSeparated:@"|"];
}

- (UIInterfaceOrientationMask)moConvertToInterfaceOrientationMaskSeparated:(NSString*)separated {
    UIInterfaceOrientationMask result = 0;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIInterfaceOrientationMaskAll;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        for(NSString* key in keys) {
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
        }
    }
    return result;
}

- (UIStatusBarStyle)moConvertToStatusBarStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIStatusBarStyleDefault;
    } else if([temp isEqualToString:@"light-content"] == YES) {
        return UIStatusBarStyleLightContent;
    } else if([temp isEqualToString:@"black-translucent"] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIStatusBarStyleBlackTranslucent;
#pragma clang diagnostic pop
    } else if([temp isEqualToString:@"black-opaque"] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIStatusBarStyleBlackOpaque;
#pragma clang diagnostic pop
    }
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)moConvertToStatusBarAnimation {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"fade"] == YES) {
        return UIStatusBarAnimationFade;
    } else if([temp isEqualToString:@"slide"] == YES) {
        return UIStatusBarAnimationSlide;
    }
    return UIStatusBarAnimationNone;
}

- (UIViewAutoresizing)moConvertToViewAutoresizing {
    return [self moConvertToViewAutoresizingSeparated:@"|"];
}

- (UIViewAutoresizing)moConvertToViewAutoresizingSeparated:(NSString*)separated {
    UIViewAutoresizing result = UIViewAutoresizingNone;
    NSString* value = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([value isEqualToString:@"all"] == YES) {
        result = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        NSArray* keys = [value componentsSeparatedByString:separated];
        for(NSString* key in keys) {
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
        }
    }
    return result;
}

- (UIViewContentMode)moConvertToViewContentMode {
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

- (UIControlContentHorizontalAlignment)moConvertToControlContentHorizontalAlignment {
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

- (UIControlContentVerticalAlignment)moConvertToControlContentVerticalAlignment {
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

- (UITextAutocapitalizationType)moConvertToTextAutocapitalizationType {
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

- (UITextAutocorrectionType)moConvertToTextAutocorrectionType {
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

- (UITextSpellCheckingType)moConvertToTestSpellCheckingType {
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

- (UIKeyboardType)moConvertToKeyboardType {
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

- (UIReturnKeyType)moConvertToReturnKeyType {
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

- (UIBaselineAdjustment)moConvertToBaselineAdjustment {
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

- (UIScrollViewIndicatorStyle)moConvertToScrollViewIndicatorStyle {
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

- (UIScrollViewKeyboardDismissMode)moConvertToScrollViewKeyboardDismissMode {
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

- (UIBarStyle)moConvertToBarStyle {
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

- (UITabBarItemPositioning)moConvertToTabBarItemPositioning {
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

- (UISearchBarStyle)moConvertToSearchBarStyle {
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

- (UIProgressViewStyle)moConvertToProgressViewStyle {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"default"] == YES) {
        return UIProgressViewStyleDefault;
    } else if([temp isEqualToString:@"bar"] == YES) {
        return UIProgressViewStyleBar;
    }
    return UIProgressViewStyleDefault;
}

- (UITextBorderStyle)moConvertToTextBorderStyle {
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

- (void)moDrawAtPoint:(CGPoint)point font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine;
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary* attributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle };
    CGRect boundingRect = [self boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:options attributes:attributes context:nil];
    CGRect rect = CGRectMake(point.x, point.y, boundingRect.size.width, boundingRect.size.height);
    switch(hAlignment) {
        case MobilyHorizontalAlignmentCenter: rect.origin.x -= rect.size.width * 0.5f; break;
        case MobilyHorizontalAlignmentRight: rect.origin.x -= rect.size.width; break;
        default: break;
    }
    switch(vAlignment) {
        case MobilyVerticalAlignmentCenter: rect.origin.y -= rect.size.height * 0.5f; break;
        case MobilyVerticalAlignmentBottom: rect.origin.y -= rect.size.height; break;
        default: break;
    }
    [self drawWithRect:CGRectMake(floorf(rect.origin.x), floorf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height)) options:options attributes:attributes context:nil];
}

- (void)moDrawInRect:(CGRect)rect font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine;
    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary* attributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle };
    CGRect boundingRect = [self boundingRectWithSize:rect.size options:options attributes:attributes context:nil];
    switch(hAlignment) {
        case MobilyHorizontalAlignmentCenter: rect.origin.x -= (boundingRect.size.width * 0.5f) - (rect.size.width * 0.5f); break;
        case MobilyHorizontalAlignmentRight: rect.origin.x -= boundingRect.size.width - rect.size.width; break;
        default: break;
    }
    switch(vAlignment) {
        case MobilyVerticalAlignmentCenter: rect.origin.y -= (boundingRect.size.height * 0.5f) - (rect.size.height * 0.5f); break;
        case MobilyVerticalAlignmentBottom: rect.origin.y -= boundingRect.size.height - rect.size.height; break;
        default: break;
    }
    [self drawWithRect:CGRectMake(floorf(rect.origin.x), floorf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height)) options:options attributes:attributes context:nil];
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

+ (UIColor*)moColorWithString:(NSString*)string {
    UIColor* result = nil;
    NSRange range = [string rangeOfString:@"#"];
    if((range.location != NSNotFound) && (range.length > 0)) {
        CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
        NSString* colorString = [[string stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        switch (colorString.length) {
            case 6: // #RRGGBB
                red = [self moColorComponentFromString:colorString start:0 length:2];
                green = [self moColorComponentFromString:colorString start:2 length:2];
                blue = [self moColorComponentFromString:colorString start:4 length:2];
                break;
            case 8: // #RRGGBBAA
                red = [self moColorComponentFromString:colorString start:0 length:2];
                green = [self moColorComponentFromString:colorString start:2 length:2];
                blue = [self moColorComponentFromString:colorString start:4 length:2];
                alpha = [self moColorComponentFromString:colorString start:6 length:2];
                break;
        }
        result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return result;
}

+ (CGFloat)moColorComponentFromString:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length {
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

- (UIColor*)moMultiplyColor:(UIColor*)color percent:(CGFloat)percent {
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return [UIColor colorWithRed:(r2 * percent) + (r1 * (1.0 - percent))
                           green:(g2 * percent) + (g1 * (1.0 - percent))
                            blue:(b2 * percent) + (b1 * (1.0 - percent))
                           alpha:(a2 * percent) + (a1 * (1.0 - percent))];
}

- (UIColor*)moMultiplyBrightness:(CGFloat)brightness {
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b * brightness alpha:a];
}

- (MobilyColorHSB)moHsb {
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

+ (UIImage*)moImageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets {
    UIImage* result = [self imageNamed:name];
    if(result != nil) {
        result = [result resizableImageWithCapInsets:capInsets];
    }
    return result;
}

+ (UIImage*)moImageWithColor:(UIColor*)color size:(CGSize)size {
    UIImage* image = nil;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != NULL) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

- (UIImage*)moUnrotate {
    UIImage* result = nil;
    CGImageRef imageRef = self.CGImage;
    if(imageRef != NULL) {
        CGSize originalSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        CGSize finalSize = CGSizeZero;
        CGAffineTransform transform = CGAffineTransformIdentity;
        switch(self.imageOrientation) {
            case UIImageOrientationUp: {
                transform = CGAffineTransformIdentity;
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationUpMirrored: {
                transform = CGAffineTransformMakeTranslation(originalSize.width, 0.0);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationDown: {
                transform = CGAffineTransformMakeTranslation(originalSize.width, originalSize.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationDownMirrored: {
                transform = CGAffineTransformMakeTranslation(0.0, originalSize.height);
                transform = CGAffineTransformScale(transform, 1.0, -1.0);
                finalSize = originalSize;
                break;
            }
            case UIImageOrientationLeftMirrored: {
                transform = CGAffineTransformMakeTranslation(originalSize.height, originalSize.width);
                transform = CGAffineTransformScale(transform, -1.0, 1.0);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationLeft: {
                transform = CGAffineTransformMakeTranslation(0.0, originalSize.width);
                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationRightMirrored: {
                transform = CGAffineTransformMakeScale(-1.0, 1.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            case UIImageOrientationRight: {
                transform = CGAffineTransformMakeTranslation(originalSize.height, 0.0);
                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                finalSize = CGSizeMake(originalSize.height, originalSize.width);
                break;
            }
            default:
                break;
        }
        if((finalSize.width > MOBILY_EPSILON) && (finalSize.height > MOBILY_EPSILON)) {
            UIGraphicsBeginImageContext(finalSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if(context != NULL) {
                switch(self.imageOrientation) {
                    case UIImageOrientationRight:
                    case UIImageOrientationLeft:
                        CGContextScaleCTM(context, -1.0f, 1.0f);
                        CGContextTranslateCTM(context, -originalSize.height, 0.0f);
                        break;
                    default:
                        CGContextScaleCTM(context, 1.0f, -1.0f);
                        CGContextTranslateCTM(context, 0.0f, -originalSize.height);
                        break;
                }
                CGContextConcatCTM(context, transform);
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, 0.0f, originalSize.width, originalSize.height), imageRef);
                result = UIGraphicsGetImageFromCurrentImageContext();
            }
            UIGraphicsEndImageContext();
        }
    }
    return result;
}

- (UIImage*)moScaleToSize:(CGSize)size {
    UIImage* result = nil;
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    if(colourSpace != NULL) {
        CGRect drawRect = MobilyRectAspectFitFromBoundsAndSize(CGRectMake(0.0f, 0.0f, size.width, size.height), self.size);
        drawRect.size.width = floorf(drawRect.size.width);
        drawRect.size.height = floorf(drawRect.size.height);
        
        CGContextRef context = CGBitmapContextCreate(NULL, drawRect.size.width, drawRect.size.height, 8, drawRect.size.width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
        if(context != NULL) {
            CGContextClearRect(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height));
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height), self.CGImage);
            
            CGImageRef image = CGBitmapContextCreateImage(context);
            if(image != NULL) {
                result = [UIImage imageWithCGImage:image scale:self.scale orientation:self.imageOrientation];
                CGImageRelease(image);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colourSpace);
    }
    return result;
}

- (UIImage*)moRotateToAngleInRadians:(CGFloat)angleInRadians {
    UIImage* result = nil;
    CGSize size = self.size;
    if((size.width > 0.0f) && (size.height > 0.0f)) {
        UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if(context != NULL) {
            CGContextTranslateCTM(context, 0.5f * size.width, 0.5f * size.height);
            CGContextRotateCTM(context, angleInRadians);
            CGContextTranslateCTM(context, -0.5f * size.width, -0.5f * size.height);
            [self drawAtPoint:CGPointZero];
            result = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    return result;
}

- (UIImage*)moGrayscale {
    UIImage* result = nil;
    CGSize size = self.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    if(colorSpace != NULL) {
        CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        if(context != NULL) {
            CGContextDrawImage(context, rect, [self CGImage]);
            CGImageRef grayscale = CGBitmapContextCreateImage(context);
            if(context != NULL) {
                result = [UIImage imageWithCGImage:grayscale];
                CGImageRelease(grayscale);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colorSpace);
    }
    return result;
}

- (UIImage*)moBlackAndWhite {
    UIImage* result = nil;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    if(colorSpace != NULL) {
        CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, self.size.width, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        if(colorSpace != NULL) {
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextSetShouldAntialias(context, NO);
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            CGImageRef bwImage = CGBitmapContextCreateImage(context);
            if(bwImage != NULL) {
                result = [UIImage imageWithCGImage:bwImage];
                CGImageRelease(bwImage);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colorSpace);
    }
    return result;
}

- (UIImage*)moInvertColors {
    UIImage* result = nil;
    UIGraphicsBeginImageContext(self.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), UIColor.whiteColor.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height));
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage*)moBlurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor*)tintColor {
    UIImage* image = nil;
    CGSize size = self.size;
    CGFloat scale = self.scale;
    if(floorf(size.width) * floorf(size.height) > MOBILY_EPSILON) {
        CGImageRef imageRef = self.CGImage;
        uint32_t boxSize = (uint32_t)(radius * scale);
        if(boxSize % 2 == 0) {
            boxSize++;
        }
        vImage_Buffer buffer1;
        buffer1.width = CGImageGetWidth(imageRef);
        buffer1.height = CGImageGetHeight(imageRef);
        buffer1.rowBytes = CGImageGetBytesPerRow(imageRef);
        size_t bytes = buffer1.rowBytes * buffer1.height;
        buffer1.data = malloc(bytes);
        if(buffer1.data != NULL) {
            vImage_Buffer buffer2;
            buffer2.width = buffer1.width;
            buffer2.height = buffer1.height;
            buffer2.rowBytes = buffer1.rowBytes;
            buffer2.data = malloc(bytes);
            if(buffer2.data != nil) {
                size_t tempBufferSize = (size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend + kvImageGetTempBufferSize);
                if(tempBufferSize > 0) {
                    void* tempBuffer = malloc(tempBufferSize);
                    if(tempBuffer != nil) {
                        CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
                        if(dataSource != NULL) {
                            memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
                            CFRelease(dataSource);
                        }
                        for(NSUInteger i = 0; i < iterations; i++) {
                            if(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend) == kvImageNoError) {
                                void* temp = buffer1.data;
                                buffer1.data = buffer2.data;
                                buffer2.data = temp;
                            }
                        }
                        free(tempBuffer);
                        CGContextRef context = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height, 8, buffer1.rowBytes, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
                        if(context != NULL) {
                            if(tintColor != nil) {
                                if(CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
                                    CGContextSetFillColorWithColor(context, [[tintColor colorWithAlphaComponent:0.25] CGColor]);
                                    CGContextSetBlendMode(context, kCGBlendModePlusDarker);
                                    CGContextFillRect(context, CGRectMake(0, 0, buffer1.width, buffer1.height));
                                }
                            }
                            imageRef = CGBitmapContextCreateImage(context);
                            if(imageRef != nil) {
                                image = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
                                CGImageRelease(imageRef);
                            }
                            CGContextRelease(context);
                        }
                    }
                }
                free(buffer2.data);
            }
            free(buffer1.data);
        }
    }
    return image;
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment {
    return [self moDrawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:0.0f blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    return [self moDrawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:0.0f blendMode:blendMode alpha:alpha];
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment radius:(CGFloat)radius {
    return [self moDrawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:radius blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    return [self moDrawInRect:rect alignment:alignment corners:UIRectCornerAllCorners radius:radius blendMode:blendMode alpha:alpha];
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius {
    return [self moDrawInRect:rect alignment:alignment corners:corners radius:radius blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    [path addClip];
    switch(alignment) {
        case MobilyImageAlignmentStretch: break;
        case MobilyImageAlignmentAspectFill: rect = MobilyRectAspectFillFromBoundsAndSize(rect, self.size); break;
        case MobilyImageAlignmentAspectFit: rect = MobilyRectAspectFitFromBoundsAndSize(rect, self.size); break;
    }
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
    CGContextRestoreGState(contextRef);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIBezierPath (MobilyUI)

+ (void)moDrawRect:(CGRect)rect fillColor:(UIColor*)fillColor {
    [self moDrawRect:rect fillColor:fillColor strokeColor:nil strokeWidth:0.0f];
}

+ (void)moDrawRect:(CGRect)rect fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth {
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:rect];
    if(fillColor != nil) {
        [fillColor setFill];
        [path fill];
    }
    if(strokeColor != nil) {
        [strokeColor setStroke];
        [path setLineWidth:strokeWidth];
        [path stroke];
    }
}

+ (void)moDrawOvalInRect:(CGRect)rect fillColor:(UIColor*)fillColor {
    [self moDrawOvalInRect:rect fillColor:fillColor strokeColor:nil strokeWidth:0.0f];
}

+ (void)moDrawOvalInRect:(CGRect)rect fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth {
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:rect];
    if(fillColor != nil) {
        [fillColor setFill];
        [path fill];
    }
    if(strokeColor != nil) {
        [strokeColor setStroke];
        [path setLineWidth:strokeWidth];
        [path stroke];
    }
}

+ (void)moDrawRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor*)fillColor {
    [self moDrawRoundedRect:rect radius:radius fillColor:fillColor strokeColor:nil strokeWidth:0.0f];
}

+ (void)moDrawRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth {
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    if(fillColor != nil) {
        [fillColor setFill];
        [path fill];
    }
    if(strokeColor != nil) {
        [strokeColor setStroke];
        [path setLineWidth:strokeWidth];
        [path stroke];
    }
}

+ (void)moDrawRoundedRect:(CGRect)rect corners:(UIRectCorner)corners radius:(CGSize)radius fillColor:(UIColor*)fillColor {
    [self moDrawRoundedRect:rect corners:corners radius:radius fillColor:fillColor strokeColor:nil strokeWidth:0.0f];
}

+ (void)moDrawRoundedRect:(CGRect)rect corners:(UIRectCorner)corners radius:(CGSize)radius fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth {
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radius];
    if(fillColor != nil) {
        [fillColor setFill];
        [path fill];
    }
    if(strokeColor != nil) {
        [strokeColor setStroke];
        [path setLineWidth:strokeWidth];
        [path stroke];
    }
}

+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges width:(CGFloat)width fillColor:(UIColor*)fillColor {
    [self moDrawSeparatorRect:rect edges:edges widthEdges:UIEdgeInsetsMake(width, width, width, width) edgeInsets:UIEdgeInsetsZero fillColor:fillColor];
}

+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges width:(CGFloat)width edgeInsets:(UIEdgeInsets)edgeInsets fillColor:(UIColor*)fillColor {
    [self moDrawSeparatorRect:rect edges:edges widthEdges:UIEdgeInsetsMake(width, width, width, width) edgeInsets:edgeInsets fillColor:fillColor];
}

+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges widthEdges:(UIEdgeInsets)widthEdges edgeInsets:(UIEdgeInsets)edgeInsets fillColor:(UIColor*)fillColor {
    UIBezierPath* path = [UIBezierPath bezierPath];
    if((edges & MobilyBezierPathSeparatorEdgeTop) != 0) {
        CGRect lineRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, widthEdges.top);
        UIEdgeInsets lineInsets = UIEdgeInsetsZero;
        if((edges & MobilyBezierPathSeparatorEdgeLeft) == 0) { lineInsets.left = edgeInsets.left; }
        if((edges & MobilyBezierPathSeparatorEdgeRight) != 0) { lineInsets.right = widthEdges.right; }
        [path appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(lineRect, lineInsets)]];
    }
    if((edges & MobilyBezierPathSeparatorEdgeRight) != 0) {
        CGRect lineRect = CGRectMake((rect.origin.x + rect.size.width) - widthEdges.right, rect.origin.y, widthEdges.right, rect.size.height);
        UIEdgeInsets lineInsets = UIEdgeInsetsZero;
        if((edges & MobilyBezierPathSeparatorEdgeTop) == 0) { lineInsets.top = edgeInsets.top; }
        if((edges & MobilyBezierPathSeparatorEdgeBottom) != 0) { lineInsets.bottom = widthEdges.bottom; }
        [path appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(lineRect, lineInsets)]];
    }
    if((edges & MobilyBezierPathSeparatorEdgeBottom) != 0) {
        CGRect lineRect = CGRectMake(rect.origin.x, (rect.origin.y + rect.size.height) - widthEdges.bottom, rect.size.width, widthEdges.bottom);
        UIEdgeInsets lineInsets = UIEdgeInsetsZero;
        if((edges & MobilyBezierPathSeparatorEdgeLeft) != 0) { lineInsets.left = widthEdges.left; }
        if((edges & MobilyBezierPathSeparatorEdgeRight) == 0) { lineInsets.right = edgeInsets.right; }
        [path appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(lineRect, lineInsets)]];
    }
    if((edges & MobilyBezierPathSeparatorEdgeLeft) != 0) {
        CGRect lineRect = CGRectMake(rect.origin.x, rect.origin.y, widthEdges.left, rect.size.height);
        UIEdgeInsets lineInsets = UIEdgeInsetsZero;
        if((edges & MobilyBezierPathSeparatorEdgeTop) != 0) { lineInsets.top = widthEdges.top; }
        if((edges & MobilyBezierPathSeparatorEdgeBottom) == 0) { lineInsets.bottom = edgeInsets.bottom; }
        [path appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(lineRect, lineInsets)]];
    }
    if(fillColor != nil) {
        [fillColor setFill];
        [path fill];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINib (MobilyUI)

+ (id)moViewWithNibName:(NSString*)nibName withClass:(Class)class {
    return [self moViewWithNibName:nibName withClass:class withOwner:nil];
}

+ (id)moViewWithNibName:(NSString*)nibName withClass:(Class)class withOwner:(id)owner {
    UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
    if(nib != nil) {
        return [nib moInstantiateWithClass:class owner:owner options:nil];
    }
    return nil;
}

+ (UINib*)moNibWithBaseName:(NSString*)baseName bundle:(NSBundle*)bundle {
    if(bundle == nil) {
        bundle = NSBundle.mainBundle;
    }
    NSMutableArray* nibNames = [NSMutableArray array];
    NSFileManager* fileManager = NSFileManager.defaultManager;
    if(UIDevice.moIsIPhone == YES) {
        NSString* modelBaseName = [NSString stringWithFormat:@"%@%@", baseName, @"-iPhone"];
        switch(UIDevice.moModel) {
            case MobilyDeviceModelPhone6Plus:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-6Plus"]];
            case MobilyDeviceModelPhone6:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-6"]];
            case MobilyDeviceModelPhone5S:
            case MobilyDeviceModelPhone5C:
            case MobilyDeviceModelPhone5:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-5"]];
            case MobilyDeviceModelPhone4S:
            case MobilyDeviceModelPhone4:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-4"]];
            case MobilyDeviceModelPhone3GS:
            case MobilyDeviceModelPhone3G:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-3"]];
            default:
                [nibNames addObject:modelBaseName];
                break;
        }
    } else if(UIDevice.moIsIPad == YES) {
        NSString* modelBaseName = [NSString stringWithFormat:@"%@%@", baseName, @"-iPad"];
        switch(UIDevice.moModel) {
            case MobilyDeviceModelPadAir2:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Air2"]];
            case MobilyDeviceModelPadAir1:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Air1"]];
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Air"]];
                break;
            case MobilyDeviceModelPadMini3:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Mini3"]];
            case MobilyDeviceModelPadMini2:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Mini2"]];
            case MobilyDeviceModelPadMini1:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Mini1"]];
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-Mini"]];
                break;
            case MobilyDeviceModelPad4:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-4"]];
            case MobilyDeviceModelPad3:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-3"]];
            case MobilyDeviceModelPad2:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-2"]];
            case MobilyDeviceModelPad1:
                [nibNames addObject:[NSString stringWithFormat:@"%@%@", modelBaseName, @"-1"]];
                break;
            default:
                [nibNames addObject:modelBaseName];
                break;
        }
    }
    [nibNames addObject:baseName];
    
    NSString* existNibName = nil;
    for(NSString* nibName in nibNames) {
        if([fileManager fileExistsAtPath:[bundle pathForResource:nibName ofType:@"nib"]] == YES) {
            existNibName = nibName;
            break;
        }
    }
    if(existNibName != nil) {
        return [self nibWithNibName:existNibName bundle:bundle];
    }
    return nil;
}

+ (UINib*)moNibWithClass:(Class)class bundle:(NSBundle*)bundle {
    UINib* nib = [self moNibWithBaseName:NSStringFromClass(class) bundle:bundle];
    if((nib == nil) && ([class superclass] != nil)) {
        nib = [self moNibWithClass:[class superclass] bundle:bundle];
    }
    return nib;
}

- (id)moInstantiateWithClass:(Class)class owner:(id)owner options:(NSDictionary*)options {
    NSArray* content = [self instantiateWithOwner:owner options:options];
    for(id item in content) {
        if([item isKindOfClass:class] == YES) {
            return item;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static UIResponder* MOBILY_CURRENT_FIRST_RESPONDER = nil;

/*--------------------------------------------------*/

@implementation UIResponder (MobilyUI)

+ (id)moCurrentFirstResponderInView:(UIView*)view {
    id responder = self.moCurrentFirstResponder;
    if([responder isKindOfClass:UIView.class] == YES) {
        if([view moIsContainsSubview:responder] == YES) {
            return responder;
        }
    }
    return nil;
}

+ (id)moCurrentFirstResponder {
    MOBILY_CURRENT_FIRST_RESPONDER = nil;
    [UIApplication.sharedApplication sendAction:@selector(moFindFirstResponder) to:nil from:nil forEvent:nil];
    return MOBILY_CURRENT_FIRST_RESPONDER;
}

- (void)moFindFirstResponder {
    MOBILY_CURRENT_FIRST_RESPONDER = self;
}

+ (UIResponder*)moPrevResponderFromView:(UIView*)view {
    NSArray* responders = view.window.moResponders;
    if(responders.count > 1) {
        NSInteger index = [responders indexOfObject:view];
        if(index != NSNotFound) {
            if(index > 0) {
                return responders[index - 1];
            }
        }
    }
    return nil;
}

+ (UIResponder*)moNextResponderFromView:(UIView*)view {
    NSArray* responders = view.window.moResponders;
    if(responders.count > 1) {
        NSInteger index = [responders indexOfObject:view];
        if(index != NSNotFound) {
            if(index < responders.count - 1) {
                return responders[index + 1];
            }
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIWindow (MobilyUI)

#pragma mark NSKeyValueCoding

#pragma mark Property

- (UIViewController*)moCurrentController {
    return self.rootViewController.moCurrentController;
}

#ifdef __IPHONE_7_0

- (UIViewController*)moControllerForStatusBarStyle {
    UIViewController* controller = self.moCurrentController;
    while(controller.childViewControllerForStatusBarStyle != nil) {
        controller = controller.childViewControllerForStatusBarStyle;
    }
    return controller;
}

- (UIViewController*)moControllerForStatusBarHidden {
    UIViewController* controller = self.moCurrentController;
    while(controller.childViewControllerForStatusBarHidden != nil) {
        controller = controller.childViewControllerForStatusBarHidden;
    }
    return controller;
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
MOBILY_DEFINE_VALIDATE_POINT(MoFramePosition)
MOBILY_DEFINE_VALIDATE_POINT(MoFrameCenter)
MOBILY_DEFINE_VALIDATE_SIZE(MoFrameSize)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameSX)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameSY)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameCX)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameCY)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameEX)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameEY)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameWidth)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameHeight)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameLeft)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameRight)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameTop)
MOBILY_DEFINE_VALIDATE_NUMBER(MoFrameBottom)
MOBILY_DEFINE_VALIDATE_NUMBER(MoCornerRadius)
MOBILY_DEFINE_VALIDATE_NUMBER(MoBorderWidth)
MOBILY_DEFINE_VALIDATE_COLOR(MoBorderColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoShadowColor)
MOBILY_DEFINE_VALIDATE_NUMBER(MoShadowOpacity);
MOBILY_DEFINE_VALIDATE_SIZE(MoShadowOffset);
MOBILY_DEFINE_VALIDATE_NUMBER(MoShadowRadius);
MOBILY_DEFINE_VALIDATE_BEZIER_PATH(MoShadowPath);
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

- (void)setMoFramePosition:(CGPoint)moFramePosition {
    CGRect frame = self.frame;
    self.frame = CGRectMake(moFramePosition.x, moFramePosition.y, frame.size.width, frame.size.height);
}

- (CGPoint)moFramePosition {
    return self.frame.origin;
}

- (void)setMoFrameCenter:(CGPoint)moFrameCenter {
    CGRect frame = self.frame;
    self.frame = CGRectMake(moFrameCenter.x - (frame.size.width * 0.5f), moFrameCenter.y - (frame.size.height * 0.5f), frame.size.width, frame.size.height);
}

- (CGPoint)moFrameCenter {
    CGRect frame = self.frame;
    return CGPointMake(frame.origin.x + (frame.size.width * 0.5f), frame.origin.y + (frame.size.height * 0.5f));
}

- (void)setMoFrameSize:(CGSize)moFrameSize {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, moFrameSize.width, moFrameSize.height);
}

- (CGSize)moFrameSize {
    return self.frame.size;
}

- (void)setMoFrameSX:(CGFloat)moFrameSX {
    CGRect frame = self.frame;
    self.frame = CGRectMake(moFrameSX, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)moFrameSX {
    return CGRectGetMinX(self.frame);
}

- (void)setMoFrameCX:(CGFloat)moFrameCX {
    CGRect frame = self.frame;
    self.frame = CGRectMake(moFrameCX - (frame.size.width * 0.5f), frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)moFrameCX {
    return CGRectGetMidX(self.frame);
}

- (void)setMoFrameEX:(CGFloat)moFrameEX {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, moFrameEX - frame.origin.x, frame.size.height);
}

- (CGFloat)moFrameEX {
    return CGRectGetMaxX(self.frame);
}

- (void)setMoFrameSY:(CGFloat)moFrameSY {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, moFrameSY, frame.size.width, frame.size.height);
}

- (CGFloat)moFrameSY {
    return CGRectGetMinY(self.frame);
}

- (void)setMoFrameCY:(CGFloat)moFrameCY {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, moFrameCY - (frame.size.height * 0.5f), frame.size.width, frame.size.height);
}

- (CGFloat)moFrameCY {
    return CGRectGetMidY(self.frame);
}

- (void)setMoFrameEY:(CGFloat)moFrameEY {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, moFrameEY - frame.origin.y);
}

- (CGFloat)moFrameEY {
    return CGRectGetMaxY(self.frame);
}

- (void)setMoFrameWidth:(CGFloat)moFrameWidth {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, moFrameWidth, frame.size.height);
}

- (CGFloat)moFrameWidth {
    return CGRectGetWidth(self.frame);
}

- (void)setMoFrameHeight:(CGFloat)moFrameHeight {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, moFrameHeight);
}

- (CGFloat)moFrameHeight {
    return CGRectGetHeight(self.frame);
}

- (void)setMoFrameLeft:(CGFloat)moFrameLeft {
    CGRect frame = self.frame;
    CGFloat offset = moFrameLeft;
    CGFloat size = frame.size.width - (moFrameLeft - frame.origin.x);
    self.frame = CGRectMake(offset, frame.origin.y, size, frame.size.height);
}

- (CGFloat)moFrameLeft {
    return self.frame.origin.x;
}

- (void)setMoFrameRight:(CGFloat)moFrameRight {
    CGRect frame = self.frame;
    CGRect bounds = self.superview.bounds;
    CGFloat offset = frame.origin.x;
    CGFloat size = bounds.size.width - (frame.origin.x + moFrameRight);
    self.frame = CGRectMake(offset, frame.origin.y, size, frame.size.height);
}

- (CGFloat)moFrameRight {
    CGRect frame = self.frame;
    CGRect bounds = self.superview.bounds;
    return bounds.size.width - (frame.origin.x + frame.size.width);
}

- (void)setMoFrameTop:(CGFloat)moFrameTop {
    CGRect frame = self.frame;
    CGFloat offset = moFrameTop;
    CGFloat size = frame.size.height - (moFrameTop - frame.origin.y);
    self.frame = CGRectMake(frame.origin.x, offset, frame.size.width, size);
}

- (CGFloat)moFrameTop {
    CGRect frame = self.frame;
    return frame.origin.y;
}

- (void)setMoFrameBottom:(CGFloat)moFrameBottom {
    CGRect frame = self.frame;
    CGRect bounds = self.superview.bounds;
    CGFloat offset = frame.origin.y;
    CGFloat size = bounds.size.height - (frame.origin.y + moFrameBottom);
    self.frame = CGRectMake(frame.origin.x, offset, frame.size.width, size);
}

- (CGFloat)moFrameBottom {
    CGRect frame = self.frame;
    CGRect bounds = self.superview.bounds;
    return bounds.size.height - (frame.origin.y + frame.size.height);
}

- (CGPoint)moBoundsPosition {
    return self.bounds.origin;
}

- (CGSize)moBoundsSize {
    return self.bounds.size;
}

- (CGPoint)moBoundsCenter {
    CGRect bounds = self.bounds;
    return CGPointMake(bounds.origin.x + (bounds.size.width * 0.5f), bounds.origin.y + (bounds.size.height * 0.5f));
}

- (CGFloat)moBoundsCX {
    return CGRectGetMidX(self.bounds);
}

- (CGFloat)moBoundsCY {
    return CGRectGetMidY(self.bounds);
}

- (CGFloat)moBoundsWidth {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)moBoundsHeight {
    return CGRectGetHeight(self.bounds);
}

- (void)setMoZPosition:(CGFloat)moZPosition {
    self.layer.zPosition = moZPosition;
}

- (CGFloat)moZPosition {
    return self.layer.zPosition;
}

- (void)setMoCornerRadius:(CGFloat)moCornerRadius {
    self.layer.cornerRadius = moCornerRadius;
}

- (CGFloat)moCornerRadius {
    return self.layer.cornerRadius;
}

- (void)setMoBorderWidth:(CGFloat)moBorderWidth {
    self.layer.borderWidth = moBorderWidth;
}

- (CGFloat)moBorderWidth {
    return self.layer.borderWidth;
}

- (void)setMoBorderColor:(UIColor*)moBorderColor {
    self.layer.borderColor = moBorderColor.CGColor;
}

- (UIColor*)moBorderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setMoShadowColor:(UIColor*)moShadowColor {
    self.layer.shadowColor = moShadowColor.CGColor;
}

- (UIColor*)moShadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setMoShadowOpacity:(CGFloat)moShadowOpacity {
    self.layer.shadowOpacity = moShadowOpacity;
}

- (CGFloat)moShadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setMoShadowOffset:(CGSize)moShadowOffset {
    self.layer.shadowOffset = moShadowOffset;
}

- (CGSize)moShadowOffset {
    return self.layer.shadowOffset;
}

- (void)setMoShadowRadius:(CGFloat)moShadowRadius {
    self.layer.shadowRadius = moShadowRadius;
}

- (CGFloat)moShadowRadius {
    return self.layer.shadowRadius;
}

- (void)setMoShadowPath:(UIBezierPath*)moShadowPath {
    self.layer.shadowPath = moShadowPath.CGPath;
}

- (UIBezierPath*)moShadowPath {
    return [UIBezierPath bezierPathWithCGPath:self.layer.shadowPath];
}

#pragma mark Public

- (NSArray*)moResponders {
    NSMutableArray* result = NSMutableArray.array;
    if(self.canBecomeFirstResponder == YES) {
        [result addObject:self];
    }
    for(UIView* view in self.subviews) {
        [result addObjectsFromArray:view.moResponders];
    }
    [result sortWithOptions:0 usingComparator:^NSComparisonResult(UIView* viewA, UIView* viewB) {
        CGRect aFrame = [viewA convertRect:[viewA bounds] toView:nil], bFrame = [viewB convertRect:[viewB bounds] toView:nil];
        CGFloat aOrder = [viewA.layer zPosition], bOrder = [viewB.layer zPosition];
        if(aOrder < bOrder) {
            return NSOrderedAscending;
        } else if(aOrder > bOrder) {
            return NSOrderedDescending;
        } else {
            if(aFrame.origin.y < bFrame.origin.y) {
                return NSOrderedAscending;
            } else if(aFrame.origin.y > bFrame.origin.y) {
                return NSOrderedDescending;
            } else {
                if(aFrame.origin.x < bFrame.origin.x) {
                    return NSOrderedAscending;
                } else if(aFrame.origin.x > bFrame.origin.x) {
                    return NSOrderedDescending;
                }
            }
        }
        return NSOrderedSame;
    }];
    return result;
}

- (BOOL)moIsContainsSubview:(UIView*)subview {
    NSArray* subviews = self.subviews;
    if([subviews containsObject:subview] == YES) {
        return YES;
    }
    for(UIView* view in subviews) {
        if([view moIsContainsSubview:subview] == YES) {
            return YES;
        }
    }
    return NO;
}

- (void)moRemoveSubview:(UIView*)subview {
    [subview removeFromSuperview];
}

- (void)moSetSubviews:(NSArray*)subviews {
    NSArray* currentSubviews = self.subviews;
    if([currentSubviews isEqualToArray:subviews] == NO) {
        for(UIView* view in currentSubviews) {
            [view removeFromSuperview];
        }
        for(UIView* view in subviews) {
            [self addSubview:view];
        }
    }
}

- (void)moRemoveAllSubviews {
    for(UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)moBlinkBackgroundColor:(UIColor*)color duration:(NSTimeInterval)duration timeout:(NSTimeInterval)timeout {
    UIColor* prevColor = self.backgroundColor;
    [UIView animateWithDuration:duration
                     animations:^{
                         self.backgroundColor = color;
                     } completion:^(BOOL finished __unused) {
                         [UIView animateWithDuration:duration
                                               delay:timeout
                                             options:0
                                          animations:^{
                                              self.backgroundColor = prevColor;
                                          }
                                          completion:nil];
                     }];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation constant:constant priority:UILayoutPriorityRequired multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant priority:(UILayoutPriority)priority {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation constant:constant priority:priority multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier {
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:constraintAttribute relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:multiplier constant:constant];
    constraint.priority = priority;
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation view:self.superview attribute:attribute constant:constant priority:UILayoutPriorityRequired multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation view:self.superview attribute:attribute constant:constant priority:priority multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation view:self.superview attribute:attribute constant:constant priority:priority multiplier:multiplier];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation view:view attribute:attribute constant:constant priority:UILayoutPriorityRequired multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority {
    return [self moAddConstraintAttribute:constraintAttribute relation:relation view:view attribute:attribute constant:constant priority:priority multiplier:1.0f];
}

- (NSLayoutConstraint*)moAddConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier {
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:constraintAttribute relatedBy:relation toItem:view attribute:attribute multiplier:multiplier constant:constant];
    constraint.priority = priority;
    [self.superview addConstraint:constraint];
    return constraint;
}

- (void)moRemoveAllConstraints {
    [self removeConstraints:self.constraints];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface UIScrollView (MobilyUI_Keyboard)

@property(nonatomic, readwrite, assign) BOOL moKeyboardShowed;
@property(nonatomic, readwrite, weak) UIResponder* moKeyboardResponder;
@property(nonatomic, readwrite, assign) UIEdgeInsets moKeyboardContentInset;
@property(nonatomic, readwrite, assign) UIEdgeInsets moKeyboardIndicatorInset;

@end

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

#pragma mark Property

- (void)setMoKeyboardShowed:(BOOL)moKeyboardShowed {
    if(self.moKeyboardShowed != moKeyboardShowed) {
        if((moKeyboardShowed == NO) && (self.moKeyboardResponder != nil)) {
            if([self isKindOfClass:MobilyDataView.class] == YES) {
                MobilyDataView* dataView = (MobilyDataView*)self;
                dataView.containerInsets = self.moKeyboardContentInset;
            } else {
                self.contentInset = self.moKeyboardContentInset;
                self.scrollIndicatorInsets = self.moKeyboardIndicatorInset;
            }
            self.moKeyboardResponder = nil;
        }
        objc_setAssociatedObject(self, @selector(moKeyboardShowed), @(moKeyboardShowed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if(moKeyboardShowed == YES) {
            if([self isKindOfClass:MobilyDataView.class] == YES) {
                MobilyDataView* dataView = (MobilyDataView*)self;
                self.moKeyboardContentInset = dataView.containerInsets;
            } else {
                self.moKeyboardContentInset = self.contentInset;
                self.moKeyboardIndicatorInset = self.scrollIndicatorInsets;
            }
            self.moKeyboardResponder = [UIResponder moCurrentFirstResponderInView:self];
        }
    }
}

- (BOOL)moKeyboardShowed {
    return [objc_getAssociatedObject(self, @selector(moKeyboardShowed)) boolValue];
}

- (void)setMoKeyboardResponder:(UIResponder*)moKeyboardResponder {
    objc_setAssociatedObject(self, @selector(moKeyboardResponder), moKeyboardResponder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIResponder*)moKeyboardResponder {
    return objc_getAssociatedObject(self, @selector(moKeyboardResponder));
}

- (void)setMoKeyboardContentInset:(UIEdgeInsets)moKeyboardContentInset {
    objc_setAssociatedObject(self, @selector(moKeyboardContentInset), [NSValue valueWithUIEdgeInsets:moKeyboardContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)moKeyboardContentInset {
    return [objc_getAssociatedObject(self, @selector(moKeyboardContentInset)) UIEdgeInsetsValue];
}

- (void)setMoKeyboardIndicatorInset:(UIEdgeInsets)moKeyboardIndicatorInset {
    objc_setAssociatedObject(self, @selector(moKeyboardIndicatorInset), [NSValue valueWithUIEdgeInsets:moKeyboardIndicatorInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)moKeyboardIndicatorInset {
    return [objc_getAssociatedObject(self, @selector(moKeyboardIndicatorInset)) UIEdgeInsetsValue];
}

- (void)setMoKeyboardInset:(UIEdgeInsets)moKeyboardInset {
    objc_setAssociatedObject(self, @selector(moKeyboardInset), [NSValue valueWithUIEdgeInsets:moKeyboardInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)moKeyboardInset {
    NSValue* value = objc_getAssociatedObject(self, @selector(moKeyboardInset));
    if(value != nil) {
        return value.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsMake(2.0f, 0.0f, 2.0f, 0.0f);
}

- (void)setMoContentOffsetX:(CGFloat)moContentOffsetX {
    [self setContentOffset:CGPointMake(moContentOffsetX, self.contentOffset.y)];
}

- (CGFloat)moContentOffsetX {
    return self.contentOffset.x;
}

- (void)setMoContentOffsetY:(CGFloat)moContentOffsetY {
    [self setContentOffset:CGPointMake(self.contentOffset.x, moContentOffsetY)];
}

- (CGFloat)moContentOffsetY {
    return self.contentOffset.y;
}

- (void)setMoContentSizeWidth:(CGFloat)moContentSizeWidth {
    [self setContentSize:CGSizeMake(moContentSizeWidth, self.contentSize.height)];
}

- (CGFloat)moContentSizeWidth {
    return self.contentSize.width;
}

- (void)setMoContentSizeHeight:(CGFloat)moContentSizeHeight {
    self.contentSize = CGSizeMake(self.contentSize.width, moContentSizeHeight);
}

- (CGFloat)moContentSizeHeight {
    return self.contentSize.height;
}

- (void)setMoContentInsetTop:(CGFloat)moContentInsetTop {
    self.contentInset = UIEdgeInsetsMake(moContentInsetTop, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
}

- (CGFloat)moContentInsetTop {
    return self.contentInset.top;
}

- (void)setMoContentInsetRight:(CGFloat)moContentInsetRight {
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom, moContentInsetRight);
}

- (CGFloat)moContentInsetRight {
    return self.contentInset.right;
}

- (void)setMoContentInsetBottom:(CGFloat)moContentInsetBottom {
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, moContentInsetBottom, self.contentInset.right);
}

- (CGFloat)moContentInsetBottom {
    return self.contentInset.bottom;
}

- (void)setMoContentInsetLeft:(CGFloat)moContentInsetLeft {
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, moContentInsetLeft, self.contentInset.bottom, self.contentInset.right);
}

- (CGFloat)moContentInsetLeft {
    return self.contentInset.left;
}

- (void)setMoScrollIndicatorInsetTop:(CGFloat)moScrollIndicatorInsetTop {
    self.scrollIndicatorInsets = UIEdgeInsetsMake(moScrollIndicatorInsetTop, self.scrollIndicatorInsets.left, self.scrollIndicatorInsets.bottom, self.scrollIndicatorInsets.right);
}

- (CGFloat)moScrollIndicatorInsetTop {
    return self.scrollIndicatorInsets.top;
}

- (void)setMoScrollIndicatorInsetRight:(CGFloat)moScrollIndicatorInsetRight {
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.scrollIndicatorInsets.top, self.scrollIndicatorInsets.left, self.scrollIndicatorInsets.bottom, moScrollIndicatorInsetRight);
}

- (CGFloat)moScrollIndicatorInsetRight {
    return self.scrollIndicatorInsets.right;
}

- (void)setMoScrollIndicatorInsetBottom:(CGFloat)moScrollIndicatorInsetBottom {
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.scrollIndicatorInsets.top, self.scrollIndicatorInsets.left, moScrollIndicatorInsetBottom, self.scrollIndicatorInsets.right);
}

- (CGFloat)moScrollIndicatorInsetBottom {
    return self.scrollIndicatorInsets.bottom;
}

- (void)setMoScrollIndicatorInsetLeft:(CGFloat)moScrollIndicatorInsetLeft {
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.scrollIndicatorInsets.top, moScrollIndicatorInsetLeft, self.scrollIndicatorInsets.bottom, self.scrollIndicatorInsets.right);
}

- (CGFloat)moScrollIndicatorInsetLeft {
    return self.scrollIndicatorInsets.left;
}

- (CGRect)moVisibleBounds {
    return UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
}

#pragma mark Public

- (void)setMoContentOffsetX:(CGFloat)moContentOffsetX animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(moContentOffsetX, self.contentOffset.y) animated:animated];
}

- (void)setMoContentOffsetY:(CGFloat)moContentOffsetY animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, moContentOffsetY) animated:animated];
}

- (void)moRegisterAdjustmentResponder {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustmentNotificationKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustmentNotificationKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustmentNotificationKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adjustmentNotificationKeyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)moUnregisterAdjustmentResponder {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark UIKeyboarNotification

- (void)adjustmentNotificationKeyboardShow:(NSNotification*)notification {
    self.moKeyboardShowed = YES;
    CGRect scrollRect = [self convertRect:self.bounds toView:nil];
    CGRect keyboardRect = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect intersectionRect = CGRectIntersection(scrollRect, keyboardRect);
    if(CGRectIsNull(intersectionRect) == NO) {
        if(intersectionRect.size.height > MOBILY_EPSILON) {
            if([self isKindOfClass:MobilyDataView.class] == YES) {
                MobilyDataView* dataView = (MobilyDataView*)self;
                UIEdgeInsets containerInsets = dataView.containerInsets;
                containerInsets.bottom = intersectionRect.size.height;
                dataView.containerInsets = containerInsets;
            } else {
                UIEdgeInsets contentInsets = self.contentInset;
                UIEdgeInsets indicatorInsets = self.scrollIndicatorInsets;
                contentInsets.bottom = indicatorInsets.bottom = intersectionRect.size.height;
                self.contentInset = contentInsets;
                self.scrollIndicatorInsets = indicatorInsets;
            }
        }
        if([self.moKeyboardResponder isKindOfClass:UIView.class] == YES) {
            CGRect visibleRect = UIEdgeInsetsInsetRect(self.moVisibleBounds, self.moKeyboardInset);
            CGRect responderRect = [(UIView*)self.moKeyboardResponder convertRect:((UIView*)self.moKeyboardResponder).bounds toView:self];
            if(CGRectContainsRect(visibleRect, responderRect) == NO) {
                CGPoint contentOffset = self.contentOffset;
                CGFloat vrsx = CGRectGetMinX(visibleRect), vrsy = CGRectGetMinY(visibleRect);
                CGFloat vrex = CGRectGetMaxX(visibleRect), vrey = CGRectGetMaxY(visibleRect);
                CGFloat vrcx = CGRectGetMidX(visibleRect), vrcy = CGRectGetMidY(visibleRect);
                CGFloat rrsx = CGRectGetMinX(responderRect), rrsy = CGRectGetMinY(responderRect);
                CGFloat rrex = CGRectGetMaxX(responderRect), rrey = CGRectGetMaxY(responderRect);
                CGFloat rrcx = CGRectGetMidX(responderRect), rrcy = CGRectGetMidY(responderRect);
                if((vrex - vrsx) < (rrex - rrsx)) {
                    contentOffset.x += vrcx - rrcx;
                } else if(vrsx > rrsx) {
                    contentOffset.x -= vrsx - rrsx;
                } else if(vrex < rrex) {
                    contentOffset.x -= vrex - rrex;
                }
                if((vrey - vrsy) < (rrey - rrsy)) {
                    contentOffset.y += vrcy - rrcy;
                } else if(vrsy > rrsy) {
                    contentOffset.y -= vrsy - rrsy;
                } else if(vrey < rrey) {
                    contentOffset.y -= vrey - rrey;
                }
                [self setContentOffset:contentOffset animated:YES];
            }
        }
    }
}

- (void)adjustmentNotificationKeyboardHide:(NSNotification* __unused)notification {
    self.moKeyboardShowed = NO;
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

- (void)setMoSelectedItemIndex:(NSUInteger)moSelectedItemIndex {
    self.selectedItem = (self.items)[moSelectedItemIndex];
}

- (NSUInteger)moSelectedItemIndex {
    return [self.items indexOfObject:self.selectedItem];
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

- (CGSize)moImplicitSize {
    return [self moImplicitSizeForSize:CGSizeMake(NSIntegerMax, NSIntegerMax)];
}

- (CGSize)moImplicitSizeForWidth:(CGFloat)width {
    return [self moImplicitSizeForSize:CGSizeMake(width, NSIntegerMax)];
}

- (CGSize)moImplicitSizeForSize:(CGSize)size {
    return [self.text moImplicitSizeWithFont:self.font forSize:size lineBreakMode:self.lineBreakMode];
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

MOBILY_DEFINE_VALIDATE_STRING(MoNormalTitle)
MOBILY_DEFINE_VALIDATE_COLOR(MoNormalTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoNormalTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(MoNormalImage)
MOBILY_DEFINE_VALIDATE_IMAGE(MoNormalBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(MoHighlightedTitle)
MOBILY_DEFINE_VALIDATE_COLOR(MoHighlightedTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoHighlightedTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(MoHighlightedImage)
MOBILY_DEFINE_VALIDATE_IMAGE(MoHighlightedBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(MoDisabledTitle)
MOBILY_DEFINE_VALIDATE_COLOR(MoDisabledTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoDisabledTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(MoDisabledImage)
MOBILY_DEFINE_VALIDATE_IMAGE(MoDisabledBackgroundImage)
MOBILY_DEFINE_VALIDATE_STRING(MoSelectedTitle)
MOBILY_DEFINE_VALIDATE_COLOR(MoSelectedTitleColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoSelectedTitleShadowColor)
MOBILY_DEFINE_VALIDATE_IMAGE(MoSelectedImage)
MOBILY_DEFINE_VALIDATE_IMAGE(MoSelectedBackgroundImage)

#pragma mark Property

- (void)setMoNormalTitle:(NSString*)moNormalTitle {
    [self setTitle:moNormalTitle forState:UIControlStateNormal];
}

- (NSString*)moNormalTitle {
    return [self titleForState:UIControlStateNormal];
}

- (void)setMoNormalTitleColor:(UIColor*)moNormalTitleColor {
    [self setTitleColor:moNormalTitleColor forState:UIControlStateNormal];
}

- (UIColor*)moNormalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setMoNormalTitleShadowColor:(UIColor*)moNormalTitleShadowColor {
    [self setTitleShadowColor:moNormalTitleShadowColor forState:UIControlStateNormal];
}

- (UIColor*)moNormalTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateNormal];
}

- (void)setMoNormalImage:(UIImage*)moNormalImage {
    [self setImage:moNormalImage forState:UIControlStateNormal];
}

- (UIImage*)moNormalImage {
    return [self imageForState:UIControlStateNormal];
}

- (void)setMoNormalBackgroundImage:(UIImage*)moNormalBackgroundImage {
    [self setBackgroundImage:moNormalBackgroundImage forState:UIControlStateNormal];
}

- (UIImage*)moNormalBackgroundImage {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setMoHighlightedTitle:(NSString*)moHighlightedTitle {
    [self setTitle:moHighlightedTitle forState:UIControlStateHighlighted];
}

- (NSString*)moHighlightedTitle {
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setMoHighlightedTitleColor:(UIColor*)moHighlightedTitleColor {
    [self setTitleColor:moHighlightedTitleColor forState:UIControlStateHighlighted];
}

- (UIColor*)moHighlightedTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setMoHighlightedTitleShadowColor:(UIColor*)moHighlightedTitleShadowColor {
    [self setTitleShadowColor:moHighlightedTitleShadowColor forState:UIControlStateHighlighted];
}

- (UIColor*)moHighlightedTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateHighlighted];
}

- (void)setMoHighlightedImage:(UIImage*)moHighlightedImage {
    [self setImage:moHighlightedImage forState:UIControlStateHighlighted];
}

- (UIImage*)moHighlightedImage {
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setMoHighlightedBackgroundImage:(UIImage*)moHighlightedBackgroundImage {
    [self setBackgroundImage:moHighlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (UIImage*)moHighlightedBackgroundImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setMoSelectedTitle:(NSString*)moSelectedTitle {
    [self setTitle:moSelectedTitle forState:UIControlStateSelected];
}

- (NSString*)moSelectedTitle {
    return [self titleForState:UIControlStateSelected];
}

- (void)setMoSelectedTitleColor:(UIColor*)moSelectedTitleColor {
    [self setTitleColor:moSelectedTitleColor forState:UIControlStateSelected];
}

- (UIColor*)moSelectedTitleColor {
    return [self titleColorForState:UIControlStateSelected];
}

- (void)setMoSelectedTitleShadowColor:(UIColor*)moSelectedTitleShadowColor {
    [self setTitleShadowColor:moSelectedTitleShadowColor forState:UIControlStateSelected];
}

- (UIColor*)moSelectedTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateSelected];
}

- (void)setMoSelectedImage:(UIImage*)moSelectedImage {
    [self setImage:moSelectedImage forState:UIControlStateSelected];
}

- (UIImage*)moSelectedImage {
    return [self imageForState:UIControlStateSelected];
}

- (void)setMoSelectedBackgroundImage:(UIImage*)moSelectedBackgroundImage {
    [self setBackgroundImage:moSelectedBackgroundImage forState:UIControlStateSelected];
}

- (UIImage*)moSelectedBackgroundImage {
    return [self backgroundImageForState:UIControlStateSelected];
}

- (void)setMoDisabledTitle:(NSString*)moDisabledTitle {
    [self setTitle:moDisabledTitle forState:UIControlStateDisabled];
}

- (NSString*)moDisabledTitle {
    return [self titleForState:UIControlStateDisabled];
}

- (void)setMoDisabledTitleColor:(UIColor*)moDisabledTitleColor {
    [self setTitleColor:moDisabledTitleColor forState:UIControlStateDisabled];
}

- (UIColor*)moDisabledTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}

- (void)setMoDisabledTitleShadowColor:(UIColor*)moDisabledTitleShadowColor {
    [self setTitleShadowColor:moDisabledTitleShadowColor forState:UIControlStateDisabled];
}

- (UIColor*)moDisabledTitleShadowColor {
    return [self titleShadowColorForState:UIControlStateDisabled];
}

- (void)setMoDisabledImage:(UIImage*)moDisabledImage {
    [self setImage:moDisabledImage forState:UIControlStateDisabled];
}

- (UIImage*)moDisabledImage {
    return [self imageForState:UIControlStateDisabled];
}

- (void)setMoDisabledBackgroundImage:(UIImage*)moDisabledBackgroundImage {
    [self setBackgroundImage:moDisabledBackgroundImage forState:UIControlStateDisabled];
}

- (UIImage*)moDisabledBackgroundImage {
    return [self backgroundImageForState:UIControlStateDisabled];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_STRING(Title)
MOBILY_DEFINE_VALIDATE_BOOL(HidesBottomBarWhenPushed)

#pragma mark Public

- (void)moLoadViewIfNeed {
    if(self.isViewLoaded == NO) {
        [self loadView];
    }
}

- (void)moUnloadViewIfPossible {
    if(self.isViewLoaded == YES) {
        if(self.view.window == nil) {
            self.view = nil;
        }
    }
}

- (void)moUnloadView {
    if(self.isViewLoaded == YES) {
        self.view = nil;
    }
}

- (UIViewController*)moCurrentController {
    return [UIViewController _moCurrentController:self];
}

#pragma mark Private

+ (UIViewController*)_moCurrentController:(UIViewController*)rootViewController {
    if([rootViewController presentedViewController] != nil) {
        return [self _moCurrentController:[rootViewController presentedViewController]];
    }
    if([rootViewController isKindOfClass:UINavigationController.class] == YES) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self _moCurrentController:navigationController.topViewController];
    } else if([rootViewController isKindOfClass:UITabBarController.class] == YES) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self _moCurrentController:tabBarController.selectedViewController];
    } else if([rootViewController isKindOfClass:MobilySlideController.class] == YES) {
        MobilySlideController* slideController = (MobilySlideController*)rootViewController;
        if(slideController.isShowedLeftController == YES) {
            return [self _moCurrentController:slideController.leftController];
        } else if(slideController.isShowedRightController == YES) {
            return [self _moCurrentController:slideController.rightController];
        }
        return [self _moCurrentController:slideController.centerController];
    }
    return rootViewController;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UINavigationController (MobilyUI)

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_BOOL(NavigationBarHidden)
MOBILY_DEFINE_VALIDATE_BOOL(ToolbarHidden)
MOBILY_DEFINE_VALIDATE_BOOL(MoTranslucent)
MOBILY_DEFINE_VALIDATE_COLOR(MoTintColor)
MOBILY_DEFINE_VALIDATE_COLOR(MoBarTintColor)
MOBILY_DEFINE_VALIDATE_IMAGE(MoShadowImage)
//MOBILY_DEFINE_VALIDATE_TEXT_ATTRIBUTES(MoTitleTextAttributes)
MOBILY_DEFINE_VALIDATE_IMAGE(MoBackIndicatorImage)
MOBILY_DEFINE_VALIDATE_IMAGE(MoBackIndicatorTransitionMaskImage)

#pragma mark Property

- (void)setMoTranslucent:(BOOL)moTranslucent {
    [self.navigationBar setTranslucent:moTranslucent];
}

- (BOOL)moTranslucent {
    return [self.navigationBar isTranslucent];
}

- (void)setMoTintColor:(UIColor*)moTintColor {
    [self.navigationBar setTintColor:moTintColor];
}

- (UIColor*)moTintColor {
    return [self.navigationBar tintColor];
}

- (void)setMoBarTintColor:(UIColor*)moBarTintColor {
    [self.navigationBar setBarTintColor:moBarTintColor];
}

- (UIColor*)moBarTintColor {
    return [self.navigationBar barTintColor];
}

- (void)setMoShadowImage:(UIImage*)moShadowImage {
    [self.navigationBar setShadowImage:moShadowImage];
}

- (UIImage*)moShadowImage {
    return [self.navigationBar shadowImage];
}

- (void)setMoTitleTextAttributes:(NSDictionary*)moTitleTextAttributes {
    [self.navigationBar setTitleTextAttributes:moTitleTextAttributes];
}

- (NSDictionary*)moTitleTextAttributes {
    return [self.navigationBar titleTextAttributes];
}

- (void)setMoBackIndicatorImage:(UIImage*)moBackIndicatorImage {
    [self.navigationBar setBackIndicatorImage:moBackIndicatorImage];
}

- (UIImage*)moBackIndicatorImage {
    return [self.navigationBar backIndicatorImage];
}

- (void)setMoBackIndicatorTransitionMaskImage:(UIImage*)moBackIndicatorTransitionMaskImage {
    [self.navigationBar setBackIndicatorTransitionMaskImage:moBackIndicatorTransitionMaskImage];
}

- (UIImage*)moBackIndicatorTransitionMaskImage {
    return [self.navigationBar backIndicatorTransitionMaskImage];
}

- (UIViewController*)moRootController {
    NSArray* viewControllers = self.viewControllers;
    if(viewControllers.count > 0) {
        return viewControllers[0];
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

- (UIBarButtonItem*)moAddLeftBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated {
    UIBarButtonItem* fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpaceItem setWidth:fixedSpaceWidth];
    [self moAddLeftBarButtonItem:fixedSpaceItem animated:animated];
    return fixedSpaceItem;
}

- (UIBarButtonItem*)moAddRightBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated {
    UIBarButtonItem* fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpaceItem setWidth:fixedSpaceWidth];
    [self moAddRightBarButtonItem:fixedSpaceItem animated:animated];
    return fixedSpaceItem;
}

- (MobilyImageView*)moAddLeftBarImageUrl:(NSURL*)imageUrl defaultImage:(UIImage*)defaultImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    MobilyImageView* imageView = [[MobilyImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)];
    imageView.defaultImage = defaultImage;
    imageView.imageUrl = imageUrl;
    [self moAddLeftBarView:imageView target:target action:action animated:animated];
    return imageView;
}

- (MobilyImageView*)moAddRightBarImageUrl:(NSURL*)imageUrl defaultImage:(UIImage*)defaultImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    MobilyImageView* imageView = [[MobilyImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)];
    imageView.defaultImage = defaultImage;
    imageView.imageUrl = imageUrl;
    [self moAddRightBarView:imageView target:target action:action animated:animated];
    return imageView;
}

- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalImage:normalImage highlightedImage:nil selectedImage:nil disabledImage:nil target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalImage:normalImage highlightedImage:nil selectedImage:nil disabledImage:nil target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalImage:normalImage highlightedImage:highlightedImage selectedImage:nil disabledImage:nil target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalImage:normalImage highlightedImage:highlightedImage selectedImage:nil disabledImage:nil target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalImage:normalImage highlightedImage:highlightedImage selectedImage:nil disabledImage:disabledImage target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalImage:normalImage highlightedImage:highlightedImage selectedImage:nil disabledImage:disabledImage target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.moNormalImage = normalImage;
    button.moHighlightedImage = highlightedImage;
    button.moSelectedImage = selectedImage;
    button.moDisabledImage = disabledImage;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self moAddLeftBarView:button animated:animated];
    return button;
}

- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.moNormalImage = normalImage;
    button.moHighlightedImage = highlightedImage;
    button.moSelectedImage = selectedImage;
    button.moDisabledImage = disabledImage;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self moAddRightBarView:button animated:animated];
    return button;
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:font frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font frame:(CGRect)frame target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:font frame:frame target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:nil disabledTitle:nil normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:nil disabledTitle:disabledTitle normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddLeftBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:selectedTitle disabledTitle:disabledTitle normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle
                          highlightedTitle:(NSString*)highlightedTitle
                             selectedTitle:(NSString*)selectedTitle
                             disabledTitle:(NSString*)disabledTitle
                          normalTitleColor:(UIColor*)normatTitleColor
                     highlightedTitleColor:(UIColor*)highlightedTitleColor
                        selectedTitleColor:(UIColor*)selectedTitleColor
                        disabledTitleColor:(UIColor*)disabledTitleColor
                                      font:(UIFont*)font
                                     frame:(CGRect)frame
                                    target:(id)target
                                    action:(SEL)action
                                  animated:(BOOL)animated {
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    
    // titles
    button.moNormalTitle = normalTitle;
    button.moHighlightedTitle = highlightedTitle;
    button.moSelectedTitle = selectedTitle;
    button.moDisabledTitle = disabledTitle;
    
    // title colors
    [button setTitleColor:normatTitleColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [button setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    
    // font
    button.titleLabel.font = font;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self moAddLeftBarView:button animated:animated];
    return button;
}


// right

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:font frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font frame:(CGRect)frame target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil normalTitleColor:normatTitleColor highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:font frame:frame target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:nil disabledTitle:nil normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:nil disabledTitle:disabledTitle normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated {
    return [self moAddRightBarButtonNormalTitle:normalTitle highlightedTitle:highlightedTitle selectedTitle:selectedTitle disabledTitle:disabledTitle normalTitleColor:nil highlightedTitleColor:nil selectedTitleColor:nil disabledTitleColor:nil font:nil frame:CGRectZero target:target action:action animated:animated];
}

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle
                           highlightedTitle:(NSString*)highlightedTitle
                              selectedTitle:(NSString*)selectedTitle
                              disabledTitle:(NSString*)disabledTitle
                           normalTitleColor:(UIColor*)normatTitleColor
                      highlightedTitleColor:(UIColor*)highlightedTitleColor
                         selectedTitleColor:(UIColor*)selectedTitleColor
                         disabledTitleColor:(UIColor*)disabledTitleColor
                                       font:(UIFont*)font
                                      frame:(CGRect)frame
                                     target:(id)target
                                     action:(SEL)action
                                   animated:(BOOL)animated {
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    
    // titles
    button.moNormalTitle = normalTitle;
    button.moHighlightedTitle = highlightedTitle;
    button.moSelectedTitle = selectedTitle;
    button.moDisabledTitle = disabledTitle;
    
    // title colors
    [button setTitleColor:normatTitleColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [button setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    
    // font
    button.titleLabel.font = font;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self moAddRightBarView:button animated:animated];
    return button;
}

- (UIBarButtonItem*)moAddLeftBarView:(UIView*)view animated:(BOOL)animated {
    return [self moAddLeftBarView:view target:nil action:nil animated:animated];
}

- (UIBarButtonItem*)moAddRightBarView:(UIView*)view animated:(BOOL)animated {
    return [self moAddRightBarView:view target:nil action:nil animated:animated];
}

- (UIBarButtonItem*)moAddLeftBarView:(UIView*)view target:(id)target action:(SEL)action animated:(BOOL)animated {
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if((target != nil) && (action != nil)) {
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [view addGestureRecognizer:tapGesture];
    }
    [self moAddLeftBarButtonItem:barButtonItem animated:animated];
    return barButtonItem;
}

- (UIBarButtonItem*)moAddRightBarView:(UIView*)view target:(id)target action:(SEL)action animated:(BOOL)animated {
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if((target != nil) && (action != nil)) {
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [view addGestureRecognizer:tapGesture];
    }
    [self moAddRightBarButtonItem:barButtonItem animated:animated];
    return barButtonItem;
}

- (void)moAddLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    [self setLeftBarButtonItems:[NSArray moArrayWithArray:self.leftBarButtonItems andAddingObject:barButtonItem] animated:animated];
}

- (void)moAddRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    [self setRightBarButtonItems:[NSArray moArrayWithArray:self.rightBarButtonItems andAddingObject:barButtonItem] animated:animated];
}

- (void)moRemoveLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    [self setLeftBarButtonItems:[NSArray moArrayWithArray:self.leftBarButtonItems andRemovingObject:barButtonItem] animated:animated];
}

- (void)moRemoveRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated {
    [self setRightBarButtonItems:[NSArray moArrayWithArray:self.rightBarButtonItems andRemovingObject:barButtonItem] animated:animated];
}

- (void)moRemoveAllLeftBarButtonItemsAnimated:(BOOL)animated {
    [self setLeftBarButtonItems:@[] animated:animated];
}

- (void)moRemoveAllRightBarButtonItemsAnimated:(BOOL)animated {
    [self setRightBarButtonItems:@[] animated:animated];
}

- (void)moSetLeftBarAutomaticAlignmentAnimated:(BOOL)animated {
    __block CGFloat rightWidth = 0.0f;
    [self.rightBarButtonItems moEach:^(UIBarButtonItem* barButtonItem) {
        rightWidth += barButtonItem.width;
    }];
    [self setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rightWidth, 0.0f)]] animated:animated];
}

- (void)moSetRightBarAutomaticAlignmentAnimated:(BOOL)animated {
    __block CGFloat leftWidth = 0.0f;
    [self.leftBarButtonItems moEach:^(UIBarButtonItem* barButtonItem) {
        leftWidth += barButtonItem.width;
    }];
    [self setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, leftWidth, 0.0f)]] animated:animated];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static CGFloat Mobily_SystemVersion = MOBILY_EPSILON;
static NSString* Mobily_DeviceTypeString = nil;
static NSString* Mobily_DeviceVersionString = nil;
static MobilyDeviceFamily Mobily_DeviceFamily = MobilyDeviceFamilyUnknown;
static MobilyDeviceModel Mobily_DeviceModel = MobilyDeviceModelUnknown;

/*--------------------------------------------------*/

@implementation UIDevice (MobilyUI)

+ (CGFloat)moSystemVersion {
    if(Mobily_SystemVersion <= MOBILY_EPSILON) {
        Mobily_SystemVersion = [self.currentDevice.systemVersion floatValue];
    }
    return Mobily_SystemVersion;
}

+ (BOOL)moIsSimulator {
#ifdef MOBILY_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)moIsIPhone {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)moIsIPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (NSString*)moDeviceTypeString {
    if(Mobily_DeviceTypeString == nil) {
        struct utsname systemInfo;
        uname(&systemInfo);
        Mobily_DeviceTypeString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return Mobily_DeviceTypeString;
}

+ (NSString*)moDeviceVersionString {
    if(Mobily_DeviceVersionString == nil) {
        NSString* deviceType = self.moDeviceTypeString;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,},[0-9]{1,}" options:0 error:nil];
        NSRange rangeOfVersion = [regex rangeOfFirstMatchInString:deviceType options:0 range:NSMakeRange(0, deviceType.length)];
        if((rangeOfVersion.location != NSNotFound) && (rangeOfVersion.length > 0)) {
            Mobily_DeviceVersionString = [deviceType substringWithRange:rangeOfVersion];
        }
    }
    return Mobily_DeviceVersionString;
}

+ (MobilyDeviceFamily)moFamily {
    if(Mobily_DeviceFamily == MobilyDeviceFamilyUnknown) {
#ifdef MOBILY_SIMULATOR
        Mobily_DeviceFamily = MobilyDeviceFamilySimulator;
#else
        NSDictionary* modelManifest = @{
            @"iPhone": @(MobilyDeviceFamilyPhone),
            @"iPad": @(MobilyDeviceFamilyPad),
            @"iPod": @(MobilyDeviceFamilyPod),
        };
        NSString* deviceType = self.moDeviceTypeString;
        [modelManifest enumerateKeysAndObjectsUsingBlock:^(NSString* string, NSNumber* number, BOOL* stop) {
            if([deviceType hasPrefix:string] == YES) {
                Mobily_DeviceFamily = number.unsignedIntegerValue;
                *stop = YES;
            }
        }];
#endif
    }
    return Mobily_DeviceFamily;
}

+ (MobilyDeviceModel)moModel {
    if(Mobily_DeviceModel == MobilyDeviceModelUnknown) {
#ifdef MOBILY_SIMULATOR
        switch(UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                switch(self.moDisplay) {
                    case MobilyDeviceDisplayPhone35Inch: Mobily_DeviceModel = MobilyDeviceModelPhone4S; break;
                    case MobilyDeviceDisplayPhone4Inch: Mobily_DeviceModel = MobilyDeviceModelPhone5S; break;
                    case MobilyDeviceDisplayPhone47Inch: Mobily_DeviceModel = MobilyDeviceModelPhone6; break;
                    case MobilyDeviceDisplayPhone55Inch: Mobily_DeviceModel = MobilyDeviceModelPhone6Plus; break;
                    default: Mobily_DeviceModel = MobilyDeviceModelSimulatorPhone; break;
                }
                break;
            case UIUserInterfaceIdiomPad: Mobily_DeviceModel = MobilyDeviceModelSimulatorPad; break;
            default: break;
        }
#else
        NSDictionary* familyModelManifest = @{
            @(MobilyDeviceFamilyPhone): @{
                @"1,1": @(MobilyDeviceModelPhone1),
                @"1,2": @(MobilyDeviceModelPhone3G),
                @"2,1": @(MobilyDeviceModelPhone3GS),
                @"3,1": @(MobilyDeviceModelPhone4),
                @"3,2": @(MobilyDeviceModelPhone4),
                @"3,3": @(MobilyDeviceModelPhone4),
                @"4,1": @(MobilyDeviceModelPhone4S),
                @"5,1": @(MobilyDeviceModelPhone5),
                @"5,2": @(MobilyDeviceModelPhone5),
                @"5,3": @(MobilyDeviceModelPhone5C),
                @"5,4": @(MobilyDeviceModelPhone5C),
                @"6,1": @(MobilyDeviceModelPhone5S),
                @"6,2": @(MobilyDeviceModelPhone5S),
                @"7,1": @(MobilyDeviceModelPhone6Plus),
                @"7,2": @(MobilyDeviceModelPhone6),
            },
            @(MobilyDeviceFamilyPad): @{
                @"1,1": @(MobilyDeviceModelPad1),
                @"2,1": @(MobilyDeviceModelPad2),
                @"2,2": @(MobilyDeviceModelPad2),
                @"2,3": @(MobilyDeviceModelPad2),
                @"2,4": @(MobilyDeviceModelPad2),
                @"2,5": @(MobilyDeviceModelPadMini1),
                @"2,6": @(MobilyDeviceModelPadMini1),
                @"2,7": @(MobilyDeviceModelPadMini1),
                @"3,1": @(MobilyDeviceModelPad3),
                @"3,2": @(MobilyDeviceModelPad3),
                @"3,3": @(MobilyDeviceModelPad3),
                @"3,4": @(MobilyDeviceModelPad4),
                @"3,5": @(MobilyDeviceModelPad4),
                @"3,6": @(MobilyDeviceModelPad4),
                @"4,1": @(MobilyDeviceModelPadAir1),
                @"4,2": @(MobilyDeviceModelPadAir1),
                @"4,3": @(MobilyDeviceModelPadAir1),
                @"4,4": @(MobilyDeviceModelPadMini2),
                @"4,5": @(MobilyDeviceModelPadMini2),
                @"4,6": @(MobilyDeviceModelPadMini2),
                @"4,7": @(MobilyDeviceModelPadMini3),
                @"4,8": @(MobilyDeviceModelPadMini3),
                @"4,9": @(MobilyDeviceModelPadMini3),
                @"5,3": @(MobilyDeviceModelPadAir2),
                @"5,4": @(MobilyDeviceModelPadAir2),
            },
            @(MobilyDeviceFamilyPod): @{
                @"1,1": @(MobilyDeviceModelPod1),
                @"2,1": @(MobilyDeviceModelPod2),
                @"3,1": @(MobilyDeviceModelPod3),
                @"4,1": @(MobilyDeviceModelPod4),
                @"5,1": @(MobilyDeviceModelPod5),
            },
        };
        NSDictionary* modelManifest = familyModelManifest[@(self.moFamily)];
        if(modelManifest != nil) {
            NSNumber* modelType = modelManifest[self.moDeviceVersionString];
            if(modelType != nil) {
                Mobily_DeviceModel = modelType.unsignedIntegerValue;
            }
        }
#endif
    }
    return Mobily_DeviceModel;
}

+ (MobilyDeviceDisplay)moDisplay {
    static MobilyDeviceDisplay displayType = MobilyDeviceDisplayUnknown;
    if(displayType == MobilyDeviceDisplayUnknown) {
        CGRect screenRect = UIScreen.mainScreen.bounds;
        CGFloat screenWidth = MAX(screenRect.size.width, screenRect.size.height);
        CGFloat screenHeight = MIN(screenRect.size.width, screenRect.size.height);
        switch(UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                if((screenWidth >= 736) && (screenHeight >= 414)) {
                    displayType = MobilyDeviceDisplayPhone55Inch;
                } else if((screenWidth >= 667) && (screenHeight >= 375)) {
                    displayType = MobilyDeviceDisplayPhone47Inch;
                } else if((screenWidth >= 568) && (screenHeight >= 320)) {
                    displayType = MobilyDeviceDisplayPhone4Inch;
                } else if((screenWidth >= 480) && (screenHeight >= 320)) {
                    displayType = MobilyDeviceDisplayPhone35Inch;
                }
                break;
            case UIUserInterfaceIdiomPad:
                if((screenWidth >= 1024) && (screenHeight >= 768)) {
                    displayType = MobilyDeviceDisplayPad;
                }
                break;
            default: break;
        }
    }
    return displayType;
}

@end

/*--------------------------------------------------*/
