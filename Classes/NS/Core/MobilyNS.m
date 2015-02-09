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

#import "MobilyNS.h"

/*--------------------------------------------------*/

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

/*--------------------------------------------------*/

@implementation NSDate (MobilyNS)

+ (NSDate*)dateOffsetYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days toDate:(NSDate*)date {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* component = [[NSDateComponents alloc] init];
    [component setYear:years];
    [component setMonth:months];
    [component setDay:days];
    return [calendar dateByAddingComponents:component toDate:date options:0];
}

+ (NSDate*)dateOffsetHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)secconds toDate:(NSDate*)date {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* component = [[NSDateComponents alloc] init];
    [component setHour:hours];
    [component setMinute:minutes];
    [component setSecond:secconds];
    return [calendar dateByAddingComponents:component toDate:date options:0];
}

+ (NSDate*)dateOffsetYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)secconds toDate:(NSDate*)date {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* component = [[NSDateComponents alloc] init];
    [component setYear:years];
    [component setMonth:months];
    [component setDay:days];
    [component setHour:hours];
    [component setMinute:minutes];
    [component setSecond:secconds];
    return [calendar dateByAddingComponents:component toDate:date options:0];
}

- (NSString*)formatTime {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:NSLocalizedString(@"h:mm a", @"Date format: 1:05 pm")];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)formatDate {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:NSLocalizedString(@"EEEE, LLLL d, YYYY", @"Date format: Monday, July 27, 2009")];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)formatShortTime {
    NSTimeInterval diff = abs([self timeIntervalSinceNow]);
    
    if(diff < MOBILY_DAY) {
        return [self formatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:NSLocalizedString(@"EEEE", @"Date format: Monday")];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:NSLocalizedString(@"M/d/yy", @"Date format: 7/27/09") ];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)formatDateTime {
    NSTimeInterval diff = abs([self timeIntervalSinceNow]);
    
    if(diff < MOBILY_DAY) {
        return [self formatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:NSLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm")];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:NSLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm")];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)formatRelativeTime {
    NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
    
    if(elapsed <= 1.0f) {
        return NSLocalizedString(@"just a moment ago", @"");
    } else if(elapsed < MOBILY_MINUTE) {
        int seconds = (int)(elapsed);
        return [NSString stringWithFormat:NSLocalizedString(@"%d seconds ago", @""), seconds];
    } else if(elapsed < 2.0f * MOBILY_MINUTE) {
        return NSLocalizedString(@"about a minute ago", @"");
    } else if(elapsed < MOBILY_HOUR) {
        int mins = (int)(elapsed / MOBILY_MINUTE);
        return [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago", @""), mins];
    } else if(elapsed < MOBILY_HOUR * 1.5f) {
        return NSLocalizedString(@"about an hour ago", @"");
    } else if(elapsed < MOBILY_DAY) {
        int hours = (int)((elapsed + MOBILY_HOUR * 0.5f) / MOBILY_HOUR);
        return [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", @""), hours];
    } else {
        return [self formatDateTime];
    }
}

- (NSString*)formatShortRelativeTime {
    NSTimeInterval elapsed = abs([self timeIntervalSinceNow]);
    
    if(elapsed < MOBILY_MINUTE) {
        return NSLocalizedString(@"<1m", @"Date format: less than one minute ago");
    } else if(elapsed < MOBILY_HOUR) {
        int mins = (int)(elapsed / MOBILY_MINUTE);
        return [NSString stringWithFormat:NSLocalizedString(@"%dm", @"Date format: 50m"), mins];
    } else if(elapsed < MOBILY_DAY) {
        int hours = (int)((elapsed + MOBILY_HOUR / 2) / MOBILY_HOUR);
        return [NSString stringWithFormat:NSLocalizedString(@"%dh", @"Date format: 3h"), hours];
    } else if(elapsed < MOBILY_WEEK) {
        int day = (int)((elapsed + MOBILY_DAY / 2) / MOBILY_DAY);
        return [NSString stringWithFormat:NSLocalizedString(@"%dd", @"Date format: 3d"), day];
    } else {
        return [self formatShortTime];
    }
}

+ (NSDate*)dateWithUnixTimestamp:(NSUInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (NSUInteger)unixTimestamp {
    return (NSUInteger)[self timeIntervalSince1970];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDateFormatter (MobilyNS)

+ (NSDateFormatter*)dateFormatterWithFormat:(NSString*)format {
    return [self dateFormatterWithFormat:format locale:[NSLocale currentLocale]];
}

+ (NSDateFormatter*)dateFormatterWithFormat:(NSString*)format locale:(NSLocale*)locale {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:format options:0 locale:locale]];
    [dateFormatter setLocale:locale];
    return dateFormatter;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static char NSDataBase64Table[] = "ABCDEMHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

/*--------------------------------------------------*/

@implementation NSData (MobilyNS)

- (NSString*)toHex {
    NSUInteger length = [self length];
    unsigned char* bytes = (unsigned char*)[self bytes];
    NSMutableString* hex = [NSMutableString stringWithCapacity:[self length]];
    for(NSUInteger i = 0; i < length; i++) {
        [hex appendFormat:@"%02X", bytes[i]];
    }
    return hex;
}

- (NSString*)toBase64 {
    NSData* data = [NSData dataWithBytes:[self bytes] length:[self length]];
    const uint8_t* input = (const uint8_t*)[data bytes];
    NSInteger length = [data length];
    
    NSMutableData* result = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)[result mutableBytes];
    
    for(NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for(NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if(j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] = NSDataBase64Table[(value >> 18) & 0x3F];
        output[index + 1] = NSDataBase64Table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? NSDataBase64Table[(value >> 6) & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? NSDataBase64Table[(value >> 0) & 0x3F] : '=';
    }
    return MOBILY_SAFE_AUTORELEASE([[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding]);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyNS)

+ (id)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding {
    return MOBILY_SAFE_AUTORELEASE([[self alloc] initWithData:data encoding:encoding]);
}

- (NSString*)stringByUppercaseFirstCharacterString {
    if([self length] > 0) {
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return [NSString string];
}

- (NSString*)stringByLowercaseFirstCharacterString {
    if([self length] > 0) {
        return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return [NSString string];
}

- (NSString*)stringByMD5 {
    unsigned char result[16];
    const char* string = [self UTF8String];
    CC_MD5(string, (CC_LONG)strlen(string), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString*)stringBySHA256 {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    const char* string = [self UTF8String];
    CC_SHA256(string, (CC_LONG)strlen(string), result);
    return [[NSString  stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]] lowercaseString];
}

- (NSString*)stringByDecodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, MOBILY_SAFE_BRIDGE(CFStringRef, self), CFSTR(""), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:MOBILY_SAFE_BRIDGE(NSString*, string)];
        CFRelease(string);
    }
    return result;
}

- (NSString*)stringByEncodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(NULL, MOBILY_SAFE_BRIDGE(CFStringRef, self), NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:MOBILY_SAFE_BRIDGE(NSString*, string)];
        CFRelease(string);
    }
    return result;
}

- (NSMutableDictionary*)dictionaryFromQueryComponents {
    NSMutableDictionary* queryComponents = [NSMutableDictionary dictionary];
    for(NSString* keyValuePairString in [self componentsSeparatedByString:@"&"]) {
        NSArray* keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if([keyValuePairArray count] < 2) {
            continue;
        }
        NSString* key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
        NSString* value = [[keyValuePairArray objectAtIndex:1] stringByDecodingURLFormat];
        NSMutableArray* results = [queryComponents objectForKey:key];
        if(results == nil) {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setObject:results forKey:key];
        }
        [results addObject:value];
    }
    return queryComponents;
}

- (BOOL)isEmail {
    static NSPredicate* predicate = nil;
    if(predicate == nil) {
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"];
    }
    return [predicate evaluateWithObject:self];
}

- (NSData*)HMACSHA1:(NSString*)key {
    const char* cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
}

- (BOOL)convertToBool {
    if(([self isEqualToString:@"yes"] == YES) || ([self isEqualToString:@"true"] == YES)) {
        return YES;
    }
    return NO;
}

- (NSNumber*)convertToNumber {
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return [formatter numberFromString:self];
}

- (NSDate*)convertToDateWithFormat:(NSString*)format {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
    }
    [formatter setDateFormat:format];
    return [formatter dateFromString:self];
}

- (NSTextAlignment)convertToTextAlignment {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"left"] == YES) {
        return NSTextAlignmentLeft;
    } else if([temp isEqualToString:@"center"] == YES) {
        return NSTextAlignmentCenter;
    } else if([temp isEqualToString:@"right"] == YES) {
        return NSTextAlignmentRight;
    } else if([temp isEqualToString:@"justified"] == YES) {
        return NSTextAlignmentJustified;
    } else if([temp isEqualToString:@"natural"] == YES) {
        return NSTextAlignmentNatural;
    }
    return NSTextAlignmentLeft;
}

- (NSLineBreakMode)convertToLineBreakMode {
    NSString* temp = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if([temp isEqualToString:@"word-wrap"] == YES) {
        return NSLineBreakByWordWrapping;
    } else if([temp isEqualToString:@"char-wrap"] == YES) {
        return NSLineBreakByCharWrapping;
    } else if([temp isEqualToString:@"clip"] == YES) {
        return NSLineBreakByClipping;
    } else if([temp isEqualToString:@"truncate-head"] == YES) {
        return NSLineBreakByTruncatingHead;
    } else if([temp isEqualToString:@"truncate-middle"] == YES) {
        return NSLineBreakByTruncatingMiddle;
    } else if([temp isEqualToString:@"truncate-tail"] == YES) {
        return NSLineBreakByTruncatingTail;
    }
    return NSLineBreakByWordWrapping;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSArray (MobilyNS)

+ (instancetype)arrayWithArray:(NSArray*)array andAddingObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result addObject:object];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)arrayWithArray:(NSArray*)array andAddingObjectsFromArray:(NSArray*)addingObjects {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result addObjectsFromArray:addingObjects];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)arrayWithArray:(NSArray*)array andRemovingObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result removeObject:object];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)arrayWithArray:(NSArray*)array andRemovingObjectsInArray:(NSArray*)removingObjects {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result removeObjectsInArray:removingObjects];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByReplaceObject:(id)object atIndex:(NSUInteger)index {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result replaceObjectAtIndex:index withObject:object];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByRemovedObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result removeObject:object];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByRemovedObjectsFromArray:(NSArray*)array {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result removeObjectsInArray:array];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByObjectClass:(Class)objectClass {
    NSMutableArray* result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object isKindOfClass:objectClass] == YES) {
            [result addObject:object];
        }
    }];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByObjectProtocol:(Protocol*)objectProtocol {
    NSMutableArray* result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            [result addObject:object];
        }
    }];
    return [NSArray arrayWithArray:result];
}

- (id)firstObjectIsClass:(Class)objectClass {
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object isKindOfClass:objectClass] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (id)lastObjectIsClass:(Class)objectClass {
    __block id result = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object isKindOfClass:objectClass] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (id)firstObjectIsProtocol:(Protocol*)objectProtocol {
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (id)lastObjectIsProtocol:(Protocol*)objectProtocol {
    __block id result = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (NSUInteger)nextIndexOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index == [self count] - 1) {
            index = NSNotFound;
        } else {
            index++;
        }
    }
    return index;
}

- (NSUInteger)prevIndexOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index == 0) {
            index = NSNotFound;
        } else {
            index--;
        }
    }
    return index;
}

- (id)nextObjectOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index < [self count] - 1) {
            return [self objectAtIndex:index + 1];
        }
    }
    return nil;
}

- (id)prevObjectOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index != 0) {
            return [self objectAtIndex:index - 1];
        }
    }
    return nil;
}

- (void)enumerateObjectsAtRange:(NSRange)range options:(NSEnumerationOptions)options usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range] options:options usingBlock:block];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSMutableArray (MobilyNS)

- (void)removeFirstObjectsByCount:(NSUInteger)count {
    [self removeObjectsInRange:NSMakeRange(0, count)];
}

- (void)removeLastObjectsByCount:(NSUInteger)count {
    [self removeObjectsInRange:NSMakeRange(([self count] - 1) - count, count)];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDictionary (MobilyNS)

- (BOOL)boolValueForKey:(NSString*)key orDefault:(BOOL)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return [number boolValue];
    }
    return defaultValue;
}

- (NSInteger)integerValueForKey:(NSString*)key orDefault:(NSInteger)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return [number integerValue];
    }
    return defaultValue;
}

- (NSUInteger)unsignedIntegerValueForKey:(NSString*)key orDefault:(NSUInteger)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return [number unsignedIntegerValue];
    }
    return defaultValue;
}

- (float)floatValueForKey:(NSString*)key orDefault:(float)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return [number floatValue];
    }
    return defaultValue;
}

- (double)doubleValueForKey:(NSString*)key orDefault:(double)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return [number doubleValue];
    }
    return defaultValue;
}

- (NSNumber*)numberValueForKey:(NSString*)key orDefault:(NSNumber*)defaultValue {
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNumber class]] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)stringValueForKey:(NSString*)key orDefault:(NSString*)defaultValue {
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSString class]] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSArray*)arrayValueForKey:(NSString*)key orDefault:(NSArray*)defaultValue {
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSArray class]] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSDictionary*)dictionaryValueForKey:(NSString*)key orDefault:(NSDictionary*)defaultValue {
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSDictionary class]] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)stringFromQueryComponents {
    NSString* result = nil;
    for(NSString* dictKey in [self allKeys]) {
        NSString* key = [dictKey stringByEncodingURLFormat];
        NSArray* allValues = [self objectForKey:key];
        if([allValues isKindOfClass:[NSArray class]]) {
            for(NSString* dictValue in allValues) {
                NSString* value = [[dictValue description] stringByEncodingURLFormat];
                if(result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@",key,value];
                } else {
                    result = [result stringByAppendingFormat:@"&%@=%@",key,value];
                }
            }
        } else {
            NSString* value = [[allValues description] stringByEncodingURLFormat];
            if(result == nil) {
                result = [NSString stringWithFormat:@"%@=%@",key,value];
            } else {
                result = [result stringByAppendingFormat:@"&%@=%@",key,value];
            }
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSURL (MobilyNS)

- (NSMutableDictionary*)queryComponents {
    return [[self query] dictionaryFromQueryComponents];
}

- (NSMutableDictionary*)fragmentComponents {
    return [[self fragment] dictionaryFromQueryComponents];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSFileManager (MobilyNS)

+ (NSString*)documentDirectory {
    static NSString* result = nil;
    if(result == nil) {
        NSArray* directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([directories count] > 0) {
            result = [directories firstObject];
        }
    }
    return result;
}

+ (NSString*)cachesDirectory {
    static NSString* result = nil;
    if(result == nil) {
        NSArray* directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if([directories count] > 0) {
            result = [directories firstObject];
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSHTTPCookieStorage (MobilyNS)

+ (void)clearCookieWithDomain:(NSString*)domain {
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if(storage != nil) {
        for(NSHTTPCookie* cookie in [storage cookies]) {
            NSRange range = [[cookie domain] rangeOfString:domain];
            if(range.length > 0) {
                [storage deleteCookie:cookie];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSBundle (MobilyNS)

- (id)objectForInfoDictionaryKey:(NSString*)key defaultValue:(id)defaultValue {
    id value = [self objectForInfoDictionaryKey:key];
    if(value == nil) {
        return defaultValue;
    }
    return value;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorage

+ (NSString*)fileSystemDirectory {
    static NSString* fileSystemDirectory = nil;
    if(fileSystemDirectory == nil) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString* path = [[NSFileManager cachesDirectory] stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
        if([fileManager fileExistsAtPath:path] == NO) {
            if([fileManager createDirectoryAtPath:fileSystemDirectory withIntermediateDirectories:YES attributes:nil error:nil] == YES) {
                fileSystemDirectory = path;
            }
        } else {
            fileSystemDirectory = path;
        }
    }
    return fileSystemDirectory;
}

@end

/*--------------------------------------------------*/