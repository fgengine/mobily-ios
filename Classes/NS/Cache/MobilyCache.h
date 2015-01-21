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

typedef void (^MobilyCacheDataForKey)(NSData* data);
typedef void (^MobilyCacheCompleted)();

/*--------------------------------------------------*/

@interface MobilyCache : NSObject

@property(nonatomic, readonly, copy) NSString* name;
@property(nonatomic, readonly, assign) NSUInteger memoryCapacity;
@property(nonatomic, readonly, assign) NSTimeInterval memoryStorageTime;
@property(nonatomic, readonly, assign) NSUInteger diskCapacity;
@property(nonatomic, readonly, assign) NSTimeInterval discStorageTime;
@property(nonatomic, readonly, assign) NSUInteger currentMemoryUsage;
@property(nonatomic, readonly, assign) NSUInteger currentDiskUsage;

- (id)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity memoryStorageTime:(NSTimeInterval)memoryStorageTime diskCapacity:(NSUInteger)diskCapacity discStorageTime:(NSTimeInterval)discStorageTime;

- (void)setCacheData:(NSData*)data forKey:(NSString*)key;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key completed:(MobilyCacheCompleted)completed;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime completed:(MobilyCacheCompleted)completed;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageTime:(NSTimeInterval)discStorageTime;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageTime:(NSTimeInterval)discStorageTime completed:(MobilyCacheCompleted)completed;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime;
- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime completed:(MobilyCacheCompleted)completed;
- (NSData*)cacheDataForKey:(NSString*)key;
- (void)cacheDataForKey:(NSString*)key completed:(MobilyCacheDataForKey)completed;

- (void)removeCacheDataForKey:(NSString*)key;
- (void)removeCacheDataForKey:(NSString*)key completed:(MobilyCacheCompleted)completed;
- (void)removeAllCachedData;
- (void)removeAllCachedDataCompleted:(MobilyCacheCompleted)completed;

@end

/*--------------------------------------------------*/
