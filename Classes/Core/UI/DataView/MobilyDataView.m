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

#import "MobilyDataView+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize delegateProxy = _delegateProxy;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize allowsEditing = _allowsEditing;
@synthesize allowsMultipleEditing = _allowsMultipleEditing;
@synthesize bouncesTop = _bouncesTop;
@synthesize bouncesLeft = _bouncesLeft;
@synthesize bouncesRight = _bouncesRight;
@synthesize bouncesBottom = _bouncesBottom;
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
@synthesize updating = _updating;
@synthesize invalidLayout = _invalidLayout;
@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize pullToRefreshHeight = _pullToRefreshHeight;
@synthesize constraintPullToRefreshBottom = _constraintPullToRefreshBottom;
@synthesize constraintPullToRefreshLeft = _constraintPullToRefreshLeft;
@synthesize constraintPullToRefreshRight = _constraintPullToRefreshRight;
@synthesize constraintPullToRefreshHeight = _constraintPullToRefreshHeight;
@synthesize pullToLoadView = _pullToLoadView;
@synthesize pullToLoadHeight = _pullToLoadHeight;
@synthesize constraintPullToLoadTop = _constraintPullToLoadTop;
@synthesize constraintPullToLoadLeft = _constraintPullToLoadLeft;
@synthesize constraintPullToLoadRight = _constraintPullToLoadRight;
@synthesize constraintPullToLoadHeight = _constraintPullToLoadHeight;
@synthesize pullDragging = _pullDragging;
@synthesize canPullToRefresh = _canPullToRefresh;
@synthesize canPullToLoad = _canPullToLoad;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        self.delegateProxy = [MobilyDataViewDelegateProxy new];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.delegateProxy = [MobilyDataViewDelegateProxy new];
        [self setup];
    }
    return self;
}

- (void)setup {
    _bouncesTop = YES;
    _bouncesLeft = YES;
    _bouncesRight = YES;
    _bouncesBottom = YES;
    
    _allowsSelection = YES;
    _allowsMultipleSelection = YES;
    _allowsEditing = YES;
    _allowsMultipleEditing = YES;
    
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
    
    _pullToRefreshHeight = -1.0f;
    _pullToLoadHeight = -1.0f;
    
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
    super.frame = frame;
    if(CGSizeEqualToSize(prev.size, frame.size) == NO) {
        [self setNeedValidateLayout];
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect prev = self.bounds;
    super.bounds = bounds;
    if(CGSizeEqualToSize(prev.size, bounds.size) == NO) {
        [self setNeedValidateLayout];
    }
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

- (void)setPullToRefreshView:(MobilyDataRefreshView*)pullToRefreshView {
    if(_pullToRefreshView != pullToRefreshView) {
        if(_pullToRefreshView != nil) {
            self.constraintPullToRefreshBottom = nil;
            self.constraintPullToRefreshLeft = nil;
            self.constraintPullToRefreshRight = nil;
            self.constraintPullToRefreshHeight = nil;
            [_pullToRefreshView removeFromSuperview];
        }
        _pullToRefreshView = pullToRefreshView;
        if(_pullToRefreshView != nil) {
            _pullToRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_pullToRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintPullToRefreshBottom:(NSLayoutConstraint*)constraintPullToRefreshBottom {
    if(_constraintPullToRefreshBottom != constraintPullToRefreshBottom) {
        if(_constraintPullToRefreshBottom != nil) {
            [self.superview removeConstraint:_constraintPullToRefreshBottom];
        }
        _constraintPullToRefreshBottom = constraintPullToRefreshBottom;
        if(_constraintPullToRefreshBottom != nil) {
            [self.superview addConstraint:_constraintPullToRefreshBottom];
        }
    }
}

- (void)setConstraintPullToRefreshLeft:(NSLayoutConstraint*)constraintPullToRefreshLeft {
    if(_constraintPullToRefreshLeft != constraintPullToRefreshLeft) {
        if(_constraintPullToRefreshLeft != nil) {
            [self.superview removeConstraint:_constraintPullToRefreshLeft];
        }
        _constraintPullToRefreshLeft = constraintPullToRefreshLeft;
        if(_constraintPullToRefreshLeft != nil) {
            [self.superview addConstraint:_constraintPullToRefreshLeft];
        }
    }
}

- (void)setConstraintPullToRefreshRight:(NSLayoutConstraint*)constraintPullToRefreshRight {
    if(_constraintPullToRefreshRight != constraintPullToRefreshRight) {
        if(_constraintPullToRefreshRight != nil) {
            [self.superview removeConstraint:_constraintPullToRefreshRight];
        }
        _constraintPullToRefreshRight = constraintPullToRefreshRight;
        if(_constraintPullToRefreshRight != nil) {
            [self.superview addConstraint:_constraintPullToRefreshRight];
        }
    }
}

- (void)setConstraintPullToRefreshHeight:(NSLayoutConstraint*)constraintPullToRefreshHeight {
    if(_constraintPullToRefreshHeight != constraintPullToRefreshHeight) {
        if(_constraintPullToRefreshHeight != nil) {
            [self.superview removeConstraint:_constraintPullToRefreshHeight];
        }
        _constraintPullToRefreshHeight = constraintPullToRefreshHeight;
        if(_constraintPullToRefreshHeight != nil) {
            [self.superview addConstraint:_constraintPullToRefreshHeight];
        }
    }
}

- (void)setPullToRefreshHeight:(CGFloat)pullToRefreshHeight {
    if(_pullToRefreshHeight != pullToRefreshHeight) {
        _pullToRefreshHeight = pullToRefreshHeight;
        if(_pullToRefreshHeight < 0.0f) {
            self.constraintPullToRefreshHeight = nil;
        } else if(_constraintPullToRefreshHeight != nil) {
            _constraintPullToRefreshHeight.constant = _pullToRefreshHeight;
        } else if(self.superview != nil) {
            [self _updateSuperviewConstraints];
        }
    }
}

- (void)setPullToLoadView:(MobilyDataRefreshView*)pullToLoadView {
    if(_pullToLoadView != pullToLoadView) {
        if(_pullToLoadView != nil) {
            self.constraintPullToLoadTop = nil;
            self.constraintPullToLoadLeft = nil;
            self.constraintPullToLoadRight = nil;
            self.constraintPullToLoadHeight = nil;
            [_pullToLoadView removeFromSuperview];
        }
        _pullToLoadView = pullToLoadView;
        if(_pullToLoadView != nil) {
            _pullToLoadView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_pullToLoadView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintPullToLoadTop:(NSLayoutConstraint*)constraintPullToLoadTop {
    if(_constraintPullToLoadTop != constraintPullToLoadTop) {
        if(_constraintPullToLoadTop != nil) {
            [self.superview removeConstraint:_constraintPullToLoadTop];
        }
        _constraintPullToLoadTop = constraintPullToLoadTop;
        if(_constraintPullToLoadTop != nil) {
            [self.superview addConstraint:_constraintPullToLoadTop];
        }
    }
}

- (void)setConstraintPullToLoadLeft:(NSLayoutConstraint*)constraintPullToLoadLeft {
    if(_constraintPullToLoadLeft != constraintPullToLoadLeft) {
        if(_constraintPullToLoadLeft != nil) {
            [self.superview removeConstraint:_constraintPullToLoadLeft];
        }
        _constraintPullToLoadLeft = constraintPullToLoadLeft;
        if(_constraintPullToLoadLeft != nil) {
            [self.superview addConstraint:_constraintPullToLoadLeft];
        }
    }
}

- (void)setConstraintPullToLoadRight:(NSLayoutConstraint*)constraintPullToLoadRight {
    if(_constraintPullToLoadRight != constraintPullToLoadRight) {
        if(_constraintPullToLoadRight != nil) {
            [self.superview removeConstraint:_constraintPullToLoadRight];
        }
        _constraintPullToLoadRight = constraintPullToLoadRight;
        if(_constraintPullToLoadRight != nil) {
            [self.superview addConstraint:_constraintPullToLoadRight];
        }
    }
}

- (void)setConstraintPullToLoadHeight:(NSLayoutConstraint*)constraintPullToLoadHeight {
    if(_constraintPullToLoadHeight != constraintPullToLoadHeight) {
        if(_constraintPullToLoadHeight != nil) {
            [self.superview removeConstraint:_constraintPullToLoadHeight];
        }
        _constraintPullToLoadHeight = constraintPullToLoadHeight;
        if(_constraintPullToLoadHeight != nil) {
            [self.superview addConstraint:_constraintPullToLoadHeight];
        }
    }
}

- (void)setPullToLoadHeight:(CGFloat)pullToLoadHeight {
    if(_pullToLoadHeight != pullToLoadHeight) {
        _pullToLoadHeight = pullToLoadHeight;
        if(_pullToLoadHeight < 0.0f) {
            self.constraintPullToLoadHeight = nil;
        } else if(_constraintPullToLoadHeight != nil) {
            _constraintPullToLoadHeight.constant = _pullToLoadHeight;
        } else if(self.superview != nil) {
            [self _updateSuperviewConstraints];
        }
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
                __block NSUInteger viewIndex = NSNotFound;
                [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
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
                    [self insertSubview:cell atIndex:viewIndex + 1];
                } else {
                    [self insertSubview:cell atIndex:0];
                }
                // NSLog(@"%@", self.subviews);
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
        return item.allowsSelection;
    }
    return _allowsSelection;
}

- (BOOL)shouldDeselectItem:(MobilyDataItem* __unused)item {
    return YES;
}

- (void)selectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_selectedItems containsObject:item] == NO) {
        if([self shouldSelectItem:item] == YES) {
            if(_allowsMultipleSelection == YES) {
                [_selectedItems addObject:item];
                [item setSelected:YES animated:animated];
            } else {
                if(_selectedItems.count > 0) {
                    for(MobilyDataItem* item in _selectedItems) {
                        [item setSelected:NO animated:animated];
                    }
                    [_selectedItems removeAllObjects];
                }
                [_selectedItems addObject:item];
                [item setSelected:YES animated:animated];
            }
        }
    }
}

- (void)deselectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([_selectedItems containsObject:item] == YES) {
        if([self shouldDeselectItem:item] == YES) {
            [_selectedItems removeObject:item];
            [item setSelected:NO animated:animated];
        }
    }
}

- (void)deselectAllItemsAnimated:(BOOL)animated {
    if(_selectedItems.count > 0) {
        [_selectedItems each:^(MobilyDataItem* item) {
            if([self shouldDeselectItem:item] == YES) {
                [_selectedItems removeObject:item];
                [item setSelected:NO animated:animated];
            }
        }];
    }
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
                    for(MobilyDataItem* item in _editingItems) {
                        [item setEditing:NO animated:animated];
                    }
                    [_editingItems removeAllObjects];
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
                            options:0
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
    [self validateLayoutIfNeed];
    [self scrollToRect:[item updateFrame] scrollPosition:scrollPosition animated:animated];
}

- (void)scrollToRect:(CGRect)rect scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated {
    NSUInteger vPosition = scrollPosition & (MobilyDataViewPositionTop | MobilyDataViewPositionCenteredVertically | MobilyDataViewPositionBottom);
    NSUInteger hPosition = scrollPosition & (MobilyDataViewPositionLeft | MobilyDataViewPositionCenteredHorizontally | MobilyDataViewPositionRight);
    CGRect viewport = self.visibleBounds;
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

- (void)showPullToRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_pullToRefreshView.state == MobilyDataRefreshViewStateRelease) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.top = (_pullToRefreshHeight < 0.0f) ? _pullToRefreshView.frameHeight : _pullToRefreshHeight;
        _constraintPullToRefreshBottom.constant = contentInset.top;
        _pullToRefreshView.state = MobilyDataRefreshViewStateLoading;
        if(animated == YES) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.scrollIndicatorInsets = self.contentInset = contentInset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.contentInset = self.scrollIndicatorInsets = contentInset;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hidePullToRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_pullToRefreshView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.top = 0.0f;
        _constraintPullToRefreshBottom.constant = contentInset.top;
        if(animated == YES) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = contentInset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.contentInset = self.scrollIndicatorInsets = contentInset;
                                 _pullToRefreshView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            _pullToRefreshView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)showPullToLoadAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_pullToLoadView.state == MobilyDataRefreshViewStateRelease) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.bottom = (_pullToLoadHeight < 0.0f) ? _pullToLoadView.frameHeight : _pullToLoadHeight;
        _constraintPullToLoadTop.constant = -contentInset.bottom;
        _pullToLoadView.state = MobilyDataRefreshViewStateLoading;
        if(animated == YES) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.scrollIndicatorInsets = self.contentInset = contentInset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.contentInset = self.scrollIndicatorInsets = contentInset;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hidePullToLoadAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_pullToLoadView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.bottom = 0.0f;
        _constraintPullToLoadTop.constant = contentInset.bottom;
        if(animated == YES) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.scrollIndicatorInsets = self.contentInset = contentInset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 self.contentInset = self.scrollIndicatorInsets = contentInset;
                                 _pullToLoadView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            _pullToLoadView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

#pragma mark Private

- (void)_receiveMemoryWarning {
    for(MobilyDataCell* cell in _queueCells) {
        [cell removeFromSuperview];
    }
    [_queueCells removeAllObjects];
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
        for(MobilyDataItem* item in items) {
            MobilyDataCell* cell = item.cell;
            if(cell != nil) {
                [cell animateAction:MobilyDataCellActionRestore];
            }
            [self _disappearItem:item];
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
        for(MobilyDataItem* item in originItems) {
            MobilyDataCell* cell = item.cell;
            if(cell != nil) {
                [cell animateAction:MobilyDataCellActionRestore];
            }
            [self _disappearItem:item];
        }
    }
    [self setNeedValidateLayout];
}

- (void)_validateLayout {
    CGRect layoutRect = CGRectZero;
    if(_container != nil) {
        layoutRect = [_container _validateLayoutForAvailableFrame:CGRectMakeOriginAndSize(CGPointZero, self.boundsSize)];
    }
    self.contentSize = layoutRect.size;
}

- (void)_layoutForVisible {
    CGRect bounds = self.bounds;
    [_container _willLayoutForBounds:self.visibleBounds];
    if(_updating == NO) {
        [_visibleItems enumerateObjectsUsingBlock:^(MobilyDataItem* item, NSUInteger itemIndex __unused, BOOL* itemStop __unused) {
            [item invalidateLayoutForBounds:bounds];
        }];
    }
    [_container _didLayoutForBounds:bounds];
}

- (void)_updateSuperviewConstraints {
    if(_pullToRefreshView != nil) {
        if(_constraintPullToRefreshBottom == nil) {
            self.constraintPullToRefreshBottom = [NSLayoutConstraint constraintWithItem:_pullToRefreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
        }
        if(_constraintPullToRefreshLeft == nil) {
            self.constraintPullToRefreshLeft = [NSLayoutConstraint constraintWithItem:_pullToRefreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        }
        if(_constraintPullToRefreshRight == nil) {
            self.constraintPullToRefreshRight = [NSLayoutConstraint constraintWithItem:_pullToRefreshView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        if(_pullToRefreshHeight >= 0.0f) {
            if(_constraintPullToRefreshHeight == nil) {
                self.constraintPullToRefreshHeight = [NSLayoutConstraint constraintWithItem:_pullToRefreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_pullToRefreshHeight];
            }
        } else {
            self.constraintPullToRefreshHeight = nil;
        }
    } else {
        self.constraintPullToRefreshBottom = nil;
        self.constraintPullToRefreshLeft = nil;
        self.constraintPullToRefreshRight = nil;
        self.constraintPullToRefreshHeight = nil;
    }
    if(_pullToLoadView != nil) {
        if(_constraintPullToLoadTop == nil) {
            self.constraintPullToLoadTop = [NSLayoutConstraint constraintWithItem:_pullToLoadView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        }
        if(_constraintPullToLoadLeft == nil) {
            self.constraintPullToLoadLeft = [NSLayoutConstraint constraintWithItem:_pullToLoadView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        }
        if(_constraintPullToLoadRight == nil) {
            self.constraintPullToLoadRight = [NSLayoutConstraint constraintWithItem:_pullToLoadView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        }
        if(_pullToLoadHeight >= 0.0f) {
            if(_constraintPullToLoadHeight == nil) {
                self.constraintPullToLoadHeight = [NSLayoutConstraint constraintWithItem:_pullToLoadView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_pullToLoadHeight];
            }
        } else {
            self.constraintPullToLoadHeight = nil;
        }
    } else {
        self.constraintPullToLoadTop = nil;
        self.constraintPullToLoadLeft = nil;
        self.constraintPullToLoadRight = nil;
        self.constraintPullToLoadHeight = nil;
    }
}

- (void)_willBeginDragging {
    if(self.pagingEnabled == NO) {
        if(_pullToRefreshView != nil) {
            self.canPullToRefresh = ([_pullToRefreshView state] != MobilyDataRefreshViewStateLoading);
        } else {
            self.canPullToRefresh = NO;
        }
        if(_pullToLoadView != nil) {
            self.canPullToLoad = ([_pullToLoadView state] != MobilyDataRefreshViewStateLoading);
        } else {
            self.canPullToLoad = NO;
        }
        if((_canPullToRefresh == YES) || (_canPullToLoad == YES)) {
            self.pullDragging = YES;
        } else {
            self.pullDragging = NO;
        }
    }
    if(_container != nil) {
        [_container _willBeginDragging];
    }
}

- (void)_didScroll {
    if(self.pagingEnabled == NO) {
        CGRect bounds = self.bounds;
        CGSize frameSize = self.frameSize;
        CGSize contentSize = self.contentSize;
        CGPoint contentOffset = self.contentOffset;
        UIEdgeInsets contentInset = self.contentInset;
        if(self.bounces == YES) {
            if(self.alwaysBounceHorizontal == YES) {
                if(_bouncesLeft == NO) {
                    contentOffset.x = MAX(0.0f, contentOffset.x);
                }
                if(_bouncesRight == NO) {
                    contentOffset.x = MIN(contentSize.width - frameSize.width, contentOffset.x);
                }
            }
            if(self.alwaysBounceVertical == YES) {
                if(_bouncesTop == NO) {
                    contentOffset.y = MAX(0.0f, contentOffset.y);
                }
                if(_bouncesBottom == NO) {
                    contentOffset.y = MIN(contentSize.height - frameSize.height, contentOffset.y);
                }
            }
        }
        if((_pullDragging == YES) && (self.isDragging == YES) && (self.isDecelerating == NO)) {
            if(_canPullToRefresh == YES) {
                CGFloat pullToRefreshSize = (_pullToRefreshHeight < 0.0f) ? _pullToRefreshView.frameHeight : _pullToRefreshHeight;
                CGFloat offset = MIN(pullToRefreshSize, -contentOffset.y);
                switch(_pullToRefreshView.state) {
                    case MobilyDataRefreshViewStateIdle:
                        if(offset > 0.0f) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = 0.0f;
                            }
                            _pullToRefreshView.state = MobilyDataRefreshViewStatePull;
                            contentInset.top = 0.0f;
                        }
                        break;
                    case MobilyDataRefreshViewStatePull:
                    case MobilyDataRefreshViewStateRelease:
                        if(offset < 0.0f) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = 0.0f;
                            }
                            _pullToRefreshView.state = MobilyDataRefreshViewStateIdle;
                            contentInset.top = 0.0f;
                        } else if(offset >= pullToRefreshSize) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = pullToRefreshSize;
                            }
                            if(_pullToRefreshView.state != MobilyDataRefreshViewStateRelease) {
                                _pullToRefreshView.state = MobilyDataRefreshViewStateRelease;
                                contentInset.top = offset;
                            }
                        } else {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = offset;
                            }
                            _pullToRefreshView.state = MobilyDataRefreshViewStatePull;
                            contentInset.top = offset;
                        }
                        break;
                    default:
                        break;
                }
            }
            if((_canPullToLoad == YES) && (contentSize.height > frameSize.height)) {
                CGFloat contentBottom = contentSize.height - bounds.size.height;
                CGFloat pullToLoadSize = (_pullToLoadHeight < 0.0f) ? _pullToLoadView.frameHeight : _pullToLoadHeight;
                if(contentOffset.y >= contentBottom) {
                    CGFloat offset = MIN(pullToLoadSize, contentOffset.y - contentBottom);
                    switch(_pullToLoadView.state) {
                        case MobilyDataRefreshViewStateIdle:
                            if(offset > 0.0f) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -offset;
                                }
                                _pullToLoadView.state = MobilyDataRefreshViewStatePull;
                                contentInset.bottom = offset;
                            }
                            break;
                        case MobilyDataRefreshViewStatePull:
                        case MobilyDataRefreshViewStateRelease:
                            if(offset < 0.0f) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = 0.0f;
                                }
                                _pullToLoadView.state = MobilyDataRefreshViewStateIdle;
                                contentInset.bottom = 0.0f;
                            } else if(offset >= pullToLoadSize) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -pullToLoadSize;
                                }
                                if(_pullToLoadView.state != MobilyDataRefreshViewStateRelease) {
                                    _pullToLoadView.state = MobilyDataRefreshViewStateRelease;
                                    contentInset.bottom = offset;
                                }
                            } else {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -offset;
                                }
                                _pullToLoadView.state = MobilyDataRefreshViewStatePull;
                                contentInset.bottom = offset;
                            }
                            break;
                        default:
                            break;
                    }
                } else {
                    if(_constraintPullToLoadTop != nil) {
                        _constraintPullToLoadTop.constant = 0.0f;
                    }
                    _pullToLoadView.state = MobilyDataRefreshViewStateIdle;
                    contentInset.bottom = 0.0f;
                }
            }
        }
        self.scrollIndicatorInsets = contentInset;
        self.contentInset = contentInset;
        self.contentOffset = contentOffset;
    }
    if(_container != nil) {
        [_container _didScroll];
    }
}

- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize visibleInsets:(UIEdgeInsets)visibleInsets {
    if(_container != nil) {
        [_container _willEndDraggingWithVelocity:velocity contentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize visibleInsets:visibleInsets];
        contentOffset->x = MAX(visibleInsets.left, MIN(contentOffset->x, contentSize.width - (visibleSize.width - (visibleInsets.left + visibleInsets.right))));
        contentOffset->y = MAX(visibleInsets.top, MIN(contentOffset->y, contentSize.height - (visibleSize.height - (visibleInsets.top + visibleInsets.bottom))));
    }
}

- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate {
    if(self.pagingEnabled == NO) {
        if(_pullDragging == YES) {
            if(_canPullToRefresh == YES) {
                switch(_pullToRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewPullToRefreshTriggered] == YES) {
                            [self showPullToRefreshAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewPullToRefreshTriggered byObject:_pullToRefreshView];
                            }];
                        } else {
                            [self hidePullToRefreshAnimated:YES complete:nil];
                        }
                        break;
                    }
                    default: {
                        [self hidePullToRefreshAnimated:YES complete:nil];
                        break;
                    }
                }
            }
            if(_canPullToLoad == YES) {
                switch(_pullToLoadView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewPullToLoadTriggered] == YES) {
                            [self showPullToLoadAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewPullToLoadTriggered byObject:_pullToLoadView];
                            }];
                        } else {
                            [self hidePullToLoadAnimated:YES complete:nil];
                        }
                        break;
                    }
                    default: {
                        [self hidePullToLoadAnimated:YES complete:nil];
                        break;
                    }
                }
            }
            self.pullDragging = NO;
        }
    }
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

- (void)_batchUpdate:(MobilyDataViewUpdateBlock)update animated:(BOOL)animated {
    self.updating = YES;
    [_container _didBeginUpdateAnimated:animated];
    if(update != nil) {
        update();
    }
    [self validateLayoutIfNeed];
    [self _layoutForVisible];
    for(MobilyDataItem* item in _reloadedBeforeItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [cell animateAction:MobilyDataCellActionReplaceOut];
        }
    }
    for(MobilyDataItem* item in _reloadedAfterItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [cell animateAction:MobilyDataCellActionReplaceIn];
        }
    }
    for(MobilyDataItem* item in _insertedItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [cell animateAction:MobilyDataCellActionInsert];
        }
    }
    for(MobilyDataItem* item in _deletedItems) {
        MobilyDataCell* cell = item.cell;
        if(cell != nil) {
            [cell animateAction:MobilyDataCellActionDelete];
        }
    }
}

- (void)_batchComplete:(MobilyDataViewUpdateBlock)complete animated:(BOOL)animated {
    if(_reloadedBeforeItems.count > 0) {
        for(MobilyDataItem* item in _reloadedBeforeItems) {
            MobilyDataCell* cell = item.cell;
            if(cell != nil) {
                [cell animateAction:MobilyDataCellActionRestore];
            }
            [self _disappearItem:item];
        }
        [_reloadedBeforeItems removeAllObjects];
    }
    if(_reloadedAfterItems.count > 0) {
        [_reloadedAfterItems removeAllObjects];
    }
    if(_insertedItems.count > 0) {
        [_insertedItems removeAllObjects];
    }
    if(_deletedItems.count > 0) {
        for(MobilyDataItem* item in _deletedItems) {
            MobilyDataCell* cell = item.cell;
            if(cell != nil) {
                [cell animateAction:MobilyDataCellActionRestore];
            }
            [self _disappearItem:item];
        }
        [_deletedItems removeAllObjects];
    }
    [_container _didEndUpdateAnimated:animated];
    self.updating = NO;
    [self _layoutForVisible];
    
    if(complete != nil) {
        complete();
    }
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
    [_view _didScroll];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    [_view _willEndDraggingWithVelocity:velocity contentOffset:targetContentOffset contentSize:scrollView.contentSize visibleSize:_view.boundsSize visibleInsets:UIEdgeInsetsZero];
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

NSString* MobilyDataViewPullToRefreshTriggered = @"MobilyDataViewPullToRefreshTriggered";
NSString* MobilyDataViewPullToLoadTriggered = @"MobilyDataViewPullToLoadTriggered";

/*--------------------------------------------------*/
