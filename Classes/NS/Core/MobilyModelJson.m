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

#import "MobilyModelJson.h"
#import "MobilyModel.h"

/*--------------------------------------------------*/

@interface MobilyModelJson ()

@property(nonatomic, readwrite, strong) NSString* path;
@property(nonatomic, readwrite, strong) NSArray* subPaths;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonArray ()

@property(nonatomic, readwrite, strong) MobilyModelJson* jsonConverter;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonDictionary ()

@property(nonatomic, readwrite, strong) MobilyModelJson* jsonConverter;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonBool ()

@property(nonatomic, readwrite, assign) BOOL defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonString ()

@property(nonatomic, readwrite, strong) NSString* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonUrl ()

@property(nonatomic, readwrite, strong) NSURL* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonNumber ()

@property(nonatomic, readwrite, strong) NSNumber* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonDate ()

@property(nonatomic, readwrite, strong) NSDate* defaultValue;
@property(nonatomic, readwrite, strong) NSArray* formats;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonEnum ()

@property(nonatomic, readwrite, strong) NSNumber* defaultValue;
@property(nonatomic, readwrite, strong) NSDictionary* enums;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonCustomClass ()

@property(nonatomic, readwrite, assign) Class customClass;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJson

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

@implementation MobilyModelJsonArray

- (id)initWithJsonConverter:(MobilyModelJson*)jsonConverter {
    self = [super init];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter {
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

@implementation MobilyModelJsonDictionary

- (id)initWithJsonConverter:(MobilyModelJson*)jsonConverter {
    self = [super init];
    if(self != nil) {
        [self setJsonConverter:jsonConverter];
    }
    return self;
}

- (id)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter {
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

@implementation MobilyModelJsonBool

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

@implementation MobilyModelJsonString

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

@implementation MobilyModelJsonUrl

- (id)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue {
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
        return [NSURL URLWithString:value];
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonNumber

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

@implementation MobilyModelJsonDate

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
        return [NSDate dateWithTimeIntervalSince1970:[value longValue]];
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonEnum

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

@implementation MobilyModelJsonCustomClass

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
