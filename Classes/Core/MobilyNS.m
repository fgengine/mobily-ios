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

#import "MobilyObject.h"

/*--------------------------------------------------*/

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

/*--------------------------------------------------*/

@implementation NSObject (MobilyNS)

+ (NSString*)className {
    return NSStringFromClass(self.class);
}

- (NSString*)className {
    return NSStringFromClass(self.class);
}

@end

/*--------------------------------------------------*/

@implementation NSDate (MobilyNS)

+ (NSDate*)dateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* component = [NSDateComponents new];
    component.year = year;
    component.month = month;
    component.day = day;
    return [calendar dateFromComponents:component];
}

+ (NSDate*)dateByHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* component = [NSDateComponents new];
    component.hour = hour;
    component.minute = minute;
    component.second = seccond;
    return [calendar dateFromComponents:component];
}

+ (NSDate*)dateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* component = [NSDateComponents new];
    component.year = year;
    component.month = month;
    component.day = day;
    component.hour = hour;
    component.minute = minute;
    component.second = seccond;
    return [calendar dateFromComponents:component];
}

- (NSString*)formatTime {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = NSLocalizedString(@"h:mm a", @"Date format: 1:05 pm");
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)formatDate {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = NSLocalizedString(@"EEEE, LLLL d, YYYY", @"Date format: Monday, July 27, 2009");
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)formatShortTime {
    NSTimeInterval diff = abs(self.timeIntervalSinceNow);
    if(diff < MOBILY_DAY) {
        return [self formatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedString(@"EEEE", @"Date format: Monday");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedString(@"M/d/yy", @"Date format: 7/27/09") ;
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)formatDateTime {
    NSTimeInterval diff = abs(self.timeIntervalSinceNow);
    if(diff < MOBILY_DAY) {
        return [self formatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedString(@"EEE h:mm a", @"Date format: Mon 1:05 pm");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedString(@"MMM d h:mm a", @"Date format: Jul 27 1:05 pm");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"en_EN", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)formatRelativeTime {
    NSTimeInterval elapsed = abs(self.timeIntervalSinceNow);
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
    NSTimeInterval elapsed = abs(self.timeIntervalSinceNow);
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
    return (NSUInteger)self.timeIntervalSince1970;
}

- (NSDate*)extractCalendarUnit:(NSCalendarUnit)calendarUnit {
    return [self extractCalendarUnit:calendarUnit byCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)extractCalendarUnit:(NSCalendarUnit)calendarUnit byCalendar:(NSCalendar*)calendar {
    return [calendar dateFromComponents:[calendar components:calendarUnit fromDate:self]];
}

- (NSDate*)withoutDate {
    return [self withoutDateByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)withoutDateByCalendar:(NSCalendar*)calendar {
    return [self extractCalendarUnit:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) byCalendar:calendar];
}

- (NSDate*)withoutTime {
    return [self withoutTimeByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)withoutTimeByCalendar:(NSCalendar*)calendar {
    return [self extractCalendarUnit:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) byCalendar:calendar];
}

- (NSDate*)beginningOfYear {
    return [self beginningOfYearByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)beginningOfYearByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.month = 1;
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate*)endOfYear {
    return [self endOfYearByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)endOfYearByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = NSDateComponents.new;
    components.year = 1;
    return [[calendar dateByAddingComponents:components toDate:self.beginningOfYear options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)beginningOfMonth {
    return [self beginningOfMonthByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)beginningOfMonthByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate*)endOfMonth {
    return [self endOfMonthByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)endOfMonthByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = NSDateComponents.new;
    components.month = 1;
    return [[calendar dateByAddingComponents:components toDate:self.beginningOfMonth options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)beginningOfWeek {
    return [self beginningOfWeekByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)beginningOfWeekByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay) fromDate:self];
    NSInteger offset = components.weekday - (NSInteger)calendar.firstWeekday;
    components.day = components.day - offset;
    return [calendar dateFromComponents:components];
}

- (NSDate*)endOfWeek {
    return [self endOfWeekByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)endOfWeekByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = NSDateComponents.new;
    components.weekOfMonth = 1;
    return [[calendar dateByAddingComponents:components toDate:self.beginningOfWeek options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)beginningOfDay {
    return [self beginningOfDayByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)beginningOfDayByCalendar:(NSCalendar*)calendar {
    return [calendar dateFromComponents:[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self]];
}

- (NSDate*)endOfDay {
    return [self endOfDayByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)endOfDayByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = NSDateComponents.new;
    components.day = 1;
    return [[calendar dateByAddingComponents:components toDate:self.beginningOfDay options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)previousYear {
    return [self previousYearByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousYearByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.year = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextYear {
    return [self nextYearByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextYearByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.year = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousMonth {
    return [self previousMonthByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousMonthByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.month = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextMonth {
    return [self nextMonthByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextMonthByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.month = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousWeek {
    return [self previousWeekByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousWeekByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.day = -7;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextWeek {
    return [self nextWeekByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextWeekByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.day = 7;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousDay {
    return [self previousDayByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousDayByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.day = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextDay {
    return [self nextDayByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextDayByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.day = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousHour {
    return [self previousHourByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousHourByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.hour = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextHour {
    return [self nextHourByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextHourByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.hour = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousMinute {
    return [self previousMinuteByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousMinuteByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.minute = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextMinute {
    return [self nextMinuteByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextMinuteByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.minute = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)previousSecond {
    return [self previousSecondByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)previousSecondByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.second = -1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSDate*)nextSecond {
    return [self nextSecondByCalendar:NSCalendar.currentCalendar];
}

- (NSDate*)nextSecondByCalendar:(NSCalendar*)calendar {
    NSDateComponents* component = [NSDateComponents new];
    component.second = 1;
    return [calendar dateByAddingComponents:component toDate:self options:0];
}

- (NSInteger)yearsToDate:(NSDate*)date {
    return [self yearsToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)yearsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitYear fromDate:self toDate:date options:0] year];
}

- (NSInteger)monthsToDate:(NSDate*)date {
    return [self monthsToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)monthsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitMonth fromDate:self toDate:date options:0] month];
}

- (NSInteger)daysToDate:(NSDate*)date {
    return [self daysToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)daysToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitDay fromDate:self toDate:date options:0] day];
}

- (NSInteger)weeksToDate:(NSDate*)date {
    return [self weeksToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)weeksToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitWeekOfYear fromDate:self toDate:date options:0] weekOfYear];
}

- (NSInteger)hoursToDate:(NSDate*)date {
    return [self hoursToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)hoursToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitHour fromDate:self toDate:date options:0] hour];
}

- (NSInteger)minutesToDate:(NSDate*)date {
    return [self minutesToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)minutesToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitMinute fromDate:self toDate:date options:0] minute];
}

- (NSInteger)secondsToDate:(NSDate*)date {
    return [self secondsToDate:date byCalendar:NSCalendar.currentCalendar];
}

- (NSInteger)secondsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar {
    return [[calendar components:NSCalendarUnitSecond fromDate:self toDate:date options:0] second];
}

- (MobilyDateSeason)season {
    return [self seasonByCalendar:NSCalendar.currentCalendar];
}

- (MobilyDateSeason)seasonByCalendar:(NSCalendar*)calendar {
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSInteger month = [components month];
    if((month >= 3) && (month <= 5)) {
        return MobilyDateSeasonSpring;
    } else if((month >= 6) && (month <= 8)) {
        return MobilyDateSeasonSummer;
    } else if((month >= 9) && (month <= 11)) {
        return MobilyDateSeasonAutumn;
    }
    return MobilyDateSeasonWinter;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDateFormatter (MobilyNS)

+ (instancetype)dateFormatterWithFormat:(NSString*)format {
    return [self dateFormatterWithFormat:format locale:NSLocale.currentLocale];
}

+ (instancetype)dateFormatterWithFormat:(NSString*)format locale:(NSLocale*)locale {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = locale;
    return dateFormatter;
}

+ (instancetype)dateFormatterWithFormatTemplate:(NSString*)formatTemplate {
    return [self dateFormatterWithFormat:formatTemplate locale:NSLocale.currentLocale];
}

+ (instancetype)dateFormatterWithFormatTemplate:(NSString*)formatTemplate locale:(NSLocale*)locale {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:formatTemplate options:0 locale:locale];
    dateFormatter.locale = locale;
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
    NSUInteger length = self.length;
    unsigned char* bytes = (unsigned char*)self.bytes;
    NSMutableString* hex = [NSMutableString stringWithCapacity:self.length];
    for(NSUInteger i = 0; i < length; i++) {
        [hex appendFormat:@"%02X", bytes[i]];
    }
    return hex;
}

- (NSString*)toBase64 {
    NSData* data = [NSData dataWithBytes:self.bytes length:self.length];
    const uint8_t* input = (const uint8_t*)data.bytes;
    NSInteger length = data.length;
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
    return [NSString stringWithData:result encoding:NSASCIIStringEncoding];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyNS)

+ (instancetype)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding {
    return [[self alloc] initWithData:data encoding:encoding];
}

- (NSString*)stringByUppercaseFirstCharacterString {
    if(self.length > 0) {
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return NSString.string;
}

- (NSString*)stringByLowercaseFirstCharacterString {
    if(self.length > 0) {
        return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return NSString.string;
}

- (NSString*)stringByMD5 {
    unsigned char result[16];
    const char* string = self.UTF8String;
    CC_MD5(string, (CC_LONG)strlen(string), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString*)stringBySHA256 {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    const char* string = self.UTF8String;
    CC_SHA256(string, (CC_LONG)strlen(string), result);
    return [[NSString  stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]] lowercaseString];
}

- (NSString*)stringByDecodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:(__bridge NSString*)string];
        CFRelease(string);
    }
    return result;
}

- (NSString*)stringByEncodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:(__bridge NSString*)string];
        CFRelease(string);
    }
    return result;
}

- (NSMutableDictionary*)dictionaryFromQueryComponents {
    NSMutableDictionary* queryComponents = NSMutableDictionary.dictionary;
    for(NSString* keyValuePairString in [self componentsSeparatedByString:@"&"]) {
        NSArray* keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if(keyValuePairArray.count < 2) {
            continue;
        }
        NSString* key = [keyValuePairArray[0] stringByDecodingURLFormat];
        NSString* value = [keyValuePairArray[1] stringByDecodingURLFormat];
        NSMutableArray* results = queryComponents[key];
        if(results == nil) {
            results = [NSMutableArray arrayWithCapacity:1];
            queryComponents[key] = results;
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
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formatter numberFromString:self];
}

- (NSDate*)convertToDateWithFormat:(NSString*)format {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
    }
    formatter.dateFormat = format;
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

+ (NSString*)rightWordFormByCount:(NSInteger)count andForms:(NSArray*)forms {
    NSInteger count100 = (ABS(count) % 100);
    NSInteger count10 = count100 % 10;
    
    if(count100 > 10 && count100 < 20) return forms[2];
    if(count10 > 1 && count10 < 5) return forms[1];
    if(count10 == 1) return forms[0];
    return forms[2];
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
    result[index] = object;
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
    NSMutableArray* result = NSMutableArray.array;
    for(id object in self) {
        if([object isKindOfClass:objectClass] == YES) {
            [result addObject:object];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray*)arrayByObjectProtocol:(Protocol*)objectProtocol {
    NSMutableArray* result = NSMutableArray.array;
    for(id object in self) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            [result addObject:object];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (id)firstObjectIsClass:(Class)objectClass {
    id result = nil;
    for(id object in self) {
        if([object isKindOfClass:objectClass] == YES) {
            result = object;
            break;
        }
    }
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
    id result = nil;
    for(id object in self) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            result = object;
            break;
        }
    }
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

- (BOOL)containsObjectsInArray:(NSArray*)objectsArray {
    for(id object in self) {
        if([self containsObject:object] == NO) {
            return NO;
        }
    }
    return (self.count > 0);
}

- (NSUInteger)nextIndexOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index == self.count - 1) {
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
        if(index < self.count - 1) {
            return self[index + 1];
        }
    }
    return nil;
}

- (id)prevObjectOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index != 0) {
            return self[index - 1];
        }
    }
    return nil;
}

- (void)enumerateObjectsAtRange:(NSRange)range options:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block {
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range] options:options usingBlock:block];
}

- (void)each:(void(^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        block(object);
    }];
}

- (void)eachWithIndex:(void(^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object, index);
    }];
}

- (void)each:(void(^)(id object))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object);
    }];
}

- (void)eachWithIndex:(void(^)(id object, NSUInteger index))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object, index);
    }];
}

- (NSArray*)map:(id(^)(id object))block {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.count];
    for(id object in self) {
        id temp = block(object);
        if(temp != nil) {
            [array addObject:temp];
        }
    }
    return array;
}

- (NSArray*)select:(BOOL(^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings) {
        return (block(evaluatedObject) == YES);
    }]];
}

- (NSArray*)reject:(BOOL(^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings) {
        return (block(evaluatedObject) == NO);
    }]];
}

- (id)find:(BOOL(^)(id object))block {
    for(id object in self) {
        if(block(object) == YES) {
            return object;
        }
    }
    return nil;
}

- (NSArray*)reverse {
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray*)intersectionWithArray:(NSArray*)array {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", array]];
}

- (NSArray*)intersectionWithArrays:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self intersectionWithArray:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray intersectionWithArray:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)unionWithArray:(NSArray*)array {
    return [[self relativeComplement:array] arrayByAddingObjectsFromArray:array];
}

- (NSArray*)unionWithArrays:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self unionWithArray:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray unionWithArray:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)relativeComplement:(NSArray*)array {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF IN %@", array]];
}

- (NSArray*)relativeComplements:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self relativeComplement:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray relativeComplement:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)symmetricDifference:(NSArray*)array {
    NSArray* subA = [array relativeComplement:self];
    NSArray* subB = [self relativeComplement:array];
    return [subB unionWithArray:subA];
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
    [self removeObjectsInRange:NSMakeRange((self.count - 1) - count, count)];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDictionary (MobilyNS)

- (BOOL)boolValueForKey:(NSString*)key orDefault:(BOOL)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.boolValue;
    }
    return defaultValue;
}

- (NSInteger)integerValueForKey:(NSString*)key orDefault:(NSInteger)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.integerValue;
    }
    return defaultValue;
}

- (NSUInteger)unsignedIntegerValueForKey:(NSString*)key orDefault:(NSUInteger)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.unsignedIntegerValue;
    }
    return defaultValue;
}

- (float)floatValueForKey:(NSString*)key orDefault:(float)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.floatValue;
    }
    return defaultValue;
}

- (double)doubleValueForKey:(NSString*)key orDefault:(double)defaultValue {
    NSNumber* number = [self numberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.doubleValue;
    }
    return defaultValue;
}

- (NSNumber*)numberValueForKey:(NSString*)key orDefault:(NSNumber*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSNumber.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)stringValueForKey:(NSString*)key orDefault:(NSString*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSString.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSArray*)arrayValueForKey:(NSString*)key orDefault:(NSArray*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSArray.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSDictionary*)dictionaryValueForKey:(NSString*)key orDefault:(NSDictionary*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSDictionary.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)stringFromQueryComponents {
    NSString* result = nil;
    for(NSString* dictKey in self.allKeys) {
        NSString* key = [dictKey stringByEncodingURLFormat];
        NSArray* allValues = self[key];
        if([allValues isKindOfClass:NSArray.class]) {
            for(NSString* dictValue in allValues) {
                NSString* value = [dictValue.description stringByEncodingURLFormat];
                if(result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@", key, value];
                } else {
                    result = [result stringByAppendingFormat:@"&%@=%@", key, value];
                }
            }
        } else {
            NSString* value = [allValues.description stringByEncodingURLFormat];
            if(result == nil) {
                result = [NSString stringWithFormat:@"%@=%@", key, value];
            } else {
                result = [result stringByAppendingFormat:@"&%@=%@", key, value];
            }
        }
    }
    return result;
}

- (void)each:(void(^)(id key, id value))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (void)eachWithIndex:(void(^)(id key, id value, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj, index);
        index++;
    }];
}

- (void)eachKey:(void(^)(id key))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
}

- (void)eachKeyWithIndex:(void(^)(id key, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, index);
        index++;
    }];
}

- (void)eachValue:(void(^)(id value))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
}

- (void)eachValueWithIndex:(void(^)(id value, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj, index);
        index++;
    }];
}

- (NSArray*)map:(id(^)(id key, id value))block {
    NSMutableArray* array = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = block(key, obj);
        if(object != nil) {
            [array addObject:object];
        }
    }];
    return array;
}

- (BOOL)hasKey:(id)key {
    return (self[key] != nil);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSURL (MobilyNS)

- (NSMutableDictionary*)queryComponents {
    return self.query.dictionaryFromQueryComponents;
}

- (NSMutableDictionary*)fragmentComponents {
    return self.fragment.dictionaryFromQueryComponents;
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
        if(directories.count > 0) {
            result = directories.firstObject;
        }
    }
    return result;
}

+ (NSString*)cachesDirectory {
    static NSString* result = nil;
    if(result == nil) {
        NSArray* directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if(directories.count > 0) {
            result = directories.firstObject;
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
        for(NSHTTPCookie* cookie in storage.cookies) {
            NSRange range = [cookie.domain rangeOfString:domain];
            if(range.length > 0) {
                [storage deleteCookie:cookie];
            }
        }
        [NSUserDefaults.standardUserDefaults synchronize];
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
        NSFileManager* fileManager = NSFileManager.defaultManager;
        NSString* path = [[NSFileManager cachesDirectory] stringByAppendingPathComponent:[NSBundle.mainBundle bundleIdentifier]];
        if([fileManager fileExistsAtPath:path] == NO) {
            if([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil] == YES) {
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