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

#import "MobilyBuilder.h"

/*--------------------------------------------------*/

@class MobilyViewElementsView;
@class MobilyViewElementsCell;
@class MobilyViewElementsLayout;
@class MobilyViewElementsItem;

/*--------------------------------------------------*/

@protocol MobilyViewElementsViewDataSource < NSObject >

@required
- (NSInteger)numberOfItemsInElementsView:(MobilyViewElementsView*)elementsView;
- (NSString*)elementsView:(MobilyViewElementsView*)elementsView itemIdentifierAtIndex:(NSUInteger)index;
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView itemSizeAtIndex:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@protocol MobilyViewElementsViewDelegate < NSObject >

@optional
- (void)elementsView:(MobilyViewElementsView*)elementsView showCell:(MobilyViewElementsCell*)elementsCell atIndex:(NSUInteger)index;
- (void)elementsView:(MobilyViewElementsView*)elementsView hideCell:(MobilyViewElementsCell*)elementsCell atIndex:(NSUInteger)index;

@optional
- (BOOL)elementsView:(MobilyViewElementsView*)elementsView shouldSelectItemAtIndex:(NSUInteger)index;
- (BOOL)elementsView:(MobilyViewElementsView*)elementsView shouldDeselectItemAtIndex:(NSUInteger)index;
- (void)elementsView:(MobilyViewElementsView*)elementsView didSelectItemAtIndex:(NSUInteger)index;
- (void)elementsView:(MobilyViewElementsView*)elementsView didDeselectItemAtIndex:(NSUInteger)index;

@optional
- (void)elementsView:(MobilyViewElementsView*)elementsView animationReloadBeforeElementsCell:(MobilyViewElementsCell*)elementsCell;
- (void)elementsView:(MobilyViewElementsView*)elementsView animationReloadAfterElementsCell:(MobilyViewElementsCell*)elementsCell;
- (void)elementsView:(MobilyViewElementsView*)elementsView animationInsertElementsCell:(MobilyViewElementsCell*)elementsCell;
- (void)elementsView:(MobilyViewElementsView*)elementsView animationDeleteElementsCell:(MobilyViewElementsCell*)elementsCell;

@end

/*--------------------------------------------------*/

@protocol MobilyViewElementsViewLayout < NSObject >

@required
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems;

@optional
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize reloadRange:(NSRange)reloadRange reloadBeforeItems:(NSArray*)reloadBeforeItems reloadAfterItems:(NSArray*)reloadAfterItems;
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize reloadIndexSet:(NSIndexSet*)reloadIndexSet;

@optional
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertRange:(NSRange)insertRange insertItems:(NSArray*)insertItems;
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertIndexSet:(NSIndexSet*)insertIndexSet;

@optional
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteRange:(NSRange)deleteRange deleteItems:(NSArray*)deleteItems;
- (CGSize)elementsView:(MobilyViewElementsView*)elementsView layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteIndexSet:(NSIndexSet*)deleteIndexSet;

@end

/*--------------------------------------------------*/

typedef void (^FGElementsUpdateBlock)();
typedef void (^FGElementsCompleteBlock)(BOOL finished);

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyViewElementsViewScrollPosition) {
    MobilyViewElementsViewScrollPositionNone = 0,
    MobilyViewElementsViewScrollPositionTop = 1 << 0,
    MobilyViewElementsViewScrollPositionCenteredVertically = 1 << 1,
    MobilyViewElementsViewScrollPositionBottom = 1 << 2,
    MobilyViewElementsViewScrollPositionLeft = 1 << 3,
    MobilyViewElementsViewScrollPositionCenteredHorizontally = 1 << 4,
    MobilyViewElementsViewScrollPositionRight = 1 << 5
};

/*--------------------------------------------------*/

@interface MobilyViewElementsView : UIScrollView< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBOutlet id< MobilyViewElementsViewDataSource > elementsDataSource;
@property(nonatomic, readwrite, assign) IBOutlet id< MobilyViewElementsViewDelegate > elementsDelegate;
@property(nonatomic, readwrite, weak) IBOutlet id< MobilyViewElementsViewLayout > elementsLayout;

@property(nonatomic, readwrite, assign) BOOL allowsSelection;
@property(nonatomic, readwrite, assign) BOOL allowsMultipleSelection;

@property(nonatomic, readonly, copy) NSIndexSet* visibleIndexSet;
@property(nonatomic, readonly, strong) NSArray* visibleItems;
@property(nonatomic, readonly, strong) NSArray* visibleCells;

@property(nonatomic, readonly, copy) NSIndexSet* selectedIndexSet;
@property(nonatomic, readonly, assign) NSUInteger selectedIndex;
@property(nonatomic, readonly, strong) NSArray* selectedItems;
@property(nonatomic, readonly, strong) NSArray* selectedCells;

@property(nonatomic, readonly, assign, getter = isUpdating) BOOL updating;

- (void)setupView;

- (void)registerCellClass:(Class)cellClass withIdentifier:(NSString*)identifier;
- (void)registerCellClass:(Class)cellClass fromNib:(UINib*)nib withIdentifier:(NSString*)identifier;
- (void)unregisterCellWithIdentifier:(NSString*)identifier;

- (MobilyViewElementsItem*)itemAtIndex:(NSUInteger)index;
- (NSUInteger)indexAtItem:(MobilyViewElementsItem*)item;

- (BOOL)isSelectedItem:(MobilyViewElementsItem*)item;
- (BOOL)isSelectedItemAtIndex:(NSUInteger)index;

- (BOOL)shouldSelectItem:(MobilyViewElementsItem*)item;
- (BOOL)shouldSelectItemAtIndex:(NSUInteger)index;

- (BOOL)shouldDeselectItem:(MobilyViewElementsItem*)item;
- (BOOL)shouldDeselectItemAtIndex:(NSUInteger)index;

- (void)selectItem:(MobilyViewElementsItem*)item animated:(BOOL)animated;
- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)deselectItem:(MobilyViewElementsItem*)item animated:(BOOL)animated;
- (void)deselectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)deselectAllSelectedItemsAnimated:(BOOL)animated;

- (void)scrollToItem:(MobilyViewElementsItem*)item scrollPosition:(MobilyViewElementsViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToItemAtIndex:(NSUInteger)index scrollPosition:(MobilyViewElementsViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)reloadItems;

- (void)reloadItemAtIndexSet:(NSIndexSet*)indexSet;
- (void)insertItemAtIndexSet:(NSIndexSet*)indexSet;
- (void)deleteItemAtIndexSet:(NSIndexSet*)indexSet;

- (void)performBatchUpdate:(FGElementsUpdateBlock)update complete:(FGElementsCompleteBlock)complete;
- (void)performBatchDuration:(NSTimeInterval)duration update:(FGElementsUpdateBlock)update complete:(FGElementsCompleteBlock)complete;

@end

/*--------------------------------------------------*/

@interface MobilyViewElementsCell : UIControl< MobilyBuilderObject >

@property(nonatomic, readonly, weak) MobilyViewElementsView* elementsView;
@property(nonatomic, readonly, weak) MobilyViewElementsItem* elementsItem;

- (void)setup;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

- (void)prepareItem:(MobilyViewElementsItem*)elementsItem;
- (void)updatingItem:(MobilyViewElementsItem*)elementsItem animated:(BOOL)animated;
- (void)cleanupItem:(MobilyViewElementsItem*)elementsItem;

@end

/*--------------------------------------------------*/

@interface MobilyViewElementsItem : NSObject

@property(nonatomic, readonly, weak) MobilyViewElementsView* elementsView;
@property(nonatomic, readonly, weak) MobilyViewElementsCell* elementsCell;

@property(nonatomic, readonly, assign) NSUInteger index;
@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, assign, getter = isSelected) BOOL selected;

@property(nonatomic, readwrite, assign) NSInteger zIndex;

@property(nonatomic, readwrite, assign) CGRect initialFrame;
@property(nonatomic, readwrite, assign) CGPoint initialFrameOrigin;
@property(nonatomic, readwrite, assign) CGFloat initialFrameOriginX;
@property(nonatomic, readwrite, assign) CGFloat initialFrameOriginY;
@property(nonatomic, readwrite, assign) CGSize initialFrameSize;
@property(nonatomic, readwrite, assign) CGFloat initialFrameSizeWidth;
@property(nonatomic, readwrite, assign) CGFloat initialFrameSizeHeight;

@property(nonatomic, readwrite, assign) CGRect frame;
@property(nonatomic, readwrite, assign) CGPoint frameOrigin;
@property(nonatomic, readwrite, assign) CGFloat frameOriginX;
@property(nonatomic, readwrite, assign) CGFloat frameOriginY;
@property(nonatomic, readwrite, assign) CGSize frameSize;
@property(nonatomic, readwrite, assign) CGFloat frameSizeWidth;
@property(nonatomic, readwrite, assign) CGFloat frameSizeHeight;

@end

/*--------------------------------------------------*/
