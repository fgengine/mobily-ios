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

typedef void (^MobilyModelBlock)();

/*--------------------------------------------------*/

@interface MobilyModel : NSObject < NSCoding, NSCopying >

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (id)initWithJson:(id)json;

- (void)setupItem;

+ (NSArray*)propertyMap;
+ (NSDictionary*)jsonMap;

- (void)convertFromJson:(id)json;

- (void)clearItem;
- (void)clearItemComplete:(MobilyModelBlock)complete;

- (BOOL)saveItem;
- (void)saveItemSuccess:(MobilyModelBlock)success failure:(MobilyModelBlock)failure;

- (void)loadItem;
- (void)loadItemComplete:(MobilyModelBlock)complete;

@end

/*--------------------------------------------------*/

typedef void (^MobilyModelCollectionEnumBlock)(id item, BOOL* stop);

/*--------------------------------------------------*/

@interface MobilyModelCollection : NSObject < NSCoding, NSCopying >

@property(nonatomic, readwrite, strong) NSString* userDefaultsKey;
@property(nonatomic, readwrite, strong) NSString* fileName;
@property(nonatomic, readonly, copy) NSArray* items;

- (id)initWithUserDefaultsKey:(NSString*)userDefaultsKey;
- (id)initWithFileName:(NSString*)fileName;
- (id)initWithJson:(id)json storageItemClass:(Class)storageItemClass;

- (void)setupCollection;

- (void)convertFromJson:(id)json storageItemClass:(Class)storageItemClass;

- (NSUInteger)countItems;

- (id)itemAtIndex:(NSUInteger)index;

- (id)firstItem;
- (id)lastItem;

- (void)prependItem:(MobilyModel*)item;
- (void)prependItems:(NSArray*)items;

- (void)appendItem:(MobilyModel*)item;
- (void)appendItems:(NSArray*)items;

- (void)insertItem:(MobilyModel*)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index;

- (void)removeItem:(MobilyModel*)item;
- (void)removeItems:(NSArray*)items;
- (void)removeAllItems;

- (void)enumirateItemsUsingBlock:(MobilyModelCollectionEnumBlock)block;

- (BOOL)saveItems;

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

@interface MobilyModelQuery : NSObject

@property(nonatomic, readwrite, weak) id< MobilyModelQueryDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyModelQueryReloadBlock reloadBlock;
@property(nonatomic, readwrite, copy) MobilyModelQueryResortBlock resortBlock;
@property(nonatomic, readwrite, assign) BOOL resortInvert;
@property(nonatomic, readonly, assign) NSArray* items;

- (id)initWithCollection:(MobilyModelCollection*)collection;

- (void)setNeedReload;
- (void)setNeedResort;

- (NSUInteger)countItems;

- (id)itemAtIndex:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@protocol MobilyModelQueryDelegate < NSObject >

@optional
- (BOOL)storageQuery:(MobilyModelQuery*)storageQuery reloadItem:(id)item;
- (MobilyModelQuerySortResult)storageQuery:(MobilyModelQuery*)storageQuery resortItem1:(id)item1 item2:(id)item2;

@end

/*--------------------------------------------------*/
