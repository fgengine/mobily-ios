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

#import <MobilyCore/MobilyDefines.h>

/*--------------------------------------------------*/

@interface NSObject (MobilyNS)

+ (NSString*)moClassName;
- (NSString*)moClassName;

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

typedef NS_ENUM(NSUInteger, MobilyDateWeekday) {
    MobilyDateWeekdayMonday = 2,
    MobilyDateWeekdayTuesday = 3,
    MobilyDateWeekdayWednesday = 4,
    MobilyDateWeekdayThursday = 5,
    MobilyDateWeekdayFriday = 6,
    MobilyDateWeekdaySaturday = 7,
    MobilyDateWeekdaySunday = 1,
};

/*--------------------------------------------------*/

@interface NSDate (MobilyNS)

+ (NSDate*)moDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate*)moDateByHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond;
+ (NSDate*)moDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)seccond;

- (NSString*)moFormatTime;
- (NSString*)moFormatDate;
- (NSString*)moFormatShortTime;
- (NSString*)moFormatDateTime;
- (NSString*)moFormatRelativeTime;
- (NSString*)moFormatShortRelativeTime;

+ (NSDate*)moDateWithUnixTimestamp:(NSUInteger)timestamp;
- (NSUInteger)moUnixTimestamp;

- (NSDate*)moExtractCalendarUnit:(NSCalendarUnit)calendarUnit;
- (NSDate*)moWithoutDate;
- (NSDate*)moWithoutTime;

- (NSDate*)moBeginningOfYear;
- (NSDate*)moEndOfYear;
- (NSDate*)moBeginningOfMonth;
- (NSDate*)moEndOfMonth;
- (NSDate*)moBeginningOfWeek;
- (NSDate*)moEndOfWeek;
- (NSDate*)moBeginningOfDay;
- (NSDate*)moEndOfDay;
- (NSDate*)moBeginningOfHour;
- (NSDate*)moEndOfHour;
- (NSDate*)moBeginningOfMinute;
- (NSDate*)moEndOfMinute;

- (NSDate*)moPreviousYear;
- (NSDate*)moNextYear;
- (NSDate*)moPreviousMonth;
- (NSDate*)moNextMonth;
- (NSDate*)moPreviousWeek;
- (NSDate*)moNextWeek;
- (NSDate*)moPreviousDay;
- (NSDate*)moNextDay;
- (NSDate*)moPreviousHour;
- (NSDate*)moNextHour;
- (NSDate*)moPreviousMinute;
- (NSDate*)moNextMinute;
- (NSDate*)moPreviousSecond;
- (NSDate*)moNextSecond;

- (NSInteger)moYearsToDate:(NSDate*)date;
- (NSInteger)moMonthsToDate:(NSDate*)date;
- (NSInteger)moDaysToDate:(NSDate*)date;
- (NSInteger)moWeeksToDate:(NSDate*)date;
- (NSInteger)moHoursToDate:(NSDate*)date;
- (NSInteger)moMinutesToDate:(NSDate*)date;
- (NSInteger)moSecondsToDate:(NSDate*)date;

- (NSDate*)moAddYears:(NSInteger)years;
- (NSDate*)moAddMonths:(NSInteger)months;
- (NSDate*)moAddWeeks:(NSInteger)weeks;
- (NSDate*)moAddDays:(NSInteger)days;
- (NSDate*)moAddHours:(NSInteger)hours;
- (NSDate*)moAddMinutes:(NSInteger)minutes;
- (NSDate*)moAddSeconds:(NSInteger)seconds;

- (BOOL)moIsYesterday;
- (BOOL)moIsToday;
- (BOOL)moIsTomorrow;
- (BOOL)moInsideFrom:(NSDate*)from to:(NSDate*)to;
- (BOOL)moIsEarlier:(NSDate*)anotherDate;
- (BOOL)moIsEarlierOrSame:(NSDate*)anotherDate;
- (BOOL)moIsSame:(NSDate*)anotherDate;
- (BOOL)moIsAfter:(NSDate*)anotherDate;
- (BOOL)moIsAfterOrSame:(NSDate*)anotherDate;

- (MobilyDateSeason)moSeason;
- (MobilyDateWeekday)moWeekday;

@end

/*--------------------------------------------------*/

@interface NSDateFormatter (MobilyNS)

+ (instancetype)moDateFormatterWithFormat:(NSString*)format;
+ (instancetype)moDateFormatterWithFormat:(NSString*)format locale:(NSLocale*)locale;
+ (instancetype)moDateFormatterWithFormatTemplate:(NSString*)formatTemplate;
+ (instancetype)moDateFormatterWithFormatTemplate:(NSString*)formatTemplate locale:(NSLocale*)locale;

@end

/*--------------------------------------------------*/

@interface NSData (MobilyNS)

- (NSString*)moToHex;

- (NSString*)moToBase64;

@end

/*--------------------------------------------------*/

@interface NSString (MobilyNS)

+ (id)moStringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

- (NSString*)moStringByUppercaseFirstCharacterString;
- (NSString*)moStringByLowercaseFirstCharacterString;

- (NSString*)moStringByMD5;
- (NSString*)moStringBySHA256;

- (NSString*)moStringByDecodingURLFormat;
- (NSString*)moStringByEncodingURLFormat;
- (NSMutableDictionary*)moDictionaryFromQueryComponents;

- (BOOL)moIsEmail;

- (NSData*)moHMACSHA1:(NSString*)key;

- (BOOL)moConvertToBool;
- (NSNumber*)moConvertToNumber;
- (NSDate*)moConvertToDateWithFormat:(NSString*)format;

- (NSTextAlignment)moConvertToTextAlignment;
- (NSLineBreakMode)moConvertToLineBreakMode;

+ (NSString*)moRightWordFormByCount:(NSInteger)count andForms:(NSArray*)forms;

- (NSArray*)moCharactersArray;

@end

/*--------------------------------------------------*/

@interface NSArray (MobilyNS)

+ (instancetype)moArrayWithArray:(NSArray*)array andAddingObject:(id)object;
+ (instancetype)moArrayWithArray:(NSArray*)array andAddingObjectsFromArray:(NSArray*)addingObjects;
+ (instancetype)moArrayWithArray:(NSArray*)array andRemovingObject:(id)object;
+ (instancetype)moArrayWithArray:(NSArray*)array andRemovingObjectsInArray:(NSArray*)removingObjects;

- (NSArray*)moArrayByReplaceObject:(id)object atIndex:(NSUInteger)index;

- (NSArray*)moArrayByRemovedObjectAtIndex:(NSUInteger)index;
- (NSArray*)moArrayByRemovedObject:(id)object;
- (NSArray*)moArrayByRemovedObjectsFromArray:(NSArray*)array;

- (NSArray*)moArrayByObjectClass:(Class)objectClass;
- (NSArray*)moArrayByObjectProtocol:(Protocol*)objectProtocol;

- (id)moFirstObjectIsClass:(Class)objectClass;
- (id)moLastObjectIsClass:(Class)objectClass;

- (id)moFirstObjectIsProtocol:(Protocol*)objectProtocol;
- (id)moLastObjectIsProtocol:(Protocol*)objectProtocol;

- (BOOL)moContainsObjectsInArray:(NSArray*)objectsArray;

- (NSUInteger)moNextIndexOfObject:(id)object;
- (NSUInteger)moPrevIndexOfObject:(id)object;

- (id)moNextObjectOfObject:(id)object;
- (id)moPrevObjectOfObject:(id)object;

- (void)moEnumerateObjectsAtRange:(NSRange)range options:(NSEnumerationOptions)options usingBlock:(void(^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

- (void)moEach:(void(^)(id object))block;
- (void)moEachWithIndex:(void(^)(id object, NSUInteger index))block;
- (void)moEach:(void(^)(id object))block options:(NSEnumerationOptions)options;
- (void)moEachWithIndex:(void(^)(id object, NSUInteger index))block options:(NSEnumerationOptions)options;
- (NSArray*)moMap:(id(^)(id object))block;
- (NSDictionary*)moGroupBy:(id(^)(id object))block;
- (NSArray*)moSelect:(BOOL(^)(id object))block;
- (NSArray*)moReject:(BOOL(^)(id object))block;
- (id)moFind:(BOOL(^)(id object))block;
- (NSArray*)moReverse;
- (NSArray*)moIntersectionWithArray:(NSArray*)array;
- (NSArray*)moIntersectionWithArrays:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)moUnionWithArray:(NSArray*)array;
- (NSArray*)moUnionWithArrays:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)moRelativeComplement:(NSArray*)array;
- (NSArray*)moRelativeComplements:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray*)moSymmetricDifference:(NSArray*)array;

@end

/*--------------------------------------------------*/

@interface NSMutableArray (MobilyNS)

- (void)moRemoveFirstObjectsByCount:(NSUInteger)count;
- (void)moRemoveLastObjectsByCount:(NSUInteger)count;

@end

/*--------------------------------------------------*/

@interface NSDictionary (MobilyNS)

- (BOOL)moBoolValueForKey:(NSString*)key orDefault:(BOOL)defaultValue;
- (NSInteger)moIntegerValueForKey:(NSString*)key orDefault:(NSInteger)defaultValue;
- (NSUInteger)moUnsignedIntegerValueForKey:(NSString*)key orDefault:(NSUInteger)defaultValue;
- (float)moFloatValueForKey:(NSString*)key orDefault:(float)defaultValue;
- (double)moDoubleValueForKey:(NSString*)key orDefault:(double)defaultValue;
- (NSNumber*)moNumberValueForKey:(NSString*)key orDefault:(NSNumber*)defaultValue;
- (NSString*)moStringValueForKey:(NSString*)key orDefault:(NSString*)defaultValue;
- (NSArray*)moArrayValueForKey:(NSString*)key orDefault:(NSArray*)defaultValue;
- (NSDictionary*)moDictionaryValueForKey:(NSString*)key orDefault:(NSDictionary*)defaultValue;

- (NSString*)moStringFromQueryComponents;

- (void)moEach:(void(^)(id key, id value))block;
- (void)moEachWithIndex:(void(^)(id key, id value, NSUInteger index))block;
- (void)moEachKey:(void(^)(id key))block;
- (void)moEachKeyWithIndex:(void(^)(id key, NSUInteger index))block;
- (void)moEachValue:(void(^)(id value))block;
- (void)moEachValueWithIndex:(void(^)(id value, NSUInteger index))block;
- (NSArray*)moMap:(id(^)(id key, id value))block;
- (id)moFindObjectByKey:(BOOL(^)(id key))block;
- (BOOL)moHasKey:(id)key;

@end

/*--------------------------------------------------*/

@interface NSURL (MobilyNS)

- (NSMutableDictionary*)moQueryComponents;
- (NSMutableDictionary*)moFragmentComponents;

@end

/*--------------------------------------------------*/

@interface NSFileManager (MobilyNS)

+ (NSString*)moDocumentDirectory;
+ (NSString*)moCachesDirectory;

@end

/*--------------------------------------------------*/

@interface NSHTTPCookieStorage (MobilyNS)

+ (void)moClearCookieWithDomain:(NSString*)domain;

@end

/*--------------------------------------------------*/

@interface NSBundle (MobilyNS)

- (id)moObjectForInfoDictionaryKey:(NSString*)key defaultValue:(id)defaultValue;

@end

/*--------------------------------------------------*/

@interface NSError (MobilyNS)

- (BOOL)moIsNoInternetConnection;
- (BOOL)moIsTimedOut;

@end

/*--------------------------------------------------*/

@interface MobilyStorage : NSObject

+ (NSString*)moFileSystemDirectory;

@end

/*--------------------------------------------------*/
