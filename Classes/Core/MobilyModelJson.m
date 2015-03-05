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

@implementation MobilyModelJson

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path {
    self = [super init];
    if(self != nil) {
        self.path = path;
        NSMutableArray* subPaths = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"|"]];
        [subPaths enumerateObjectsUsingBlock:^(NSString* subPath, NSUInteger index, BOOL* stop) {
            subPaths[index] = [subPath componentsSeparatedByString:@"."];
        }];
        self.subPaths = subPaths;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.subPaths = nil;
    self.path = nil;
}

#pragma mark Public

- (id)parseJson:(id)json {
    id value = json;
    if([value isKindOfClass:NSDictionary.class] == YES) {
        for(NSArray* subPath in _subPaths) {
            value = json;
            for(NSString* path in subPath) {
                if([value isKindOfClass:NSDictionary.class] == YES) {
                    value = value[path];
                    if(value == nil) {
                        break;
                    }
                } else {
                    if(path != subPath.lastObject) {
                        value = nil;
                    }
                    break;
                }
            }
        }
    }
    return [self convertValue:value];
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    return value;
}

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

@implementation MobilyModelJsonArray

#pragma mark Init / Free

- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter {
    self = [super init];
    if(self != nil) {
        self.jsonConverter = jsonConverter;
    }
    return self;
}

- (instancetype)initWithJsonModelClass:(Class)jsonModelClass {
    self = [super init];
    if(self != nil) {
        self.jsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass];
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter {
    self = [super initWithPath:path];
    if(self != nil) {
        self.jsonConverter = jsonConverter;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass {
    self = [super initWithPath:path];
    if(self != nil) {
        self.jsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass];
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSArray.class] == YES) {
        NSMutableArray* result = NSMutableArray.array;
        if(result != nil) {
            for(id object in value) {
                id convertedValue = [_jsonConverter convertValue:object];
                if(convertedValue != nil) {
                    [result addObject:convertedValue];
                }
            }
            return result;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonDictionary ()

@property(nonatomic, readwrite, strong) MobilyModelJson* keyJsonConverter;
@property(nonatomic, readwrite, strong) MobilyModelJson* valueJsonConverter;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonDictionary

#pragma mark Init / Free

- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    self = [super init];
    if(self != nil) {
        self.valueJsonConverter = valueJsonConverter;
    }
    return self;
}

- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass {
    self = [super init];
    if(self != nil) {
        self.valueJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass];
    }
    return self;
}

- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    self = [super init];
    if(self != nil) {
        self.keyJsonConverter = keyJsonConverter;
        self.valueJsonConverter = valueJsonConverter;
    }
    return self;
}

- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass {
    self = [super init];
    if(self != nil) {
        self.keyJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass];
        self.valueJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass];
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    self = [super initWithPath:path];
    if(self != nil) {
        self.valueJsonConverter = valueJsonConverter;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass {
    self = [super initWithPath:path];
    if(self != nil) {
        self.valueJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass];
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    self = [super initWithPath:path];
    if(self != nil) {
        self.keyJsonConverter = keyJsonConverter;
        self.valueJsonConverter = valueJsonConverter;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass {
    self = [super initWithPath:path];
    if(self != nil) {
        self.keyJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass];
        self.valueJsonConverter = [[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass];
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSDictionary.class] == YES) {
        NSMutableDictionary* result = NSMutableDictionary.dictionary;
        if(result != nil) {
            [value enumerateKeysAndObjectsUsingBlock:^(id jsonKey, id jsonObject, BOOL* stop) {
                id key = (_keyJsonConverter != nil) ? [_keyJsonConverter convertValue:jsonKey] : jsonKey;
                if(key != nil) {
                    id value = [_valueJsonConverter convertValue:jsonObject];
                    if(value != nil) {
                        result[key] = value;
                    }
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

@interface MobilyModelJsonBool ()

@property(nonatomic, readwrite, assign) BOOL defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonBool

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        NSString* lowercaseString = [value lowercaseString];
        if(([lowercaseString isEqualToString:@"true"] == YES) || ([lowercaseString isEqualToString:@"yes"] == YES) || ([lowercaseString isEqualToString:@"on"] == YES)) {
            return @YES;
        }
        return @NO;
    } else if([value isKindOfClass:NSNumber.class] == YES) {
        return value;
    }
    return @(_defaultValue);
}

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

@implementation MobilyModelJsonString

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)dealloc {
    self.defaultValue = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        return value;
    } else if([value isKindOfClass:NSNumber.class] == YES) {
        static NSNumberFormatter* numberFormat = nil;
        if(numberFormat == nil) {
            numberFormat = [NSNumberFormatter new];
            numberFormat.locale = NSLocale.currentLocale;
            numberFormat.formatterBehavior = NSNumberFormatterBehavior10_4;
            numberFormat.numberStyle = NSNumberFormatterDecimalStyle;
        }
        return [numberFormat stringFromNumber:value];
    }
    return _defaultValue;
}

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

@implementation MobilyModelJsonUrl

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)dealloc {
    self.defaultValue = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        return [NSURL URLWithString:value];
    }
    return _defaultValue;
}

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

@implementation MobilyModelJsonNumber

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)dealloc {
    self.defaultValue = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSNumber.class] == YES) {
        return value;
    } else if([value isKindOfClass:NSString.class] == YES) {
        static NSNumberFormatter* numberFormat = nil;
        if(numberFormat == nil) {
            numberFormat = [NSNumberFormatter new];
        }
        numberFormat.locale = NSLocale.currentLocale;
        numberFormat.formatterBehavior = NSNumberFormatterBehavior10_4;
        numberFormat.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSNumber* number = [numberFormat numberFromString:value];
        if(number == nil) {
            if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                numberFormat.decimalSeparator = @",";
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

@interface MobilyModelJsonDate ()

@property(nonatomic, readwrite, strong) NSDate* defaultValue;
@property(nonatomic, readwrite, strong) NSArray* formats;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonDate

#pragma mark Init / Free

- (instancetype)initWithFormat:(NSString*)format {
    self = [super init];
    if(self != nil) {
        self.formats = @[ format ];
    }
    return self;
}

- (instancetype)initWithFormats:(NSArray*)formats {
    self = [super init];
    if(self != nil) {
        self.formats = formats;
    }
    return self;
}

- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue {
    self = [super init];
    if(self != nil) {
        self.formats = @[ format ];
        self.defaultValue = defaultValue;
    }
    return self;
}

- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    self = [super init];
    if(self != nil) {
        self.formats = formats;
        self.defaultValue = defaultValue;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format {
    self = [super initWithPath:path];
    if(self != nil) {
        self.formats = @[ format ];
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats {
    self = [super initWithPath:path];
    if(self != nil) {
        self.formats = formats;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.formats = @[ format ];
        self.defaultValue = defaultValue;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.formats = formats;
        self.defaultValue = defaultValue;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)dealloc {
    self.formats = nil;
    self.defaultValue = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        static NSDateFormatter* dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [NSDateFormatter new];
        }
        NSDate* resultValue = nil;
        for(NSString* format in _formats) {
            if([format isKindOfClass:NSString.class] == true) {
                dateFormatter.dateFormat = format;
            }
            NSDate* date = [dateFormatter dateFromString:value];
            if(date != nil) {
                resultValue = date;
                break;
            }
        }
        return resultValue;
    } else if([value isKindOfClass:NSNumber.class] == YES) {
        return [NSDate dateWithTimeIntervalSince1970:[value longValue]];
    }
    return _defaultValue;
}

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

@implementation MobilyModelJsonEnum

#pragma mark Init / Free

- (instancetype)initWithEnums:(NSDictionary*)enums {
    self = [super init];
    if(self != nil) {
        self.enums = enums;
    }
    return self;
}

- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    self = [super init];
    if(self != nil) {
        self.enums = enums;
        self.defaultValue = defaultValue;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums {
    self = [super initWithPath:path];
    if(self != nil) {
        self.enums = enums;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    self = [super initWithPath:path];
    if(self != nil) {
        self.enums = enums;
        self.defaultValue = defaultValue;
    }
    return self;
}

- (void)dealloc {
    self.enums = nil;
    self.defaultValue = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        if([_enums.allKeys containsObject:value] == YES) {
            return _enums[value];
        }
    } else if([value isKindOfClass:NSNumber.class] == YES) {
        if([_enums.allKeys containsObject:value] == YES) {
            return _enums[value];
        }
    }
    return _defaultValue;
}

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

@implementation MobilyModelJsonCustomClass

#pragma mark Init / Free

- (instancetype)initWithCustomClass:(Class)customClass {
    self = [super init];
    if(self != nil) {
        self.customClass = customClass;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass {
    self = [super initWithPath:path];
    if(self != nil) {
        self.customClass = customClass;
    }
    return self;
}

- (void)dealloc {
    self.customClass = nil;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSDictionary.class] == YES) {
        return [[_customClass alloc] initWithJson:value];
    }
    return nil;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonBlock ()

@property(nonatomic, readwrite, copy) MobilyModelJsonConvertBlock block;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonBlock

#pragma mark Init / Free

- (instancetype)initWithBlock:(MobilyModelJsonConvertBlock)block {
    self = [super init];
    if(self != nil) {
        self.block = block;
    }
    return self;
}

- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block {
    self = [super initWithPath:path];
    if(self != nil) {
        self.block = block;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if(_block != nil) {
        return _block(value);
    }
    return nil;
}

@end

/*--------------------------------------------------*/
