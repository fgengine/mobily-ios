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

#import "MobilyCore.h"

/*--------------------------------------------------*/

@interface NSObject (MobilyNS)

+ (NSString*)className;
- (NSString*)className;

@end

/*--------------------------------------------------*/

#define MOBILY_MINUTE                               60.0f
#define MOBILY_HOUR                                 (60.0f * MOBILY_MINUTE)
#define MOBILY_DAY                                  (24.0f * MOBILY_HOUR)
#define MOBILY_5_DAYS                               (5.0f * MOBILY_DAY)
#define MOBILY_WEEK                                 (7.0f * MOBILY_DAY)
#define MOBILY_MONTH                                (30.5f * MOBILY_DAY)
#define MOBILY_YEAR                                 (365.0f * MOBILY_DAY)

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDateSeason) {
    MobilyDateSeasonWinter,
    MobilyDateSeasonSpring,
    MobilyDateSeasonSummer,
    MobilyDateSeasonAutumn
};

/*--------------------------------------------------*/

@interface NSDate (MobilyNS)

+ (NSDate*)dateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate*)dateByHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond;
+ (NSDate*)dateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond;;

- (NSString*)formatTime;
- (NSString*)formatDate;
- (NSString*)formatShortTime;
- (NSString*)formatDateTime;
- (NSString*)formatRelativeTime;
- (NSString*)formatShortRelativeTime;

+ (NSDate*)dateWithUnixTimestamp:(NSUInteger)timestamp;
- (NSUInteger)unixTimestamp;

- (NSDate*)extractCalendarUnit:(NSCalendarUnit)calendarUnit;
- (NSDate*)extractCalendarUnit:(NSCalendarUnit)calendarUnit byCalendar:(NSCalendar*)calendar;
- (NSDate*)withoutDate;
- (NSDate*)withoutDateByCalendar:(NSCalendar*)calendar;
- (NSDate*)withoutTime;
- (NSDate*)withoutTimeByCalendar:(NSCalendar*)calendar;

- (NSDate*)beginningOfYear;
- (NSDate*)beginningOfYearByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfYear;
- (NSDate*)endOfYearByCalendar:(NSCalendar*)calendar;
- (NSDate*)beginningOfMonth;
- (NSDate*)beginningOfMonthByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfMonth;
- (NSDate*)endOfMonthByCalendar:(NSCalendar*)calendar;
- (NSDate*)beginningOfWeek;
- (NSDate*)beginningOfWeekByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfWeek;
- (NSDate*)endOfWeekByCalendar:(NSCalendar*)calendar;
- (NSDate*)beginningOfDay;
- (NSDate*)beginningOfDayByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfDay;
- (NSDate*)endOfDayByCalendar:(NSCalendar*)calendar;
- (NSDate*)beginningOfHour;
- (NSDate*)beginningOfHourByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfHour;
- (NSDate*)endOfHourByCalendar:(NSCalendar*)calendar;
- (NSDate*)beginningOfMinute;
- (NSDate*)beginningOfMinuteByCalendar:(NSCalendar*)calendar;
- (NSDate*)endOfMinute;
- (NSDate*)endOfMinuteByCalendar:(NSCalendar*)calendar;

- (NSDate*)previousYear;
- (NSDate*)previousYearByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextYear;
- (NSDate*)nextYearByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousMonth;
- (NSDate*)previousMonthByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextMonth;
- (NSDate*)nextMonthByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousWeek;
- (NSDate*)previousWeekByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextWeek;
- (NSDate*)nextWeekByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousDay;
- (NSDate*)previousDayByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextDay;
- (NSDate*)nextDayByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousHour;
- (NSDate*)previousHourByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextHour;
- (NSDate*)nextHourByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousMinute;
- (NSDate*)previousMinuteByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextMinute;
- (NSDate*)nextMinuteByCalendar:(NSCalendar*)calendar;
- (NSDate*)previousSecond;
- (NSDate*)previousSecondByCalendar:(NSCalendar*)calendar;
- (NSDate*)nextSecond;
- (NSDate*)nextSecondByCalendar:(NSCalendar*)calendar;

- (NSInteger)yearsToDate:(NSDate*)date;
- (NSInteger)yearsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)monthsToDate:(NSDate*)date;
- (NSInteger)monthsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)daysToDate:(NSDate*)date;
- (NSInteger)daysToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)weeksToDate:(NSDate*)date;
- (NSInteger)weeksToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)hoursToDate:(NSDate*)date;
- (NSInteger)hoursToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)minutesToDate:(NSDate*)date;
- (NSInteger)minutesToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;
- (NSInteger)secondsToDate:(NSDate*)date;
- (NSInteger)secondsToDate:(NSDate*)date byCalendar:(NSCalendar*)calendar;

- (NSDate*)addMinutes:(NSInteger)minutes;

- (MobilyDateSeason)season;
- (MobilyDateSeason)seasonByCalendar:(NSCalendar*)calendar;

@end

/*--------------------------------------------------*/

@interface NSDateFormatter (MobilyNS)

+ (instancetype)dateFormatterWithFormat:(NSString*)format;
+ (instancetype)dateFormatterWithFormat:(NSString*)format locale:(NSLocale*)locale;
+ (instancetype)dateFormatterWithFormatTemplate:(NSString*)formatTemplate;
+ (instancetype)dateFormatterWithFormatTemplate:(NSString*)formatTemplate locale:(NSLocale*)locale;

@end

/*--------------------------------------------------*/

@interface NSData (MobilyNS)

- (NSString*)toHex;

- (NSString*)toBase64;

@end

/*--------------------------------------------------*/

@interface NSString (MobilyNS)

+ (id)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

- (NSString*)stringByUppercaseFirstCharacterString;
- (NSString*)stringByLowercaseFirstCharacterString;

- (NSString*)stringByMD5;
- (NSString*)stringBySHA256;

- (NSString*)stringByDecodingURLFormat;
- (NSString*)stringByEncodingURLFormat;
- (NSMutableDictionary*)dictionaryFromQueryComponents;

- (BOOL)isEmail;

- (NSData*)HMACSHA1:(NSString*)key;

- (BOOL)convertToBool;
- (NSNumber*)convertToNumber;
- (NSDate*)convertToDateWithFormat:(NSString*)format;

- (NSTextAlignment)convertToTextAlignment;
- (NSLineBreakMode)convertToLineBreakMode;

+ (NSString*)rightWordFormByCount:(NSInteger)count andForms:(NSArray*)forms;

@end

/*--------------------------------------------------*/

@interface NSArray (MobilyNS)

+ (instancetype)arrayWithArray:(NSArray*)array andAddingObject:(id)object;
+ (instancetype)arrayWithArray:(NSArray*)array andAddingObjectsFromArray:(NSArray*)addingObjects;
+ (instancetype)arrayWithArray:(NSArray*)array andRemovingObject:(id)object;
+ (instancetype)arrayWithArray:(NSArray*)array andRemovingObjectsInArray:(NSArray*)removingObjects;

- (NSArray*)arrayByReplaceObject:(id)object atIndex:(NSUInteger)index;

- (NSArray*)arrayByRemovedObject:(id)object;
- (NSArray*)arrayByRemovedObjectsFromArray:(NSArray*)array;

- (NSArray*)arrayByObjectClass:(Class)objectClass;
- (NSArray*)arrayByObjectProtocol:(Protocol*)objectProtocol;

- (id)firstObjectIsClass:(Class)objectClass;
- (id)lastObjectIsClass:(Class)objectClass;

- (id)firstObjectIsProtocol:(Protocol*)objectProtocol;
- (id)lastObjectIsProtocol:(Protocol*)objectProtocol;

- (BOOL)containsObjectsInArray:(NSArray*)objectsArray;

- (NSUInteger)nextIndexOfObject:(id)object;
- (NSUInteger)prevIndexOfObject:(id)object;

- (id)nextObjectOfObject:(id)object;
- (id)prevObjectOfObject:(id)object;

- (void)enumerateObjectsAtRange:(NSRange)range options:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

- (void)each:(void(^)(id object))block;
- (void)eachWithIndex:(void(^)(id object, NSUInteger index))block;
- (void)each:(void(^)(id object))block options:(NSEnumerationOptions)options;
- (void)eachWithIndex:(void(^)(id object, NSUInteger index))block options:(NSEnumerationOptions)options;
- (NSArray*)map:(id(^)(id object))block;
- (NSArray*)select:(BOOL(^)(id object))block;
- (NSArray*)reject:(BOOL(^)(id object))block;
- (id)find:(BOOL(^)(id object))block;
- (NSArray*)reverse;
- (NSArray*)intersectionWithArray:(NSArray*)array;
- (NSArray*)intersectionWithArrays:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)unionWithArray:(NSArray*)array;
- (NSArray*)unionWithArrays:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)relativeComplement:(NSArray*)array;
- (NSArray*)relativeComplements:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)symmetricDifference:(NSArray*)array;

@end

/*--------------------------------------------------*/

@interface NSMutableArray (MobilyNS)

- (void)removeFirstObjectsByCount:(NSUInteger)count;
- (void)removeLastObjectsByCount:(NSUInteger)count;

@end

/*--------------------------------------------------*/

@interface NSDictionary (MobilyNS)

- (BOOL)boolValueForKey:(NSString*)key orDefault:(BOOL)defaultValue;
- (NSInteger)integerValueForKey:(NSString*)key orDefault:(NSInteger)defaultValue;
- (NSUInteger)unsignedIntegerValueForKey:(NSString*)key orDefault:(NSUInteger)defaultValue;
- (float)floatValueForKey:(NSString*)key orDefault:(float)defaultValue;
- (double)doubleValueForKey:(NSString*)key orDefault:(double)defaultValue;
- (NSNumber*)numberValueForKey:(NSString*)key orDefault:(NSNumber*)defaultValue;
- (NSString*)stringValueForKey:(NSString*)key orDefault:(NSString*)defaultValue;
- (NSArray*)arrayValueForKey:(NSString*)key orDefault:(NSArray*)defaultValue;
- (NSDictionary*)dictionaryValueForKey:(NSString*)key orDefault:(NSDictionary*)defaultValue;

- (NSString*)stringFromQueryComponents;

- (void)each:(void(^)(id key, id value))block;
- (void)eachWithIndex:(void(^)(id key, id value, NSUInteger index))block;
- (void)eachKey:(void(^)(id key))block;
- (void)eachKeyWithIndex:(void(^)(id key, NSUInteger index))block;
- (void)eachValue:(void(^)(id value))block;
- (void)eachValueWithIndex:(void(^)(id value, NSUInteger index))block;
- (NSArray*)map:(id(^)(id key, id value))block;
- (BOOL)hasKey:(id)key;

@end

/*--------------------------------------------------*/

@interface NSURL (MobilyNS)

- (NSMutableDictionary*)queryComponents;
- (NSMutableDictionary*)fragmentComponents;

@end

/*--------------------------------------------------*/

@interface NSFileManager (MobilyNS)

+ (NSString*)documentDirectory;
+ (NSString*)cachesDirectory;

@end

/*--------------------------------------------------*/

@interface NSHTTPCookieStorage (MobilyNS)

+ (void)clearCookieWithDomain:(NSString*)domain;

@end

/*--------------------------------------------------*/

@interface NSBundle (MobilyNS)

- (id)objectForInfoDictionaryKey:(NSString*)key defaultValue:(id)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorage : NSObject

+ (NSString*)fileSystemDirectory;

@end

/*--------------------------------------------------*/
