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

typedef void (^MobilyStorageItemBlock)();

/*--------------------------------------------------*/

@interface MobilyStorageItem : NSObject < NSCoding, NSCopying >

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (id)initWithJson:(id)json;

- (void)setupItem;

+ (NSArray*)propertyMap;
+ (NSDictionary*)jsonMap;

- (void)convertFromJson:(id)json;

- (void)clearItem;
- (void)clearItemComplete:(MobilyStorageItemBlock)complete;

- (BOOL)saveItem;
- (void)saveItemSuccess:(MobilyStorageItemBlock)success failure:(MobilyStorageItemBlock)failure;

- (void)loadItem;
- (void)loadItemComplete:(MobilyStorageItemBlock)complete;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverter : NSObject

@property(nonatomic, readonly, strong) NSString* path;

- (id)initWithPath:(NSString*)path;

- (id)parseJson:(id)json;

- (id)convertValue:(id)value;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterArray : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) MobilyStorageJsonConverter* jsonConverter;

- (id)initWithJsonConverter:(MobilyStorageJsonConverter*)jsonConverter;
- (id)initWithPath:(NSString*)path jsonConverter:(MobilyStorageJsonConverter*)jsonConverter;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterDictionary : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) MobilyStorageJsonConverter* jsonConverter;

- (id)initWithJsonConverter:(MobilyStorageJsonConverter*)jsonConverter;
- (id)initWithPath:(NSString*)path jsonConverter:(MobilyStorageJsonConverter*)jsonConverter;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterBool : MobilyStorageJsonConverter

@property(nonatomic, readonly, assign) BOOL defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(BOOL)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterString : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) NSString* defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(NSString*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterNumber : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) NSNumber* defaultValue;

- (id)initWithPath:(NSString*)path defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterDate : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) NSDate* defaultValue;
@property(nonatomic, readonly, strong) NSString* format;

- (id)initWithFormat:(NSString*)format;
- (id)initWithFormat:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (id)initWithPath:(NSString*)path format:(NSString*)format;
- (id)initWithPath:(NSString*)path format:(NSString*)format defaultValue:(NSDate*)defaultValue;
- (id)initWithPath:(NSString*)path defaultValue:(NSDate*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterEnum : MobilyStorageJsonConverter

@property(nonatomic, readonly, strong) NSNumber* defaultValue;
@property(nonatomic, readonly, strong) NSDictionary* enums;

- (id)initWithEnums:(NSDictionary*)enums;
- (id)initWithEnums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;
- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums;
- (id)initWithPath:(NSString*)path enums:(NSDictionary*)enums defaultValue:(NSNumber*)defaultValue;

@end

/*--------------------------------------------------*/

@interface MobilyStorageJsonConverterCustomClass : MobilyStorageJsonConverter

@property(nonatomic, readonly, assign) Class customClass;

- (id)initWithCustomClass:(Class)customClass;
- (id)initWithPath:(NSString*)path customClass:(Class)customClass;

@end

/*--------------------------------------------------*/

typedef void (^MobilyStorageCollectionEnumBlock)(id item, BOOL* stop);

/*--------------------------------------------------*/

@interface MobilyStorageCollection : NSObject

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;
@property(nonatomic, readonly, copy) NSArray* items;

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (id)initWithName:(NSString*)name;

- (NSUInteger)countItems;

- (id)itemAtIndex:(NSUInteger)index;

- (id)firstItem;
- (id)lastItem;

- (void)prependItem:(MobilyStorageItem*)item;
- (void)prependItems:(NSArray*)items;

- (void)appendItem:(MobilyStorageItem*)item;
- (void)appendItems:(NSArray*)items;

- (void)insertItem:(MobilyStorageItem*)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index;

- (void)removeItem:(MobilyStorageItem*)item;
- (void)removeItems:(NSArray*)items;
- (void)removeAllItems;

- (void)enumirateItemsUsingBlock:(MobilyStorageCollectionEnumBlock)block;

- (BOOL)saveItems;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyStorageQuerySortResult) {
    MobilyStorageQuerySortResultMore = NSOrderedAscending,
    MobilyStorageQuerySortResultEqual = NSOrderedSame,
    MobilyStorageQuerySortResultLess = NSOrderedDescending
};

/*--------------------------------------------------*/

typedef BOOL (^MobilyStorageQueryReloadBlock)(id item);
typedef MobilyStorageQuerySortResult (^MobilyStorageQueryResortBlock)(id item1, id item2);

/*--------------------------------------------------*/

@interface MobilyStorageQuery : NSObject

@property(nonatomic, readwrite, copy) MobilyStorageQueryReloadBlock reloadBlock;
@property(nonatomic, readwrite, copy) MobilyStorageQueryResortBlock resortBlock;
@property(nonatomic, readwrite, assign) BOOL resortInvert;
@property(nonatomic, readonly, assign) NSArray* items;

- (id)initWithCollection:(MobilyStorageCollection*)collection;

- (void)setNeedReload;
- (void)setNeedResort;

- (NSUInteger)countItems;

- (id)itemAtIndex:(NSUInteger)index;

@end

/*--------------------------------------------------*/
