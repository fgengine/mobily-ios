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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import "MobilyDataView+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize delegateProxy = _delegateProxy;
@synthesize contentView = _contentView;
@synthesize velocity = _velocity;
@synthesize velocityMin = _velocityMin;
@synthesize velocityMax = _velocityMax;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize allowsOnceSelection = _allowsOnceSelection;
@synthesize allowsEditing = _allowsEditing;
@synthesize allowsMultipleEditing = _allowsMultipleEditing;
@synthesize bouncesTop = _bouncesTop;
@synthesize bouncesLeft = _bouncesLeft;
@synthesize bouncesRight = _bouncesRight;
@synthesize bouncesBottom = _bouncesBottom;
@synthesize scrollBeginPosition = _scrollBeginPosition;
@synthesize scrollDirection = _scrollDirection;
@synthesize container = _container;
@synthesize visibleItems = _visibleItems;
@synthesize selectedItems = _selectedItems;
@synthesize highlightedItems = _highlightedItems;
@synthesize editingItems = _editingItems;
@synthesize registersViews = _registersViews;
@synthesize registersEvents = _registersEvents;
@synthesize queueCells = _queueCells;
@synthesize reloadedBeforeItems = _reloadedBeforeItems;
@synthesize reloadedAfterItems = _reloadedAfterItems;
@synthesize deletedItems = _deletedItems;
@synthesize insertedItems = _insertedItems;
@synthesize animating = _animating;
@synthesize updating = _updating;
@synthesize invalidLayout = _invalidLayout;
@synthesize showedSearchBar = _showedSearchBar;
@synthesize searchBar = _searchBar;
@synthesize searchBarStyle =  _searchBarStyle;
@synthesize searchBarOverlayLastOffset =  _searchBarOverlayLastOffset;
@synthesize searchBarInsets =  _searchBarInsets;
@synthesize constraintSearchBarTop = _constraintSearchBarTop;
@synthesize constraintSearchBarLeft = _constraintSearchBarLeft;
@synthesize constraintSearchBarRight = _constraintSearchBarRight;
@synthesize topRefreshView = _topRefreshView;
@synthesize constraintTopRefreshTop = _constraintTopRefreshTop;
@synthesize constraintTopRefreshLeft = _constraintTopRefreshLeft;
@synthesize constraintTopRefreshRight = _constraintTopRefreshRight;
@synthesize constraintTopRefreshSize = _constraintTopRefreshSize;
@synthesize bottomRefreshView = _bottomRefreshView;
@synthesize constraintBottomRefreshBottom = _constraintBottomRefreshBottom;
@synthesize constraintBottomRefreshLeft = _constraintBottomRefreshLeft;
@synthesize constraintBottomRefreshRight = _constraintBottomRefreshRight;
@synthesize constraintBottomRefreshSize = _constraintBottomRefreshSize;
@synthesize leftRefreshView = _leftRefreshView;
@synthesize constraintLeftRefreshTop = _constraintLeftRefreshTop;
@synthesize constraintLeftRefreshBottom = _constraintLeftRefreshBottom;
@synthesize constraintLeftRefreshLeft = _constraintLeftRefreshLeft;
@synthesize constraintLeftRefreshSize = _constraintLeftRefreshSize;
@synthesize rightRefreshView = _rightRefreshView;
@synthesize constraintRightRefreshTop = _constraintRightRefreshTop;
@synthesize constraintRightRefreshBottom = _constraintRightRefreshBottom;
@synthesize constraintRightRefreshRight = _constraintRightRefreshRight;
@synthesize constraintRightRefreshSize = _constraintRightRefreshSize;
@synthesize refreshViewInsets =  _refreshViewInsets;
@synthesize searchBarDragging = _searchBarDragging;
@synthesize canSearchBar = _canSearchBar;
@synthesize refreshDragging = _refreshDragging;
@synthesize canTopRefresh = _canTopRefresh;
@synthesize canBottomRefresh = _canBottomRefresh;
@synthesize canLeftRefresh = _canLeftRefresh;
@synthesize canRightRefresh = _canRightRefresh;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.delegateProxy = [MobilyDataViewDelegateProxy new];
    
    if([UIDevice isIPhone] == YES) {
        _velocity = 400.0f;
        _velocityMin = 300.0f;
        _velocityMax = 900.0f;
    } else if([UIDevice isIPad] == YES) {
        _velocity = 2000.0f;
        _velocityMin = 3000.0f;
        _velocityMax = 6000.0f;
    }
    
    _bouncesTop = YES;
    _bouncesLeft = YES;
    _bouncesRight = YES;
    _bouncesBottom = YES;
    
    _allowsSelection = YES;
    _allowsEditing = YES;
    
    _visibleItems = NSMutableArray.array;
    _selectedItems = NSMutableArray.array;
    _highlightedItems = NSMutableArray.array;
    _editingItems = NSMutableArray.array;
    _registersViews = NSMutableDictionary.dictionary;
    _registersEvents = [MobilyEvents new];
    _queueCells = NSMutableDictionary.dictionary;
    _reloadedBeforeItems = NSMutableArray.array;
    _reloadedAfterItems = NSMutableArray.array;
    _deletedItems = NSMutableArray.array;
    _insertedItems = NSMutableArray.array;
    
    _showedSearchBar = NO;
    _searchBarStyle = MobilyDataViewSearchBarStyleOverlay;
    
    [self registerAdjustmentResponder];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_receiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [self unregisterAdjustmentResponder];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return _objectChilds;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self validateLayoutIfNeed];
    [self _layoutForVisible];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self _updateSuperviewConstraints];
}

#pragma mark Property

- (void)setFrame:(CGRect)frame {
    CGRect prev = self.frame;
    if(CGSizeEqualToSize(prev.size, frame.size) == NO) {
        [self setNeedValidateLayout];
    }
    super.frame = frame;
}

- (void)setBounds:(CGRect)bounds {
    CGRect prev = self.bounds;
    if(CGSizeEqualToSize(prev.size, bounds.size) == NO) {
        [self setNeedValidateLayout];
    }
    super.bounds = bounds;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    self.contentView.frameSize = contentSize;
}

- (void)setDelegateProxy:(MobilyDataViewDelegateProxy*)delegateProxy {
    if(_delegateProxy != delegateProxy) {
        if(_delegateProxy != nil) {
            _delegateProxy.view = nil;
        }
        super.delegate = nil;
        _delegateProxy = delegateProxy;
        super.delegate = _delegateProxy;
        if(_delegateProxy != nil) {
            _delegateProxy.view = self;
        }
    }
}

- (void)setDelegate:(id< UIScrollViewDelegate >)delegate {
    if(_delegateProxy.delegate != delegate) {
        super.delegate = nil;
        _delegateProxy.delegate = delegate;
        super.delegate = _delegateProxy;
    }
}

- (id< UIScrollViewDelegate >)delegate {
    return _delegateProxy.delegate;
}

- (MobilyDataContentView*)contentView {
    if(_contentView == nil) {
        _contentView = [[MobilyDataContentView alloc] initWithFrame:CGRectMakeOriginAndSize(CGPointZero, self.contentSize)];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)setContainer:(MobilyDataContainer*)container {
    if(_container != container) {
        if(_container != nil) {
            [self setNeedValidateLayout];
            [UIView performWithoutAnimation:^{
                [self deselectAllItemsAnimated:NO];
                [self unhighlightAllItemsAnimated:NO];
                if(_visibleItems.count > 0) {
                    for(MobilyDataItem* item in _visibleItems) {
                        [self _disappearItem:item];
                    }
                    [_visibleItems removeAllObjects];
                }
            }];
            _container.view = nil;
            [self validateLayoutIfNeed];
        }
        _container = container;
        if(_container != nil) {
            [self setNeedValidateLayout];
            _container.view = self;
            [UIView performWithoutAnimation:^{
                [self validateLayoutIfNeed];
                [self _layoutForVisible];
            }];
        }
    }
}

- (NSArray*)visibleItems {
    [_visibleItems sortUsingComparator:^NSComparisonResult(MobilyDataItem* item1, MobilyDataItem* item2) {
        if(item1.order < item2.order) {
            return NSOrderedAscending;
        } else if(item1.order > item2.order) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    return _visibleItems;
}

- (NSArray*)visibleCells {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataItem* item in self.visibleItems) {
        [result addObject:item.view];
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray*)selectedItems {
    return _selectedItems;
}

- (NSArray*)selectedCells {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataItem* item in _selectedItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [result addObject:cell];
        }
    }
    return result;
}

- (NSArray*)highlightedItems {
    return _highlightedItems;
}

- (NSArray*)highlightedCells {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataItem* item in _highlightedItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [result addObject:cell];
        }
    }
    return result;
}

- (NSArray*)editingItems {
    return _editingItems;
}

- (NSArray*)editingCells {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataItem* item in _editingItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [result addObject:cell];
        }
    }
    return result;
}

- (void)setShowedSearchBar:(BOOL)showedSearchBar {
    if(showedSearchBar == YES) {
        [self showSearchBarAnimated:NO complete:nil];
    } else {
        [self hideSearchBarAnimated:NO complete:nil];
    }
}

- (void)setSearchBarStyle:(MobilyDataViewSearchBarStyle)searchBarStyle {
    if(_searchBarStyle != searchBarStyle) {
        if(_searchBar != nil) {
            self.constraintSearchBarTop = nil;
            self.constraintSearchBarLeft = nil;
            self.constraintSearchBarRight = nil;
        }
        _searchBarStyle = searchBarStyle;
        if(_searchBar != nil) {
            [self _updateSuperviewConstraints];
        }
        UIEdgeInsets searchBarInsets = self.searchBarInsets;
        searchBarInsets.top = (_showedSearchBar == YES) ? _searchBar.frameHeight : 0.0f;
        self.searchBarInsets = searchBarInsets;
    }
}

- (void)setSearchBar:(MobilySearchBar*)searchBar {
    if(_searchBar != searchBar) {
        if(_searchBar != nil) {
            self.constraintSearchBarTop = nil;
            self.constraintSearchBarLeft = nil;
            self.constraintSearchBarRight = nil;
            [_searchBar removeFromSuperview];
        }
        _searchBar = searchBar;
        if(_searchBar != nil) {
            _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_searchBar aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
        UIEdgeInsets searchBarInsets = self.searchBarInsets;
        searchBarInsets.top = (_showedSearchBar == YES) ? _searchBar.frameHeight : 0.0f;
        self.searchBarInsets = searchBarInsets;
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintSearchBarTop, constraintSearchBarTop, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintSearchBarLeft, constraintSearchBarLeft, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintSearchBarRight, constraintSearchBarRight, self.superview, {
}, {
})

- (void)setSearchBarInsets:(UIEdgeInsets)searchBarInsets {
    if(UIEdgeInsetsEqualToEdgeInsets(_searchBarInsets, searchBarInsets) == NO) {
        _searchBarInsets = searchBarInsets;
        [self _updateInsets];
    }
}

- (void)setTopRefreshView:(MobilyDataRefreshView*)topRefreshView {
    if(_topRefreshView != topRefreshView) {
        if(_topRefreshView != nil) {
            self.constraintTopRefreshTop = nil;
            self.constraintTopRefreshLeft = nil;
            self.constraintTopRefreshRight = nil;
            self.constraintTopRefreshSize = nil;
            [_topRefreshView removeFromSuperview];
            _topRefreshView.view = nil;
        }
        _topRefreshView = topRefreshView;
        if(_topRefreshView != nil) {
            _topRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            _topRefreshView.type = MobilyDataRefreshViewTypeTop;
            _topRefreshView.view = self;
            if(self.superview != nil) {
                [self.superview insertSubview:_topRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintTopRefreshTop, constraintTopRefreshTop, self.superview, {
}, {
    _topRefreshView.constraintOffset = _constraintTopRefreshTop;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintTopRefreshLeft, constraintTopRefreshLeft, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintTopRefreshRight, constraintTopRefreshRight, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintTopRefreshSize, constraintTopRefreshSize, self.superview, {
}, {
    _topRefreshView.constraintSize = _constraintTopRefreshSize;
})

- (void)setBottomRefreshView:(MobilyDataRefreshView*)bottomRefreshView {
    if(_bottomRefreshView != bottomRefreshView) {
        if(_bottomRefreshView != nil) {
            self.constraintBottomRefreshBottom = nil;
            self.constraintBottomRefreshLeft = nil;
            self.constraintBottomRefreshRight = nil;
            self.constraintBottomRefreshSize = nil;
            [_bottomRefreshView removeFromSuperview];
            _bottomRefreshView.view = nil;
        }
        _bottomRefreshView = bottomRefreshView;
        if(_bottomRefreshView != nil) {
            _bottomRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            _bottomRefreshView.type = MobilyDataRefreshViewTypeBottom;
            _bottomRefreshView.view = self;
            if(self.superview != nil) {
                [self.superview insertSubview:_bottomRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintBottomRefreshBottom, constraintBottomRefreshBottom, self.superview, {
}, {
    _bottomRefreshView.constraintOffset = _constraintBottomRefreshBottom;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintBottomRefreshLeft, constraintBottomRefreshLeft, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintBottomRefreshRight, constraintBottomRefreshRight, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintBottomRefreshSize, constraintBottomRefreshSize, self.superview, {
}, {
    _bottomRefreshView.constraintSize = _constraintBottomRefreshSize;
})

- (void)setLeftRefreshView:(MobilyDataRefreshView*)leftRefreshView {
    if(_leftRefreshView != leftRefreshView) {
        if(_leftRefreshView != nil) {
            self.constraintLeftRefreshBottom = nil;
            self.constraintLeftRefreshLeft = nil;
            self.constraintLeftRefreshTop = nil;
            self.constraintLeftRefreshSize = nil;
            [_leftRefreshView removeFromSuperview];
            _leftRefreshView.view = nil;
        }
        _leftRefreshView = leftRefreshView;
        if(_leftRefreshView != nil) {
            _leftRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            _leftRefreshView.type = MobilyDataRefreshViewTypeLeft;
            _leftRefreshView.view = self;
            if(self.superview != nil) {
                [self.superview insertSubview:_leftRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftRefreshTop, constraintLeftRefreshTop, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftRefreshBottom, constraintLeftRefreshBottom, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftRefreshLeft, constraintLeftRefreshLeft, self.superview, {
}, {
    _leftRefreshView.constraintOffset = _constraintLeftRefreshLeft;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintLeftRefreshSize, constraintLeftRefreshSize, self.superview, {
}, {
    _leftRefreshView.constraintSize = _constraintLeftRefreshSize;
})

- (void)setRightRefreshView:(MobilyDataRefreshView*)rightRefreshView {
    if(_rightRefreshView != rightRefreshView) {
        if(_rightRefreshView != nil) {
            self.constraintRightRefreshTop = nil;
            self.constraintRightRefreshBottom = nil;
            self.constraintRightRefreshRight = nil;
            self.constraintRightRefreshSize = nil;
            [_rightRefreshView removeFromSuperview];
            _rightRefreshView.view = nil;
        }
        _rightRefreshView = rightRefreshView;
        if(_rightRefreshView != nil) {
            _rightRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            _rightRefreshView.type = MobilyDataRefreshViewTypeRight;
            _rightRefreshView.view = self;
            if(self.superview != nil) {
                [self.superview insertSubview:_rightRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightRefreshTop, constraintRightRefreshTop, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightRefreshBottom, constraintRightRefreshBottom, self.superview, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightRefreshRight, constraintRightRefreshRight, self.superview, {
}, {
    _rightRefreshView.constraintOffset = _constraintRightRefreshRight;
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRightRefreshSize, constraintRightRefreshSize, self.superview, {
}, {
    _rightRefreshView.constraintSize = _constraintRightRefreshSize;
})

- (void)setRefreshViewInsets:(UIEdgeInsets)refreshViewInsets {
    if(UIEdgeInsetsEqualToEdgeInsets(_refreshViewInsets, refreshViewInsets) == NO) {
        _refreshViewInsets = refreshViewInsets;
        [self _updateInsets];
    }
}

#pragma mark Public

- (void)registerIdentifier:(NSString*)identifier withViewClass:(Class)viewClass {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_registersViews[identifier] != nil) {
        NSLog(@"ERROR: [%@:%@] %@ - %@", self.class, NSStringFromSelector(_cmd), identifier, viewClass);
        return;
    }
#endif
    _registersViews[identifier] = viewClass;
}

- (void)unregisterIdentifier:(NSString*)identifier {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_registersViews[identifier] == nil) {
        NSLog(@"ERROR: [%@:%@] %@", self.class, NSStringFromSelector(_cmd), identifier);
        return;
    }
#endif
    [_registersViews removeObjectForKey:identifier];
}

- (void)unregisterAllIdentifiers {
    [_registersViews removeAllObjects];
}

- (void)registerEventWithTarget:(id)target action:(SEL)action forKey:(id)key {
    [_registersEvents addEventWithTarget:target action:action forKey:key];
}

- (void)registerEventWithTarget:(id)target action:(SEL)action forIdentifier:(NSString*)identifier forKey:(id)key {
    [_registersEvents addEventWithTarget:target action:action forGroup:identifier forKey:key];
}

- (void)registerEventWithBlock:(MobilyEventBlockType)block forKey:(id)key {
    [_registersEvents addEventWithBlock:block forKey:key];
}

- (void)registerEventWithBlock:(MobilyEventBlockType)block forIdentifier:(NSString*)identifier forKey:(id)key {
    [_registersEvents addEventWithBlock:block forGroup:identifier forKey:key];
}

- (void)registerEvent:(id< MobilyEvent >)event forKey:(id)key {
    [_registersEvents addEvent:event forKey:key];
}

- (void)registerEvent:(id< MobilyEvent >)event forIdentifier:(NSString*)identifier forKey:(id)key {
    [_registersEvents addEvent:event forGroup:identifier forKey:key];
}

- (void)unregisterEventForKey:(id)key {
    [_registersEvents removeEventForKey:key];
}

- (void)unregisterEventForIdentifier:(NSString*)identifier forKey:(id)key {
    [_registersEvents removeEventInGroup:identifier forKey:key];
}

- (void)unregisterEventsForIdentifier:(NSString*)identifier {
    [_registersEvents removeEventsForGroup:identifier];
}

- (void)unregisterAllEvents {
    [_registersEvents removeAllEvents];
}

- (BOOL)containsEventForKey:(id)key {
    return [_registersEvents containsEventForKey:key];
}

- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key {
    return [_registersEvents containsEventInGroup:identifier forKey:key];
}

- (BOOL)containsEventForKey:(id)key forIdentifier:(NSString*)identifier {
    return [_registersEvents containsEventInGroup:identifier forKey:key];
}

- (void)fireEventForKey:(id)key byObject:(id)object {
    [_registersEvents fireEventForKey:key bySender:self byObject:object];
}

- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object {
    [_registersEvents fireEventInGroup:identifier forKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_registersEvents fireEventForKey:key bySender:self byObject:object orDefault:orDefault];
}

- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_registersEvents fireEventInGroup:identifier forKey:key bySender:self byObject:object orDefault:orDefault];
}

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    [_registersEvents fireEventForKey:key bySender:sender byObject:object];
}

- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object {
    [_registersEvents fireEventInGroup:identifier forKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_registersEvents fireEventForKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_registersEvents fireEventInGroup:identifier forKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (Class)cellClassWithItem:(MobilyDataItem*)item {
    return _registersViews[item.identifier];
}

- (void)dequeueCellWithItem:(MobilyDataItem*)item {
    if(item.cell == nil) {
        NSString* identifier = item.identifier;
        NSMutableArray* queue = _queueCells[identifier];
        MobilyDataCell* cell = [queue lastObject];
        if(cell == nil) {
            cell = [[_registersViews[identifier] alloc] initWithIdentifier:identifier];
            if(cell != nil) {
                cell.view = self;
                __block NSUInteger viewIndex = NSNotFound;
                [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
                    if([view isKindOfClass:MobilyDataCell.class] == YES) {
                        MobilyDataCell* existCell = (MobilyDataCell*)view;
                        if(item.order > existCell.item.order) {
                            viewIndex = index;
                        } else if(item.order <= existCell.item.order) {
                            *stop = YES;
                        }
                    }
                }];
                if(viewIndex != NSNotFound) {
                    [self.contentView insertSubview:cell atIndex:viewIndex + 1];
                } else {
                    [self.contentView insertSubview:cell atIndex:0];
                }
            }
        } else {
            [queue removeLastObject];
        }
        item.cell = cell;
    }
}

- (void)enqueueCellWithItem:(MobilyDataItem*)item {
    MobilyDataCell* cell = item.cell;
    if(cell != nil) {
        NSString* identifier = item.identifier;
        NSMutableArray* queue = _queueCells[identifier];
        if(queue == nil) {
            _queueCells[identifier] = [NSMutableArray arrayWithObject:cell];
        } else {
            [queue addObject:cell];
        }
        item.cell = nil;
    }
}

- (MobilyDataItem*)itemForPoint:(CGPoint)point {
    [self validateLayoutIfNeed];
    return [_container itemForPoint:point];
}

- (MobilyDataItem*)itemForData:(id)data {
    return [_container itemForData:data];
}

- (MobilyDataCell*)cellForData:(id)data {
    return [_container cellForData:data];
}

- (BOOL)isSelectedItem:(MobilyDataItem*)item {
    return [_selectedItems containsObject:item];
}

- (BOOL)shouldSelectItem:(MobilyDataItem*)item {
    if(_allowsSelection == YES) {
        if(item.allowsSelection == YES) {
            if([self isSelectedItem:item] == NO) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)shouldDeselectItem:(MobilyDataItem* __unused)item {
    if([self isSelectedItem:item] == YES) {
        return YES;
    }
    return NO;
}

- (void)selectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    [self _selectItem:item user:NO animated:animated];
}

- (void)deselectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    [self _deselectItem:item user:NO animated:animated];
}

- (void)deselectAllItemsAnimated:(BOOL)animated {
    [self _deselectAllItemsUser:NO animated:animated];
}

- (BOOL)isHighlightedItem:(MobilyDataItem*)item {
    return [_highlightedItems containsObject:item];
}

- (BOOL)shouldHighlightItem:(MobilyDataItem*)item {
    return item.allowsHighlighting;
}

- (BOOL)shouldUnhighlightItem:(MobilyDataItem* __unused)item {
    return YES;
}

- (void)highlightItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_highlightedItems containsObject:item] == NO) {
        if([self shouldHighlightItem:item] == YES) {
            [_highlightedItems addObject:item];
            [item setHighlighted:YES animated:animated];
        }
    }
}

- (void)unhighlightItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_highlightedItems containsObject:item] == YES) {
        if([self shouldUnhighlightItem:item] == YES) {
            [_highlightedItems removeObject:item];
            [item setHighlighted:NO animated:animated];
        }
    }
}

- (void)unhighlightAllItemsAnimated:(BOOL)animated {
    if(_highlightedItems.count > 0) {
        [_highlightedItems each:^(MobilyDataItem* item) {
            if([self shouldUnhighlightItem:item] == YES) {
                [_highlightedItems removeObject:item];
                [item setHighlighted:NO animated:animated];
            }
        }];
    }
}

- (BOOL)isEditingItem:(MobilyDataItem*)item {
    return [_editingItems containsObject:item];
}

- (BOOL)shouldBeganEditItem:(MobilyDataItem*)item {
    if(_allowsEditing == YES) {
        return item.allowsEditing;
    }
    return NO;
}

- (BOOL)shouldEndedEditItem:(MobilyDataItem* __unused)item {
    return _allowsEditing;
}

- (void)beganEditItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_editingItems containsObject:item] == NO) {
        if([self shouldBeganEditItem:item] == YES) {
            if(_allowsMultipleEditing == YES) {
                [_editingItems addObject:item];
                [item setEditing:YES animated:animated];
            } else {
                if(_editingItems.count > 0) {
                    [_editingItems each:^(MobilyDataItem* item) {
                        if([self shouldEndedEditItem:item] == YES) {
                            [_editingItems removeObject:item];
                            [item setEditing:NO animated:animated];
                        }
                    }];
                }
                [_editingItems addObject:item];
                [item setEditing:YES animated:animated];
            }
        }
    }
}

- (void)endedEditItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_editingItems containsObject:item] == YES) {
        if([self shouldEndedEditItem:item] == YES) {
            [_editingItems removeObject:item];
            [item setEditing:NO animated:animated];
        }
    }
}

- (void)endedEditAllItemsAnimated:(BOOL)animated {
    if(_editingItems.count > 0) {
        [_editingItems each:^(MobilyDataItem* item) {
            if([self shouldEndedEditItem:item] == YES) {
                [_editingItems removeObject:item];
                [item setEditing:NO animated:animated];
            }
        }];
    }
}

- (void)batchUpdate:(MobilyDataViewUpdateBlock)update {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %@", self.class, NSStringFromSelector(_cmd), update);
        return;
    }
#endif
    [self _batchUpdate:^{
        if(update != nil) {
            update();
        }
        [self _batchComplete:nil animated:NO];
    } animated:NO];
}

- (void)batchUpdate:(MobilyDataViewUpdateBlock)update complete:(MobilyDataViewCompleteBlock)complete {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %@ - %@", self.class, NSStringFromSelector(_cmd), update, complete);
        return;
    }
#endif
    [self _batchUpdate:^{
        if(update != nil) {
            update();
        }
        [self _batchComplete:^() {
            if(complete != nil) {
                complete(YES);
            }
        } animated:NO];
    } animated:NO];
}

- (void)batchDuration:(NSTimeInterval)duration update:(MobilyDataViewUpdateBlock)update complete:(MobilyDataViewCompleteBlock)complete {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %0.2f - %@ - %@", self.class, NSStringFromSelector(_cmd), duration, update, complete);
        return;
    }
#endif
    if(duration > FLT_EPSILON) {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             [self _batchUpdate:update animated:YES];
                         }
                         completion:^(BOOL finished) {
                             [self _batchComplete:^() {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             } animated:YES];
                         }];
    } else {
        [self _batchUpdate:^{
            if(update != nil) {
                update();
            }
            [self _batchComplete:^() {
                if(complete != nil) {
                    complete(YES);
                }
            } animated:NO];
        } animated:NO];
    }
}

- (void)setNeedValidateLayout {
    self.invalidLayout = YES;
    [self setNeedsLayout];
}

- (void)validateLayoutIfNeed {
    if(_invalidLayout == YES) {
        [self _validateLayout];
        self.invalidLayout = NO;
    }
}

- (void)setNeedLayoutForVisible {
    [self setNeedsLayout];
}

- (void)layoutForVisibleIfNeed {
    [self layoutIfNeeded];
}

- (void)scrollToItem:(MobilyDataItem*)item scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated {
    [self scrollToRect:[item updateFrame] scrollPosition:scrollPosition animated:animated];
}

- (void)scrollToRect:(CGRect)rect scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated {
    [self validateLayoutIfNeed];
    NSUInteger vPosition = scrollPosition & (MobilyDataViewPositionTop | MobilyDataViewPositionCenteredVertically | MobilyDataViewPositionBottom);
    NSUInteger hPosition = scrollPosition & (MobilyDataViewPositionLeft | MobilyDataViewPositionCenteredHorizontally | MobilyDataViewPositionRight);
    CGRect viewport = self.bounds;
    CGPoint offset = rect.origin;
    switch(vPosition) {
        case MobilyDataViewPositionCenteredVertically: {
            offset.y = rect.origin.y - ((viewport.size.height * 0.5f) - (rect.size.height * 0.5f));
            break;
        }
        case MobilyDataViewPositionBottom: {
            offset.y = rect.origin.y - (viewport.size.height - rect.size.height);
            break;
        }
        case MobilyDataViewPositionInsideVertically: {
            if(offset.y + rect.size.height > viewport.origin.y + viewport.size.height) {
                offset.y = rect.origin.y - (viewport.size.height - rect.size.height);
            } else if(offset.y > viewport.origin.y) {
                offset.y = viewport.origin.y;
            }
            break;
        }
    }
    switch(hPosition) {
        case MobilyDataViewPositionCenteredHorizontally: {
            offset.x = rect.origin.x - ((viewport.size.width * 0.5f) - (rect.size.width * 0.5f));
            break;
        }
        case MobilyDataViewPositionRight: {
            offset.x = rect.origin.x - (viewport.size.width - rect.size.width);
            break;
        }
        case MobilyDataViewPositionInsideHorizontally: {
            if(offset.x + rect.size.width > viewport.origin.x + viewport.size.width) {
                offset.x = rect.origin.x - (viewport.size.width - rect.size.width);
            } else if(offset.x > viewport.origin.x) {
                offset.x = viewport.origin.x;
            }
            break;
        }
    }
    [self scrollRectToVisible:CGRectMake(offset.x, offset.y, viewport.size.width, viewport.size.height) animated:animated];
}

- (void)showSearchBarAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _showSearchBarAnimated:animated velocity:_velocity complete:complete];
}

- (void)hideSearchBarAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _hideSearchBarAnimated:animated velocity:_velocity complete:complete];
}

- (void)showTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _showTopRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)hideTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _hideTopRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)showBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _showBottomRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)hideBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _hideBottomRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)showLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _showLeftRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)hideLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _hideLeftRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)showRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _showRightRefreshAnimated:animated velocity:_velocity complete:complete];
}

- (void)hideRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    [self _hideRightRefreshAnimated:animated velocity:_velocity complete:complete];
}

#pragma mark Private

- (void)_receiveMemoryWarning {
    [_queueCells each:^(NSString* identifier, NSArray* cells) {
        for(MobilyDataCell* cell in cells) {
            [cell removeFromSuperview];
            cell.view = nil;
        }
    }];
    [_queueCells removeAllObjects];
}

- (void)_pressedItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if(_allowsOnceSelection == YES) {
        [self _selectItem:item user:YES animated:animated];
    } else {
        if([self isSelectedItem:item] == NO) {
            [self _selectItem:item user:YES animated:animated];
        } else {
            [self _deselectItem:item user:YES animated:animated];
        }
    }
}

- (void)_selectItem:(MobilyDataItem*)item user:(BOOL)user animated:(BOOL)animated {
    if([self shouldSelectItem:item] == YES) {
        if(_allowsMultipleSelection == YES) {
            [_selectedItems addObject:item];
            [item setSelected:YES animated:animated];
            if(user == YES) {
            }
        } else {
            if(_selectedItems.count > 0) {
                [_selectedItems each:^(MobilyDataItem* item) {
                    if([self shouldDeselectItem:item] == YES) {
                        [_selectedItems removeObject:item];
                        [item setSelected:NO animated:animated];
                    }
                }];
            }
            [_selectedItems addObject:item];
            [item setSelected:YES animated:animated];
            if(user == YES) {
                [self fireEventForKey:MobilyDataViewSelectItem byObject:item];
            }
        }
    }
}

- (void)_deselectItem:(MobilyDataItem*)item user:(BOOL)user animated:(BOOL)animated {
    if([self shouldDeselectItem:item] == YES) {
        [_selectedItems removeObject:item];
        [item setSelected:NO animated:animated];
        if(user == YES) {
            [self fireEventForKey:MobilyDataViewDeselectItem byObject:item];
        }
    }
}

- (void)_deselectAllItemsUser:(BOOL)user animated:(BOOL)animated {
    if(_selectedItems.count > 0) {
        [_selectedItems each:^(MobilyDataItem* item) {
            if([self shouldDeselectItem:item] == YES) {
                [_selectedItems removeObject:item];
                [item setSelected:NO animated:animated];
                if(user == YES) {
                    [self fireEventForKey:MobilyDataViewDeselectItem byObject:item];
                }
            }
        }];
    }
}

- (void)_appearItem:(MobilyDataItem*)item {
    [_visibleItems addObject:item];
    [self dequeueCellWithItem:item];
}

- (void)_disappearItem:(MobilyDataItem*)item {
    [_visibleItems removeObject:item];
    [self enqueueCellWithItem:item];
}

- (void)_didInsertItems:(NSArray*)items {
    if(_updating == YES) {
        [_insertedItems addObjectsFromArray:items];
    }
    [self setNeedValidateLayout];
}

- (void)_didDeleteItems:(NSArray*)items {
    [_visibleItems removeObjectsInArray:items];
    [_selectedItems removeObjectsInArray:items];
    [_highlightedItems removeObjectsInArray:items];
    [_editingItems removeObjectsInArray:items];
    if(_updating == YES) {
        [_deletedItems addObjectsFromArray:items];
    } else {
        if([self containsEventForKey:MobilyDataViewAnimateRestore] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateRestore byObject:items];
            for(MobilyDataItem* item in items) {
                [self _disappearItem:item];
            }
        } else {
            for(MobilyDataItem* item in items) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
                [self _disappearItem:item];
            }
        }
    }
    [self setNeedValidateLayout];
}

- (void)_didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items {
    [_visibleItems removeObjectsInArray:originItems];
    [_selectedItems removeObjectsInArray:originItems];
    [_highlightedItems removeObjectsInArray:originItems];
    [_editingItems removeObjectsInArray:originItems];
    if(_updating == YES) {
        [_reloadedBeforeItems addObjectsFromArray:originItems];
        [_reloadedAfterItems addObjectsFromArray:items];
    } else {
        if([self containsEventForKey:MobilyDataViewAnimateRestore] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateRestore byObject:items];
            for(MobilyDataItem* item in items) {
                [self _disappearItem:item];
            }
        } else {
            for(MobilyDataItem* item in originItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
                [self _disappearItem:item];
            }
        }
    }
    [self setNeedValidateLayout];
}

- (void)_validateLayout {
    CGRect layoutRect = CGRectZero;
    if(_container != nil) {
        layoutRect = [_container _validateLayoutForAvailableFrame:CGRectMakeOriginAndSize(CGPointZero, self.frameSize)];
    }
    self.contentSize = layoutRect.size;
}

- (void)_layoutForVisible {
    if((self.dragging == YES) || (self.decelerating == YES)) {
        [_container _willLayoutForBounds:self.visibleBounds];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect bounds = self.visibleBounds;
            if(_updating == NO) {
                [_visibleItems each:^(MobilyDataItem* item) {
                    [item invalidateLayoutForBounds:bounds];
                }];
            }
            [_container _didLayoutForBounds:bounds];
        });
    } else {
        CGRect bounds = self.visibleBounds;
        [_container _willLayoutForBounds:bounds];
        if(_updating == NO) {
            [_visibleItems enumerateObjectsUsingBlock:^(MobilyDataItem* item, NSUInteger itemIndex __unused, BOOL* itemStop __unused) {
                [item invalidateLayoutForBounds:bounds];
            }];
        }
        [_container _didLayoutForBounds:bounds];
    }
}

- (void)_updateSuperviewConstraints {
    if(_searchBar != nil) {
        if(_constraintSearchBarTop == nil) {
            if(_showedSearchBar == YES) {
                self.constraintSearchBarTop = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            } else {
                self.constraintSearchBarTop = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            }
        }
        if(_constraintSearchBarLeft == nil) {
            if(_leftRefreshView != nil) {
                self.constraintSearchBarLeft = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_leftRefreshView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            } else {
                self.constraintSearchBarLeft = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
            }
        }
        if(_constraintSearchBarRight == nil) {
            if(_rightRefreshView != nil) {
                self.constraintSearchBarRight = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightRefreshView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
            } else {
                self.constraintSearchBarRight = [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            }
        }
    } else {
        self.constraintSearchBarTop = nil;
        self.constraintSearchBarLeft = nil;
        self.constraintSearchBarRight = nil;
    }
    if(_topRefreshView != nil) {
        if(_constraintTopRefreshTop == nil) {
            if(_searchBar != nil) {
                self.constraintTopRefreshTop = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_searchBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            } else {
                self.constraintTopRefreshTop = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            }
        }
        if(_constraintTopRefreshLeft == nil) {
            self.constraintTopRefreshLeft = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        }
        if(_constraintTopRefreshRight == nil) {
            self.constraintTopRefreshRight = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        if(_constraintTopRefreshSize == nil) {
            self.constraintTopRefreshSize = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintTopRefreshTop = nil;
        self.constraintTopRefreshLeft = nil;
        self.constraintTopRefreshRight = nil;
        self.constraintTopRefreshSize = nil;
    }
    if(_bottomRefreshView != nil) {
        if(_constraintBottomRefreshBottom == nil) {
            self.constraintBottomRefreshBottom = [NSLayoutConstraint constraintWithItem:_bottomRefreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        }
        if(_constraintBottomRefreshLeft == nil) {
            self.constraintBottomRefreshLeft = [NSLayoutConstraint constraintWithItem:_bottomRefreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        }
        if(_constraintBottomRefreshRight == nil) {
            self.constraintBottomRefreshRight = [NSLayoutConstraint constraintWithItem:_bottomRefreshView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        if(_constraintBottomRefreshSize == nil) {
            self.constraintBottomRefreshSize = [NSLayoutConstraint constraintWithItem:_bottomRefreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintBottomRefreshBottom = nil;
        self.constraintBottomRefreshLeft = nil;
        self.constraintBottomRefreshRight = nil;
        self.constraintBottomRefreshSize = nil;
    }
    if(_leftRefreshView != nil) {
        if(_constraintLeftRefreshTop == nil) {
            self.constraintLeftRefreshTop = [NSLayoutConstraint constraintWithItem:_leftRefreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
        if(_constraintLeftRefreshBottom == nil) {
            self.constraintLeftRefreshBottom = [NSLayoutConstraint constraintWithItem:_leftRefreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        }
        if(_constraintLeftRefreshLeft == nil) {
            self.constraintLeftRefreshLeft = [NSLayoutConstraint constraintWithItem:_leftRefreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        }
        if(_constraintLeftRefreshSize == nil) {
            self.constraintLeftRefreshSize = [NSLayoutConstraint constraintWithItem:_leftRefreshView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintLeftRefreshTop = nil;
        self.constraintLeftRefreshBottom = nil;
        self.constraintLeftRefreshLeft = nil;
        self.constraintLeftRefreshSize = nil;
    }
    if(_rightRefreshView != nil) {
        if(_constraintRightRefreshTop == nil) {
            self.constraintRightRefreshTop = [NSLayoutConstraint constraintWithItem:_rightRefreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
        if(_constraintRightRefreshBottom == nil) {
            self.constraintRightRefreshBottom = [NSLayoutConstraint constraintWithItem:_rightRefreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        }
        if(_constraintRightRefreshRight == nil) {
            self.constraintRightRefreshRight = [NSLayoutConstraint constraintWithItem:_rightRefreshView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        if(_constraintRightRefreshSize == nil) {
            self.constraintRightRefreshSize = [NSLayoutConstraint constraintWithItem:_rightRefreshView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintRightRefreshTop = nil;
        self.constraintRightRefreshBottom = nil;
        self.constraintRightRefreshRight = nil;
        self.constraintRightRefreshSize = nil;
    }
}

- (void)_updateInsets {
    UIEdgeInsets scrollInsets = UIEdgeInsetsMake(_searchBarInsets.top + _refreshViewInsets.top,
                                                 _searchBarInsets.left + _refreshViewInsets.left,
                                                 _searchBarInsets.bottom + _refreshViewInsets.bottom,
                                                 _searchBarInsets.right + _refreshViewInsets.right);
    UIEdgeInsets contentInset = _searchBarInsets;
    if((_topRefreshView.state == MobilyDataRefreshViewStateLoading) || (_bottomRefreshView.state == MobilyDataRefreshViewStateLoading)) {
        contentInset.top += _refreshViewInsets.top;
        contentInset.bottom += _refreshViewInsets.bottom;
    }
    if((_leftRefreshView.state == MobilyDataRefreshViewStateLoading) || (_rightRefreshView.state == MobilyDataRefreshViewStateLoading)) {
        contentInset.left += _refreshViewInsets.left;
        contentInset.right += _refreshViewInsets.right;
    }
    self.scrollIndicatorInsets = scrollInsets;
    self.contentInset = contentInset;
}

- (void)_willBeginDragging {
    self.scrollBeginPosition = self.contentOffset;
    if(self.directionalLockEnabled == YES) {
        self.scrollDirection = MobilyDataViewDirectionUnknown;
    }
    if(self.pagingEnabled == NO) {
        if(_searchBarDragging == NO) {
            if(_searchBar != nil) {
                switch(_searchBarStyle) {
                    case MobilyDataViewSearchBarStyleStatic:
                        self.canSearchBar = NO;
                        break;
                    case MobilyDataViewSearchBarStyleInside:
                    case MobilyDataViewSearchBarStyleOverlay:
                        self.searchBarOverlayLastOffset = _scrollBeginPosition.y;
                        self.canSearchBar = YES;
                        break;
                }
            }
            self.searchBarDragging = (_canSearchBar == YES);
        }
        if(_refreshDragging == NO) {
            if(_topRefreshView != nil) {
                switch(_topRefreshView.state) {
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: self.canTopRefresh = NO; break;
                    default: self.canTopRefresh = YES; break;
                }
            } else {
                self.canTopRefresh = NO;
            }
            if(_bottomRefreshView != nil) {
                switch(_bottomRefreshView.state) {
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: self.canBottomRefresh = NO; break;
                    default: self.canBottomRefresh = YES; break;
                }
            } else {
                self.canBottomRefresh = NO;
            }
            if(_leftRefreshView != nil) {
                switch(_leftRefreshView.state) {
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: self.canLeftRefresh = NO; break;
                    default: self.canLeftRefresh = YES; break;
                }
            } else {
                self.canLeftRefresh = NO;
            }
            if(_rightRefreshView != nil) {
                switch(_rightRefreshView.state) {
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: self.canRightRefresh = NO; break;
                    default: self.canRightRefresh = YES; break;
                }
            } else {
                self.canRightRefresh = NO;
            }
            self.refreshDragging = ((_canTopRefresh == YES) || (_canBottomRefresh == YES) || (_canLeftRefresh == YES) || (_canRightRefresh == YES));
        }
    }
    if(_container != nil) {
        [_container _willBeginDragging];
    }
}

- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating {
    if((self.pagingEnabled == NO) && ((dragging == YES) || (decelerating == YES))) {
        CGSize frameSize = self.frameSize;
        CGPoint originOffset = self.contentOffset;
        CGPoint contentOffset = originOffset;
        CGSize contentSize = self.contentSize;
        UIEdgeInsets searchBarInsets = self.searchBarInsets;
        UIEdgeInsets refreshViewInsets = self.refreshViewInsets;
        CGFloat duration = 0.0f;
        if(self.bounces == YES) {
            if(self.alwaysBounceHorizontal == YES) {
                if(_bouncesLeft == NO) {
                    contentOffset.x = MAX(0.0f, contentOffset.x);
                }
                if((_bouncesRight == NO) && (contentSize.width > FLT_EPSILON)) {
                    contentOffset.x = MIN(contentSize.width - frameSize.width, contentOffset.x);
                }
            }
            if(self.alwaysBounceVertical == YES) {
                if(_bouncesTop == NO) {
                    contentOffset.y = MAX(0.0f, contentOffset.y);
                }
                if((_bouncesBottom == NO) && (contentSize.height > FLT_EPSILON)) {
                    contentOffset.y = MIN(contentSize.height - frameSize.height, contentOffset.y);
                }
            }
        }
        if((self.directionalLockEnabled == YES) && (dragging == YES)) {
            switch(_scrollDirection) {
                case MobilyDataViewDirectionUnknown: {
                    CGFloat dx = ABS(contentOffset.x - _scrollBeginPosition.x);
                    CGFloat dy = ABS(contentOffset.y - _scrollBeginPosition.y);
                    if(dx > dy) {
                        self.scrollDirection = MobilyDataViewDirectionHorizontal;
                        contentOffset.y = _scrollBeginPosition.y;
                    } else if(dx < dy) {
                        self.scrollDirection = MobilyDataViewDirectionVertical;
                        contentOffset.x = _scrollBeginPosition.x;
                    }
                    break;
                }
                case MobilyDataViewDirectionHorizontal:
                    contentOffset.y = _scrollBeginPosition.y;
                    break;
                case MobilyDataViewDirectionVertical:
                    contentOffset.x = _scrollBeginPosition.x;
                    break;
            }
        }
        if((_searchBarDragging == YES) && (decelerating == NO)) {
            if(_canSearchBar == YES) {
                CGFloat searchBarHeight = _searchBar.frameHeight;
                switch(_searchBarStyle) {
                    case MobilyDataViewSearchBarStyleStatic:
                        break;
                    case MobilyDataViewSearchBarStyleInside: {
                        CGFloat offset = contentOffset.y + searchBarInsets.top;
                        searchBarInsets.top = MAX(0.0f, MIN(searchBarInsets.top - offset, searchBarHeight));
                        if(_showedSearchBar == YES) {
                            _constraintSearchBarTop.constant = -(searchBarHeight - searchBarInsets.top);
                        } else {
                            _constraintSearchBarTop.constant = searchBarInsets.top;
                        }
                        break;
                    }
                    case MobilyDataViewSearchBarStyleOverlay: {
                        CGFloat offset = contentOffset.y;
                        CGFloat diff = offset - _searchBarOverlayLastOffset;
                        if(ABS(diff) > (searchBarHeight * 0.5f)) {
                            if(diff < 0.0f) {
                                searchBarInsets.top = searchBarHeight;
                            } else {
                                searchBarInsets.top = 0.0f;
                            }
                            if(_showedSearchBar == YES) {
                                _constraintSearchBarTop.constant = -(searchBarHeight - searchBarInsets.top);
                            } else {
                                _constraintSearchBarTop.constant = searchBarInsets.top;
                            }
                            self.searchBarOverlayLastOffset = offset;
                            duration = 0.1f;
                        }
                        break;
                    }
                }
            }
        }
        if((_refreshDragging == YES) && (decelerating == NO)) {
            if(_canTopRefresh == YES) {
                CGFloat offset = contentOffset.y + (refreshViewInsets.top + searchBarInsets.top);
                CGFloat progress = MAX(0.0f, refreshViewInsets.top - offset);
                switch(_topRefreshView.state) {
                    case MobilyDataRefreshViewStateIdle:
                        if(progress > 0.0f) {
                            _topRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    case MobilyDataRefreshViewStatePull:
                    case MobilyDataRefreshViewStateRelease:
                        if(progress < 0.0f) {
                            _topRefreshView.state = MobilyDataRefreshViewStateIdle;
                        } else if(progress >= _topRefreshView.threshold) {
                            if(_topRefreshView.state != MobilyDataRefreshViewStateRelease) {
                                _topRefreshView.state = MobilyDataRefreshViewStateRelease;
                            }
                        } else {
                            _topRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    default:
                        break;
                }
                _constraintTopRefreshSize.constant = refreshViewInsets.top = progress;
                refreshViewInsets.bottom = -progress;
            }
            if(_canBottomRefresh == YES) {
                if(contentSize.height >= frameSize.height) {
                    CGFloat limit = contentSize.height - frameSize.height;
                    CGFloat offset = (contentOffset.y - refreshViewInsets.bottom) - limit;
                    CGFloat progress = MAX(0.0f, refreshViewInsets.bottom + offset);
                    switch(_bottomRefreshView.state) {
                        case MobilyDataRefreshViewStateIdle:
                            if(progress > 0.0f) {
                                _bottomRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        case MobilyDataRefreshViewStatePull:
                        case MobilyDataRefreshViewStateRelease:
                            if(progress < 0.0f) {
                                _bottomRefreshView.state = MobilyDataRefreshViewStateIdle;
                            } else if(progress >= _bottomRefreshView.threshold) {
                                if(_bottomRefreshView.state != MobilyDataRefreshViewStateRelease) {
                                    _bottomRefreshView.state = MobilyDataRefreshViewStateRelease;
                                }
                            } else {
                                _bottomRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        default:
                            break;
                    }
                    _constraintBottomRefreshSize.constant = refreshViewInsets.bottom = progress;
                    refreshViewInsets.top = -progress;
                }
            }
            if(_canLeftRefresh == YES) {
                CGFloat offset = contentOffset.x + refreshViewInsets.left;
                CGFloat progress = MAX(0.0f, refreshViewInsets.left - offset);
                switch(_leftRefreshView.state) {
                    case MobilyDataRefreshViewStateIdle:
                        if(progress > 0.0f) {
                            _leftRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    case MobilyDataRefreshViewStatePull:
                    case MobilyDataRefreshViewStateRelease:
                        if(progress < 0.0f) {
                            _leftRefreshView.state = MobilyDataRefreshViewStateIdle;
                        } else if(progress >= _leftRefreshView.threshold) {
                            if(_leftRefreshView.state != MobilyDataRefreshViewStateRelease) {
                                _leftRefreshView.state = MobilyDataRefreshViewStateRelease;
                            }
                        } else {
                            _leftRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    default:
                        break;
                }
                _constraintLeftRefreshSize.constant = refreshViewInsets.left = progress;
                refreshViewInsets.right = -progress;
            }
            if(_canRightRefresh == YES) {
                if(contentSize.width >= frameSize.width) {
                    CGFloat limit = contentSize.width - frameSize.width;
                    CGFloat offset = (contentOffset.x - refreshViewInsets.right) - limit;
                    CGFloat progress = MAX(0.0f, refreshViewInsets.right + offset);
                    switch(_rightRefreshView.state) {
                        case MobilyDataRefreshViewStateIdle:
                            if(progress > 0.0f) {
                                _rightRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        case MobilyDataRefreshViewStatePull:
                        case MobilyDataRefreshViewStateRelease:
                            if(progress < 0.0f) {
                                _rightRefreshView.state = MobilyDataRefreshViewStateIdle;
                            } else if(progress >= _rightRefreshView.threshold) {
                                if(_rightRefreshView.state != MobilyDataRefreshViewStateRelease) {
                                    _rightRefreshView.state = MobilyDataRefreshViewStateRelease;
                                }
                            } else {
                                _rightRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        default:
                            break;
                    }
                    _constraintRightRefreshSize.constant = refreshViewInsets.right = progress;
                    refreshViewInsets.left = -progress;
                }
            }
        }
        if(duration > FLT_EPSILON) {
            [UIView animateWithDuration:duration
                                  delay:0.0f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.searchBarInsets = searchBarInsets;
                                 self.refreshViewInsets = refreshViewInsets;
                                 if((ABS(originOffset.x - contentOffset.x) >= 1.0f) || (ABS(originOffset.y - contentOffset.y) >= 1.0f)) {
                                     self.contentOffset = contentOffset;
                                 }
                                 [self.superview layoutIfNeeded];
                             }
                             completion:nil];
        } else {
            self.searchBarInsets = searchBarInsets;
            self.refreshViewInsets = refreshViewInsets;
            if((ABS(originOffset.x - contentOffset.x) >= 1.0f) || (ABS(originOffset.y - contentOffset.y) >= 1.0f)) {
                self.contentOffset = contentOffset;
            }
        }
    }
    if(_container != nil) {
        [_container _didScrollDragging:dragging decelerating:decelerating];
    }
}

- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if(self.pagingEnabled == NO) {
        if(_searchBarDragging == YES) {
            if(_canSearchBar == YES) {
                CGFloat searchBarHeight = _searchBar.frameHeight;
                switch(_searchBarStyle) {
                    case MobilyDataViewSearchBarStyleStatic:
                        break;
                    case MobilyDataViewSearchBarStyleInside:
                    case MobilyDataViewSearchBarStyleOverlay: {
                        CGFloat offset = MAX(0.0f, MIN(_searchBarInsets.top - (contentOffset->y + _searchBarInsets.top), searchBarHeight));
                        if(contentOffset->y > -searchBarHeight) {
                            contentOffset->y = -searchBarHeight;
                        }
                        if(offset >= (searchBarHeight * 0.33f)) {
                            [self _showSearchBarAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                                self.searchBarDragging = NO;
                            }];
                        } else {
                            [self _hideSearchBarAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                                self.searchBarDragging = NO;
                            }];
                        }
                        break;
                    }
                }
            }
        }
        if(_refreshDragging == YES) {
            if(_canTopRefresh == YES) {
                switch(_topRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        contentOffset->y = -_topRefreshView.size;
                        if([self containsEventForKey:MobilyDataViewTopRefreshTriggered] == YES) {
                            [self _showTopRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewTopRefreshTriggered byObject:_topRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self _hideTopRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    case MobilyDataRefreshViewStatePull: {
                        contentOffset->y = -_topRefreshView.size;
                        [self _hideTopRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                    case MobilyDataRefreshViewStateIdle:
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: {
                        break;
                    }
                }
            }
            if(_canBottomRefresh == YES) {
                switch(_bottomRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewBottomRefreshTriggered] == YES) {
                            [self _showBottomRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewBottomRefreshTriggered byObject:_bottomRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self _hideBottomRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    case MobilyDataRefreshViewStatePull: {
                        [self _hideBottomRefreshAnimated:YES velocity:velocity.y complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                    case MobilyDataRefreshViewStateIdle:
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: {
                        break;
                    }
                }
            }
            if(_canLeftRefresh == YES) {
                switch(_leftRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        contentOffset->x = -_leftRefreshView.size;
                        if([self containsEventForKey:MobilyDataViewLeftRefreshTriggered] == YES) {
                            [self _showLeftRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewLeftRefreshTriggered byObject:_leftRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self _hideLeftRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    case MobilyDataRefreshViewStatePull: {
                        contentOffset->x = -_leftRefreshView.size;
                        [self _hideLeftRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                    case MobilyDataRefreshViewStateIdle:
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: {
                        break;
                    }
                }
            }
            if(_canRightRefresh == YES) {
                switch(_rightRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewRightRefreshTriggered] == YES) {
                            [self _showRightRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewRightRefreshTriggered byObject:_rightRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self _hideRightRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    case MobilyDataRefreshViewStatePull: {
                        [self _hideRightRefreshAnimated:YES velocity:velocity.x complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                    case MobilyDataRefreshViewStateIdle:
                    case MobilyDataRefreshViewStateLoading:
                    case MobilyDataRefreshViewStateDisable: {
                        break;
                    }
                }
            }
        }
    }
    if(_container != nil) {
        [_container _willEndDraggingWithVelocity:velocity contentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
    }
}

- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate {
    if(_container != nil) {
        [_container _didEndDraggingWillDecelerate:decelerate];
    }
}

- (void)_willBeginDecelerating {
    if(_container != nil) {
        [_container _willBeginDecelerating];
    }
}

- (void)_didEndDecelerating {
    if(_container != nil) {
        [_container _didEndDecelerating];
    }
}

- (void)_didEndScrollingAnimation {
    if(_container != nil) {
        [_container _didEndScrollingAnimation];
    }
}

- (void)_showSearchBarAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    _showedSearchBar = YES;
    
    UIEdgeInsets from = self.searchBarInsets;
    UIEdgeInsets to = UIEdgeInsetsMake(_searchBar.frameHeight, from.left, from.bottom, from.right);
    self.constraintSearchBarTop = nil;
    [self _updateSuperviewConstraints];
    
    if(animated == YES) {
        [UIView animateWithDuration:ABS(from.top - to.top) / ABS(velocity)
                              delay:0.01f
                            options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             self.searchBarInsets = to;
                             [self.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
    } else {
        self.searchBarInsets = to;
        if(complete != nil) {
            complete(YES);
        }
    }
}

- (void)_hideSearchBarAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    _showedSearchBar = NO;
    
    UIEdgeInsets from = self.searchBarInsets;
    UIEdgeInsets to = UIEdgeInsetsMake(0.0f, from.left, from.bottom, from.right);
    self.constraintSearchBarTop = nil;
    [self _updateSuperviewConstraints];
    
    if(animated == YES) {
        [UIView animateWithDuration:ABS(from.top - to.top) / ABS(velocity)
                              delay:0.01f
                            options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             self.searchBarInsets = to;
                             [self.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
    } else {
        self.searchBarInsets = to;
        if(complete != nil) {
            complete(YES);
        }
    }
}

- (void)_showTopRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_topRefreshView _showAnimated:animated velocity:velocity complete:complete];
}

- (void)_hideTopRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_topRefreshView _hideAnimated:animated velocity:velocity complete:complete];
}

- (void)_showBottomRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_bottomRefreshView _showAnimated:animated velocity:velocity complete:complete];
}

- (void)_hideBottomRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_bottomRefreshView _hideAnimated:animated velocity:velocity complete:complete];
}

- (void)_showLeftRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_leftRefreshView _showAnimated:animated velocity:velocity complete:complete];
}

- (void)_hideLeftRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_leftRefreshView _hideAnimated:animated velocity:velocity complete:complete];
}

- (void)_showRightRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_rightRefreshView _showAnimated:animated velocity:velocity complete:complete];
}

- (void)_hideRightRefreshAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataViewCompleteBlock)complete {
    [_rightRefreshView _hideAnimated:animated velocity:velocity complete:complete];
}

- (void)_batchUpdate:(MobilyDataViewUpdateBlock)update animated:(BOOL)animated {
    self.updating = YES;
    self.animating = animated;
    [_container _didBeginUpdateAnimated:animated];
    if(update != nil) {
        update();
    }
    [self validateLayoutIfNeed];
    [self _layoutForVisible];
    if(_reloadedBeforeItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateReplaceOut] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateReplaceOut byObject:_reloadedBeforeItems];
        } else {
            for(MobilyDataItem* item in _reloadedBeforeItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = -1.0f;
                    cell.alpha = 0.0f;
                }
            }
        }
    }
    if(_reloadedAfterItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateReplaceIn] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateReplaceIn byObject:_reloadedAfterItems];
        } else {
            for(MobilyDataItem* item in _reloadedAfterItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    [UIView performWithoutAnimation:^{
                        cell.alpha = 0.0f;
                    }];
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
            }
        }
        [_reloadedAfterItems removeAllObjects];
    }
    if(_insertedItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateInsert] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateInsert byObject:_insertedItems];
        } else {
            for(MobilyDataItem* item in _insertedItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    [UIView performWithoutAnimation:^{
                        cell.alpha = 0.0f;
                    }];
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
            }
        }
        [_insertedItems removeAllObjects];
    }
    if(_deletedItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateDelete] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateDelete byObject:_deletedItems];
        } else {
            for(MobilyDataItem* item in _deletedItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = -1.0f;
                    cell.alpha = 0.0f;
                }
            }
        }
    }
}

- (void)_batchComplete:(MobilyDataViewUpdateBlock)complete animated:(BOOL)animated {
    if(_reloadedBeforeItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateRestore] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateRestore byObject:_reloadedBeforeItems];
            for(MobilyDataItem* item in _reloadedBeforeItems) {
                [self _disappearItem:item];
            }
        } else {
            for(MobilyDataItem* item in _reloadedBeforeItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
                [self _disappearItem:item];
            }
        }
        [_reloadedBeforeItems removeAllObjects];
    }
    if(_deletedItems.count > 0) {
        if([self containsEventForKey:MobilyDataViewAnimateRestore] == YES) {
            [self fireEventForKey:MobilyDataViewAnimateRestore byObject:_deletedItems];
            for(MobilyDataItem* item in _deletedItems) {
                [self _disappearItem:item];
            }
        } else {
            for(MobilyDataItem* item in _deletedItems) {
                MobilyDataCell* cell = item.cell;
                if(cell != nil) {
                    cell.zPosition = 0.0f;
                    cell.alpha = 1.0f;
                }
                [self _disappearItem:item];
            }
        }
        [_deletedItems removeAllObjects];
    }
    [_container _didEndUpdateAnimated:animated];
    self.animating = NO;
    self.updating = NO;
    [self _layoutForVisible];
    
    if(complete != nil) {
        complete();
    }
}

#pragma mark MobilySearchBarDelegate

- (void)searchBarBeginSearch:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchBegin byObject:nil];
    [_container searchBarBeginSearch:searchBar];
}

- (void)searchBarEndSearch:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchEnd byObject:nil];
    [_container searchBarEndSearch:searchBar];
}

- (void)searchBarBeginEditing:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchBeginEditing byObject:nil];
    [_container searchBarBeginEditing:searchBar];
}

- (void)searchBar:(MobilySearchBar*)searchBar textChanged:(NSString*)textChanged {
    [self fireEventForKey:MobilyDataViewSearchTextChanged byObject:textChanged];
    [_container searchBar:searchBar textChanged:textChanged];
}

- (void)searchBarEndEditing:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchEndEditing byObject:nil];
    [_container searchBarEndEditing:searchBar];
}

- (void)searchBarPressedClear:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchPressedClear byObject:nil];
    [_container searchBarPressedClear:searchBar];
}

- (void)searchBarPressedReturn:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchPressedReturn byObject:nil];
    [_container searchBarPressedReturn:searchBar];
}

- (void)searchBarPressedCancel:(MobilySearchBar*)searchBar {
    [self fireEventForKey:MobilyDataViewSearchPressedCancel byObject:nil];
    [_container searchBarPressedCancel:searchBar];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataContentView

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataViewDelegateProxy

#pragma mark Init / Free

- (instancetype)initWithDataView:(MobilyDataView*)view {
    self = [super init];
    if(self != nil) {
        self.view = view;
    }
    return self;
}

- (void)dealloc {
    self.view = nil;
    self.delegate = nil;
}

#pragma mark NSObject

- (BOOL)respondsToSelector:(SEL)selector {
    return (([_delegate respondsToSelector:selector] == YES) || ([super respondsToSelector:selector] == YES));
}

- (void)forwardInvocation:(NSInvocation*)invocation {
    [invocation invokeWithTarget:_delegate];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    [_view _willBeginDragging];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [_view _didScrollDragging:_view.dragging decelerating:_view.decelerating];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    CGFloat vx = (ABS(velocity.x) > FLT_EPSILON) ? (velocity.x * 1000.0f) : _view.velocity;
    CGFloat vy = (ABS(velocity.y) > FLT_EPSILON) ? (velocity.y * 1000.0f) : _view.velocity;
    CGFloat nvx = MAX(_view.velocityMin, MIN(ABS(vx), _view.velocityMax));
    CGFloat nvy = MAX(_view.velocityMin, MIN(ABS(vy), _view.velocityMax));
    [_view _willEndDraggingWithVelocity:CGPointMake((vx > FLT_EPSILON) ? nvx : -nvx, (vy > FLT_EPSILON) ? nvy : -nvy) contentOffset:targetContentOffset contentSize:scrollView.contentSize visibleSize:_view.boundsSize];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [_view _didEndDraggingWillDecelerate:decelerate];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView*)scrollView {
    [_view _willBeginDecelerating];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    [_view _didEndDecelerating];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView {
    [_view _didEndScrollingAnimation];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

NSString* MobilyDataViewSelectItem = @"MobilyDataViewSelectItem";
NSString* MobilyDataViewDeselectItem = @"MobilyDataViewDeselectItem";

/*--------------------------------------------------*/

NSString* MobilyDataViewSearchBegin = @"MobilyDataViewSearchBegin";
NSString* MobilyDataViewSearchEnd = @"MobilyDataViewSearchEnd";
NSString* MobilyDataViewSearchBeginEditing = @"MobilyDataViewSearchBeginEditing";
NSString* MobilyDataViewSearchTextChanged = @"MobilyDataViewSearchTextChanged";
NSString* MobilyDataViewSearchEndEditing = @"MobilyDataViewSearchEndEditing";
NSString* MobilyDataViewSearchPressedClear = @"MobilyDataViewSearchPressedClear";
NSString* MobilyDataViewSearchPressedReturn = @"MobilyDataViewSearchPressedReturn";
NSString* MobilyDataViewSearchPressedCancel = @"MobilyDataViewSearchPressedCancel";

/*--------------------------------------------------*/

NSString* MobilyDataViewTopRefreshTriggered = @"MobilyDataViewTopRefreshTriggered";
NSString* MobilyDataViewBottomRefreshTriggered = @"MobilyDataViewBottomRefreshTriggered";
NSString* MobilyDataViewLeftRefreshTriggered = @"MobilyDataViewLeftRefreshTriggered";
NSString* MobilyDataViewRightRefreshTriggered = @"MobilyDataViewRightRefreshTriggered";

/*--------------------------------------------------*/

NSString* MobilyDataViewAnimateRestore = @"MobilyDataViewAnimateRestore";
NSString* MobilyDataViewAnimateInsert = @"MobilyDataViewAnimateInsert";
NSString* MobilyDataViewAnimateDelete = @"MobilyDataViewAnimateDelete";
NSString* MobilyDataViewAnimateReplaceOut = @"MobilyDataViewAnimateReplaceOut";
NSString* MobilyDataViewAnimateReplaceIn = @"MobilyDataViewAnimateReplaceIn";

/*--------------------------------------------------*/
