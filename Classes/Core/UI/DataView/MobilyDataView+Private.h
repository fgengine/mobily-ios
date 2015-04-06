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

typedef NS_ENUM(NSUInteger, MobilyDataViewDirection) {
    MobilyDataViewDirectionUnknown,
    MobilyDataViewDirectionHorizontal,
    MobilyDataViewDirectionVertical
};

/*--------------------------------------------------*/

@class MobilyDataViewDelegateProxy;

/*--------------------------------------------------*/

@interface MobilyDataView () {
@protected
    MobilyDataViewDelegateProxy* _delegateProxy;
    CGFloat _velocity;
    CGFloat _velocityMin;
    CGFloat _velocityMax;
    BOOL _allowsSelection;
    BOOL _allowsMultipleSelection;
    BOOL _allowsOnceSelection;
    BOOL _allowsEditing;
    BOOL _allowsMultipleEditing;
    BOOL _bouncesTop;
    BOOL _bouncesLeft;
    BOOL _bouncesRight;
    BOOL _bouncesBottom;
    CGPoint _scrollBeginPosition;
    MobilyDataViewDirection _scrollDirection;
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
    BOOL _animating;
    BOOL _updating;
    BOOL _invalidLayout;
    BOOL _showedSearchBar;
    MobilyDataViewSearchBarStyle _searchBarStyle;
    CGFloat _searchBarOverlayLastOffset;
    __weak MobilySearchBar* _searchBar;
    UIEdgeInsets _searchBarInsets;
    __weak NSLayoutConstraint* _constraintSearchBarTop;
    __weak NSLayoutConstraint* _constraintSearchBarLeft;
    __weak NSLayoutConstraint* _constraintSearchBarRight;
    __weak NSLayoutConstraint* _constraintSearchBarSize;
    __weak MobilyDataRefreshView* _topRefreshView;
    __weak NSLayoutConstraint* _constraintTopRefreshTop;
    __weak NSLayoutConstraint* _constraintTopRefreshLeft;
    __weak NSLayoutConstraint* _constraintTopRefreshRight;
    __weak NSLayoutConstraint* _constraintTopRefreshSize;
    __weak MobilyDataRefreshView* _bottomRefreshView;
    __weak NSLayoutConstraint* _constraintBottomRefreshBottom;
    __weak NSLayoutConstraint* _constraintBottomRefreshLeft;
    __weak NSLayoutConstraint* _constraintBottomRefreshRight;
    __weak NSLayoutConstraint* _constraintBottomRefreshSize;
    __weak MobilyDataRefreshView* _leftRefreshView;
    __weak NSLayoutConstraint* _constraintLeftRefreshTop;
    __weak NSLayoutConstraint* _constraintLeftRefreshBottom;
    __weak NSLayoutConstraint* _constraintLeftRefreshLeft;
    __weak NSLayoutConstraint* _constraintLeftRefreshSize;
    __weak MobilyDataRefreshView* _rightRefreshView;
    __weak NSLayoutConstraint* _constraintRightRefreshTop;
    __weak NSLayoutConstraint* _constraintRightRefreshBottom;
    __weak NSLayoutConstraint* _constraintRightRefreshRight;
    __weak NSLayoutConstraint* _constraintRightRefreshSize;
    UIEdgeInsets _refreshViewInsets;
    BOOL _searchBarDragging;
    BOOL _canSearchBar;
    BOOL _refreshDragging;
    BOOL _canTopRefresh;
    BOOL _canBottomRefresh;
    BOOL _canLeftRefresh;
    BOOL _canRightRefresh;
}

@property(nonatomic, readwrite, strong) MobilyDataViewDelegateProxy* delegateProxy;
@property(nonatomic, readwrite, assign) CGPoint scrollBeginPosition;
@property(nonatomic, readwrite, assign) MobilyDataViewDirection scrollDirection;

@property(nonatomic, readwrite, strong) NSMutableDictionary* registersViews;
@property(nonatomic, readwrite, strong) MobilyEvents* registersEvents;
@property(nonatomic, readwrite, strong) NSMutableDictionary* queueCells;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedBeforeItems;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedAfterItems;
@property(nonatomic, readwrite, strong) NSMutableArray* deletedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* insertedItems;
@property(nonatomic, readwrite, assign, getter=isAnimating) BOOL animating;
@property(nonatomic, readwrite, assign, getter=isUpdating) BOOL updating;
@property(nonatomic, readwrite, assign) BOOL invalidLayout;

@property(nonatomic, readwrite, assign) CGFloat searchBarOverlayLastOffset;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintSearchBarTop;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintSearchBarLeft;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintSearchBarRight;

@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintTopRefreshTop;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintTopRefreshLeft;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintTopRefreshRight;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintTopRefreshSize;

@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintBottomRefreshBottom;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintBottomRefreshLeft;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintBottomRefreshRight;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintBottomRefreshSize;

@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintLeftRefreshTop;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintLeftRefreshBottom;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintLeftRefreshLeft;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintLeftRefreshSize;

@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintRightRefreshTop;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintRightRefreshBottom;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintRightRefreshRight;
@property(nonatomic, readwrite, weak) NSLayoutConstraint* constraintRightRefreshSize;

@property(nonatomic, readwrite, assign, getter=isSearchBarDragging) BOOL searchBarDragging;
@property(nonatomic, readwrite, assign) BOOL canSearchBar;
@property(nonatomic, readwrite, assign, getter=isRefreshDragging) BOOL refreshDragging;
@property(nonatomic, readwrite, assign) BOOL canTopRefresh;
@property(nonatomic, readwrite, assign) BOOL canBottomRefresh;
@property(nonatomic, readwrite, assign) BOOL canLeftRefresh;
@property(nonatomic, readwrite, assign) BOOL canRightRefresh;

- (void)_receiveMemoryWarning;

- (void)_pressedItem:(MobilyDataItem*)item animated:(BOOL)animated;

- (void)_selectItem:(MobilyDataItem*)item user:(BOOL)user animated:(BOOL)animated;
- (void)_deselectItem:(MobilyDataItem*)item user:(BOOL)user animated:(BOOL)animated;
- (void)_deselectAllItemsUser:(BOOL)user animated:(BOOL)animated;

- (void)_appearItem:(MobilyDataItem*)item;
- (void)_disappearItem:(MobilyDataItem*)item;

- (void)_didInsertItems:(NSArray*)items;
- (void)_didDeleteItems:(NSArray*)items;
- (void)_didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;

- (void)_validateLayout;
- (void)_layoutForVisible;

- (void)_updateSuperviewConstraints;
- (void)_updateInsets;

- (void)_willBeginDragging;
- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating;
- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize;
- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate;
- (void)_willBeginDecelerating;
- (void)_didEndDecelerating;
- (void)_didEndScrollingAnimation;

- (void)_showSearchBarAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_hideSearchBarAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;

- (void)_showTopRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_hideTopRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_showBottomRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_hideBottomRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_showLeftRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_hideLeftRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_showRightRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;
- (void)_hideRightRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataViewCompleteBlock)complete;

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
