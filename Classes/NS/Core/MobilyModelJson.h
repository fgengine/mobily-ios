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

@interface MobilyModelJson : NSObject

@property(nonatomic, readonly, strong) NSString* path;

- (id)initWithPath:(NSString*)path;

- (id)parseJson:(id)json;

- (id)convertValue:(id)value;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonArray : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* jsonConverter;

- (id)initWithJsonConverter:(MobilyModelJson*)jsonConverter;
- (id)initWithJsonModelClass:(Class)jsonModelClass;
- (id)initWithPath:(NSString*)path jsonConverter:(MobilyModelJson*)jsonConverter;
- (id)initWithPath:(NSString*)path jsonModelClass:(Class)jsonModelClass;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDictionary : MobilyModelJson

@property(nonatomic, readonly, strong) MobilyModelJson* keyJsonConverter;
@property(nonatomic, readonly, strong) MobilyModelJson* valueJsonConverter;

- (id)initWithValueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (id)initWithValueJsonModelClass:(Class)valueJsonModelClass;
- (id)initWithPath:(NSString*)path valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (id)initWithPath:(NSString*)path valueJsonModelClass:(Class)valueJsonModelClass;
- (id)initWithPath:(NSString*)path keyJsonConverter:(MobilyModelJson*)keyJsonConverter valueJsonConverter:(MobilyModelJson*)valueJsonConverter;
- (id)initWithPath:(NSString*)path keyJsonModelClass:(Class)keyJsonModelClass valueJsonModelClass:(Class)valueJsonModelClass;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonBool : MobilyModelJson

@property(nonatomic, readonly, assign) BOOL defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonString : MobilyModelJson

@property(nonatomic, readonly, strong) NSString* defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonUrl : MobilyModelJson

@property(nonatomic, readonly, strong) NSURL* defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(NSURL*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonNumber : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonDate : MobilyModelJson

@property(nonatomic, readonly, strong) NSDate* defaultValue;
@property(nonatomic, readonly, strong) NSArray* formats;

- (id)initWithFormat:(NSString*)format;
- (id)initWithFormats:(NSArray*)formats;
- (id)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (id)initWithFormats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (id)initWithPath:(NSString*)path format:(NSString*)format;
- (id)initWithPath:(NSString*)path formats:(NSArray*)formats;
- (id)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (id)initWithPath:(NSString*)path formats:(NSArray*)formats defaultValue:(NSDate*)defaultValue;
- (id)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonEnum : MobilyModelJson

@property(nonatomic, readonly, strong) NSNumber* defaultValue;
@property(nonatomic, readonly, strong) NSDictionary* enums;

- (id)initWithEnums:(NSDictionary*)enums;
- (id)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;
- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums;
- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyModelJsonCustomClass : MobilyModelJson

@property(nonatomic, readonly, assign) Class customClass;

- (id)initWithCustomClass:(Class)customClass;
- (id)initWithPath:(NSString*)path customClass:(Class)customClass;

@end

/*--------------------------------------------------*/
