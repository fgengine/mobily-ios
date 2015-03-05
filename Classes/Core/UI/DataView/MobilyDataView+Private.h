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
    MobilyDataRefreshView* _pullToRefreshView;
    CGFloat _pullToRefreshHeight;
    NSLayoutConstraint* _constraintPullToRefreshBottom;
    NSLayoutConstraint* _constraintPullToRefreshLeft;
    NSLayoutConstraint* _constraintPullToRefreshRight;
    NSLayoutConstraint* _constraintPullToRefreshHeight;
    MobilyDataRefreshView* _pullToLoadView;
    CGFloat _pullToLoadHeight;
    NSLayoutConstraint* _constraintPullToLoadTop;
    NSLayoutConstraint* _constraintPullToLoadLeft;
    NSLayoutConstraint* _constraintPullToLoadRight;
    NSLayoutConstraint* _constraintPullToLoadHeight;
    BOOL _pullDragging;
    BOOL _canPullToRefresh;
    BOOL _canPullToLoad;
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

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToRefreshBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToRefreshLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToRefreshRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToRefreshHeight;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToLoadTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToLoadLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToLoadRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintPullToLoadHeight;

@property(nonatomic, readwrite, assign, getter=isPullDragging) BOOL pullDragging;
@property(nonatomic, readwrite, assign) BOOL canPullToRefresh;
@property(nonatomic, readwrite, assign) BOOL canPullToLoad;

- (void)_receiveMemoryWarning;

- (void)_appearItem:(MobilyDataItem*)item;
- (void)_disappearItem:(MobilyDataItem*)item;

- (void)_didInsertItems:(NSArray*)items;
- (void)_didDeleteItems:(NSArray*)items;
- (void)_didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;

- (void)_validateLayout;
- (void)_layoutForVisible;

- (void)_updateSuperviewConstraints;

- (void)_willBeginDragging;
- (void)_didScroll;
- (void)_willEndDraggingWithVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset;
- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate;
- (void)_willBeginDecelerating;
- (void)_didEndDecelerating;
- (void)_didEndScrollingAnimation;

- (void)_batchUpdate:(MobilyDataViewUpdateBlock)update;
- (void)_batchComplete:(MobilyDataViewUpdateBlock)complete;

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
