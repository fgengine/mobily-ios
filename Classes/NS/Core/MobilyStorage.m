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

#import "MobilyStorage.h"

/*--------------------------------------------------*/

@interface MobilyStorage : NSObject

+ (NSString*)fileSystemDirectory;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageItem ()

@property(nonatomic, readwrite, weak) NSArray* propertyMap;
@property(nonatomic, readwrite, weak) NSDictionary* jsonMap;

+ (NSArray*)buildPropertyMap;
+ (NSDictionary*)buildJsonMap;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverter ()

@property(nonatomic, readwrite, strong) NSString* path;
@property(nonatomic, readwrite, strong) NSArray* subPaths;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterArray ()

@property(nonatomic, readwrite, strong) MobilyStorageJsonConverter* jsonConverter;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterDictionary ()

@property(nonatomic, readwrite, strong) MobilyStorageJsonConverter* jsonConverter;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterBool ()

@property(nonatomic, readwrite, assign) BOOL defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterString ()

@property(nonatomic, readwrite, strong) NSString* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterNumber ()

@property(nonatomic, readwrite, strong) NSNumber* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterDate ()

@property(nonatomic, readwrite, strong) NSDate* defaultValue;
@property(nonatomic, readwrite, strong) NSArray* formats;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterEnum ()

@property(nonatomic, readwrite, strong) NSNumber* defaultValue;
@property(nonatomic, readwrite, strong) NSDictionary* enums;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterCustomClass ()

@property(nonatomic, readwrite, assign) Class customClass;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageCollection ()

@property(nonatomic, readwrite, strong) NSString* filePath;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeItems;
@property(nonatomic, readwrite, assign) BOOL flagLoad;

- (void)loadIsNeedItems;
- (void)loadItems;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorageQuery () {
    NSMutableArray* _unsafeItems;
}

@property(nonatomic, readwrite, weak) MobilyStorageCollection* collection;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeItems;
@property(nonatomic, readwrite, assign) BOOL flagReload;
@property(nonatomic, readwrite, assign) BOOL flagResort;

- (void)reloadItems;
- (void)resortItems;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorage

+ (NSString*)fileSystemDirectory {
    static NSString* fileSystemDirectory = nil;
    if(fileSystemDirectory == nil) {
        fileSystemDirectory = [[NSFileManager cachesDirectory] stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    }
    return fileSystemDirectory;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageItem

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setupItem];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
            id value = [coder decodeObjectForKey:field];
            if(value != nil) {
                [self setValue:value forKey:field];
            }
        }];
        [self setupItem];
    }
    return self;
}

- (id)initWithJson:(id)json {
    self = [super init];
    if(self != nil) {
        [self convertFromJson:json];
        [self setupItem];
    }
    return self;
}

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        [self setUserDefaultsKey:userDefaultsKey];
        [self loadItem];
        [self setupItem];
    }
    return self;
}

- (void)dealloc {
    [self setUserDefaultsKey:nil];
    [self setPropertyMap:nil];
    [self setJsonMap:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (BOOL)isEqual:(id)object {
    __block BOOL result = NO;
    if(([object isKindOfClass:[self class]] == YES) && ([[self propertyMap] count] > 0)) {
        result = YES;
        [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
            id value1 = [self valueForKey:field];
            id value2 = [object valueForKey:field];
            if(value1 != value2) {
                if([value1 isEqual:value2] == NO) {
                    result = NO;
                    *stop = YES;
                }
            }
        }];
    } else {
        result = [super isEqual:object];
    }
    return result;
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
        id value = [self valueForKey:field];
        if(value != nil) {
            [coder encodeObject:value forKey:field];
        }
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    id result = [[[self class] allocWithZone:zone] init];
    if(result != nil) {
        [result setPropertyMap:[self propertyMap]];
        [result setJsonMap:[self jsonMap]];
        [result setUserDefaultsKey:[self userDefaultsKey]];
        
        [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
            [result setValue:[[self valueForKey:field] copyWithZone:zone] forKey:field];
        }];
    }
    return result;
}

#pragma mark Property

- (void)setupItem {
}

- (NSArray*)propertyMap {
    if(_propertyMap == nil) {
        [self setPropertyMap:[[self class] buildPropertyMap]];
    }
    return _propertyMap;
}

- (NSDictionary*)jsonMap {
    if(_jsonMap == nil) {
        [self setJsonMap:[[self class] buildJsonMap]];
    }
    return _jsonMap;
}

#pragma mark Public

+ (NSArray*)propertyMap {
    return nil;
}

+ (NSDictionary*)jsonMap {
    return nil;
}

- (void)convertFromJson:(id)json {
    [[self jsonMap] enumerateKeysAndObjectsUsingBlock:^(NSString* field, MobilyStorageJsonConverter* converter, BOOL* stop) {
        id value = [converter parseJson:json];
        if(value != nil) {
            [self setValue:value forKey:field];
        }
    }];
}

- (void)clearItem {
    [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
        @try {
            [self setValue:nil forKey:field];
        }
        @catch(NSException *exception) {
        }
    }];
}

- (void)clearItemComplete:(MobilyStorageItemBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self clearItem];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

- (BOOL)saveItem {
    @try {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        if(dict != nil) {
            [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
                @try {
                    id value = [self valueForKey:field];
                    if(value != nil) {
                        NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:value];
                        if(archive != nil) {
                            [dict setObject:archive forKey:field];
                        }
                    }
                }
                @catch (NSException* exception) {
                    NSLog(@"MobilyStorageItem::saveItem:%@ Exception = %@ Field=%@", _userDefaultsKey, exception, field);
                }
            }];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:_userDefaultsKey];
            return [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyStorageItem::saveItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
    return NO;
}

- (void)saveItemSuccess:(MobilyStorageItemBlock)success failure:(MobilyStorageItemBlock)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if([self saveItem] == YES) {
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

- (void)loadItem {
    @try {
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:_userDefaultsKey];
        if(dict != nil) {
            [[self propertyMap] enumerateObjectsUsingBlock:^(NSString* field, NSUInteger index, BOOL* stop) {
                id value = [dict objectForKey:field];
                if(value != nil) {
                    if([value isKindOfClass:[NSData class]] == YES) {
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
            }];
        }
    }
    @catch(NSException* exception) {
        NSLog(@"MobilyStorageItem::loadItem:%@ Exception = %@", _userDefaultsKey, exception);
    }
}

- (void)loadItemComplete:(MobilyStorageItemBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self loadItem];
        if(complete != nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    });
}

#pragma mark Private

+ (NSArray*)buildPropertyMap {
    static NSMutableDictionary* propertyMap = nil;
    if(propertyMap == nil) {
        propertyMap = [NSMutableDictionary dictionary];
    }
    NSMutableArray* result = nil;
    NSString* className = NSStringFromClass([self class]);
    if(className != nil) {
        result = [propertyMap objectForKey:className];
        if(result == nil) {
            result = [NSMutableArray array];
            if(result != nil) {
                NSMutableArray* finalMap = [NSMutableArray array];
                if(finalMap != nil) {
                    if([[self superclass] respondsToSelector:_cmd] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        id superMap = [[self superclass] performSelector:_cmd];
#pragma clang diagnostic pop
                        if([superMap isKindOfClass:[NSArray class]] == YES) {
                            [result addObjectsFromArray:superMap];
                        }
                    }
                    id selfMap = [self propertyMap];
                    if([selfMap isKindOfClass:[NSArray class]] == YES) {
                        [result addObjectsFromArray:selfMap];
                    }
                    [propertyMap setObject:result forKey:className];
                }
            }
        }
    }
    return result;
}

+ (NSDictionary*)buildJsonMap {
    static NSMutableDictionary* jsonMaps = nil;
    if(jsonMaps == nil) {
        jsonMaps = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary* result = nil;
    NSString* className = NSStringFromClass([self class]);
    if(className != nil) {
        result = [jsonMaps objectForKey:className];
        if(result == nil) {
            result = [NSMutableDictionary dictionary];
            if(result != nil) {
                NSMutableDictionary* finalMap = [NSMutableDictionary dictionary];
                if(finalMap != nil) {
                    if([[self superclass] respondsToSelector:_cmd] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        id superMap = [[self superclass] performSelector:_cmd];
#pragma clang diagnostic pop
                        if([superMap isKindOfClass:[NSDictionary class]] == YES) {
                            [result addEntriesFromDictionary:superMap];
                        }
                    }
                    id selfMap = [self jsonMap];
                    if([selfMap isKindOfClass:[NSDictionary class]] == YES) {
                        [result addEntriesFromDictionary:selfMap];
                    }
                    [jsonMaps setObject:result forKey:className];
                }
            }
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverter

- (id)initWithPath:(NSString*)path {
    self = [super init];
    if(self != nil) {
        [self setPath:path];
        
        NSMutableArray* subPaths = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"|"]];
        [subPaths enumerateObjectsUsingBlock:^(NSString* subPath, NSUInteger subPathIndex, BOOL* subPathStop) {
            [subPaths replaceObjectAtIndex:subPathIndex withObject:[subPath componentsSeparatedByString:@"."]];
        }];
        [self setSubPaths:subPaths];
    }
    return self;
}

- (void)dealloc {
    [self setSubPaths:nil];
    [self setPath:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)parseJson:(id)json {
    __block id value = json;
    if([value isKindOfClass:[NSDictionary class]] == YES) {
        [_subPaths enumerateObjectsUsingBlock:^(NSArray* subPath, NSUInteger subPathIndex, BOOL* subPathStop) {
            value = json;
            [subPath enumerateObjectsUsingBlock:^(NSString* path, NSUInteger pathIndex, BOOL* pathStop) {
                if([value isKindOfClass:[NSDictionary class]] == YES) {
                    value = [value objectForKey:path];
                    if(value == nil) {
                        *pathStop = YES;
                    }
                } else {
                    if(pathIndex != ([subPath count] - 1)) {
                        value = nil;
                    }
                    *pathStop = YES;
                }
            }];
        }];
    }
    return [self convertValue:value];
}

- (id)convertValue:(id)value {
    return value;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterArray

- (id)initWithJsonConverter:(MobilyStorageJsonConverter*)jsonConverter {
    self = [super init];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)initWithPath:(NSString*)path jsonConverter:(MobilyStorageJsonConverter*)jsonConverter {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray* result = [NSMutableArray array];
        if(result != nil) {
            [value enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
                id convertedValue = [_jsonConverter convertValue:object];
                if(convertedValue != nil) {
                    [result addObject:convertedValue];
                }
            }];
            return result;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterDictionary

- (id)initWithJsonConverter:(MobilyStorageJsonConverter*)jsonConverter {
    self = [super init];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)initWithPath:(NSString*)path jsonConverter:(MobilyStorageJsonConverter*)jsonConverter {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSDictionary class]] == YES) {
        NSMutableDictionary* result = [NSMutableDictionary dictionary];
        if(result != nil) {
            [value enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop) {
                id convertedValue = [_jsonConverter convertValue:object];
                if(convertedValue != nil) {
                    [result setObject:convertedValue forKey:key];
                }
            }];
            return result;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterBool

- (id)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSString class]] == YES) {
        NSString* lowercaseString = [value lowercaseString];
        if(([lowercaseString isEqualToString:@"true"] == YES) || ([lowercaseString isEqualToString:@"yes"] == YES) || ([lowercaseString isEqualToString:@"on"] == YES)) {
            return @YES;
        }
        return @NO;
    } else if([value isKindOfClass:[NSNumber class]] == YES) {
        return value;
    }
    return @(_defaultValue);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterString

- (id)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (void)dealloc {
    [self setDefaultValue:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSString class]] == YES) {
        return value;
    } else if([value isKindOfClass:[NSNumber class]] == YES) {
        static NSNumberFormatter* numberFormat = nil;
        if(numberFormat == nil) {
            numberFormat = [[NSNumberFormatter alloc] init];
            [numberFormat setLocale:[NSLocale currentLocale]];
            [numberFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        return [numberFormat stringFromNumber:value];
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterNumber

- (id)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (void)dealloc {
    [self setDefaultValue:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSNumber class]] == YES) {
        return value;
    } else if([value isKindOfClass:[NSString class]] == YES) {
        static NSNumberFormatter* numberFormat = nil;
        if(numberFormat == nil) {
            numberFormat = [[NSNumberFormatter alloc] init];
        }
        [numberFormat setLocale:[NSLocale currentLocale]];
        [numberFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber* number = [numberFormat numberFromString:value];
        if(number == nil) {
            if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                [numberFormat setDecimalSeparator:@","];
            }
            number = [numberFormat numberFromString:value];
        }
        if(number != nil) {
            return number;
        }
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterDate

- (id)initWithFormat:(NSString*)format {
    self = [super init];
    if(self != nil) {
        [self setFormats:@[ format ]];
    }
    return self;
}

- (id)initWithFormats:(NSArray*)formats {
    self = [super init];
    if(self != nil) {
        [self setFormats:formats];
    }
    return self;
}

- (id)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue {
    self = [super init];
    if(self != nil) {
        [self setFormats:@[ format ]];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    self = [super init];
    if(self != nil) {
        [self setFormats:formats];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)initWithPath:(NSString*)path format:(NSString*)format {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setFormats:@[ format ]];
    }
    return self;
}

- (id)initWithPath:(NSString*)path formats:(NSArray*)formats {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setFormats:formats];
    }
    return self;
}

- (id)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setFormats:@[ format ]];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setFormats:formats];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (void)dealloc {
    [self setFormats:nil];
    [self setDefaultValue:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSString class]] == YES) {
        static NSDateFormatter* dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        __block NSDate* resultValue = nil;
        [_formats enumerateObjectsUsingBlock:^(NSString* format, NSUInteger index, BOOL* stop) {
            if([format isKindOfClass:[NSString class]] == true) {
                [dateFormatter setDateFormat:format];
            }
            NSDate* date = [dateFormatter dateFromString:value];
            if(date != nil) {
                resultValue = date;
                *stop = YES;
            }
        }];
        return resultValue;
    } else if([value isKindOfClass:[NSNumber class]] == YES) {
        return [NSDate dateWithTimeIntervalSince1970:[value floatValue]];
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterEnum

- (id)initWithEnums:(NSDictionary*)enums {
    self = [super init];
    if(self != nil) {
        [self setEnums:enums];
    }
    return self;
}

- (id)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    self = [super init];
    if(self != nil) {
        [self setEnums:enums];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setEnums:enums];
    }
    return self;
}

- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setEnums:enums];
        [self setDefaultValue:defaultValue];
    }
    return self;
}

- (void)dealloc {
    [self setEnums:nil];
    [self setDefaultValue:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSString class]] == YES) {
        if([[_enums allKeys] containsObject:value] == YES) {
            return [_enums objectForKey:value];
        }
    } else if([value isKindOfClass:[NSNumber class]] == YES) {
        if([[_enums allKeys] containsObject:value] == YES) {
            return [_enums objectForKey:value];
        }
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageJsonConverterCustomClass

- (id)initWithCustomClass:(Class)customClass {
    self = [super init];
    if(self != nil) {
        [self setCustomClass:customClass];
    }
    return self;
}

- (id)initWithPath:(NSString*)path customClass:(Class)customClass {
    self = [super initWithPath:path];
    if(self != nil) {
        [self setCustomClass:customClass];
    }
    return self;
}

- (void)dealloc {
    [self setCustomClass:nil];
    
    MOBILY_SAFE_DEALLOC;
}

- (id)convertValue:(id)value {
    if([value isKindOfClass:[NSDictionary class]] == YES) {
        return [[_customClass alloc] initWithJson:value];
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_STORAGE_COLLECTION_EXTENSION         @"collection"

/*--------------------------------------------------*/

@implementation MobilyStorageCollection

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setUnsafeItems:[NSMutableArray array]];
        [self setFlagLoad:NO];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        id items = [coder decodeObjectForKey:@"items"];
        if(items != nil) {
            [self setUnsafeItems:items];
        } else {
            [self setUnsafeItems:[NSMutableArray array]];
        }
        [self setFlagLoad:NO];
        [self setupCollection];
    }
    return self;
}

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey {
    self = [super init];
    if(self != nil) {
        [self setUserDefaultsKey:userDefaultsKey];
        [self setUnsafeItems:[NSMutableArray array]];
        [self setFlagLoad:YES];
        [self setupCollection];
    }
    return self;
}

- (id)initWithFileName:(NSString*)fileName {
    self = [super init];
    if(self != nil) {
        NSString* fileGroup = [MobilyStorage fileSystemDirectory];
        if(fileGroup != nil) {
            NSString* filePath = [fileGroup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, MOBILY_STORAGE_COLLECTION_EXTENSION]];
            if(filePath != nil) {
                [self setFileName:fileName];
                [self setFilePath:filePath];
                [self setUnsafeItems:[NSMutableArray array]];
                [self setFlagLoad:YES];
                [self setupCollection];
            } else {
                self = nil;
            }
        } else {
            self = nil;
        }
    }
    return self;
}

- (id)initWithJson:(id)json storageItemClass:(Class)storageItemClass {
    self = [super init];
    if(self != nil) {
        [self setUnsafeItems:[NSMutableArray array]];
        [self setFlagLoad:NO];
        [self convertFromJson:json storageItemClass:storageItemClass];
        [self setupCollection];
    }
    return self;
}

- (void)dealloc {
    [self setFileName:nil];
    [self setUserDefaultsKey:nil];
    [self setFilePath:nil];
    [self setUnsafeItems:nil];

    MOBILY_SAFE_DEALLOC;
}

- (void)encodeWithCoder:(NSCoder*)coder {
    [self loadIsNeedItems];
    [coder encodeObject:_unsafeItems forKey:@"items"];
}

- (id)copyWithZone:(NSZone*)zone {
    id result = [[[self class] allocWithZone:zone] init];
    if(result != nil) {
        [result setFilePath:[self filePath]];
        [result setUserDefaultsKey:[self userDefaultsKey]];
        [result setUnsafeItems:[[self unsafeItems] copyWithZone:zone]];
        [result setFlagLoad:[self flagLoad]];
    }
    return result;
}

#pragma mark Property

- (void)setFileName:(NSString*)fileName {
    if(_fileName != fileName) {
        MOBILY_SAFE_SETTER(_fileName, fileName);
        
        NSString* fileGroup = [MobilyStorage fileSystemDirectory];
        if(fileGroup != nil) {
            NSString* filePath = [fileGroup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, MOBILY_STORAGE_COLLECTION_EXTENSION]];
            if(filePath != nil) {
                [self setFilePath:filePath];
            } else {
                [self setFilePath:nil];
            }
        } else {
            [self setFilePath:nil];
        }
    }
}

- (void)setUserDefaultsKey:(NSString*)userDefaultsKey {
    if(_userDefaultsKey != userDefaultsKey) {
        MOBILY_SAFE_SETTER(_userDefaultsKey, userDefaultsKey);
    }
}

#pragma mark Public

- (void)setupCollection {
}

- (void)convertFromJson:(id)json storageItemClass:(Class)storageItemClass {
    [_unsafeItems removeAllObjects];
    if([storageItemClass isSubclassOfClass:[MobilyStorageItem class]] == YES) {
        if([json isKindOfClass:[NSArray class]] == YES) {
            [json enumerateObjectsUsingBlock:^(id jsonItem, NSUInteger jsonItemIndex, BOOL* jsonItemStop) {
                id item = [[storageItemClass alloc] initWithJson:jsonItem];
                if(item != nil) {
                    [_unsafeItems addObject:item];
                }
            }];
        }
    }
}

- (NSUInteger)countItems {
    [self loadIsNeedItems];
    return [_unsafeItems count];
}

- (id)itemAtIndex:(NSUInteger)index {
    [self loadIsNeedItems];
    return [_unsafeItems objectAtIndex:index];
}

- (id)firstItem {
    [self loadIsNeedItems];
    if([_unsafeItems count] > 0) {
        return [_unsafeItems objectAtIndex:0];
    }
    return nil;
}

- (id)lastItem {
    return [_unsafeItems lastObject];
}

- (void)prependItem:(MobilyStorageItem*)item {
    [self loadIsNeedItems];
    [_unsafeItems insertObject:item atIndex:0];
}

- (void)prependItems:(NSArray*)items {
    [self loadIsNeedItems];
    [_unsafeItems insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [items count])]];
}

- (void)appendItem:(MobilyStorageItem*)item {
    [self loadIsNeedItems];
    [_unsafeItems addObject:item];
}

- (void)appendItems:(NSArray*)items {
    [self loadIsNeedItems];
    [_unsafeItems addObjectsFromArray:items];
}

- (void)insertItem:(MobilyStorageItem*)item atIndex:(NSUInteger)index {
    [self loadIsNeedItems];
    [_unsafeItems insertObject:item atIndex:index];
}

- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index {
    [self loadIsNeedItems];
    [_unsafeItems insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [items count])]];
}

- (void)removeItem:(MobilyStorageItem*)item {
    [self loadIsNeedItems];
    [_unsafeItems removeObject:item];
}

- (void)removeItems:(NSArray*)items {
    [self loadIsNeedItems];
    [_unsafeItems removeObjectsInArray:items];
}

- (void)removeAllItems {
    [self loadIsNeedItems];
    [_unsafeItems removeAllObjects];
}

- (NSArray*)items {
    [self loadIsNeedItems];
    return MOBILY_SAFE_AUTORELEASE([_unsafeItems copy]);
}

- (void)enumirateItemsUsingBlock:(MobilyStorageCollectionEnumBlock)block {
    [self loadIsNeedItems];
    [_unsafeItems enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        block(item, stop);
    }];
}

- (BOOL)saveItems {
    @try {
        if(_flagLoad == NO) {
            if([_userDefaultsKey length] > 0) {
                NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:_userDefaultsKey];
                if([data isKindOfClass:[NSData class]] == YES) {
                    id items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if([items isKindOfClass:[NSArray class]] == YES) {
                        [_unsafeItems setArray:items];
                    } else {
                        [_unsafeItems removeAllObjects];
                    }
                }
            } else if([_filePath length] > 0) {
                NSFileManager* fileManager = [NSFileManager defaultManager];
                if([fileManager fileExistsAtPath:_filePath] == NO) {
                    NSError* error = nil;
                    NSString* fileSystemDirectory = [MobilyStorage fileSystemDirectory];
                    if([fileManager createDirectoryAtPath:fileSystemDirectory withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
                        return NO;
                    }
                }
                return [NSKeyedArchiver archiveRootObject:_unsafeItems toFile:_filePath];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"MobilyStorageCollection::saveItems: Exception = %@", exception);
#endif
    }
    return NO;
}

#pragma mark Private

- (NSMutableArray*)safeItems {
    [self loadIsNeedItems];
    return _unsafeItems;
}

- (void)loadIsNeedItems {
    if(_flagLoad == YES) {
        [self loadItems];
        _flagLoad = NO;
    }
}

- (void)loadItems {
    @try {
        if([_userDefaultsKey length] > 0) {
            NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:_userDefaultsKey];
            if([data isKindOfClass:[NSData class]] == YES) {
                id items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if([items isKindOfClass:[NSArray class]] == YES) {
                    [_unsafeItems setArray:items];
                } else {
                    [_unsafeItems removeAllObjects];
                }
            }
        } else if([_filePath length] > 0) {
            id items = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if([items isKindOfClass:[NSArray class]] == YES) {
                [_unsafeItems setArray:items];
            } else {
                [_unsafeItems removeAllObjects];
            }
        }
    }
    @catch(NSException* exception) {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
        NSLog(@"MobilyStorageCollection::loadItems: Exception = %@", exception);
#endif
        [_unsafeItems removeAllObjects];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorageQuery : NSObject

#pragma mark Standart

- (id)initWithCollection:(MobilyStorageCollection*)collection {
    self = [super init];
    if(self != nil) {
        [self setCollection:collection];
        [self setUnsafeItems:[NSMutableArray array]];
        [self setFlagReload:YES];
        [self setFlagResort:YES];
    }
    return self;
}

- (void)dealloc {
    [self setCollection:nil];
    [self setUnsafeItems:nil];
    [self setReloadBlock:nil];
    [self setResortBlock:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)setNeedReload {
    _flagReload = YES;
    _flagResort = YES;
}

- (void)setNeedResort {
    _flagReload = YES;
}

- (NSUInteger)countItems {
    return [[self items] count];
}

- (id)itemAtIndex:(NSUInteger)index {
    return [[self items] objectAtIndex:index];
}

- (NSArray*)items {
    if(_flagReload == YES) {
        [self reloadItems];
        _flagReload = NO;
    }
    if(_flagResort == YES) {
        [self resortItems];
        _flagResort = NO;
    }
    return _unsafeItems;
}

#pragma mark Property

- (void)setReloadBlock:(MobilyStorageQueryReloadBlock)block {
    _reloadBlock = MOBILY_SAFE_RETAIN([block copy]);
    _flagReload = YES;
    _flagResort = YES;
}

- (void)setResortBlock:(MobilyStorageQueryResortBlock)block {
    _resortBlock = MOBILY_SAFE_RETAIN([block copy]);
    _flagResort = YES;
}

- (void)setResortInvert:(BOOL)resortInvert {
    if(_resortInvert != resortInvert) {
        _resortInvert = resortInvert;
        _flagResort = YES;
    }
}

#pragma mark Private

- (void)reloadItems {
    [_unsafeItems removeAllObjects];
    
    if([_delegate respondsToSelector:@selector(storageQuery:reloadItem:)] == YES) {
        [[_collection safeItems] enumerateObjectsUsingBlock:^(id item, NSUInteger itemIndex, BOOL* itemStop) {
            if([_delegate storageQuery:self reloadItem:item] == YES) {
                [_unsafeItems addObject:item];
            }
        }];
    } else if(_reloadBlock != nil) {
        [[_collection safeItems] enumerateObjectsUsingBlock:^(id item, NSUInteger itemIndex, BOOL* itemStop) {
            if(_reloadBlock(item) == YES) {
                [_unsafeItems addObject:item];
            }
        }];
    } else {
        [_unsafeItems setArray:[_collection safeItems]];
    }
}

- (void)resortItems {
    if([_delegate respondsToSelector:@selector(storageQuery:resortItem1:item2:)] == YES) {
        if(_resortInvert == YES) {
            [_unsafeItems sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch([_delegate storageQuery:self resortItem1:item1 item2:item2]) {
                    case MobilyStorageQuerySortResultMore: return NSOrderedDescending;
                    case MobilyStorageQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        } else {
            [_unsafeItems sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)[_delegate storageQuery:self resortItem1:item1 item2:item2];
            }];
        }
    } else if(_resortBlock != nil) {
        if(_resortInvert == YES) {
            [_unsafeItems sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                switch(_resortBlock(item1, item2)) {
                    case MobilyStorageQuerySortResultMore: return NSOrderedDescending;
                    case MobilyStorageQuerySortResultLess: return NSOrderedAscending;
                    default: break;
                }
                return NSOrderedSame;
            }];
        } else {
            [_unsafeItems sortUsingComparator:^NSComparisonResult(id item1, id item2) {
                return (NSComparisonResult)_resortBlock(item1, item2);
            }];
        }
    }
}

@end

/*--------------------------------------------------*/
