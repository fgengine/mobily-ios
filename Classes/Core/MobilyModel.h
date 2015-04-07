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

#import "MobilyObject.h"

/*--------------------------------------------------*/

typedef void (^MobilyModelBlock)();

/*--------------------------------------------------*/

@interface MobilyModel : NSObject < MobilyObject, NSCopying >

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (instancetype)initWithJson:(id)json;

- (void)setup NS_REQUIRES_SUPER;

+ (NSArray*)compareMap;
+ (NSArray*)serializeMap;
+ (NSDictionary*)jsonMap;
+ (NSUInteger)sqlVersion;
+ (NSDictionary*)sqlMap;

- (void)fromJson:(id)json;

- (void)clear;
- (void)clearComplete:(MobilyModelBlock)complete;

- (BOOL)save;
- (void)saveSuccess:(MobilyModelBlock)success failure:(MobilyModelBlock)failure;

- (void)load;
- (void)loadComplete:(MobilyModelBlock)complete;

- (void)erase;
- (void)eraseComplete:(MobilyModelBlock)complete;

@end

/*--------------------------------------------------*/

typedef void (^MobilyModelCollectionEnumBlock)(id item, BOOL* stop);

/*--------------------------------------------------*/

@interface MobilyModelCollection : NSObject < MobilyObject, NSCopying >

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;
@property(nonatomic, readwrite, strong) NSString* fileName;
@property(nonatomic, readonly, strong) NSString* filePath;
@property(nonatomic, readwrite, copy) NSArray* models;

- (instancetype)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (instancetype)initWithFileName:(NSString*)fileName;
- (instancetype)initWithJson:(id)json storageItemClass:(Class)storageItemClass;

- (void)setup NS_REQUIRES_SUPER;

- (void)fromJson:(id)json modelClass:(Class)storageItemClass;

- (NSUInteger)count;

- (id)modelAtIndex:(NSUInteger)index;

- (id)firstModel;
- (id)lastModel;

- (void)prependModel:(MobilyModel*)item;
- (void)prependModelsFromArray:(NSArray*)items;

- (void)appendModel:(MobilyModel*)item;
- (void)appendModelsFromArray:(NSArray*)items;

- (void)insertModel:(MobilyModel*)item atIndex:(NSUInteger)index;
- (void)insertModelsFromArray:(NSArray*)items atIndex:(NSUInteger)index;

- (void)removeModel:(MobilyModel*)item;
- (void)removeModelsInArray:(NSArray*)items;
- (void)removeAllModels;

- (void)enumirateModelsUsingBlock:(MobilyModelCollectionEnumBlock)block;

- (BOOL)save;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyModelQuerySortResult) {
    MobilyModelQuerySortResultMore = NSOrderedAscending,
    MobilyModelQuerySortResultEqual = NSOrderedSame,
    MobilyModelQuerySortResultLess = NSOrderedDescending
};

/*--------------------------------------------------*/

@protocol MobilyModelQueryDelegate;

/*--------------------------------------------------*/

typedef BOOL (^MobilyModelQueryReloadBlock)(id item);
typedef MobilyModelQuerySortResult (^MobilyModelQueryResortBlock)(id item1, id item2);

/*--------------------------------------------------*/

@interface MobilyModelQuery : NSObject < MobilyObject >

@property(nonatomic, readwrite, weak) id< MobilyModelQueryDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyModelQueryReloadBlock reloadBlock;
@property(nonatomic, readwrite, copy) MobilyModelQueryResortBlock resortBlock;
@property(nonatomic, readwrite, assign) BOOL resortInvert;
@property(nonatomic, readonly, assign) NSArray* models;

- (instancetype)initWithCollection:(MobilyModelCollection*)collection;

- (void)setup NS_REQUIRES_SUPER;

- (void)setNeedReload;
- (void)setNeedResort;

- (NSUInteger)count;

- (id)modelAtIndex:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@protocol MobilyModelQueryDelegate < NSObject >

@optional
- (BOOL)modelQuery:(MobilyModelQuery*)modelQuery reloadItem:(id)item;
- (MobilyModelQuerySortResult)modelQuery:(MobilyModelQuery*)modelQuery resortItem1:(id)item1 item2:(id)item2;

@end

/*--------------------------------------------------*/
