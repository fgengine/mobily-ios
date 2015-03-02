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

#import "MobilyObject.h"

/*--------------------------------------------------*/

@interface MobilyModelJson : NSObject < MobilyObject >

@property(nonatomic, readonly, strong) NSString* path;

- (instancetype)initWithPath:(NSString*)path;

- (id)parseJson:(id)json;

- (id)convertValue:(id)value;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonArray : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* jsonConverter;

- (instancetype)initWithJsonConverter:(MobilyModelJson*)jsonConverter;
- (instancetype)initWithJsonModelClass:(Class)jsonModelClass;
- (instancetype)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter;
- (instancetype)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDictionary : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* keyJsonConverter;
@property(nonatomic, readonly, strong) MobilyModelJson* valueJsonConverter;

- (instancetype)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithValueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithKeyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithKeyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass;
- (instancetype)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (instancetype)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonBool : MobilyModelJson

@property(nonatomic, readonly, assign) BOOL defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonString : MobilyModelJson

@property(nonatomic, readonly, strong) NSString* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonUrl : MobilyModelJson

@property(nonatomic, readonly, strong) NSURL* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonNumber : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;

- (instancetype)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDate : MobilyModelJson

@property(nonatomic, readonly, strong) NSDate* defaultValue;
@property(nonatomic, readonly, strong) NSArray* formats;

- (instancetype)initWithFormat:(NSString*)format;
- (instancetype)initWithFormats:(NSArray*)formats;
- (instancetype)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats;
- (instancetype)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (instancetype)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonEnum : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;
@property(nonatomic, readonly, strong) NSDictionary* enums;

- (instancetype)initWithEnums:(NSDictionary*)enums;
- (instancetype)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums;
- (instancetype)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonCustomClass : MobilyModelJson

@property(nonatomic, readonly, assign) Class customClass;

- (instancetype)initWithCustomClass:(Class)customClass;
- (instancetype)initWithPath:(NSString*)path customClass:(Class)customClass;

@end

/*--------------------------------------------------*/

typedef id (^MobilyModelJsonConvertBlock)(id value);

/*--------------------------------------------------*/

@interface MobilyModelJsonBlock : MobilyModelJson

@property(nonatomic, readonly, copy) MobilyModelJsonConvertBlock block;

- (instancetype)initWithBlock:(MobilyModelJsonConvertBlock)block;
- (instancetype)initWithPath:(NSString*)path block:(MobilyModelJsonConvertBlock)block;

@end

/*--------------------------------------------------*/
