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

#import <MobilyCore/MobilyModel+Private.h>

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_MODEL_EXTENSION                      @"model"

/*--------------------------------------------------*/

@implementation MobilyModel

#pragma mark Synthesize

@synthesize userDefaultsKey = _userDefaultsKey;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize compareMap = _compareMap;
@synthesize serializeMap = _serializeMap;
@synthesize copyMap = _copyMap;
@synthesize jsonMap = _jsonMap;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        for(NSString* field in self.serializeMap) {
            id value = [coder decodeObjectForKey:field];
            if(value != nil) {
                [self setValue:value forKey:field];
            }
        }
        [self setup];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString*)fileName {
    self = [super init];
    if(self != nil) {
        self.fileName = fileName;
        [self load];
        [self setup];
    }
    return self;
}

- (instancetype)initWithJson:(id)json {
    self = [super init];
    if(self != nil) {
        [self fromJson:json];
        [self setup];
    }
    return self;
}

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        _userDefaultsKey = userDefaultsKey;
        [self load];
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    BOOL result = NO;
    if([object isKindOfClass:self.class] == YES) {
        NSArray* map = self.compareMap;
        if(map.count < 1) {
            map = self.serializeMap;
        }
        if(map.count > 0) {
            result = YES;
            for(NSString* field in map) {
                id value1 = [self valueForKey:field];
                id value2 = [object valueForKey:field];
                if(value1 != value2) {
                    if([value1 isEqual:value2] == NO) {
                        result = NO;
                        break;
                    }
                }
            }
        }
    } else {
        result = [super isEqual:object];
    }
    return result;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)coder {
    for(NSString* field in self.serializeMap) {
        id value = [self valueForKey:field];
        if(value != nil) {
            [coder encodeObject:value forKey:field];
        }
    }
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    MobilyModel* result = [[self.class allocWithZone:zone] init];
    if(result != nil) {
        result.userDefaultsKey = _userDefaultsKey;
        result.fileName = _fileName;
        NSArray* map = self.copyMap;
        if(map.count < 1) {
            map = self.serializeMap;
        }
        for(NSString* field in map) {
            id value = [self valueForKey:field];
            if([value isKindOfClass:NSArray.class] == YES) {
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:[value count]];
                for(id item in value) {
                    [array addObject:[item copyWithZone:zone]];
                }
                [result setValue:array forKey:field];
            } else if([value isKindOfClass:NSDictionary.class] == YES) {
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[value count]];
                [value each:^(id key, id item) {
                    dict[key] = [item copyWithZone:zone];
                }];
                [result setValue:dict forKey:field];
            } else {
                [result setValue:[value copyWithZone:zone] forKey:field];
            }
        }
    }
    return result;
}

#pragma mark Debug

- (NSString*)description {
    NSMutableArray* result = NSMutableArray.array;
    for(NSString* field in self.serializeMap) {
        [result addObject:[NSString stringWithFormat:@"%@ = %@", field, [self valueForKey:field]]];
    }
    return [result componentsJoinedByString:@"; "];
}

#pragma mark Property

- (void)setFileName:(NSString*)fileName {
    if(_fileName != fileName) {
        _fileName = fileName;
        if(_fileName != nil) {
            _filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_MODEL_EXTENSION]];
        } else {
            _filePath = nil;
        }
    }
}

- (NSArray*)compareMap {
    if(_compareMap == nil) {
        _compareMap = [self.class _buildCompareMap];
    }
    return _compareMap;
}

- (NSArray*)serializeMap {
    if(_serializeMap == nil) {
        _serializeMap = [self.class _buildSerializeMap];
    }
    return _serializeMap;
}

- (NSArray*)copyMap {
    if(_copyMap == nil) {
        _copyMap = [self.class _buildCopyMap];
    }
    return _copyMap;
}

- (NSDictionary*)jsonMap {
    if(_jsonMap == nil) {
        _jsonMap = [self.class _buildJsonMap];
    }
    return _jsonMap;
}

#pragma mark Public

+ (NSArray*)compareMap {
    return nil;
}

+ (NSArray*)serializeMap {
    return nil;
}

+ (NSArray*)copyMap {
    return nil;
}

+ (NSDictionary*)jsonMap {
    return nil;
}

- (void)fromJson:(id)json {
    [self.jsonMap enumerateKeysAndObjectsUsingBlock:^(NSString* field, MobilyModelJson* converter, BOOL* stop __unused) {
        id value = [converter parseJson:json];
        if(value != nil) {
            [self setValue:value forKey:field];
        }
    }];
}

- (void)clear {
    for(NSString* field in self.serializeMap) {
        @try {
            [self setValue:nil forKey:field];
        }
        @catch(NSException *exception) {
        }
    }
}

- (void)clearComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self clear];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

- (BOOL)save {
    @try {
        NSMutableDictionary* dict = NSMutableDictionary.dictionary;
        if(dict != nil) {
            for(NSString* field in self.serializeMap) {
                @try {
                    id value = [self valueForKey:field];
                    if(value != nil) {
                        NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:value];
                        if(archive != nil) {
                            dict[field] = archive;
                        }
                    }
                }
                @catch (NSException* exception) {
                    NSLog(@"MobilyModel::saveItem:%@ Exception = %@ Field=%@", _userDefaultsKey, exception, field);
                }
            }
            if(_userDefaultsKey.length > 0) {
                [NSUserDefaults.standardUserDefaults setObject:dict forKey:_userDefaultsKey];
                return [NSUserDefaults.standardUserDefaults synchronize];
            } else if(_filePath.length > 0) {
                return [NSKeyedArchiver archiveRootObject:dict toFile:_filePath];
            }
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyModel::saveItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
    return NO;
}

- (void)saveSuccess:(MobilyModelBlock)success failure:(MobilyModelBlock)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if([self save] == YES) {
            if(success != nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    success();
                });
            }
        } else {
            if(failure != nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure();
                });
            }
        }
    });
}

- (void)load {
    @try {
        NSDictionary* dict = nil;
        if(_userDefaultsKey.length > 0) {
            dict = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
        } else if(_filePath.length > 0) {
            dict = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
        }
        if(dict != nil) {
            for(NSString* field in self.serializeMap) {
                id value = dict[field];
                if(value != nil) {
                    if([value isKindOfClass:NSData.class] == YES) {
                        id unarchive = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                        if(unarchive != nil) {
                            @try {
                                [self setValue:unarchive forKey:field];
                            }
                            @catch(NSException *exception) {
                            }
                        }
                    }
                }
            }
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyModel::loadItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
}

- (void)loadComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self load];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

- (void)erase {
    NSDictionary* dict = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
    if(dict != nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:_userDefaultsKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

- (void)eraseComplete:(MobilyModelBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self erase];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

#pragma mark Private

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (NSArray*)_arrayMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector {
    NSString* className = NSStringFromClass(class);
    NSMutableArray* map = cache[className];
    if(map == nil) {
        map = NSMutableArray.array;
        while(class != nil) {
            if([class respondsToSelector:selector] == YES) {
                NSArray* mapPart = [class performSelector:selector];
                if([mapPart isKindOfClass:NSArray.class] == YES) {
                    [map addObjectsFromArray:mapPart];
                }
            }
            class = [class superclass];
        }
        cache[className] = map;
    }
    return map;
}

+ (NSDictionary*)_dictionaryMap:(NSMutableDictionary*)cache class:(Class)class selector:(SEL)selector {
    NSString* className = NSStringFromClass(class);
    NSMutableDictionary* map = cache[className];
    if(map == nil) {
        map = NSMutableDictionary.dictionary;
        while(class != nil) {
            if([class respondsToSelector:selector] == YES) {
                NSDictionary* mapPart = [class performSelector:selector];
                if([mapPart isKindOfClass:NSDictionary.class] == YES) {
                    [map addEntriesFromDictionary:mapPart];
                }
            }
            class = [class superclass];
        }
        cache[className] = map;
    }
    return map;
}

#pragma clang diagnostic pop

+ (NSArray*)_buildCompareMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self _arrayMap:cache class:self.class selector:@selector(compareMap)];
}

+ (NSArray*)_buildSerializeMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self _arrayMap:cache class:self.class selector:@selector(serializeMap)];
}

+ (NSArray*)_buildCopyMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self _arrayMap:cache class:self.class selector:@selector(copyMap)];
}

+ (NSDictionary*)_buildJsonMap {
    static NSMutableDictionary* cache = nil;
    if(cache == nil) {
        cache = NSMutableDictionary.dictionary;
    }
    return [self _dictionaryMap:cache class:self.class selector:@selector(jsonMap)];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_STORAGE_COLLECTION_EXTENSION         @"collection"

/*--------------------------------------------------*/

@implementation MobilyModelCollection

#pragma mark Synthesize

@synthesize userDefaultsKey = _userDefaultsKey;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize models = _models;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _models = NSMutableArray.array;
        _needLoad = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        id models = [coder decodeObjectForKey:@"models"];
        if(models != nil) {
            _models = models;
        } else {
            _models = NSMutableArray.array;
        }
        _needLoad = NO;
        [self setup];
    }
    return self;
}

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        _userDefaultsKey = userDefaultsKey;
        _models = NSMutableArray.array;
        _needLoad = YES;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFileName:(NSString*)fileName {
    self = [super init];
    if(self != nil) {
        self.fileName = fileName;
        _models = NSMutableArray.array;
        _needLoad = YES;
        [self setup];
    }
    return self;
}

- (instancetype)initWithJson:(id)json storageItemClass:(Class)storageItemClass {
    self = [super init];
    if(self != nil) {
        _models = NSMutableArray.array;
        _needLoad = NO;
        [self fromJson:json modelClass:storageItemClass];
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)coder {
    [self _loadIsNeed];
    [coder encodeObject:_models forKey:@"models"];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    MobilyModelCollection* result = [[self.class allocWithZone:zone] init];
    if(result != nil) {
        result.userDefaultsKey = self.userDefaultsKey;
        result.fileName = _fileName;
        result.models = [_models copyWithZone:zone];
    }
    return result;
}

#pragma mark Property

- (void)setFileName:(NSString*)fileName {
    if(_fileName != fileName) {
        _fileName = fileName;
        if(_fileName != nil) {
            _filePath = [MobilyStorage.fileSystemDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _fileName, MOBILY_STORAGE_COLLECTION_EXTENSION]];
        } else {
            _filePath = nil;
        }
    }
}

- (void)setUserDefaultsKey:(NSString*)userDefaultsKey {
    if(_userDefaultsKey != userDefaultsKey) {
        _userDefaultsKey = userDefaultsKey;
    }
}

- (void)setModels:(NSArray*)items {
    _needLoad = NO;
    _models.array = items;
}

- (NSArray*)models {
    [self _loadIsNeed];
    return [_models copy];
}

#pragma mark Public

- (void)fromJson:(id)json modelClass:(Class)storageItemClass {
    [_models removeAllObjects];
    if([storageItemClass isSubclassOfClass:MobilyModel.class] == YES) {
        if([json isKindOfClass:NSArray.class] == YES) {
            for(id jsonItem in json) {
                id item = [[storageItemClass alloc] initWithJson:jsonItem];
                if(item != nil) {
                    [_models addObject:item];
                }
            }
        }
    }
}

- (NSUInteger)count {
    [self _loadIsNeed];
    return _models.count;
}

- (id)modelAtIndex:(NSUInteger)index {
    [self _loadIsNeed];
    return _models[index];
}

- (id)firstModel {
    [self _loadIsNeed];
    if(_models.count > 0) {
        return _models[0];
    }
    return nil;
}

- (id)lastModel {
    return [_models lastObject];
}

- (void)prependModel:(MobilyModel*)item {
    [self _loadIsNeed];
    [_models insertObject:item atIndex:0];
}

- (void)prependModelsFromArray:(NSArray*)items {
    [self _loadIsNeed];
    [_models insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)]];
}

- (void)appendModel:(MobilyModel*)item {
    [self _loadIsNeed];
    [_models addObject:item];
}

- (void)appendModelsFromArray:(NSArray*)items {
    [self _loadIsNeed];
    [_models addObjectsFromArray:items];
}

- (void)insertModel:(MobilyModel*)item atIndex:(NSUInteger)index {
    [self _loadIsNeed];
    [_models insertObject:item atIndex:index];
}

- (void)insertModelsFromArray:(NSArray*)items atIndex:(NSUInteger)index {
    [self _loadIsNeed];
    [_models insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, items.count)]];
}

- (void)removeModel:(MobilyModel*)item {
    [self _loadIsNeed];
    [_models removeObject:item];
}

- (void)removeModelsInArray:(NSArray*)items {
    [self _loadIsNeed];
    [_models removeObjectsInArray:items];
}

- (void)removeAllModels {
    [self _loadIsNeed];
    [_models removeAllObjects];
}

- (void)enumirateModelsUsingBlock:(MobilyModelCollectionEnumBlock)block {
    [self _loadIsNeed];
    [_models enumerateObjectsUsingBlock:^(id item, NSUInteger index __unused, BOOL* stop) {
        block(item, stop);
    }];
}

- (BOOL)save {
    @try {
        if(_needLoad == NO) {
            if(_userDefaultsKey.length > 0) {
                @try {
                    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_models];
                    [NSUserDefaults.standardUserDefaults setObject:data forKey:_userDefaultsKey];
                }
                @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
                    NSLog(@"ERROR: [%@:%@]: Exception = %@", self.class, NSStringFromSelector(_cmd), exception);
#endif
                    [_models removeAllObjects];
                }
            } else if(_filePath.length > 0) {
                return [NSKeyedArchiver archiveRootObject:_models toFile:_filePath];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"ERROR: [%@:%@]: Exception = %@", self.class, NSStringFromSelector(_cmd), exception);
#endif
    }
    return NO;
}

#pragma mark Private

- (NSMutableArray*)_mutableModels {
    [self _loadIsNeed];
    return _models;
}

- (void)_loadIsNeed {
    if(_needLoad == YES) {
        [self _load];
        _needLoad = NO;
    }
}

- (void)_load {
    @try {
        if(_userDefaultsKey.length > 0) {
            NSData* data = [NSUserDefaults.standardUserDefaults objectForKey:_userDefaultsKey];
            if([data isKindOfClass:NSData.class] == YES) {
                id items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if([items isKindOfClass:NSArray.class] == YES) {
                    _models.array = items;
                } else {
                    [_models removeAllObjects];
                }
            }
        } else if(_filePath.length > 0) {
            id items = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if([items isKindOfClass:NSArray.class] == YES) {
                _models.array = items;
            } else {
                [_models removeAllObjects];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"ERROR: [%@:%@]: Exception = %@", self.class, NSStringFromSelector(_cmd), exception);
#endif
        [_models removeAllObjects];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelQuery

#pragma mark Synthesize

@synthesize delegate = _delegate;
@synthesize reloadBlock = _reloadBlock;
@synthesize resortBlock = _resortBlock;
@synthesize resortInvert = _resortInvert;
@synthesize models = _models;

#pragma mark Init / Free

- (instancetype)initWithCollection:(MobilyModelCollection*)collection {
    self = [super init];
    if(self != nil) {
        _collection = collection;
        [self setup];
    }
    return self;
}

- (void)setup {
    _models = NSMutableArray.array;
    _needReload = YES;
    _needResort = YES;
}

#pragma mark Public

- (void)setNeedReload {
    _needReload = YES;
    _needResort = YES;
}

- (void)setNeedResort {
    _needResort = YES;
}

- (NSUInteger)count {
    return self.models.count;
}

- (id)modelAtIndex:(NSUInteger)index {
    return self.models[index];
}

- (NSArray*)models {
    if(_needReload == YES) {
        [self _reload];
        _needReload = NO;
    }
    if(_needResort == YES) {
        [self _resort];
        _needResort = NO;
    }
    return _models;
}

#pragma mark Property

- (void)setReloadBlock:(MobilyModelQueryReloadBlock)reloadBlock {
    if(_reloadBlock != reloadBlock) {
        _reloadBlock = [reloadBlock copy];
        _needReload = YES;
        _needResort = YES;
    }
}

- (void)setResortBlock:(MobilyModelQueryResortBlock)resortBlock {
    if(_resortBlock != resortBlock) {
        _resortBlock = [resortBlock copy];
        _needResort = YES;
    }
}

- (void)setResortInvert:(BOOL)resortInvert {
    if(_resortInvert != resortInvert) {
        _resortInvert = resortInvert;
        _needResort = YES;
    }
}

#pragma mark Private

- (void)_reload {
    NSArray* collectionModels = [_collection _mutableModels];
    if([_delegate respondsToSelector:@selector(modelQuery:reloadItem:)] == YES) {
        [_models removeAllObjects];
        for(id item in collectionModels) {
            if([_delegate modelQuery:self reloadItem:item] == YES) {
                [_models addObject:item];
            }
        }
    } else if(_reloadBlock != nil) {
        [_models removeAllObjects];
        for(id item in collectionModels) {
            if(_reloadBlock(item) == YES) {
                [_models addObject:item];
            }
        }
    } else {
        _models.array = collectionModels;
    }
}

- (void)_resort {
    if(_resortInvert == YES) {
        if([_delegate respondsToSelector:@selector(modelQuery:resortItem1:item2:)] == YES) {
            [_models sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch(_resortBlock(item1, item2)) {
                    case MobilyModelQuerySortResultMore: return NSOrderedDescending;
                    case MobilyModelQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        } else if(_resortBlock != nil) {
            [_models sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch([_delegate modelQuery:self resortItem1:item1 item2:item2]) {
                    case MobilyModelQuerySortResultMore: return NSOrderedDescending;
                    case MobilyModelQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        }
    } else {
        if([_delegate respondsToSelector:@selector(modelQuery:resortItem1:item2:)] == YES) {
            [_models sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)_resortBlock(item1, item2);
            }];
        } else if(_resortBlock != nil) {
            [_models sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)[_delegate modelQuery:self resortItem1:item1 item2:item2];
            }];
        }
    }
}

@end

/*--------------------------------------------------*/
