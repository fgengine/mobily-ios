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

#import "MobilyDataView.h"
#import "MobilyDataContainer+Private.h"
#import "MobilyDataItem+Private.h"
#import "MobilyDataCell+Private.h"
#import "MobilyDataRefreshView+Private.h"

/*--------------------------------------------------*/

@class MobilyDataViewDelegateProxy;

/*--------------------------------------------------*/

@interface MobilyDataView () {
@protected
    MobilyDataViewDelegateProxy* _delegateProxy;
    BOOL _allowsSelection;
    BOOL _allowsMultipleSelection;
    BOOL _allowsOnceSelection;
    BOOL _allowsEditing;
    BOOL _allowsMultipleEditing;
    BOOL _bouncesTop;
    BOOL _bouncesLeft;
    BOOL _bouncesRight;
    BOOL _bouncesBottom;
    MobilyDataContainer* _container;
    NSMutableArray* _visibleItems;
    NSMutableArray* _selectedItems;
    NSMutableArray* _highlightedItems;
    NSMutableArray* _editingItems;
    NSMutableDictionary* _registersViews;
    MobilyEvents* _registersEvents;
    NSMutableDictionary* _queueCells;
    NSMutableArray* _reloadedBeforeItems;
    NSMutableArray* _reloadedAfterItems;
    NSMutableArray* _deletedItems;
    NSMutableArray* _insertedItems;
    BOOL _updating;
    BOOL _invalidLayout;
    MobilyDataRefreshView* _topRefreshView;
    CGFloat _topRefreshThreshold;
    NSLayoutConstraint* _constraintTopRefreshBottom;
    NSLayoutConstraint* _constraintTopRefreshLeft;
    NSLayoutConstraint* _constraintTopRefreshRight;
    NSLayoutConstraint* _constraintTopRefreshSize;
    MobilyDataRefreshView* _bottomRefreshView;
    CGFloat _bottomRefreshThreshold;
    NSLayoutConstraint* _constraintBottomRefreshTop;
    NSLayoutConstraint* _constraintBottomRefreshLeft;
    NSLayoutConstraint* _constraintBottomRefreshRight;
    NSLayoutConstraint* _constraintBottomRefreshSize;
    MobilyDataRefreshView* _leftRefreshView;
    CGFloat _leftRefreshThreshold;
    NSLayoutConstraint* _constraintLeftRefreshTop;
    NSLayoutConstraint* _constraintLeftRefreshBottom;
    NSLayoutConstraint* _constraintLeftRefreshLeft;
    NSLayoutConstraint* _constraintLeftRefreshSize;
    MobilyDataRefreshView* _rightRefreshView;
    CGFloat _rightRefreshThreshold;
    NSLayoutConstraint* _constraintRightRefreshTop;
    NSLayoutConstraint* _constraintRightRefreshBottom;
    NSLayoutConstraint* _constraintRightRefreshRight;
    NSLayoutConstraint* _constraintRightRefreshSize;
    BOOL _refreshDragging;
    BOOL _canTopRefresh;
    BOOL _canBottomRefresh;
    BOOL _canLeftRefresh;
    BOOL _canRightRefresh;
}

@property(nonatomic, readwrite, strong) MobilyDataViewDelegateProxy* delegateProxy;

@property(nonatomic, readwrite, strong) NSMutableDictionary* registersViews;
@property(nonatomic, readwrite, strong) MobilyEvents* registersEvents;
@property(nonatomic, readwrite, strong) NSMutableDictionary* queueCells;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedBeforeItems;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedAfterItems;
@property(nonatomic, readwrite, strong) NSMutableArray* deletedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* insertedItems;
@property(nonatomic, readwrite, assign, getter=isUpdating) BOOL updating;
@property(nonatomic, readwrite, assign) BOOL invalidLayout;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintTopRefreshBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintTopRefreshLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintTopRefreshRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintTopRefreshSize;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintBottomRefreshTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintBottomRefreshLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintBottomRefreshRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintBottomRefreshSize;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftRefreshTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftRefreshBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftRefreshLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftRefreshSize;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightRefreshTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightRefreshBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightRefreshRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightRefreshSize;

@property(nonatomic, readwrite, assign, getter=isRefreshDragging) BOOL refreshDragging;
@property(nonatomic, readwrite, assign) BOOL canTopRefresh;
@property(nonatomic, readwrite, assign) BOOL canBottomRefresh;
@property(nonatomic, readwrite, assign) BOOL canLeftRefresh;
@property(nonatomic, readwrite, assign) BOOL canRightRefresh;

- (void)_receiveMemoryWarning;

- (void)_userSelectItem:(MobilyDataItem*)item animated:(BOOL)animated;

- (void)_appearItem:(MobilyDataItem*)item;
- (void)_disappearItem:(MobilyDataItem*)item;

- (void)_didInsertItems:(NSArray*)items;
- (void)_didDeleteItems:(NSArray*)items;
- (void)_didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;

- (void)_validateLayout;
- (void)_layoutForVisible;

- (void)_updateSuperviewConstraints;

- (void)_willBeginDragging;
- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating;
- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize;
- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate;
- (void)_willBeginDecelerating;
- (void)_didEndDecelerating;
- (void)_didEndScrollingAnimation;

- (void)_batchUpdate:(MobilyDataViewUpdateBlock)update animated:(BOOL)animated;
- (void)_batchComplete:(MobilyDataViewUpdateBlock)complete animated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDataViewDelegateProxy : NSObject< UIScrollViewDelegate > {
@protected
    __weak MobilyDataView* _view;
    __weak id< UIScrollViewDelegate > _delegate;
}

@property(nonatomic, readwrite, weak) MobilyDataView* view;
@property(nonatomic, readwrite, weak) id< UIScrollViewDelegate > delegate;

- (instancetype)initWithDataView:(MobilyDataView*)view;

@end

/*--------------------------------------------------*/
