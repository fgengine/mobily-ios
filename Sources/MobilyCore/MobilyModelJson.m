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

#import <MobilyCore/MobilyModelJson.h>
#import <MobilyCore/MobilyModel.h>

/*--------------------------------------------------*/

@interface MobilyModelJson ()

@property(nonatomic, readwrite, strong) NSString* path;
@property(nonatomic, readwrite, strong) NSArray* subPaths;
@property(nonatomic, readwrite, copy) MobilyModelJsonUndefinedBehaviour undefinedBehaviour;

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
    return [self initWithPath:path
           undefinedBehaviour:nil];
}

- (instancetype)initWithUndefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [self init];
    if(self != nil) {
        if(path.length > 0) {
            self.path = path;
            NSMutableArray* subPaths = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"|"]];
            [subPaths enumerateObjectsUsingBlock:^(NSString* subPath, NSUInteger index, BOOL* stop __unused) {
                subPaths[index] = [subPath componentsSeparatedByString:@"."];
            }];
            self.subPaths = subPaths;
        }
        self.undefinedBehaviour = undefinedBehaviour;
    }
    return self;
}

- (void)setup {
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
    id result = [self convertValue:value];
    if(result == nil) {
        if(_undefinedBehaviour != nil) {
            result = _undefinedBehaviour(self, value);
        }
    }
    return result;
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

- (instancetype)initWithJsonModelClass:(Class)jsonModelClass {
    return [self initWithPath:nil
                jsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithJsonModelClass:(Class)jsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
                jsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter {
    return [self initWithPath:nil
                jsonConverter:jsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
                jsonConverter:jsonConverter
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass {
    return [self initWithPath:path
                jsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path
                jsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:jsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter {
    return [self initWithPath:path
                jsonConverter:jsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.jsonConverter = jsonConverter;
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

- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass {
    return [self initWithPath:nil
             keyJsonConverter:nil
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
             keyJsonConverter:nil
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    return [self initWithPath:nil
             keyJsonConverter:nil
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
             keyJsonConverter:nil
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass {
    return [self initWithPath:nil
             keyJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass]
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
             keyJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass]
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    return [self initWithPath:nil
             keyJsonConverter:keyJsonConverter
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil
             keyJsonConverter:keyJsonConverter
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass {
    return [self initWithPath:path
             keyJsonConverter:nil
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path
             keyJsonConverter:nil
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    return [self initWithPath:path
             keyJsonConverter:nil
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path
             keyJsonConverter:nil
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass {
    return [self initWithPath:path
             keyJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass]
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path
             keyJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:keyJsonModelClass]
           valueJsonConverter:[[MobilyModelJsonCustomClass alloc] initWithCustomClass:valueJsonModelClass]
           undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter {
    return [self initWithPath:path
             keyJsonConverter:keyJsonConverter
           valueJsonConverter:valueJsonConverter
           undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.keyJsonConverter = keyJsonConverter;
        self.valueJsonConverter = valueJsonConverter;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSDictionary.class] == YES) {
        NSMutableDictionary* result = NSMutableDictionary.dictionary;
        if(result != nil) {
            [value enumerateKeysAndObjectsUsingBlock:^(id jsonKey, id jsonObject, BOOL* stop __unused) {
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
    return [self initWithPath:path defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        NSString* lowercaseString = [value lowercaseString];
        if(([lowercaseString isEqualToString:@"true"] == YES) || ([lowercaseString isEqualToString:@"yes"] == YES) || ([lowercaseString isEqualToString:@"on"] == YES) || ([lowercaseString isEqualToString:@"1"] == YES)) {
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
    return [self initWithPath:path defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
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
            numberFormat.numberStyle = NSNumberFormatterNoStyle;
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
    return [self initWithPath:path defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
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
    return [self initWithPath:path defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
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
        numberFormat.numberStyle = NSNumberFormatterNoStyle;
        
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
@property(nonatomic, readwrite, strong) NSTimeZone* timeZone;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonDate

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:nil timeZone:nil defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:nil timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:nil timeZone:nil defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:nil timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormat:(NSString*)format {
    return [self initWithPath:nil formats:@[ format ] timeZone:nil defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone {
    return [self initWithPath:nil formats:@[ format ] timeZone:timeZone defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithFormat:(NSString*)format undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:@[ format ] timeZone:nil defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:@[ format ] timeZone:timeZone defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:nil formats:@[ format ] timeZone:nil defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:nil formats:@[ format ] timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:@[ format ] timeZone:nil defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:@[ format ] timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format {
    return [self initWithPath:path formats:@[ format ] timeZone:nil defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone {
    return [self initWithPath:path formats:@[ format ] timeZone:timeZone defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:@[ format ] timeZone:nil defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:@[ format ] timeZone:timeZone defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:@[ format ] timeZone:nil defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:@[ format ] timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:@[ format ] timeZone:nil defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:@[ format ] timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormats:(NSArray*)formats {
    return [self initWithPath:nil formats:formats timeZone:nil defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone {
    return [self initWithPath:nil formats:formats timeZone:timeZone defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithFormats:(NSArray*)formats undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:formats timeZone:nil defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:formats timeZone:timeZone defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:nil formats:formats timeZone:nil defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:nil formats:formats timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:formats timeZone:nil defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil formats:formats timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats {
    return [self initWithPath:path formats:formats timeZone:nil defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone {
    return [self initWithPath:path formats:formats timeZone:timeZone defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:formats timeZone:nil defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:formats timeZone:timeZone defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:formats timeZone:nil defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue {
    return [self initWithPath:path formats:formats timeZone:timeZone defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path formats:formats timeZone:nil defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.formats = formats;
        self.defaultValue = defaultValue;
        self.timeZone = timeZone;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if([value isKindOfClass:NSString.class] == YES) {
        static NSDateFormatter* dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [NSDateFormatter new];
        }
        if(_timeZone != nil) {
            dateFormatter.timeZone = _timeZone;
        } else {
            dateFormatter.timeZone = NSTimeZone.localTimeZone;
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
    return [self initWithPath:nil enums:enums defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithEnums:(NSDictionary*)enums undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil enums:enums defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    return [self initWithPath:nil enums:enums defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil enums:enums defaultValue:defaultValue undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums {
    return [self initWithPath:path enums:enums defaultValue:nil undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path enums:enums defaultValue:nil undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue {
    return [self initWithPath:path enums:enums defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.enums = enums;
        self.defaultValue = defaultValue;
    }
    return self;
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

@interface MobilyModelJsonLocation ()

@property(nonatomic, readwrite, strong) CLLocation* defaultValue;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonLocation

#pragma mark Init / Free

- (instancetype)initWithPath:(NSString*)path defaultValue:(CLLocation*)defaultValue {
    return [self initWithPath:path defaultValue:defaultValue undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path defaultValue:(CLLocation*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.defaultValue = defaultValue;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    static NSNumberFormatter* numberFormat = nil;
    if(numberFormat == nil) {
        numberFormat = [NSNumberFormatter new];
        numberFormat.locale = NSLocale.currentLocale;
        numberFormat.formatterBehavior = NSNumberFormatterBehavior10_4;
        numberFormat.numberStyle = NSNumberFormatterNoStyle;
    }
    if([value isKindOfClass:NSString.class] == YES) {
        NSArray* parts = [value componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-/_,"]];
        if(parts.count == 2) {
            NSNumber* latitude = [numberFormat numberFromString:parts[0]];
            if(latitude == nil) {
                if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                    numberFormat.decimalSeparator = @",";
                }
                latitude = [numberFormat numberFromString:parts[0]];
            }
            NSNumber* longitude = [numberFormat numberFromString:parts[1]];
            if(longitude == nil) {
                if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                    numberFormat.decimalSeparator = @",";
                }
                longitude = [numberFormat numberFromString:parts[1]];
            }
            return [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        }
    } else if([value isKindOfClass:NSArray.class] == YES) {
        if([value count] == 2) {
            id latitude = value[0];
            if([latitude isKindOfClass:NSString.class] == YES) {
                latitude = [numberFormat numberFromString:latitude];
                if(latitude == nil) {
                    if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                        numberFormat.decimalSeparator = @",";
                    }
                    latitude = [numberFormat numberFromString:latitude];
                }
            } else if([latitude isKindOfClass:NSNumber.class] == NO) {
                latitude = nil;
            }
            id longitude = value[1];
            if([longitude isKindOfClass:NSString.class] == YES) {
                longitude = [numberFormat numberFromString:longitude];
                if(longitude == nil) {
                    if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                        numberFormat.decimalSeparator = @",";
                    }
                    longitude = [numberFormat numberFromString:longitude];
                }
            } else if([longitude isKindOfClass:NSNumber.class] == NO) {
                longitude = nil;
            }
            return [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        }
    } else if([value isKindOfClass:NSDictionary.class] == YES) {
        id latitude = value[@"latitude"];
        if(latitude == nil) {
            latitude = value[@"lat"];
        }
        if([latitude isKindOfClass:NSString.class] == YES) {
            latitude = [numberFormat numberFromString:latitude];
            if(latitude == nil) {
                if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                    numberFormat.decimalSeparator = @",";
                }
                latitude = [numberFormat numberFromString:latitude];
            }
        } else if([latitude isKindOfClass:NSNumber.class] == NO) {
            latitude = nil;
        }
        id longitude = value[@"longitude"];
        if(longitude == nil) {
            longitude = value[@"lon"];
        }
        if([longitude isKindOfClass:NSString.class] == YES) {
            longitude = [numberFormat numberFromString:longitude];
            if(longitude == nil) {
                if([[numberFormat decimalSeparator] isEqualToString:@"."] == YES) {
                    numberFormat.decimalSeparator = @",";
                }
                longitude = [numberFormat numberFromString:longitude];
            }
        } else if([longitude isKindOfClass:NSNumber.class] == NO) {
            longitude = nil;
        }
        return [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    }
    return _defaultValue;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyModelJsonCustomClass ()

@property(nonatomic, readwrite, assign) Class customClass;
@property(nonatomic, readwrite, assign) BOOL hasAnySource;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyModelJsonCustomClass

#pragma mark Init / Free

- (instancetype)initWithCustomClass:(Class)customClass {
    return [self initWithPath:nil customClass:customClass hasAnySource:NO undefinedBehaviour:nil];
}

- (instancetype)initWithCustomClass:(Class)customClass hasAnySource:(BOOL)hasAnySource {
    return [self initWithPath:nil customClass:customClass hasAnySource:hasAnySource undefinedBehaviour:nil];
}

- (instancetype)initWithCustomClass:(Class)customClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil customClass:customClass hasAnySource:NO undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithCustomClass:(Class)customClass hasAnySource:(BOOL)hasAnySource undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil customClass:customClass hasAnySource:hasAnySource undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass {
    return [self initWithPath:path customClass:customClass hasAnySource:NO undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass hasAnySource:(BOOL)hasAnySource {
    return [self initWithPath:path customClass:customClass hasAnySource:hasAnySource undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:path customClass:customClass hasAnySource:NO undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass hasAnySource:(BOOL)hasAnySource undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
    if(self != nil) {
        self.customClass = customClass;
        self.hasAnySource = hasAnySource;
    }
    return self;
}

#pragma mark MobilyModelJson

- (id)convertValue:(id)value {
    if(_hasAnySource == YES) {
        return [[_customClass alloc] initWithJson:value];
    }
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
    return [self initWithPath:nil block:block undefinedBehaviour:nil];
}

- (instancetype)initWithBlock:(MobilyModelJsonConvertBlock)block undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    return [self initWithPath:nil block:block undefinedBehaviour:undefinedBehaviour];
}

- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block {
    return [self initWithPath:path block:block undefinedBehaviour:nil];
}

- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour {
    self = [super initWithPath:path undefinedBehaviour:undefinedBehaviour];
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
