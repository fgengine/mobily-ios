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

#import "MobilyUI.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@protocol MobilyDataContainer;
@protocol MobilyDataContainerView;
@protocol MobilyDataItem;
@protocol MobilyDataItemView;

/*--------------------------------------------------*/

typedef void(^MobilyDataWidgetUpdateBlock)();
typedef void(^MobilyDataWidgetCompleteBlock)(BOOL finished);

/*--------------------------------------------------*/

@protocol MobilyDataWidget < MobilyObject >

@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsMultipleSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsEditing;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsMultipleEditing;

@property(nonatomic, readwrite, strong) id< MobilyDataContainer > container;
@property(nonatomic, readonly, strong) NSArray* visibleItems;
@property(nonatomic, readonly, strong) NSArray* visibleViews;
@property(nonatomic, readonly, strong) NSArray* selectedItems;
@property(nonatomic, readonly, strong) NSArray* selectedViews;
@property(nonatomic, readonly, strong) NSArray* highlightedItems;
@property(nonatomic, readonly, strong) NSArray* highlightedViews;
@property(nonatomic, readonly, strong) NSArray* editingItems;
@property(nonatomic, readonly, strong) NSArray* editingViews;
@property(nonatomic, readonly, assign, getter=isUpdating) BOOL updating;

- (void)registerIdentifier:(NSString*)identifier withViewClass:(Class< MobilyDataItemView >)viewClass;
- (void)unregisterIdentifier:(NSString*)identifier;
- (void)unregisterAllIdentifiers;

- (void)registerEventWithTarget:(id)target action:(SEL)action forKey:(id)key;
- (void)registerEventWithBlock:(MobilyEventBlockType)block forKey:(id)key;
- (void)registerEvent:(id< MobilyEvent >)event forKey:(id)key;
- (void)unregisterEventForKey:(id)key;
- (void)unregisterAllEvents;

- (BOOL)containsEventForKey:(id)key;

- (id)performEventForKey:(id)key byObject:(id)object;
- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult;

- (Class< MobilyDataItemView >)viewClassWithItem:(id< MobilyDataItem >)item;

- (void)dequeueViewWithItem:(id< MobilyDataItem >)item;
- (void)enqueueViewWithItem:(id< MobilyDataItem >)item;

- (id< MobilyDataItem >)itemForData:(id)data;
- (UIView< MobilyDataItemView >*)itemViewForData:(id)data;

- (BOOL)isSelectedItem:(id< MobilyDataItem >)item;
- (BOOL)shouldSelectItem:(id< MobilyDataItem >)item;
- (BOOL)shouldDeselectItem:(id< MobilyDataItem >)item;

- (void)selectItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)deselectItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)deselectAllItemsAnimated:(BOOL)animated;

- (BOOL)isHighlightedItem:(id< MobilyDataItem >)item;
- (BOOL)shouldHighlightItem:(id< MobilyDataItem >)item;
- (BOOL)shouldUnhighlightItem:(id< MobilyDataItem >)item;

- (void)highlightItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)unhighlightItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)unhighlightAllItemsAnimated:(BOOL)animated;

- (BOOL)isEditingItem:(id< MobilyDataItem >)item;
- (BOOL)shouldBeganEditItem:(id< MobilyDataItem >)item;
- (BOOL)shouldEndedEditItem:(id< MobilyDataItem >)item;

- (void)beganEditItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)endedEditItem:(id< MobilyDataItem >)item animated:(BOOL)animated;
- (void)endedEditAllItemsAnimated:(BOOL)animated;

- (void)appearItem:(id< MobilyDataItem >)item;
- (void)disappearItem:(id< MobilyDataItem >)item;

- (void)performBatchUpdate:(MobilyDataWidgetUpdateBlock)update complete:(MobilyDataWidgetCompleteBlock)complete;
- (void)performBatchDuration:(NSTimeInterval)duration update:(MobilyDataWidgetUpdateBlock)update complete:(MobilyDataWidgetCompleteBlock)complete;

- (void)didInsertItems:(NSArray*)items;
- (void)didDeleteItems:(NSArray*)items;
- (void)didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;

- (void)setNeedValidateLayout;
- (void)validateLayoutIfNeed;
- (void)validateLayout;

- (void)setNeedLayoutForVisible;
- (void)layoutForVisibleIfNeed;
- (void)layoutForVisible;

@end

/*--------------------------------------------------*/

@protocol MobilyDataObject < MobilyObject >

@property(nonatomic, readwrite, weak) UIView< MobilyDataWidget >* widget;
@property(nonatomic, readwrite, weak) id< MobilyDataContainer > parentContainer;

@end

/*--------------------------------------------------*/

@protocol MobilyDataContainer < MobilyDataObject >

@property(nonatomic, readonly, strong) NSArray* snapToEdgeContainers;
@property(nonatomic, readonly, copy) NSArray* containers;
@property(nonatomic, readwrite, assign) CGRect containersFrame;
@property(nonatomic, readonly, strong) NSArray* snapToEdgeItems;
@property(nonatomic, readonly, copy) NSArray* items;
@property(nonatomic, readwrite, assign) CGRect itemsFrame;
@property(nonatomic, readonly, copy) NSArray* allItems;

- (id< MobilyDataItem >)itemForData:(id)data;
- (UIView< MobilyDataItemView >*)itemViewForData:(id)data;

- (void)addSnapToEdgeItem:(id< MobilyDataItem >)item;
- (void)removeSnapToEdgeItem:(id< MobilyDataItem >)item;

- (void)prependContainer:(id< MobilyDataContainer >)container;
- (void)appendContainer:(id< MobilyDataContainer >)container;
- (void)insertContainer:(id< MobilyDataContainer >)container atIndex:(NSUInteger)index;
- (void)replaceOriginContainer:(id< MobilyDataContainer >)originContainer withContainer:(id< MobilyDataContainer >)container;
- (void)deleteContainer:(id< MobilyDataContainer >)container;

- (void)prependItem:(id< MobilyDataItem >)item;
- (void)prependItems:(NSArray*)items;
- (void)appendItem:(id< MobilyDataItem >)item;
- (void)appendItems:(NSArray*)items;
- (void)insertItem:(id< MobilyDataItem >)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index;
- (void)replaceOriginItem:(id< MobilyDataItem >)originItem withItem:(id< MobilyDataItem >)item;
- (void)replaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;
- (void)deleteItem:(id< MobilyDataItem >)item;
- (void)deleteItems:(NSArray*)items;
- (void)deleteAllItems;

- (BOOL)containsEventForKey:(id)key;

- (id)performEventForKey:(id)key byObject:(id)object;
- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult;

- (void)didBeginUpdate;
- (void)didEndUpdate;

- (CGRect)validateLayoutForAvailableFrame:(CGRect)frame;
- (CGRect)validateContainersLayoutForAvailableFrame:(CGRect)frame;
- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame;

- (void)layoutForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds;
- (void)layoutContainersForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds;
- (void)layoutItemsForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds;
- (void)layoutItemsForSnapBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@protocol MobilyDataContainerView < MobilyObject >
@end

/*--------------------------------------------------*/

@protocol MobilyDataItem < MobilyDataObject >

@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, strong) id data;
@property(nonatomic, readwrite, strong) UIView< MobilyDataItemView >* view;
@property(nonatomic, readwrite, assign) CGRect originFrame;
@property(nonatomic, readwrite, assign) CGRect updateFrame;
@property(nonatomic, readwrite, assign) CGRect displayFrame;
@property(nonatomic, readonly, assign) CGRect frame;
@property(nonatomic, readwrite, assign) CGFloat zOrder;
@property(nonatomic, readwrite, assign) BOOL allowsSnapToEdge;
@property(nonatomic, readwrite, assign) BOOL allowsSelection;
@property(nonatomic, readwrite, assign) BOOL allowsHighlighting;
@property(nonatomic, readwrite, assign) BOOL allowsEditing;
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@property(nonatomic, readwrite, assign, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, readwrite, assign, getter=isEditing) BOOL editing;

- (instancetype)initWithIdentifier:(NSString*)identifier data:(id)data;

- (BOOL)containsEventForKey:(id)key;

- (id)performEventForKey:(id)key byObject:(id)object;
- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult;

- (void)didBeginUpdate;
- (void)didEndUpdate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (CGSize)sizeForAvailableSize:(CGSize)size;

- (void)appear;
- (void)disappear;
- (void)validateLayoutForVisibleBounds:(CGRect)bounds;
- (void)invalidateLayoutForVisibleBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataItemViewAction) {
    MobilyDataItemViewActionInsert,
    MobilyDataItemViewActionDelete,
    MobilyDataItemViewActionReplaceOut,
    MobilyDataItemViewActionReplaceIn
};

/*--------------------------------------------------*/

@protocol MobilyDataItemView < MobilyObject >

@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readwrite, weak) id< MobilyDataItem > item;
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@property(nonatomic, readwrite, assign, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, readwrite, assign, getter=isEditing) BOOL editing;

+ (CGSize)sizeForItem:(id< MobilyDataItem >)item availableSize:(CGSize)size;

- (instancetype)initWithIdentifier:(NSString*)identifier;
- (instancetype)initWithIdentifier:(NSString*)identifier nib:(UINib*)nib;

- (void)prepareForUse;
- (void)prepareForUnuse;

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (void)animateAction:(MobilyDataItemViewAction)action;

- (void)validateLayoutForVisibleBounds:(CGRect)bounds;
- (void)invalidateLayoutForVisibleBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/
