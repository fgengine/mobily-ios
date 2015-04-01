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

typedef void (^MobilyCacheDataForKey)(NSData* data);
typedef void (^MobilyCacheComplete)();

/*--------------------------------------------------*/

@interface MobilyCache : NSObject< MobilyObject >

@property(nonatomic, readonly, copy) NSString* name;
@property(nonatomic, readwrite, assign) NSUInteger memoryCapacity;
@property(nonatomic, readonly, assign) NSTimeInterval memoryStorageInterval;
@property(nonatomic, readwrite, assign) NSUInteger discCapacity;
@property(nonatomic, readonly, assign) NSTimeInterval discStorageInterval;
@property(nonatomic, readonly, assign) NSUInteger currentMemoryUsage;
@property(nonatomic, readonly, assign) NSUInteger currentDiscUsage;

+ (instancetype)shared;

- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity discCapacity:(NSUInteger)discCapacity;
- (instancetype)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discCapacity:(NSUInteger)discCapacity discStorageInterval:(NSTimeInterval)discStorageInterval;

- (void)setCacheData:(NSData*)data forKey:(NSString*)key;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key complete:(MobilyCacheComplete)complete;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval complete:(MobilyCacheComplete)complete;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageInterval:(NSTimeInterval)discStorageInterval;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageInterval:(NSTimeInterval)discStorageInterval complete:(MobilyCacheComplete)complete;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval complete:(MobilyCacheComplete)complete;
- (NSData*)cacheDataForKey:(NSString*)key;
- (void)cacheDataForKey:(NSString*)key complete:(MobilyCacheDataForKey)complete;

- (void)removeCacheDataForKey:(NSString*)key;
- (void)removeCacheDataForKey:(NSString*)key complete:(MobilyCacheComplete)complete;
- (void)removeAllCachedData;
- (void)removeAllCachedDataComplete:(MobilyCacheComplete)complete;

@end

/*--------------------------------------------------*/
