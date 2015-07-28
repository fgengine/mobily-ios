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

#import <MobilyCore/MobilyObject.h>

/*--------------------------------------------------*/

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

/*--------------------------------------------------*/

@implementation NSObject (MobilyNS)

+ (NSString*)moClassName {
    return NSStringFromClass(self.class);
}

- (NSString*)moClassName {
    return NSStringFromClass(self.class);
}

@end

/*--------------------------------------------------*/

@implementation NSDate (MobilyNS)

+ (NSDate*)moDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents* components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

+ (NSDate*)moDateByHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond {
    NSDateComponents* components = [NSDateComponents new];
    components.hour = hour;
    components.minute = minute;
    components.second = seccond;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

+ (NSDate*)moDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond {
    NSDateComponents* components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = seccond;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

- (NSString*)moFormatTime {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = NSLocalizedStringFromTable(@"h:mm a", @"MobilyNS", @"Date format: 1:05 pm");
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)moFormatDate {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
        formatter.dateFormat = NSLocalizedStringFromTable(@"EEEE, LLLL d, YYYY", @"MobilyNS", @"Date format: Monday, July 27, 2009");
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return [formatter stringFromDate:self];
}

- (NSString*)moFormatShortTime {
    NSTimeInterval diff = MOBILY_FABS(self.timeIntervalSinceNow);
    if(diff < MOBILY_DAY) {
        return [self moFormatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedStringFromTable(@"EEEE", @"MobilyNS", @"Date format: Monday");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedStringFromTable(@"M/d/yy", @"MobilyNS", @"Date format: 7/27/09");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)moFormatDateTime {
    NSTimeInterval diff = MOBILY_FABS(self.timeIntervalSinceNow);
    if(diff < MOBILY_DAY) {
        return [self moFormatTime];
    } else if(diff < MOBILY_5_DAYS) {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedStringFromTable(@"EEE h:mm a", @"MobilyNS", @"Date format: Mon 1:05 pm");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    } else {
        static NSDateFormatter* formatter = nil;
        if(formatter == nil) {
            formatter = [NSDateFormatter new];
            formatter.dateFormat = NSLocalizedStringFromTable(@"MMM d h:mm a", @"MobilyNS", @"Date format: Jul 27 1:05 pm");
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedStringFromTable(@"en_EN", @"MobilyNS", @"Current locale")];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        return [formatter stringFromDate:self];
    }
}

- (NSString*)moFormatRelativeTime {
    NSTimeInterval elapsed = MOBILY_FABS(self.timeIntervalSinceNow);
    if(elapsed <= 1.0f) {
        return NSLocalizedStringFromTable(@"just a moment ago", @"MobilyNS", @"");
    } else if(elapsed < MOBILY_MINUTE) {
        int seconds = (int)(elapsed);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%d seconds ago", @"MobilyNS", @""), seconds];
    } else if(elapsed < 2.0f * MOBILY_MINUTE) {
        return NSLocalizedStringFromTable(@"about a minute ago", @"MobilyNS", @"");
    } else if(elapsed < MOBILY_HOUR) {
        int mins = (int)(elapsed / MOBILY_MINUTE);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%d minutes ago", @"MobilyNS", @""), mins];
    } else if(elapsed < MOBILY_HOUR * 1.5f) {
        return NSLocalizedStringFromTable(@"about an hour ago", @"MobilyNS", @"");
    } else if(elapsed < MOBILY_DAY) {
        int hours = (int)((elapsed + MOBILY_HOUR * 0.5f) / MOBILY_HOUR);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%d hours ago", @"MobilyNS", @""), hours];
    } else {
        return [self moFormatDateTime];
    }
}

- (NSString*)moFormatShortRelativeTime {
    NSTimeInterval elapsed = MOBILY_FABS(self.timeIntervalSinceNow);
    if(elapsed < MOBILY_MINUTE) {
        return NSLocalizedStringFromTable(@"<1m", @"MobilyNS", @"Date format: less than one minute ago");
    } else if(elapsed < MOBILY_HOUR) {
        int mins = (int)(elapsed / MOBILY_MINUTE);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%dm", @"MobilyNS", @"Date format: 50m"), mins];
    } else if(elapsed < MOBILY_DAY) {
        int hours = (int)((elapsed + MOBILY_HOUR / 2) / MOBILY_HOUR);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%dh", @"MobilyNS", @"Date format: 3h"), hours];
    } else if(elapsed < MOBILY_WEEK) {
        int day = (int)((elapsed + MOBILY_DAY / 2) / MOBILY_DAY);
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%dd", @"MobilyNS", @"Date format: 3d"), day];
    } else {
        return [self moFormatShortTime];
    }
}

+ (NSDate*)moDateWithUnixTimestamp:(NSUInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (NSUInteger)moUnixTimestamp {
    return (NSUInteger)self.timeIntervalSince1970;
}


- (NSDate*)moExtractCalendarUnit:(NSCalendarUnit)calendarUnit {
    return [NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:calendarUnit fromDate:self]];
}

- (NSDate*)moWithoutDate {
    return [self moExtractCalendarUnit:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)];
}

- (NSDate*)moWithoutTime {
    return [self moExtractCalendarUnit:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)];
}

- (NSDate*)moBeginningOfYear {
    NSDateComponents* components = [NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.month = 1;
    components.day = 1;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

- (NSDate*)moEndOfYear {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.year = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfYear options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moBeginningOfMonth {
    NSDateComponents* components = [NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

- (NSDate*)moEndOfMonth {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.month = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfMonth options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moBeginningOfWeek {
    NSDateComponents* components = [NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay) fromDate:self];
    NSInteger offset = components.weekday - (NSInteger)NSCalendar.currentCalendar.firstWeekday;
    if(offset < 0) {
        offset = offset + 7;
    }
    components.day = components.day - offset;
    return [NSCalendar.currentCalendar dateFromComponents:components];
}

- (NSDate*)moEndOfWeek {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.weekOfMonth = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfWeek options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moBeginningOfDay {
    return [NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self]];
}

- (NSDate*)moEndOfDay {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.day = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfDay options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moBeginningOfHour {
    return [NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:self]];
}

- (NSDate*)moEndOfHour {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.hour = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfHour options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moBeginningOfMinute {
    return [NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self]];
}

- (NSDate*)moEndOfMinute {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = NSDateComponents.new;
        components.minute = 1;
    }
    return [[NSCalendar.currentCalendar dateByAddingComponents:components toDate:self.moBeginningOfMinute options:0] dateByAddingTimeInterval:-1];
}

- (NSDate*)moPreviousYear {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.year = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextYear {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.year = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousMonth {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.month = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextMonth {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.month = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousWeek {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.day = -7;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextWeek {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.day = 7;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousDay {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.day = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextDay {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.day = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousHour {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.hour = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextHour {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.hour = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousMinute {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.minute = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextMinute {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.minute = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moPreviousSecond {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.second = -1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moNextSecond {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.second = 1;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)moYearsToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitYear fromDate:self toDate:date options:0] year];
}

- (NSInteger)moMonthsToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitMonth fromDate:self toDate:date options:0] month];
}

- (NSInteger)moDaysToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitDay fromDate:self toDate:date options:0] day];
}

- (NSInteger)moWeeksToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitWeekOfYear fromDate:self toDate:date options:0] weekOfYear];
}

- (NSInteger)moHoursToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitHour fromDate:self toDate:date options:0] hour];
}

- (NSInteger)moMinutesToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitMinute fromDate:self toDate:date options:0] minute];
}

- (NSInteger)moSecondsToDate:(NSDate*)date {
    return [[NSCalendar.currentCalendar components:NSCalendarUnitSecond fromDate:self toDate:date options:0] second];
}

- (NSDate*)moAddYears:(NSInteger)years {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.year = years;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moAddMonths:(NSInteger)months {
    static NSDateComponents* components = nil;
    if(components == nil) {
        components = [NSDateComponents new];
        components.month = months;
    }
    return [NSCalendar.currentCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)moAddWeeks:(NSInteger)weeks {
    return [self dateByAddingTimeInterval:(MOBILY_DAY * 7)*weeks];
}

- (NSDate*)moAddDays:(NSInteger)days {
    return [self dateByAddingTimeInterval:MOBILY_DAY * days];
}

- (NSDate*)moAddHours:(NSInteger)hours {
    return [self dateByAddingTimeInterval:MOBILY_HOUR * hours];
}

- (NSDate*)moAddMinutes:(NSInteger)minutes {
    return [self dateByAddingTimeInterval:MOBILY_MINUTE * minutes];
}

- (NSDate*)moAddSeconds:(NSInteger)seconds {
    return [self dateByAddingTimeInterval:seconds];
}

- (BOOL)moIsYesterday {
    NSDate* date = NSDate.date.moPreviousDay;
    return [self moInsideFrom:date.moBeginningOfDay to:date.moEndOfDay];
}

- (BOOL)moIsToday {
    NSDate* date = NSDate.date;
    return [self moInsideFrom:date.moBeginningOfDay to:date.moEndOfDay];
}

- (BOOL)moIsTomorrow {
    NSDate* date = NSDate.date.moNextDay;
    return [self moInsideFrom:date.moBeginningOfDay to:date.moEndOfDay];
}

- (BOOL)moInsideFrom:(NSDate*)from to:(NSDate*)to {
    return ([self moIsAfterOrSame:from] == YES) && ([self moIsEarlierOrSame:to]);
}

- (BOOL)moIsEarlier:(NSDate*)anotherDate {
    return ([self compare:anotherDate] == NSOrderedAscending);
}

- (BOOL)moIsEarlierOrSame:(NSDate*)anotherDate {
    return ([self moIsEarlier:anotherDate] || [self moIsSame:anotherDate]);
}

- (BOOL)moIsSame:(NSDate*)anotherDate {
    return ([self compare:anotherDate] == NSOrderedSame);
}

- (BOOL)moIsAfter:(NSDate*)anotherDate {
    return ([self compare:anotherDate] == NSOrderedDescending);
}

- (BOOL)moIsAfterOrSame:(NSDate*)anotherDate {
    return ([self moIsAfter:anotherDate] || [self moIsSame:anotherDate]);
}

- (MobilyDateSeason)moSeason {
    NSDateComponents* components = [NSCalendar.currentCalendar components:NSCalendarUnitMonth fromDate:self];
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

- (MobilyDateWeekday)moWeekday {
    NSDateComponents* components = [NSCalendar.currentCalendar components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDateFormatter (MobilyNS)

+ (instancetype)moDateFormatterWithFormat:(NSString*)format {
    return [self moDateFormatterWithFormat:format locale:NSLocale.currentLocale];
}

+ (instancetype)moDateFormatterWithFormat:(NSString*)format locale:(NSLocale*)locale {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = locale;
    return dateFormatter;
}

+ (instancetype)moDateFormatterWithFormatTemplate:(NSString*)formatTemplate {
    return [self moDateFormatterWithFormatTemplate:formatTemplate locale:NSLocale.currentLocale];
}

+ (instancetype)moDateFormatterWithFormatTemplate:(NSString*)formatTemplate locale:(NSLocale*)locale {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:formatTemplate options:0 locale:locale];
    dateFormatter.locale = locale;
    return dateFormatter;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static char Mobily_Base64Table[] = "ABCDEMHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

/*--------------------------------------------------*/

@implementation NSData (MobilyNS)

- (NSString*)moToHex {
    NSUInteger length = self.length;
    unsigned char* bytes = (unsigned char*)self.bytes;
    NSMutableString* hex = [NSMutableString stringWithCapacity:self.length];
    for(NSUInteger i = 0; i < length; i++) {
        [hex appendFormat:@"%02X", bytes[i]];
    }
    return hex;
}

- (NSString*)moToBase64 {
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
        output[index + 0] = Mobily_Base64Table[(value >> 18) & 0x3F];
        output[index + 1] = Mobily_Base64Table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? Mobily_Base64Table[(value >> 6) & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? Mobily_Base64Table[(value >> 0) & 0x3F] : '=';
    }
    return [NSString moStringWithData:result encoding:NSASCIIStringEncoding];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSString (MobilyNS)

+ (instancetype)moStringWithData:(NSData*)data encoding:(NSStringEncoding)encoding {
    return [[self alloc] initWithData:data encoding:encoding];
}

- (NSString*)moStringByUppercaseFirstCharacterString {
    if(self.length > 0) {
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return NSString.string;
}

- (NSString*)moStringByLowercaseFirstCharacterString {
    if(self.length > 0) {
        return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
    }
    return NSString.string;
}

- (NSString*)moStringByMD5 {
    unsigned char result[16];
    const char* string = self.UTF8String;
    CC_MD5(string, (CC_LONG)strlen(string), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString*)moStringBySHA256 {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    const char* string = self.UTF8String;
    CC_SHA256(string, (CC_LONG)strlen(string), result);
    return [[NSString  stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15], result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]] lowercaseString];
}

- (NSString*)moStringByDecodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:(__bridge NSString*)string];
        CFRelease(string);
    }
    return result;
}

- (NSString*)moStringByEncodingURLFormat {
    NSString* result = nil;
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    if(string != nil) {
        result = [NSString stringWithString:(__bridge NSString*)string];
        CFRelease(string);
    }
    return result;
}

- (NSMutableDictionary*)moDictionaryFromQueryComponents {
    NSMutableDictionary* queryComponents = NSMutableDictionary.dictionary;
    for(NSString* keyValuePairString in [self componentsSeparatedByString:@"&"]) {
        NSArray* keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if(keyValuePairArray.count < 2) {
            continue;
        }
        NSString* key = [keyValuePairArray[0] moStringByDecodingURLFormat];
        NSString* value = [keyValuePairArray[1] moStringByDecodingURLFormat];
        NSMutableArray* results = queryComponents[key];
        if(results == nil) {
            results = [NSMutableArray arrayWithCapacity:1];
            queryComponents[key] = results;
        }
        [results addObject:value];
    }
    return queryComponents;
}

- (BOOL)moIsEmail {
    static NSPredicate* predicate = nil;
    if(predicate == nil) {
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", @".+@.+\\..+"];
    }
    return [predicate evaluateWithObject:self];
}

- (NSData*)moHMACSHA1:(NSString*)key {
    const char* cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
}

- (BOOL)moConvertToBool {
    if(([self isEqualToString:@"yes"] == YES) || ([self isEqualToString:@"true"] == YES)) {
        return YES;
    }
    return NO;
}

- (NSNumber*)moConvertToNumber {
    static NSNumberFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formatter numberFromString:self];
}

- (NSDate*)moConvertToDateWithFormat:(NSString*)format {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [NSDateFormatter new];
    }
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

- (NSTextAlignment)moConvertToTextAlignment {
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

- (NSLineBreakMode)moConvertToLineBreakMode {
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

+ (NSString*)moRightWordFormByCount:(NSInteger)count andForms:(NSArray*)forms {
    NSInteger count100 = (ABS(count) % 100);
    NSInteger count10 = count100 % 10;
    
    if(count100 > 10 && count100 < 20) return forms[2];
    if(count10 > 1 && count10 < 5) return forms[1];
    if(count10 == 1) return forms[0];
    return forms[2];
}

- (NSArray*)moCharactersArray {
    NSMutableArray* chars = NSMutableArray.array;
    for(int i=0; i < self.length; i++) {
        [chars addObject:[NSString stringWithFormat:@"%c", [self characterAtIndex:i]]];
    }
    return chars;
}


@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSArray (MobilyNS)

+ (instancetype)moArrayWithArray:(NSArray*)array andAddingObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result addObject:object];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)moArrayWithArray:(NSArray*)array andAddingObjectsFromArray:(NSArray*)addingObjects {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result addObjectsFromArray:addingObjects];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)moArrayWithArray:(NSArray*)array andRemovingObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result removeObject:object];
    return [NSArray arrayWithArray:result];
}

+ (instancetype)moArrayWithArray:(NSArray*)array andRemovingObjectsInArray:(NSArray*)removingObjects {
    NSMutableArray* result = [NSMutableArray arrayWithArray:array];
    [result removeObjectsInArray:removingObjects];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByReplaceObject:(id)object atIndex:(NSUInteger)index {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    result[index] = object;
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByRemovedObjectAtIndex:(NSUInteger)index {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result removeObjectAtIndex:index];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByRemovedObject:(id)object {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result removeObject:object];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByRemovedObjectsFromArray:(NSArray*)array {
    NSMutableArray* result = [NSMutableArray arrayWithArray:self];
    [result removeObjectsInArray:array];
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByObjectClass:(Class)objectClass {
    NSMutableArray* result = NSMutableArray.array;
    for(id object in self) {
        if([object isKindOfClass:objectClass] == YES) {
            [result addObject:object];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray*)moArrayByObjectProtocol:(Protocol*)objectProtocol {
    NSMutableArray* result = NSMutableArray.array;
    for(id object in self) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            [result addObject:object];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (id)moFirstObjectIsClass:(Class)objectClass {
    id result = nil;
    for(id object in self) {
        if([object isKindOfClass:objectClass] == YES) {
            result = object;
            break;
        }
    }
    return result;
}

- (id)moLastObjectIsClass:(Class)objectClass {
    __block id result = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger index __unused, BOOL *stop __unused) {
        if([object isKindOfClass:objectClass] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (id)moFirstObjectIsProtocol:(Protocol*)objectProtocol {
    id result = nil;
    for(id object in self) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            result = object;
            break;
        }
    }
    return result;
}

- (id)moLastObjectIsProtocol:(Protocol*)objectProtocol {
    __block id result = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger index __unused, BOOL *stop __unused) {
        if([object conformsToProtocol:objectProtocol] == YES) {
            result = object;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL)moContainsObjectsInArray:(NSArray*)objectsArray {
    for(id object in objectsArray) {
        if([self containsObject:object] == NO) {
            return NO;
        }
    }
    return (self.count > 0);
}

- (NSUInteger)moNextIndexOfObject:(id)object {
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

- (NSUInteger)moPrevIndexOfObject:(id)object {
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

- (id)moNextObjectOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index < self.count - 1) {
            return self[index + 1];
        }
    }
    return nil;
}

- (id)moPrevObjectOfObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        if(index != 0) {
            return self[index - 1];
        }
    }
    return nil;
}

- (void)moEnumerateObjectsAtRange:(NSRange)range options:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block {
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range] options:options usingBlock:block];
}

- (void)moEach:(void(^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index __unused, BOOL* stop __unused) {
        block(object);
    }];
}

- (void)moEachWithIndex:(void(^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop __unused) {
        block(object, index);
    }];
}

- (void)moEach:(void(^)(id object))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id object, NSUInteger index __unused, BOOL* stop __unused) {
        block(object);
    }];
}

- (void)moEachWithIndex:(void(^)(id object, NSUInteger index))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id object, NSUInteger index, BOOL* stop __unused) {
        block(object, index);
    }];
}

- (NSArray*)moMap:(id(^)(id object))block {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.count];
    for(id object in self) {
        id temp = block(object);
        if(temp != nil) {
            [array addObject:temp];
        }
    }
    return array;
}

- (NSDictionary*)moGroupBy:(id(^)(id object))block {
    NSMutableDictionary* dictionary = NSMutableDictionary.dictionary;
    for(id object in self) {
        id temp = block(object);
        if([dictionary moHasKey:temp] == YES) {
            [dictionary[temp] addObject:object];
        } else {
            dictionary[temp] = [NSMutableArray arrayWithObject:object];
        }
    }
    return dictionary;
}

- (NSArray*)moSelect:(BOOL(^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings __unused) {
        return (block(evaluatedObject) == YES);
    }]];
}

- (NSArray*)moReject:(BOOL(^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings __unused) {
        return (block(evaluatedObject) == NO);
    }]];
}

- (id)moFind:(BOOL(^)(id object))block {
    for(id object in self) {
        if(block(object) == YES) {
            return object;
        }
    }
    return nil;
}

- (NSArray*)moReverse {
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray*)moIntersectionWithArray:(NSArray*)array {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", array]];
}

- (NSArray*)moIntersectionWithArrays:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self moIntersectionWithArray:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray moIntersectionWithArray:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)moUnionWithArray:(NSArray*)array {
    return [[self moRelativeComplement:array] arrayByAddingObjectsFromArray:array];
}

- (NSArray*)moUnionWithArrays:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self moUnionWithArray:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray moUnionWithArray:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)moRelativeComplement:(NSArray*)array {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF IN %@", array]];
}

- (NSArray*)moRelativeComplements:(NSArray*)firstArray, ... {
    NSArray* resultArray = nil;
    if(firstArray != nil) {
        NSArray* eachArray = nil;
        resultArray = [self moRelativeComplement:firstArray];
        va_list argumentList;
        va_start(argumentList, firstArray);
        while((eachArray = va_arg(argumentList, id)) != nil) {
            resultArray = [resultArray moRelativeComplement:eachArray];
        }
        va_end(argumentList);
    } else {
        resultArray = @[];
    }
    return resultArray;
}

- (NSArray*)moSymmetricDifference:(NSArray*)array {
    NSArray* subA = [array moRelativeComplement:self];
    NSArray* subB = [self moRelativeComplement:array];
    return [subB moUnionWithArray:subA];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSMutableArray (MobilyNS)

- (void)moRemoveFirstObjectsByCount:(NSUInteger)count {
    [self removeObjectsInRange:NSMakeRange(0, count)];
}

- (void)moRemoveLastObjectsByCount:(NSUInteger)count {
    [self removeObjectsInRange:NSMakeRange((self.count - 1) - count, count)];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSDictionary (MobilyNS)

- (BOOL)moBoolValueForKey:(NSString*)key orDefault:(BOOL)defaultValue {
    NSNumber* number = [self moNumberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.boolValue;
    }
    return defaultValue;
}

- (NSInteger)moIntegerValueForKey:(NSString*)key orDefault:(NSInteger)defaultValue {
    NSNumber* number = [self moNumberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.integerValue;
    }
    return defaultValue;
}

- (NSUInteger)moUnsignedIntegerValueForKey:(NSString*)key orDefault:(NSUInteger)defaultValue {
    NSNumber* number = [self moNumberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.unsignedIntegerValue;
    }
    return defaultValue;
}

- (float)moFloatValueForKey:(NSString*)key orDefault:(float)defaultValue {
    NSNumber* number = [self moNumberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.floatValue;
    }
    return defaultValue;
}

- (double)moDoubleValueForKey:(NSString*)key orDefault:(double)defaultValue {
    NSNumber* number = [self moNumberValueForKey:key orDefault:nil];
    if(number != nil) {
        return number.doubleValue;
    }
    return defaultValue;
}

- (NSNumber*)moNumberValueForKey:(NSString*)key orDefault:(NSNumber*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSNumber.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)moStringValueForKey:(NSString*)key orDefault:(NSString*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSString.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSArray*)moArrayValueForKey:(NSString*)key orDefault:(NSArray*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSArray.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSDictionary*)moDictionaryValueForKey:(NSString*)key orDefault:(NSDictionary*)defaultValue {
    id value = self[key];
    if([value isKindOfClass:NSDictionary.class] == YES) {
        return value;
    }
    return defaultValue;
}

- (NSString*)moStringFromQueryComponents {
    NSString* result = nil;
    for(NSString* dictKey in self.allKeys) {
        NSString* key = [dictKey moStringByEncodingURLFormat];
        NSArray* allValues = self[key];
        if([allValues isKindOfClass:NSArray.class]) {
            for(NSString* dictValue in allValues) {
                NSString* value = [dictValue.description moStringByEncodingURLFormat];
                if(result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@", key, value];
                } else {
                    result = [result stringByAppendingFormat:@"&%@=%@", key, value];
                }
            }
        } else {
            NSString* value = [allValues.description moStringByEncodingURLFormat];
            if(result == nil) {
                result = [NSString stringWithFormat:@"%@=%@", key, value];
            } else {
                result = [result stringByAppendingFormat:@"&%@=%@", key, value];
            }
        }
    }
    return result;
}

- (void)moEach:(void(^)(id key, id value))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop __unused) {
        block(key, obj);
    }];
}

- (void)moEachWithIndex:(void(^)(id key, id value, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop __unused) {
        block(key, obj, index);
        index++;
    }];
}

- (void)moEachKey:(void(^)(id key))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj __unused, BOOL* stop __unused) {
        block(key);
    }];
}

- (void)moEachKeyWithIndex:(void(^)(id key, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj __unused, BOOL* stop __unused) {
        block(key, index);
        index++;
    }];
}

- (void)moEachValue:(void(^)(id value))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key __unused, id obj, BOOL* stop __unused) {
        block(obj);
    }];
}

- (void)moEachValueWithIndex:(void(^)(id value, NSUInteger index))block {
    __block NSInteger index = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key __unused, id obj, BOOL* stop __unused) {
        block(obj, index);
        index++;
    }];
}

- (NSArray*)moMap:(id(^)(id key, id value))block {
    NSMutableArray* array = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop __unused) {
        id object = block(key, obj);
        if(object != nil) {
            [array addObject:object];
        }
    }];
    return array;
}

- (BOOL)moHasKey:(id)key {
    return (self[key] != nil);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSURL (MobilyNS)

- (NSMutableDictionary*)moQueryComponents {
    return self.query.moDictionaryFromQueryComponents;
}

- (NSMutableDictionary*)moFragmentComponents {
    return self.fragment.moDictionaryFromQueryComponents;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSFileManager (MobilyNS)

+ (NSString*)moDocumentDirectory {
    static NSString* result = nil;
    if(result == nil) {
        NSArray* directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if(directories.count > 0) {
            result = directories.firstObject;
        }
    }
    return result;
}

+ (NSString*)moCachesDirectory {
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

+ (void)moClearCookieWithDomain:(NSString*)domain {
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

- (id)moObjectForInfoDictionaryKey:(NSString*)key defaultValue:(id)defaultValue {
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

@implementation NSError (MobilyNS)

- (BOOL)moIsNoInternetConnection {
    return ([self.domain isEqualToString:NSURLErrorDomain] || (self.code == NSURLErrorNotConnectedToInternet));
}

- (BOOL)moIsTimedOut {
    return ([self.domain isEqualToString:NSURLErrorDomain] && (self.code == NSURLErrorTimedOut));
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorage

+ (NSString*)moFileSystemDirectory {
    static NSString* fileSystemDirectory = nil;
    if(fileSystemDirectory == nil) {
        NSFileManager* fileManager = NSFileManager.defaultManager;
        NSString* path = [NSFileManager.moCachesDirectory stringByAppendingPathComponent:NSBundle.mainBundle.bundleIdentifier];
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