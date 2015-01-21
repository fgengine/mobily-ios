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

#import "MobilyCache.h"
#import "MobilyModel.h"
#import "MobilyModelJson.h"

/*--------------------------------------------------*/

@interface MobilyCache ()

@property(nonatomic, readwrite, strong) NSMutableArray* items;

- (void)saveToDiscCacheCompleted:(MobilyCacheCompleted)completed;

@end

/*--------------------------------------------------*/

@interface MobilyCacheItem : MobilyModel

@property(nonatomic, readwrite, weak) MobilyCache* cache;
@property(nonatomic, readwrite, strong) NSString* key;
@property(nonatomic, readonly, strong) NSData* data;
@property(nonatomic, readwrite, assign) NSUInteger size;
@property(nonatomic, readwrite, assign) NSTimeInterval memoryStorageTime;
@property(nonatomic, readwrite, assign) NSTimeInterval discStorageTime;
@property(nonatomic, readwrite, assign, getter=isInMemory) BOOL inMemory;

- (id)initWithCache:(MobilyCache*)cache key:(NSString*)key data:(NSData*)data memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime;

- (void)updateData:(NSData*)data memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime;

- (void)saveToDiscCache;
- (void)clearFromMemoryCache;
- (void)clearFromDiscCache;
- (void)clearFromAllCache;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_CACHE_NAME                           @"MobilyImageLoaderCache"
#define MOBILY_CACHE_MEMORY_CAPACITY                (1024 * 1024) * 5
#define MOBILY_CACHE_MEMORY_STORAGE_TIME            (60 * 10)
#define MOBILY_CACHE_DISC_CAPACITY                  (1024 * 1024) * 100
#define MOBILY_CACHE_DISK_STORAGE_TIME              ((60 * 60) * 24) * 7

/*--------------------------------------------------*/

@implementation MobilyCache

#pragma mark Standart

- (id)init {
    return [self initWithName:MOBILY_CACHE_NAME memoryCapacity:MOBILY_CACHE_MEMORY_CAPACITY memoryStorageTime:MOBILY_CACHE_MEMORY_STORAGE_TIME diskCapacity:MOBILY_CACHE_DISC_CAPACITY discStorageTime:MOBILY_CACHE_DISK_STORAGE_TIME];
}

- (id)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity memoryStorageTime:(NSTimeInterval)memoryStorageTime diskCapacity:(NSUInteger)diskCapacity discStorageTime:(NSTimeInterval)discStorageTime {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)setCacheData:(NSData*)data forKey:(NSString*)key {
    [self setCacheData:data forKey:key memoryStorageTime:_memoryStorageTime discStorageTime:_discStorageTime];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key completed:(MobilyCacheCompleted)completed {
    [self setCacheData:data forKey:key memoryStorageTime:_memoryStorageTime discStorageTime:_discStorageTime completed:completed];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime {
    [self setCacheData:data forKey:key memoryStorageTime:memoryStorageTime discStorageTime:_discStorageTime];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime completed:(MobilyCacheCompleted)completed {
    [self setCacheData:data forKey:key memoryStorageTime:memoryStorageTime discStorageTime:_discStorageTime completed:completed];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageTime:(NSTimeInterval)discStorageTime {
    [self setCacheData:data forKey:key memoryStorageTime:_memoryStorageTime discStorageTime:discStorageTime];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageTime:(NSTimeInterval)discStorageTime completed:(MobilyCacheCompleted)completed {
    [self setCacheData:data forKey:key memoryStorageTime:_memoryStorageTime discStorageTime:discStorageTime completed:completed];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime {
    @synchronized(_items) {
        __block MobilyCacheItem* foundedItem = nil;
        [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
            if([[item key] isEqualToString:key] == YES) {
                foundedItem = item;
                *stop = YES;
            }
        }];
        if(foundedItem != nil) {
            [_items addObject:[[MobilyCacheItem alloc] initWithCache:self key:key data:data memoryStorageTime:memoryStorageTime discStorageTime:discStorageTime]];
        } else {
            [foundedItem updateData:data memoryStorageTime:memoryStorageTime discStorageTime:discStorageTime];
        }
        [self saveToDiscCacheCompleted:nil];
    }
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime completed:(MobilyCacheCompleted)completed {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(_items) {
            __block MobilyCacheItem* foundedItem = nil;
            [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
                if([[item key] isEqualToString:key] == YES) {
                    foundedItem = item;
                    *stop = YES;
                }
            }];
            if(foundedItem != nil) {
                [_items addObject:[[MobilyCacheItem alloc] initWithCache:self key:key data:data memoryStorageTime:memoryStorageTime discStorageTime:discStorageTime]];
            } else {
                [foundedItem updateData:data memoryStorageTime:memoryStorageTime discStorageTime:discStorageTime];
            }
            [self saveToDiscCacheCompleted:completed];
        }
    });
}

- (NSData*)cacheDataForKey:(NSString*)key {
    __block NSData* result = nil;
    @synchronized(_items) {
        [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
            if([[item key] isEqualToString:key] == YES) {
                result = [item data];
                *stop = YES;
            }
        }];
    }
    return result;
}

- (void)cacheDataForKey:(NSString*)key completed:(MobilyCacheDataForKey)completed {
    if(completed != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completed([self cacheDataForKey:key]);
        });
    }
}

- (void)removeCacheDataForKey:(NSString*)key {
    @synchronized(_items) {
        __block MobilyCacheItem* foundedItem = nil;
        [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
            if([[item key] isEqualToString:key] == YES) {
                foundedItem = item;
                *stop = YES;
            }
        }];
        if(foundedItem != nil) {
            [foundedItem clearFromAllCache];
            [_items removeObject:foundedItem];
            [self saveToDiscCacheCompleted:nil];
        }
    }
}

- (void)removeCacheDataForKey:(NSString*)key completed:(MobilyCacheCompleted)completed {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block MobilyCacheItem* foundedItem = nil;
        [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
            if([[item key] isEqualToString:key] == YES) {
                foundedItem = item;
                *stop = YES;
            }
        }];
        if(foundedItem != nil) {
            [foundedItem clearFromAllCache];
            [_items removeObject:foundedItem];
            [self saveToDiscCacheCompleted:completed];
        } else {
            if(completed != nil) {
                completed();
            }
        }
    });
}

- (void)removeAllCachedData {
    @synchronized(_items) {
        if([_items count] > 0) {
            [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
                [item clearFromAllCache];
            }];
            [_items removeAllObjects];
            [self saveToDiscCacheCompleted:nil];
        }
    }
}

- (void)removeAllCachedDataCompleted:(MobilyCacheCompleted)completed {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(_items) {
            if([_items count] > 0) {
                [_items enumerateObjectsUsingBlock:^(MobilyCacheItem* item, NSUInteger index, BOOL* stop) {
                    [item clearFromAllCache];
                }];
                [_items removeAllObjects];
                [self saveToDiscCacheCompleted:completed];
            } else {
                if(completed != nil) {
                    completed();
                }
            }
        }
    });
}

#pragma mark Private

- (void)saveToDiscCacheCompleted:(MobilyCacheCompleted)completed {
    if(completed != nil) {
        completed();
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyCacheItem

+ (NSArray*)propertyMap {
    return @[
        @"",
        @""
    ];
}

- (id)initWithCache:(MobilyCache*)cache key:(NSString*)key data:(NSData*)data memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

- (void)updateData:(NSData*)data memoryStorageTime:(NSTimeInterval)memoryStorageTime discStorageTime:(NSTimeInterval)discStorageTime {
}

- (void)saveToDiscCache {
}

- (void)clearFromMemoryCache {
}

- (void)clearFromDiscCache {
}

- (void)clearFromAllCache {
}

@end

/*--------------------------------------------------*/
