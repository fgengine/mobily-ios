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

#import <MobilyObject.h>

/*--------------------------------------------------*/

typedef id (^MobilyModelJsonUndefinedBehaviour)(id modelJson, id value);

/*--------------------------------------------------*/

@interface MobilyModelJson : NSObject < MobilyObject >

@property(nonatomic, readonly, strong) NSString* path;

- (instancetype)initWithPath:(NSString*)path;
- (instancetype)initWithUndefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

- (void)setup NS_REQUIRES_SUPER;

- (id)parseJson:(id)json;

- (id)convertValue:(id)value;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonArray : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* jsonConverter;

- (instancetype)initWithJsonModelClass:(Class)jsonModelClass;
- (instancetype)initWithJsonModelClass:(Class)jsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter;
- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass;
- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter;
- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDictionary : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* keyJsonConverter;
@property(nonatomic, readonly, strong) MobilyModelJson* valueJsonConverter;

- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonBool : MobilyModelJson

@property(nonatomic, readonly, assign) BOOL defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonString : MobilyModelJson

@property(nonatomic, readonly, strong) NSString* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonUrl : MobilyModelJson

@property(nonatomic, readonly, strong) NSURL* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonNumber : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDate : MobilyModelJson

@property(nonatomic, readonly, strong) NSDate* defaultValue;
@property(nonatomic, readonly, strong) NSArray* formats;
@property(nonatomic, readonly, strong) NSTimeZone* timeZone;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormat:(NSString*)format;
- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone;
- (instancetype)initWithFormat:(NSString*)format undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormat:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormats:(NSArray*)formats;
- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone;
- (instancetype)initWithFormats:(NSArray*)formats undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithFormats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats timeZone:(NSTimeZone*)timeZone defaultValue:(NSDate*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonEnum : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;
@property(nonatomic, readonly, strong) NSDictionary* enums;

- (instancetype)initWithEnums:(NSDictionary*)enums;
- (instancetype)initWithEnums:(NSDictionary*)enums undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;
- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonLocation : MobilyModelJson

@property(nonatomic, readonly, strong) CLLocation* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(CLLocation*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(CLLocation*)defaultValue undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonCustomClass : MobilyModelJson

@property(nonatomic, readonly, assign) Class customClass;

- (instancetype)initWithCustomClass:(Class)customClass;
- (instancetype)initWithCustomClass:(Class)customClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass;
- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/

typedef id (^MobilyModelJsonConvertBlock)(id value);

/*--------------------------------------------------*/

@interface MobilyModelJsonBlock : MobilyModelJson

@property(nonatomic, readonly, copy) MobilyModelJsonConvertBlock block;

- (instancetype)initWithBlock:(MobilyModelJsonConvertBlock)block;
- (instancetype)initWithBlock:(MobilyModelJsonConvertBlock)block undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;
- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block;
- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block undefinedBehaviour:(MobilyModelJsonUndefinedBehaviour)undefinedBehaviour;

@end

/*--------------------------------------------------*/
