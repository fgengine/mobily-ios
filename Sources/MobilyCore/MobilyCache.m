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

#import <MobilyCore/MobilyCache.h>
#import <MobilyCore/MobilyTimer.h>
#import <MobilyCore/MobilyModel.h>

/*--------------------------------------------------*/

@interface MobilyCache () < MobilyTimerDelegate >

@property(nonatomic, readwrite, copy) NSString* name;
@property(nonatomic, readwrite, strong) NSString* fileName;
@property(nonatomic, readwrite, strong) NSString* filePath;
@property(nonatomic, readwrite, assign) NSTimeInterval memoryStorageInterval;
@property(nonatomic, readwrite, assign) NSTimeInterval discStorageInterval;
@property(nonatomic, readwrite, assign) NSUInteger currentMemoryUsage;
@property(nonatomic, readwrite, assign) NSUInteger currentDiscUsage;

@property(nonatomic, readwrite, strong) MobilyTimer* timer;
@property(nonatomic, readwrite, strong) NSMutableArray* items;

- (void)removeObsoleteItemsInViewOfReserveSize:(NSUInteger)reserveSize;
- (void)removeObsoleteItems;
- (void)saveItems;

- (void)notificationReceiveMemoryWarning:(NSNotification*)notification;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyCacheItem : MobilyModel

@property(nonatomic, readwrite, weak) MobilyCache* cache;
@property(nonatomic, readwrite, strong) NSString* key;
@property(nonatomic, readwrite, strong) NSString* fileName;
@property(nonatomic, readonly, strong) NSString* filePath;
@property(nonatomic, readonly, strong) NSData* data;
@property(nonatomic, readonly, assign) NSUInteger size;
@property(nonatomic, readonly, assign) NSTimeInterval memoryStorageInterval;
@property(nonatomic, readonly, assign) NSTimeInterval memoryStorageTime;
@property(nonatomic, readonly, assign) NSTimeInterval discStorageInterval;
@property(nonatomic, readonly, assign) NSTimeInterval discStorageTime;
@property(nonatomic, readonly, assign, getter=isInMemory) BOOL inMemory;

- (instancetype)initWithCache:(MobilyCache*)cache key:(NSString*)key data:(NSData*)data memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval;

- (void)updateData:(NSData*)data memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval;

- (void)saveToDiscCache;
- (void)clearFromMemoryCache;
- (void)clearFromDiscCache;
- (void)clearFromAllCache;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_CACHE_NAME                           @"MobilyCache"
#define MOBILY_CACHE_EXTENSION                      @"cache"
#define MOBILY_CACHE_MEMORY_CAPACITY                (1024 * 1024) * 30
#define MOBILY_CACHE_MEMORY_STORAGE_INTERVAL        (60 * 10)
#define MOBILY_CACHE_DISC_CAPACITY                  (1024 * 1024) * 500
#define MOBILY_CACHE_DISC_STORAGE_INTERVAL          ((60 * 60) * 24) * 7

/*--------------------------------------------------*/

@implementation MobilyCache

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                NSBundle* bundle = NSBundle.mainBundle;
                NSString* name = [bundle objectForInfoDictionaryKey:@"MobilyCacheName" defaultValue:MOBILY_CACHE_NAME];
                NSNumber* memoryCapacity = [bundle objectForInfoDictionaryKey:@"MobilyCacheMemoryCapacity" defaultValue:@(MOBILY_CACHE_MEMORY_CAPACITY)];
                NSNumber* memoryStorageInterval = [bundle objectForInfoDictionaryKey:@"MobilyCacheMemoryStorageInterval" defaultValue:@(MOBILY_CACHE_MEMORY_STORAGE_INTERVAL)];
                NSNumber* discCapacity = [bundle objectForInfoDictionaryKey:@"MobilyCacheDiscCapacity" defaultValue:@(MOBILY_CACHE_DISC_CAPACITY)];
                NSNumber* discStorageInterval = [bundle objectForInfoDictionaryKey:@"MobilyCacheDiscStorageInterval" defaultValue:@(MOBILY_CACHE_DISC_STORAGE_INTERVAL)];
                shared = [[self alloc] initWithName:name memoryCapacity:memoryCapacity.unsignedIntegerValue memoryStorageInterval:memoryStorageInterval.doubleValue discCapacity:discCapacity.unsignedIntegerValue discStorageInterval:discStorageInterval.doubleValue];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    return [self initWithName:MOBILY_CACHE_NAME memoryCapacity:MOBILY_CACHE_MEMORY_CAPACITY memoryStorageInterval:MOBILY_CACHE_MEMORY_STORAGE_INTERVAL discCapacity:MOBILY_CACHE_DISC_CAPACITY discStorageInterval:MOBILY_CACHE_DISC_STORAGE_INTERVAL];
}

- (instancetype)initWithName:(NSString*)name {
    return [self initWithName:name memoryCapacity:MOBILY_CACHE_MEMORY_CAPACITY memoryStorageInterval:MOBILY_CACHE_MEMORY_STORAGE_INTERVAL discCapacity:MOBILY_CACHE_DISC_CAPACITY discStorageInterval:MOBILY_CACHE_DISC_STORAGE_INTERVAL];
}

- (instancetype)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity discCapacity:(NSUInteger)discCapacity {
    return [self initWithName:name memoryCapacity:memoryCapacity memoryStorageInterval:MOBILY_CACHE_MEMORY_STORAGE_INTERVAL discCapacity:discCapacity discStorageInterval:MOBILY_CACHE_DISC_STORAGE_INTERVAL];
}

- (instancetype)initWithName:(NSString*)name memoryCapacity:(NSUInteger)memoryCapacity memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discCapacity:(NSUInteger)discCapacity discStorageInterval:(NSTimeInterval)discStorageInterval {
    self = [super init];
    if(self != nil) {
        self.name = name;
        self.fileName = [[[_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] stringByMD5];
        self.filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_CACHE_EXTENSION]];
        self.memoryCapacity = (memoryCapacity > discCapacity) ? discCapacity : memoryCapacity;
        self.memoryStorageInterval = (memoryStorageInterval > discStorageInterval) ? discStorageInterval : memoryStorageInterval;
        self.discCapacity = (discCapacity > memoryCapacity) ? discCapacity : memoryCapacity;
        self.discStorageInterval = (discStorageInterval > memoryStorageInterval) ? discStorageInterval : memoryStorageInterval;
        self.timer = [MobilyTimer timerWithInterval:MIN(_memoryStorageInterval, _discStorageInterval) repeat:NSNotFound];
        self.items = NSMutableArray.array;
        if([NSFileManager.defaultManager fileExistsAtPath:_filePath] == YES) {
            id items = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if([items isKindOfClass:NSArray.class] == YES) {
                _items.array = items;
            }
        }
        for(MobilyCacheItem* item in _items) {
            item.cache = self;
        }
        [self removeObsoleteItems];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notificationReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    self.name = nil;
    self.timer = nil;
    self.items = nil;
}

#pragma mark Property

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity {
    if(_memoryCapacity != memoryCapacity) {
        BOOL needRemoveObsoleteItems = (_memoryCapacity > memoryCapacity);
        _memoryCapacity = memoryCapacity;
        if(needRemoveObsoleteItems == YES) {
            [self removeObsoleteItems];
        }
    }
}

- (void)setDiscCapacity:(NSUInteger)discCapacity {
    if(_discCapacity != discCapacity) {
        BOOL needRemoveObsoleteItems = (_discCapacity > discCapacity);
        _discCapacity = discCapacity;
        if(needRemoveObsoleteItems == YES) {
            [self removeObsoleteItems];
        }
    }
}

- (void)setTimer:(MobilyTimer*)timer {
    if(_timer != timer) {
        if(_timer != nil) {
            [timer stop];
        }
        _timer = timer;
        if(_timer != nil) {
            _timer.delegate = self;
            [_timer start];
        }
    }
}

#pragma mark Public

- (void)setCacheData:(NSData*)data forKey:(NSString*)key {
    [self setCacheData:data forKey:key memoryStorageInterval:_memoryStorageInterval discStorageInterval:_discStorageInterval];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key complete:(MobilyCacheComplete)complete {
    [self setCacheData:data forKey:key memoryStorageInterval:_memoryStorageInterval discStorageInterval:_discStorageInterval complete:complete];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval {
    [self setCacheData:data forKey:key memoryStorageInterval:memoryStorageInterval discStorageInterval:_discStorageInterval];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval complete:(MobilyCacheComplete)complete {
    [self setCacheData:data forKey:key memoryStorageInterval:memoryStorageInterval discStorageInterval:_discStorageInterval complete:complete];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageInterval:(NSTimeInterval)discStorageInterval {
    [self setCacheData:data forKey:key memoryStorageInterval:_memoryStorageInterval discStorageInterval:discStorageInterval];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key discStorageInterval:(NSTimeInterval)discStorageInterval complete:(MobilyCacheComplete)complete {
    [self setCacheData:data forKey:key memoryStorageInterval:_memoryStorageInterval discStorageInterval:discStorageInterval complete:complete];
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval {
    @synchronized(_items) {
        MobilyCacheItem* foundedItem = nil;
        for(MobilyCacheItem* item in _items) {
            if([item.key isEqualToString:key] == YES) {
                foundedItem = item;
                break;
            }
        }
        if(((_currentMemoryUsage + data.length) > _memoryCapacity) || ((_currentDiscUsage + data.length) > _discCapacity)) {
            [self removeObsoleteItemsInViewOfReserveSize:data.length];
        }
        if(foundedItem == nil) {
            [_items addObject:[[MobilyCacheItem alloc] initWithCache:self key:key data:data memoryStorageInterval:(memoryStorageInterval > discStorageInterval) ? discStorageInterval : memoryStorageInterval discStorageInterval:discStorageInterval]];
        } else {
            [foundedItem updateData:data memoryStorageInterval:(memoryStorageInterval > discStorageInterval) ? discStorageInterval : memoryStorageInterval discStorageInterval:discStorageInterval];
        }
        [self saveItems];
    }
}

- (void)setCacheData:(NSData*)data forKey:(NSString*)key memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval complete:(MobilyCacheComplete)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setCacheData:data forKey:key memoryStorageInterval:memoryStorageInterval discStorageInterval:discStorageInterval];
        if(complete != nil) {
            complete();
        }
    });
}

- (NSData*)cacheDataForKey:(NSString*)key {
    NSData* result = nil;
    @synchronized(_items) {
        for(MobilyCacheItem* item in _items) {
            if([item.key isEqualToString:key] == YES) {
                result = item.data;
                break;
            }
        }
    }
    return result;
}

- (void)cacheDataForKey:(NSString*)key complete:(MobilyCacheDataForKey)complete {
    if(complete != nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            complete([self cacheDataForKey:key]);
        });
    }
}

- (void)removeCacheDataForKey:(NSString*)key {
    @synchronized(_items) {
        MobilyCacheItem* foundedItem = nil;
        for(MobilyCacheItem* item in _items) {
            if([item.key isEqualToString:key] == YES) {
                foundedItem = item;
                break;
            }
        }
        if(foundedItem != nil) {
            [foundedItem clearFromAllCache];
            [_items removeObject:foundedItem];
            [self saveItems];
        }
    }
}

- (void)removeCacheDataForKey:(NSString*)key complete:(MobilyCacheComplete)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeCacheDataForKey:key];
        if(complete != nil) {
            complete();
        }
    });
}

- (void)removeAllCachedData {
    @synchronized(_items) {
        if(_items.count > 0) {
            for(MobilyCacheItem* item in _items) {
                [item clearFromAllCache];
            }
            [_items removeAllObjects];
            [self saveItems];
        }
    }
}

- (void)removeAllCachedDataComplete:(MobilyCacheComplete)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeAllCachedData];
        if(complete != nil) {
            complete();
        }
    });
}

#pragma mark Private

- (void)removeObsoleteItemsInViewOfReserveSize:(NSUInteger)reserveSize {
    NSUInteger currentMemoryUsage = 0;
    NSUInteger currentDiscUsage = 0;
    if(_items.count > 0) {
        NSTimeInterval now = NSDate.timeIntervalSinceReferenceDate;
        NSMutableArray* removedMemoryItems = NSMutableArray.array;
        NSMutableArray* removedDiscItems = NSMutableArray.array;
        [_items sortUsingComparator:^NSComparisonResult(MobilyCacheItem* item1, MobilyCacheItem* item2) {
            if(item1.discStorageTime > item2.discStorageTime) {
                return NSOrderedDescending;
            } else if(item1.discStorageTime < item2.discStorageTime) {
                return NSOrderedAscending;
            } else {
                if(item1.memoryStorageTime > item2.memoryStorageTime) {
                    return NSOrderedDescending;
                } else if(item1.memoryStorageTime < item2.memoryStorageTime) {
                    return NSOrderedAscending;
                } else {
                    if(item1.size > item2.size) {
                        return NSOrderedDescending;
                    } else if(item1.size < item2.size) {
                        return NSOrderedAscending;
                    }
                }
            }
            return NSOrderedSame;
        }];
        for(MobilyCacheItem* item in _items) {
            if((item.discStorageTime > now) && (((currentDiscUsage + reserveSize) + item.size) <= _discCapacity)) {
                if((item.memoryStorageTime > now) && (((currentMemoryUsage + reserveSize) + item.size) <= _memoryCapacity)) {
                    if([item isInMemory] == YES) {
                        currentMemoryUsage += item.size;
                    }
                } else {
                    [removedMemoryItems addObject:item];
                }
                currentDiscUsage += item.size;
            } else {
                [removedDiscItems addObject:item];
            }
        }
        if(removedMemoryItems.count > 0) {
            for(MobilyCacheItem* item in removedMemoryItems) {
                [item clearFromMemoryCache];
            }
        }
        if(removedDiscItems.count > 0) {
            for(MobilyCacheItem* item in removedDiscItems) {
                [item clearFromAllCache];
            }
            [_items removeObjectsInArray:removedDiscItems];
            [self saveItems];
        }
    }
    self.currentMemoryUsage = currentMemoryUsage;
    self.currentDiscUsage = currentDiscUsage;
}

- (void)removeObsoleteItems {
    [self removeObsoleteItemsInViewOfReserveSize:0];
}

- (void)saveItems {
    [NSKeyedArchiver archiveRootObject:_items toFile:_filePath];
}

#pragma mark NSNotificationCenter

- (void)notificationReceiveMemoryWarning:(NSNotification* __unused)notification {
    for(MobilyCacheItem* item in _items) {
        [item clearFromMemoryCache];
    }
    self.currentMemoryUsage = 0;
}

#pragma mark MobilyTimerDelegate

-(void)timerDidRepeat:(MobilyTimer* __unused)timer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeObsoleteItems];
    });
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_CACHE_ITEM_EXTENSION                 @"data"

/*--------------------------------------------------*/

@implementation MobilyCacheItem

#pragma mark Synthesize

@synthesize cache = _cache;
@synthesize key = _key;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize data = _data;
@synthesize size = _size;
@synthesize memoryStorageInterval = _memoryStorageInterval;
@synthesize memoryStorageTime =_memoryStorageTime;
@synthesize discStorageInterval = _discStorageInterval;
@synthesize discStorageTime = _discStorageTime;
@synthesize inMemory = _inMemory;

#pragma mark Init / Free

- (instancetype)initWithCache:(MobilyCache*)cache key:(NSString*)key data:(NSData*)data memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval {
    self = [super init];
    if(self != nil) {
        _cache = cache;
        _key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _fileName = _key.lowercaseString.stringByMD5;
        _filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_CACHE_ITEM_EXTENSION]];
        _data = data;
        _size = _data.length;
        _memoryStorageInterval = memoryStorageInterval;
        _memoryStorageTime = ceil(NSDate.timeIntervalSinceReferenceDate + memoryStorageInterval);
        _discStorageInterval = discStorageInterval;
        _discStorageTime = ceil(NSDate.timeIntervalSinceReferenceDate + discStorageInterval);
        
        _cache.currentMemoryUsage = _cache.currentMemoryUsage + _size;
        [self saveToDiscCache];
    }
    return self;
}

- (void)dealloc {
    [self clearFromMemoryCache];
}

#pragma mark MobilyModel

+ (NSArray*)compareMap {
    return @[
        @"key",
    ];
}

+ (NSArray*)serializeMap {
    return @[
        @"key",
        @"fileName",
        @"size",
        @"memoryStorageInterval",
        @"memoryStorageTime",
        @"discStorageInterval",
        @"discStorageTime"
    ];
}

#pragma mark Property

- (void)setFileName:(NSString*)fileName {
    if([_fileName isEqualToString:fileName] == NO) {
        _fileName = fileName;
        if(_fileName != nil) {
            _filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_CACHE_ITEM_EXTENSION]];
        } else {
            _filePath = nil;
        }
    }
}

- (NSData*)data {
    if((_data == nil) && (_filePath != nil)) {
        _data = [NSData dataWithContentsOfFile:_filePath];
        if(_data != nil) {
            _cache.currentMemoryUsage = _cache.currentMemoryUsage + _size;
        }
    }
    return _data;
}

- (BOOL)isInMemory {
    return (_data != nil);
}

#pragma mark Private

- (void)updateData:(NSData*)data memoryStorageInterval:(NSTimeInterval)memoryStorageInterval discStorageInterval:(NSTimeInterval)discStorageInterval {
    _cache.currentMemoryUsage = _cache.currentMemoryUsage - _size;
    _data = data;
    _size = data.length;
    _cache.currentMemoryUsage = _cache.currentMemoryUsage + _size;
    _memoryStorageInterval = memoryStorageInterval;
    _memoryStorageTime = ceil(NSDate.timeIntervalSinceReferenceDate + memoryStorageInterval);
    _discStorageInterval = discStorageInterval;
    _discStorageTime = ceil(NSDate.timeIntervalSinceReferenceDate + discStorageInterval);
    [self saveToDiscCache];
}

- (void)saveToDiscCache {
    if([_data writeToFile:_filePath atomically:YES] == YES) {
        _cache.currentDiscUsage = _cache.currentDiscUsage + _size;
    }
}

- (void)clearFromMemoryCache {
    _cache.currentMemoryUsage = _cache.currentMemoryUsage - _size;
    _data = nil;
}

- (void)clearFromDiscCache {
    if([NSFileManager.defaultManager removeItemAtPath:_filePath error:nil] == YES) {
        _cache.currentDiscUsage = _cache.currentDiscUsage - _size;
    }
}

- (void)clearFromAllCache {
    [self clearFromMemoryCache];
    [self clearFromDiscCache];
}

@end

/*--------------------------------------------------*/
