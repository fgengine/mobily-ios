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

@class MobilyElementsView;
@class MobilyElementsCell;
@class MobilyElementsItem;

/*--------------------------------------------------*/

@protocol MobilyElementsViewDataSource < NSObject >

@required
- (NSInteger)numberOfItemsInElements:(MobilyElementsView*)elements;
- (NSString*)elements:(MobilyElementsView*)elements itemIdentifierAtIndex:(NSUInteger)index;
- (CGSize)elements:(MobilyElementsView*)elements itemSizeAtIndex:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@protocol MobilyElementsViewDelegate < NSObject >

@optional
- (void)elements:(MobilyElementsView*)elements showCell:(MobilyElementsCell*)elementsCell atIndex:(NSUInteger)index;
- (void)elements:(MobilyElementsView*)elements hideCell:(MobilyElementsCell*)elementsCell atIndex:(NSUInteger)index;

@optional
- (BOOL)elements:(MobilyElementsView*)elements shouldSelectItemAtIndex:(NSUInteger)index;
- (BOOL)elements:(MobilyElementsView*)elements shouldDeselectItemAtIndex:(NSUInteger)index;
- (void)elements:(MobilyElementsView*)elements didSelectItemAtIndex:(NSUInteger)index;
- (void)elements:(MobilyElementsView*)elements didDeselectItemAtIndex:(NSUInteger)index;

@optional
- (void)elements:(MobilyElementsView*)elements animationReloadBeforeElementsCell:(MobilyElementsCell*)elementsCell;
- (void)elements:(MobilyElementsView*)elements animationReloadAfterElementsCell:(MobilyElementsCell*)elementsCell;
- (void)elements:(MobilyElementsView*)elements animationInsertElementsCell:(MobilyElementsCell*)elementsCell;
- (void)elements:(MobilyElementsView*)elements animationDeleteElementsCell:(MobilyElementsCell*)elementsCell;

@end

/*--------------------------------------------------*/

@protocol MobilyElementsLayout < NSObject >

@required
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems;

@optional
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize reloadRange:(NSRange)reloadRange reloadBeforeItems:(NSArray*)reloadBeforeItems reloadAfterItems:(NSArray*)reloadAfterItems;
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize reloadIndexSet:(NSIndexSet*)reloadIndexSet;

@optional
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertRange:(NSRange)insertRange insertItems:(NSArray*)insertItems;
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertIndexSet:(NSIndexSet*)insertIndexSet;

@optional
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteRange:(NSRange)deleteRange deleteItems:(NSArray*)deleteItems;
- (CGSize)elements:(MobilyElementsView*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteIndexSet:(NSIndexSet*)deleteIndexSet;

@end

/*--------------------------------------------------*/

typedef void (^MobilyElementsViewUpdateBlock)();
typedef void (^MobilyElementsViewCompleteBlock)(BOOL finished);

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyElementsViewScrollPosition) {
    MobilyElementsViewScrollPositionNone = 0,
    MobilyElementsViewScrollPositionTop = 1 << 0,
    MobilyElementsViewScrollPositionCenteredVertically = 1 << 1,
    MobilyElementsViewScrollPositionBottom = 1 << 2,
    MobilyElementsViewScrollPositionLeft = 1 << 3,
    MobilyElementsViewScrollPositionCenteredHorizontally = 1 << 4,
    MobilyElementsViewScrollPositionRight = 1 << 5
};

/*--------------------------------------------------*/

@interface MobilyElementsView : UIScrollView< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBOutlet id< MobilyElementsViewDataSource > elementsDataSource;
@property(nonatomic, readwrite, assign) IBOutlet id< MobilyElementsViewDelegate > elementsDelegate;
@property(nonatomic, readwrite, weak) IBOutlet id< MobilyElementsLayout > elementsLayout;

@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsMultipleSelection;

@property(nonatomic, readonly, copy) NSIndexSet* visibleIndexSet;
@property(nonatomic, readonly, strong) NSArray* visibleItems;
@property(nonatomic, readonly, strong) NSArray* visibleCells;

@property(nonatomic, readonly, copy) NSIndexSet* selectedIndexSet;
@property(nonatomic, readonly, assign) NSUInteger selectedIndex;
@property(nonatomic, readonly, strong) NSArray* selectedItems;
@property(nonatomic, readonly, strong) NSArray* selectedCells;

@property(nonatomic, readonly, assign, getter=isUpdating) BOOL updating;

- (void)setup;

- (void)registerCellClass:(Class)cellClass withIdentifier:(NSString*)identifier;
- (void)registerCellClass:(Class)cellClass fromNib:(UINib*)nib withIdentifier:(NSString*)identifier;
- (void)unregisterCellWithIdentifier:(NSString*)identifier;

- (MobilyElementsItem*)itemAtIndex:(NSUInteger)index;
- (NSUInteger)indexAtItem:(MobilyElementsItem*)item;

- (BOOL)isSelectedItem:(MobilyElementsItem*)item;
- (BOOL)isSelectedItemAtIndex:(NSUInteger)index;

- (BOOL)shouldSelectItem:(MobilyElementsItem*)item;
- (BOOL)shouldSelectItemAtIndex:(NSUInteger)index;

- (BOOL)shouldDeselectItem:(MobilyElementsItem*)item;
- (BOOL)shouldDeselectItemAtIndex:(NSUInteger)index;

- (void)selectItem:(MobilyElementsItem*)item animated:(BOOL)animated;
- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)selectItemAtIndexSet:(NSIndexSet*)indexSet animated:(BOOL)animated;

- (void)deselectItem:(MobilyElementsItem*)item animated:(BOOL)animated;
- (void)deselectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)deselectItemAtIndexSet:(NSIndexSet*)indexSet animated:(BOOL)animated;
- (void)deselectAllSelectedItemsAnimated:(BOOL)animated;

- (void)scrollToItem:(MobilyElementsItem*)item scrollPosition:(MobilyElementsViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToItemAtIndex:(NSUInteger)index scrollPosition:(MobilyElementsViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)reloadItems;

- (void)reloadItemAtIndexSet:(NSIndexSet*)indexSet;
- (void)insertItemAtIndexSet:(NSIndexSet*)indexSet;
- (void)deleteItemAtIndexSet:(NSIndexSet*)indexSet;

- (void)performBatchUpdate:(MobilyElementsViewUpdateBlock)update complete:(MobilyElementsViewCompleteBlock)complete;
- (void)performBatchDuration:(NSTimeInterval)duration update:(MobilyElementsViewUpdateBlock)update complete:(MobilyElementsViewCompleteBlock)complete;

@end

/*--------------------------------------------------*/

@interface MobilyElementsCell : UIControl< MobilyBuilderObject >

@property(nonatomic, readonly, weak) MobilyElementsView* elements;
@property(nonatomic, readonly, weak) MobilyElementsItem* elementsItem;

- (void)setup;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

- (void)prepareItem:(MobilyElementsItem*)elementsItem;
- (void)updatingItem:(MobilyElementsItem*)elementsItem animated:(BOOL)animated;
- (void)cleanupItem:(MobilyElementsItem*)elementsItem;

@end

/*--------------------------------------------------*/

@interface MobilyElementsItem : NSObject

@property(nonatomic, readonly, weak) MobilyElementsView* elements;
@property(nonatomic, readonly, weak) MobilyElementsCell* elementsCell;

@property(nonatomic, readonly, assign) NSUInteger index;
@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, assign, getter=isSelected) BOOL selected;

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
