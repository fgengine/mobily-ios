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

#import "MobilyCore.h"

/*--------------------------------------------------*/

#define MOBILY_MINUTE                               60.0f
#define MOBILY_HOUR                                 (60.0f * MOBILY_MINUTE)
#define MOBILY_DAY                                  (24.0f * MOBILY_HOUR)
#define MOBILY_5_DAYS                               (5.0f * MOBILY_DAY)
#define MOBILY_WEEK                                 (7.0f * MOBILY_DAY)
#define MOBILY_MONTH                                (30.5f * MOBILY_DAY)
#define MOBILY_YEAR                                 (365.0f * MOBILY_DAY)

/*--------------------------------------------------*/

@interface NSDate (MobilyNS)

+ (NSDate*)dateOffsetYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days toDate:(NSDate*)date;
+ (NSDate*)dateOffsetHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)secconds toDate:(NSDate*)date;
+ (NSDate*)dateOffsetYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)secconds toDate:(NSDate*)date;

- (NSString*)formatTime;
- (NSString*)formatDate;
- (NSString*)formatShortTime;
- (NSString*)formatDateTime;
- (NSString*)formatRelativeTime;
- (NSString*)formatShortRelativeTime;

+ (NSDate*)dateFromIso8601:(NSString*)iso8601;
- (NSString*)iso8601;

+ (NSDate*)dateWithUnixTimestamp:(NSUInteger)timestamp;
- (NSUInteger)unixTimestamp;

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

@end

/*--------------------------------------------------*/

@interface NSDictionary (MobilyNS)

- (NSString*)stringFromQueryComponents;

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
