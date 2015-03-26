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

#import "MobilyData.h"

/*--------------------------------------------------*/

@class MobilyDataContainer;
@class MobilyDataItem;
@class MobilyDataCell;
@class MobilyDataRefreshView;

/*--------------------------------------------------*/

typedef void(^MobilyDataViewUpdateBlock)();
typedef void(^MobilyDataViewCompleteBlock)(BOOL finished);

/*--------------------------------------------------*/

@protocol MobilyDataRefreshView;

/*--------------------------------------------------*/

@interface MobilyDataView : UIScrollView< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsOnceSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsMultipleSelection;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsEditing;
@property(nonatomic, readwrite, assign) IBInspectable BOOL allowsMultipleEditing;
@property(nonatomic, readwrite, assign) IBInspectable BOOL bouncesTop;
@property(nonatomic, readwrite, assign) IBInspectable BOOL bouncesLeft;
@property(nonatomic, readwrite, assign) IBInspectable BOOL bouncesRight;
@property(nonatomic, readwrite, assign) IBInspectable BOOL bouncesBottom;

@property(nonatomic, readwrite, strong) MobilyDataContainer* container;
@property(nonatomic, readonly, strong) NSArray* visibleItems;
@property(nonatomic, readonly, strong) NSArray* visibleCells;
@property(nonatomic, readonly, strong) NSArray* selectedItems;
@property(nonatomic, readonly, strong) NSArray* selectedCells;
@property(nonatomic, readonly, strong) NSArray* highlightedItems;
@property(nonatomic, readonly, strong) NSArray* highlightedCells;
@property(nonatomic, readonly, strong) NSArray* editingItems;
@property(nonatomic, readonly, strong) NSArray* editingCells;
@property(nonatomic, readonly, assign, getter=isAnimating) BOOL animating;
@property(nonatomic, readonly, assign, getter=isUpdating) BOOL updating;

@property(nonatomic, readwrite, strong) IBOutlet MobilyDataRefreshView* topRefreshView;
@property(nonatomic, readwrite, strong) IBOutlet MobilyDataRefreshView* bottomRefreshView;
@property(nonatomic, readwrite, strong) IBOutlet MobilyDataRefreshView* leftRefreshView;
@property(nonatomic, readwrite, strong) IBOutlet MobilyDataRefreshView* rightRefreshView;

- (void)registerIdentifier:(NSString*)identifier withViewClass:(Class)viewClass;
- (void)unregisterIdentifier:(NSString*)identifier;
- (void)unregisterAllIdentifiers;

- (void)registerEventWithTarget:(id)target action:(SEL)action forKey:(id)key;
- (void)registerEventWithTarget:(id)target action:(SEL)action forIdentifier:(NSString*)identifier forKey:(id)key;
- (void)registerEventWithBlock:(MobilyEventBlockType)block forKey:(id)key;
- (void)registerEventWithBlock:(MobilyEventBlockType)block forIdentifier:(NSString*)identifier forKey:(id)key;
- (void)registerEvent:(id< MobilyEvent >)event forKey:(id)key;
- (void)registerEvent:(id< MobilyEvent >)event forIdentifier:(NSString*)identifier forKey:(id)key;
- (void)unregisterEventForKey:(id)key;
- (void)unregisterEventForIdentifier:(NSString*)identifier forKey:(id)key;
- (void)unregisterEventsForIdentifier:(NSString*)identifier;
- (void)unregisterAllEvents;

- (BOOL)containsEventForKey:(id)key;
- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key;

- (void)fireEventForKey:(id)key byObject:(id)object;
- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

- (Class)cellClassWithItem:(MobilyDataItem*)item;

- (void)dequeueCellWithItem:(MobilyDataItem*)item;
- (void)enqueueCellWithItem:(MobilyDataItem*)item;

- (MobilyDataItem*)itemForPoint:(CGPoint)point;
- (MobilyDataItem*)itemForData:(id)data;
- (MobilyDataCell*)cellForData:(id)data;

- (BOOL)isSelectedItem:(MobilyDataItem*)item;
- (BOOL)shouldSelectItem:(MobilyDataItem*)item;
- (BOOL)shouldDeselectItem:(MobilyDataItem*)item;

- (void)selectItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)deselectItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)deselectAllItemsAnimated:(BOOL)animated;

- (BOOL)isHighlightedItem:(MobilyDataItem*)item;
- (BOOL)shouldHighlightItem:(MobilyDataItem*)item;
- (BOOL)shouldUnhighlightItem:(MobilyDataItem*)item;

- (void)highlightItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)unhighlightItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)unhighlightAllItemsAnimated:(BOOL)animated;

- (BOOL)isEditingItem:(MobilyDataItem*)item;
- (BOOL)shouldBeganEditItem:(MobilyDataItem*)item;
- (BOOL)shouldEndedEditItem:(MobilyDataItem*)item;

- (void)beganEditItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)endedEditItem:(MobilyDataItem*)item animated:(BOOL)animated;
- (void)endedEditAllItemsAnimated:(BOOL)animated;

- (void)batchUpdate:(MobilyDataViewUpdateBlock)update;
- (void)batchUpdate:(MobilyDataViewUpdateBlock)update complete:(MobilyDataViewCompleteBlock)complete;
- (void)batchDuration:(NSTimeInterval)duration update:(MobilyDataViewUpdateBlock)update complete:(MobilyDataViewCompleteBlock)complete;

- (void)setNeedValidateLayout;
- (void)validateLayoutIfNeed;

- (void)setNeedLayoutForVisible;
- (void)layoutForVisibleIfNeed;

- (void)scrollToItem:(MobilyDataItem*)item scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToRect:(CGRect)rect scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated;

- (void)showTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)hideTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)showBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)hideBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)showLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)hideLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)showRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;
- (void)hideRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataViewSelectItem;
extern NSString* MobilyDataViewDeselectItem;

/*--------------------------------------------------*/

extern NSString* MobilyDataViewTopRefreshTriggered;
extern NSString* MobilyDataViewBottomRefreshTriggered;
extern NSString* MobilyDataViewLeftRefreshTriggered;
extern NSString* MobilyDataViewRightRefreshTriggered;

/*--------------------------------------------------*/

extern NSString* MobilyDataViewAnimateRestore;
extern NSString* MobilyDataViewAnimateInsert;
extern NSString* MobilyDataViewAnimateDelete;
extern NSString* MobilyDataViewAnimateReplaceOut;
extern NSString* MobilyDataViewAnimateReplaceIn;

/*--------------------------------------------------*/
