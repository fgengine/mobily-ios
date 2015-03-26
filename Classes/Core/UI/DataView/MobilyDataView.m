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
@synthesize allowsOnceSelection = _allowsOnceSelection;
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
@synthesize animating = _animating;
@synthesize updating = _updating;
@synthesize invalidLayout = _invalidLayout;
@synthesize topRefreshView = _topRefreshView;
@synthesize topRefreshThreshold = _topRefreshThreshold;
@synthesize topRefreshVelocity = _topRefreshVelocity;
@synthesize constraintTopRefreshBottom = _constraintTopRefreshBottom;
@synthesize constraintTopRefreshLeft = _constraintTopRefreshLeft;
@synthesize constraintTopRefreshRight = _constraintTopRefreshRight;
@synthesize constraintTopRefreshSize = _constraintTopRefreshSize;
@synthesize bottomRefreshView = _bottomRefreshView;
@synthesize bottomRefreshThreshold = _bottomRefreshThreshold;
@synthesize bottomRefreshVelocity = _bottomRefreshVelocity;
@synthesize constraintBottomRefreshTop = _constraintBottomRefreshTop;
@synthesize constraintBottomRefreshLeft = _constraintBottomRefreshLeft;
@synthesize constraintBottomRefreshRight = _constraintBottomRefreshRight;
@synthesize constraintBottomRefreshSize = _constraintBottomRefreshSize;
@synthesize leftRefreshView = _leftRefreshView;
@synthesize leftRefreshThreshold = _leftRefreshThreshold;
@synthesize leftRefreshVelocity = _leftRefreshVelocity;
@synthesize constraintLeftRefreshTop = _constraintLeftRefreshTop;
@synthesize constraintLeftRefreshBottom = _constraintLeftRefreshBottom;
@synthesize constraintLeftRefreshLeft = _constraintLeftRefreshLeft;
@synthesize constraintLeftRefreshSize = _constraintLeftRefreshSize;
@synthesize rightRefreshView = _rightRefreshView;
@synthesize rightRefreshThreshold = _rightRefreshThreshold;
@synthesize rightRefreshVelocity = _rightRefreshVelocity;
@synthesize constraintRightRefreshTop = _constraintRightRefreshTop;
@synthesize constraintRightRefreshBottom = _constraintRightRefreshBottom;
@synthesize constraintRightRefreshRight = _constraintRightRefreshRight;
@synthesize constraintRightRefreshSize = _constraintRightRefreshSize;
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
    
    _topRefreshThreshold = 64.0f;
    _topRefreshVelocity = 240.0f;
    _bottomRefreshThreshold = 64.0f;
    _bottomRefreshVelocity = 240.0f;
    _leftRefreshThreshold = 64.0f;
    _leftRefreshVelocity = 240.0f;
    _rightRefreshThreshold = 64.0f;
    _rightRefreshVelocity = 240.0f;
    
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

- (void)setTopRefreshView:(MobilyDataRefreshView*)topRefreshView {
    if(_topRefreshView != topRefreshView) {
        if(_topRefreshView != nil) {
            self.constraintTopRefreshBottom = nil;
            self.constraintTopRefreshLeft = nil;
            self.constraintTopRefreshRight = nil;
            self.constraintTopRefreshSize = nil;
            [_topRefreshView removeFromSuperview];
        }
        _topRefreshView = topRefreshView;
        if(_topRefreshView != nil) {
            _topRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_topRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintTopRefreshBottom:(NSLayoutConstraint*)constraintTopRefreshBottom {
    if(_constraintTopRefreshBottom != constraintTopRefreshBottom) {
        if(_constraintTopRefreshBottom != nil) {
            [self.superview removeConstraint:_constraintTopRefreshBottom];
        }
        _constraintTopRefreshBottom = constraintTopRefreshBottom;
        if(_constraintTopRefreshBottom != nil) {
            [self.superview addConstraint:_constraintTopRefreshBottom];
        }
    }
}

- (void)setConstraintTopRefreshLeft:(NSLayoutConstraint*)constraintTopRefreshLeft {
    if(_constraintTopRefreshLeft != constraintTopRefreshLeft) {
        if(_constraintTopRefreshLeft != nil) {
            [self.superview removeConstraint:_constraintTopRefreshLeft];
        }
        _constraintTopRefreshLeft = constraintTopRefreshLeft;
        if(_constraintTopRefreshLeft != nil) {
            [self.superview addConstraint:_constraintTopRefreshLeft];
        }
    }
}

- (void)setConstraintTopRefreshRight:(NSLayoutConstraint*)constraintTopRefreshRight {
    if(_constraintTopRefreshRight != constraintTopRefreshRight) {
        if(_constraintTopRefreshRight != nil) {
            [self.superview removeConstraint:_constraintTopRefreshRight];
        }
        _constraintTopRefreshRight = constraintTopRefreshRight;
        if(_constraintTopRefreshRight != nil) {
            [self.superview addConstraint:_constraintTopRefreshRight];
        }
    }
}

- (void)setConstraintTopRefreshSize:(NSLayoutConstraint*)constraintTopRefreshSize {
    if(_constraintTopRefreshSize != constraintTopRefreshSize) {
        if(_constraintTopRefreshSize != nil) {
            [self.superview removeConstraint:_constraintTopRefreshSize];
        }
        _constraintTopRefreshSize = constraintTopRefreshSize;
        if(_constraintTopRefreshSize != nil) {
            [self.superview addConstraint:_constraintTopRefreshSize];
        }
    }
}

- (void)setTopRefreshThreshold:(CGFloat)topRefreshThreshold {
    if(_topRefreshThreshold != topRefreshThreshold) {
        _topRefreshThreshold = topRefreshThreshold;
        if(_constraintTopRefreshSize != nil) {
            _constraintTopRefreshSize.constant = _topRefreshThreshold;
        } else if(self.superview != nil) {
            [self _updateSuperviewConstraints];
        }
    }
}

- (void)setBottomRefreshView:(MobilyDataRefreshView*)bottomRefreshView {
    if(_bottomRefreshView != bottomRefreshView) {
        if(_bottomRefreshView != nil) {
            self.constraintBottomRefreshTop = nil;
            self.constraintBottomRefreshLeft = nil;
            self.constraintBottomRefreshRight = nil;
            self.constraintBottomRefreshSize = nil;
            [_bottomRefreshView removeFromSuperview];
        }
        _bottomRefreshView = bottomRefreshView;
        if(_bottomRefreshView != nil) {
            _bottomRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_bottomRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintBottomRefreshTop:(NSLayoutConstraint*)constraintBottomRefreshTop {
    if(_constraintBottomRefreshTop != constraintBottomRefreshTop) {
        if(_constraintBottomRefreshTop != nil) {
            [self.superview removeConstraint:_constraintBottomRefreshTop];
        }
        _constraintBottomRefreshTop = constraintBottomRefreshTop;
        if(_constraintBottomRefreshTop != nil) {
            [self.superview addConstraint:_constraintBottomRefreshTop];
        }
    }
}

- (void)setConstraintBottomRefreshLeft:(NSLayoutConstraint*)constraintBottomRefreshLeft {
    if(_constraintBottomRefreshLeft != constraintBottomRefreshLeft) {
        if(_constraintBottomRefreshLeft != nil) {
            [self.superview removeConstraint:_constraintBottomRefreshLeft];
        }
        _constraintBottomRefreshLeft = constraintBottomRefreshLeft;
        if(_constraintBottomRefreshLeft != nil) {
            [self.superview addConstraint:_constraintBottomRefreshLeft];
        }
    }
}

- (void)setConstraintBottomRefreshRight:(NSLayoutConstraint*)constraintBottomRefreshRight {
    if(_constraintBottomRefreshRight != constraintBottomRefreshRight) {
        if(_constraintBottomRefreshRight != nil) {
            [self.superview removeConstraint:_constraintBottomRefreshRight];
        }
        _constraintBottomRefreshRight = constraintBottomRefreshRight;
        if(_constraintBottomRefreshRight != nil) {
            [self.superview addConstraint:_constraintBottomRefreshRight];
        }
    }
}

- (void)setConstraintBottomRefreshSize:(NSLayoutConstraint*)constraintBottomRefreshSize {
    if(_constraintBottomRefreshSize != constraintBottomRefreshSize) {
        if(_constraintBottomRefreshSize != nil) {
            [self.superview removeConstraint:_constraintBottomRefreshSize];
        }
        _constraintBottomRefreshSize = constraintBottomRefreshSize;
        if(_constraintBottomRefreshSize != nil) {
            [self.superview addConstraint:_constraintBottomRefreshSize];
        }
    }
}

- (void)setBottomRefreshThreshold:(CGFloat)bottomRefreshThreshold {
    if(_bottomRefreshThreshold != bottomRefreshThreshold) {
        _bottomRefreshThreshold = bottomRefreshThreshold;
        if(_constraintBottomRefreshSize != nil) {
            _constraintBottomRefreshSize.constant = _bottomRefreshThreshold;
        } else if(self.superview != nil) {
            [self _updateSuperviewConstraints];
        }
    }
}

- (void)setLeftRefreshView:(MobilyDataRefreshView*)leftRefreshView {
    if(_leftRefreshView != leftRefreshView) {
        if(_leftRefreshView != nil) {
            self.constraintLeftRefreshBottom = nil;
            self.constraintLeftRefreshLeft = nil;
            self.constraintLeftRefreshTop = nil;
            self.constraintLeftRefreshSize = nil;
            [_leftRefreshView removeFromSuperview];
        }
        _leftRefreshView = leftRefreshView;
        if(_leftRefreshView != nil) {
            _leftRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_leftRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintLeftRefreshTop:(NSLayoutConstraint*)constraintLeftRefreshTop {
    if(_constraintLeftRefreshTop != constraintLeftRefreshTop) {
        if(_constraintLeftRefreshTop != nil) {
            [self.superview removeConstraint:_constraintLeftRefreshTop];
        }
        _constraintLeftRefreshTop = constraintLeftRefreshTop;
        if(_constraintLeftRefreshTop != nil) {
            [self.superview addConstraint:_constraintLeftRefreshTop];
        }
    }
}

- (void)setConstraintLeftRefreshBottom:(NSLayoutConstraint*)constraintLeftRefreshBottom {
    if(_constraintLeftRefreshBottom != constraintLeftRefreshBottom) {
        if(_constraintLeftRefreshBottom != nil) {
            [self.superview removeConstraint:_constraintLeftRefreshBottom];
        }
        _constraintLeftRefreshBottom = constraintLeftRefreshBottom;
        if(_constraintLeftRefreshBottom != nil) {
            [self.superview addConstraint:_constraintLeftRefreshBottom];
        }
    }
}

- (void)setConstraintLeftRefreshLeft:(NSLayoutConstraint*)constraintLeftRefreshLeft {
    if(_constraintLeftRefreshLeft != constraintLeftRefreshLeft) {
        if(_constraintLeftRefreshLeft != nil) {
            [self.superview removeConstraint:_constraintLeftRefreshLeft];
        }
        _constraintLeftRefreshLeft = constraintLeftRefreshLeft;
        if(_constraintLeftRefreshLeft != nil) {
            [self.superview addConstraint:_constraintLeftRefreshLeft];
        }
    }
}

- (void)setConstraintLeftRefreshSize:(NSLayoutConstraint*)constraintLeftRefreshSize {
    if(_constraintLeftRefreshSize != constraintLeftRefreshSize) {
        if(_constraintLeftRefreshSize != nil) {
            [self.superview removeConstraint:_constraintLeftRefreshSize];
        }
        _constraintLeftRefreshSize = constraintLeftRefreshSize;
        if(_constraintLeftRefreshSize != nil) {
            [self.superview addConstraint:_constraintLeftRefreshSize];
        }
    }
}

- (void)setLeftRefreshThreshold:(CGFloat)leftRefreshThreshold {
    if(_leftRefreshThreshold != leftRefreshThreshold) {
        _leftRefreshThreshold = leftRefreshThreshold;
        if(_constraintLeftRefreshSize != nil) {
            _constraintLeftRefreshSize.constant = _leftRefreshThreshold;
        } else if(self.superview != nil) {
            [self _updateSuperviewConstraints];
        }
    }
}

- (void)setRightRefreshView:(MobilyDataRefreshView*)rightRefreshView {
    if(_rightRefreshView != rightRefreshView) {
        if(_rightRefreshView != nil) {
            self.constraintRightRefreshTop = nil;
            self.constraintRightRefreshBottom = nil;
            self.constraintRightRefreshRight = nil;
            self.constraintRightRefreshSize = nil;
            [_rightRefreshView removeFromSuperview];
        }
        _rightRefreshView = rightRefreshView;
        if(_rightRefreshView != nil) {
            _rightRefreshView.translatesAutoresizingMaskIntoConstraints = NO;
            if(self.superview != nil) {
                [self.superview insertSubview:_rightRefreshView aboveSubview:self];
                [self _updateSuperviewConstraints];
            }
        }
    }
}

- (void)setConstraintRightRefreshTop:(NSLayoutConstraint*)constraintRightRefreshTop {
    if(_constraintRightRefreshTop != constraintRightRefreshTop) {
        if(_constraintRightRefreshTop != nil) {
            [self.superview removeConstraint:_constraintRightRefreshTop];
        }
        _constraintRightRefreshTop = constraintRightRefreshTop;
        if(_constraintRightRefreshTop != nil) {
            [self.superview addConstraint:_constraintRightRefreshTop];
        }
    }
}

- (void)setConstraintRightRefreshBottom:(NSLayoutConstraint*)constraintRightRefreshBottom {
    if(_constraintRightRefreshBottom != constraintRightRefreshBottom) {
        if(_constraintRightRefreshBottom != nil) {
            [self.superview removeConstraint:_constraintRightRefreshBottom];
        }
        _constraintRightRefreshBottom = constraintRightRefreshBottom;
        if(_constraintRightRefreshBottom != nil) {
            [self.superview addConstraint:_constraintRightRefreshBottom];
        }
    }
}

- (void)setConstraintRightRefreshRight:(NSLayoutConstraint*)constraintRightRefreshRight {
    if(_constraintRightRefreshRight != constraintRightRefreshRight) {
        if(_constraintRightRefreshRight != nil) {
            [self.superview removeConstraint:_constraintRightRefreshRight];
        }
        _constraintRightRefreshRight = constraintRightRefreshRight;
        if(_constraintRightRefreshRight != nil) {
            [self.superview addConstraint:_constraintRightRefreshRight];
        }
    }
}

- (void)setConstraintRightRefreshSize:(NSLayoutConstraint*)constraintRightRefreshSize {
    if(_constraintRightRefreshSize != constraintRightRefreshSize) {
        if(_constraintRightRefreshSize != nil) {
            [self.superview removeConstraint:_constraintRightRefreshSize];
        }
        _constraintRightRefreshSize = constraintRightRefreshSize;
        if(_constraintRightRefreshSize != nil) {
            [self.superview addConstraint:_constraintRightRefreshSize];
        }
    }
}

- (void)setRightRefreshThreshold:(CGFloat)rightRefreshThreshold {
    if(_rightRefreshThreshold != rightRefreshThreshold) {
        _rightRefreshThreshold = rightRefreshThreshold;
        if(_constraintRightRefreshSize != nil) {
            _constraintRightRefreshSize.constant = _rightRefreshThreshold;
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
    if([self shouldSelectItem:item] == YES) {
        if(_allowsMultipleSelection == YES) {
            [_selectedItems addObject:item];
            [item setSelected:YES animated:animated];
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
        }
    }
}

- (void)deselectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if([self shouldDeselectItem:item] == YES) {
        [_selectedItems removeObject:item];
        [item setSelected:NO animated:animated];
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

- (void)showTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_topRefreshView.state == MobilyDataRefreshViewStateRelease) {
        _topRefreshView.state = MobilyDataRefreshViewStateLoading;
        
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(_topRefreshThreshold, fromInsets.left, fromInsets.bottom, fromInsets.right);
        CGFloat fromConstraint = _constraintTopRefreshSize.constant;
        CGFloat toConstraint = _topRefreshThreshold;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _topRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintTopRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintTopRefreshSize.constant = toConstraint;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hideTopRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_topRefreshView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(0.0f, fromInsets.left, fromInsets.bottom, fromInsets.right);
        CGFloat fromConstraint = _constraintTopRefreshSize.constant;
        CGFloat toConstraint = 0.0f;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _topRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintTopRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 _topRefreshView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintTopRefreshSize.constant = toConstraint;
            _topRefreshView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)showBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_bottomRefreshView.state == MobilyDataRefreshViewStateRelease) {
        _bottomRefreshView.state = MobilyDataRefreshViewStateLoading;
        
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, fromInsets.left, _bottomRefreshThreshold, fromInsets.right);
        CGFloat fromConstraint = _constraintBottomRefreshSize.constant;
        CGFloat toConstraint = _bottomRefreshThreshold;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _bottomRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintBottomRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintBottomRefreshSize.constant = toConstraint;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hideBottomRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_bottomRefreshView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, fromInsets.left, 0.0f, fromInsets.right);
        CGFloat fromConstraint = _constraintBottomRefreshSize.constant;
        CGFloat toConstraint = 0.0f;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _bottomRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintBottomRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 _bottomRefreshView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintBottomRefreshSize.constant = toConstraint;
            _bottomRefreshView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)showLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_leftRefreshView.state == MobilyDataRefreshViewStateRelease) {
        _leftRefreshView.state = MobilyDataRefreshViewStateLoading;
        
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, _leftRefreshThreshold, fromInsets.bottom, fromInsets.right);
        CGFloat fromConstraint = _constraintLeftRefreshSize.constant;
        CGFloat toConstraint = _leftRefreshThreshold;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _leftRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintLeftRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintLeftRefreshSize.constant = toConstraint;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hideLeftRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_leftRefreshView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, 0.0f, fromInsets.bottom, fromInsets.right);
        CGFloat fromConstraint = _constraintLeftRefreshSize.constant;
        CGFloat toConstraint = 0.0f;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _leftRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintLeftRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 _leftRefreshView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintLeftRefreshSize.constant = toConstraint;
            _leftRefreshView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)showRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_rightRefreshView.state == MobilyDataRefreshViewStateRelease) {
        _rightRefreshView.state = MobilyDataRefreshViewStateLoading;
        
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, fromInsets.left, fromInsets.bottom, _rightRefreshThreshold);
        CGFloat fromConstraint = _constraintRightRefreshSize.constant;
        CGFloat toConstraint = _rightRefreshThreshold;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _rightRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintRightRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintRightRefreshSize.constant = toConstraint;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)hideRightRefreshAnimated:(BOOL)animated complete:(MobilyDataViewCompleteBlock)complete {
    if(_rightRefreshView.state != MobilyDataRefreshViewStateIdle) {
        UIEdgeInsets fromInsets = self.contentInset;
        UIEdgeInsets toInsets = UIEdgeInsetsMake(fromInsets.top, fromInsets.left, fromInsets.bottom, 0.0f);
        CGFloat fromConstraint = _constraintRightRefreshSize.constant;
        CGFloat toConstraint = 0.0f;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / _rightRefreshVelocity
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 self.contentInset = self.scrollIndicatorInsets = toInsets;
                                 _constraintRightRefreshSize.constant = toConstraint;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 _rightRefreshView.state = MobilyDataRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.contentInset = self.scrollIndicatorInsets = toInsets;
            _constraintRightRefreshSize.constant = toConstraint;
            _rightRefreshView.state = MobilyDataRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

#pragma mark Private

- (void)_receiveMemoryWarning {
    [_queueCells each:^(NSString* identifier, NSArray* cells) {
        for(MobilyDataCell* cell in cells) {
            [cell removeFromSuperview];
        }
    }];
    [_queueCells removeAllObjects];
}

- (void)_userSelectItem:(MobilyDataItem*)item animated:(BOOL)animated {
    if(_allowsOnceSelection == YES) {
        [self selectItem:item animated:animated];
    } else {
        if([self isSelectedItem:item] == NO) {
            [self selectItem:item animated:animated];
        } else {
            [self deselectItem:item animated:animated];
        }
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

- (void)_validateLayout {
    CGRect layoutRect = CGRectZero;
    if(_container != nil) {
        layoutRect = [_container _validateLayoutForAvailableFrame:CGRectMakeOriginAndSize(CGPointZero, self.boundsSize)];
    }
    self.contentSize = layoutRect.size;
}

- (void)_layoutForVisible {
    if((self.dragging == YES) || (self.decelerating == YES)) {
        [_container _willLayoutForBounds:self.visibleBounds];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect bounds = self.bounds;
            if(_updating == NO) {
                [_visibleItems enumerateObjectsUsingBlock:^(MobilyDataItem* item, NSUInteger itemIndex __unused, BOOL* itemStop __unused) {
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
    if(_topRefreshView != nil) {
        if(_constraintTopRefreshBottom == nil) {
            self.constraintTopRefreshBottom = [NSLayoutConstraint constraintWithItem:_topRefreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
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
        self.constraintTopRefreshBottom = nil;
        self.constraintTopRefreshLeft = nil;
        self.constraintTopRefreshRight = nil;
        self.constraintTopRefreshSize = nil;
    }
    if(_bottomRefreshView != nil) {
        if(_constraintBottomRefreshTop == nil) {
            self.constraintBottomRefreshTop = [NSLayoutConstraint constraintWithItem:_bottomRefreshView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
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
        self.constraintBottomRefreshTop = nil;
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

- (void)_willBeginDragging {
    if(self.pagingEnabled == NO) {
        if(_refreshDragging == NO) {
            if(_topRefreshView != nil) {
                self.canTopRefresh = ([_topRefreshView state] != MobilyDataRefreshViewStateLoading);
            } else {
                self.canTopRefresh = NO;
            }
            if(_bottomRefreshView != nil) {
                self.canBottomRefresh = ([_bottomRefreshView state] != MobilyDataRefreshViewStateLoading);
            } else {
                self.canBottomRefresh = NO;
            }
            if(_leftRefreshView != nil) {
                self.canLeftRefresh = ([_leftRefreshView state] != MobilyDataRefreshViewStateLoading);
            } else {
                self.canLeftRefresh = NO;
            }
            if(_rightRefreshView != nil) {
                self.canRightRefresh = ([_rightRefreshView state] != MobilyDataRefreshViewStateLoading);
            } else {
                self.canRightRefresh = NO;
            }
            if((_canTopRefresh == YES) || (_canBottomRefresh == YES) || (_canLeftRefresh == YES) || (_canRightRefresh == YES)) {
                self.refreshDragging = YES;
            } else {
                self.refreshDragging = NO;
            }
        }
    }
    if(_container != nil) {
        [_container _willBeginDragging];
    }
}

- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating {
    if(self.pagingEnabled == NO) {
        CGSize frameSize = self.frameSize;
        CGPoint contentOffset = self.contentOffset;
        CGSize contentSize = self.contentSize;
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
            self.contentOffset = contentOffset;
        }
        if((_refreshDragging == YES) && (dragging == YES) && (decelerating == NO)) {
            if((_canTopRefresh == YES) && (contentOffset.y < 0.0f)) {
                CGFloat offset = -contentOffset.y;
                switch(_topRefreshView.state) {
                    case MobilyDataRefreshViewStateIdle:
                        if(offset > 0.0f) {
                            _topRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    case MobilyDataRefreshViewStatePull:
                    case MobilyDataRefreshViewStateRelease:
                        if(offset < 0.0f) {
                            _topRefreshView.state = MobilyDataRefreshViewStateIdle;
                        } else if(offset >= _topRefreshThreshold) {
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
                _constraintTopRefreshSize.constant = offset;
            } else {
                _topRefreshView.state = MobilyDataRefreshViewStateIdle;
                _constraintTopRefreshSize.constant = 0.0f;
            }
            if((_canBottomRefresh == YES) && (contentSize.height >= frameSize.height)) {
                CGFloat contentBottom = contentSize.height - frameSize.height;
                if(contentOffset.y >= contentBottom) {
                    CGFloat offset = contentOffset.y - contentBottom;
                    switch(_bottomRefreshView.state) {
                        case MobilyDataRefreshViewStateIdle:
                            if(offset > 0.0f) {
                                _bottomRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        case MobilyDataRefreshViewStatePull:
                        case MobilyDataRefreshViewStateRelease:
                            if(offset < 0.0f) {
                                _bottomRefreshView.state = MobilyDataRefreshViewStateIdle;
                            } else if(offset >= _bottomRefreshThreshold) {
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
                    _constraintBottomRefreshSize.constant = offset;
                } else {
                    _bottomRefreshView.state = MobilyDataRefreshViewStateIdle;
                    _constraintBottomRefreshSize.constant = 0.0f;
                }
            }
            if((_canLeftRefresh == YES) && (contentOffset.x < 0.0f)) {
                CGFloat offset = -contentOffset.x;
                switch(_leftRefreshView.state) {
                    case MobilyDataRefreshViewStateIdle:
                        if(offset > 0.0f) {
                            _leftRefreshView.state = MobilyDataRefreshViewStatePull;
                        }
                        break;
                    case MobilyDataRefreshViewStatePull:
                    case MobilyDataRefreshViewStateRelease:
                        if(offset < 0.0f) {
                            _leftRefreshView.state = MobilyDataRefreshViewStateIdle;
                        } else if(offset >= _leftRefreshThreshold) {
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
                _constraintLeftRefreshSize.constant = offset;
            } else {
                _leftRefreshView.state = MobilyDataRefreshViewStateIdle;
                _constraintLeftRefreshSize.constant = 0.0f;
            }
            if((_canRightRefresh == YES) && (contentSize.width >= frameSize.width)) {
                CGFloat contentRight = contentSize.width - frameSize.width;
                if(contentOffset.x >= contentRight) {
                    CGFloat offset = contentOffset.x - contentRight;
                    switch(_rightRefreshView.state) {
                        case MobilyDataRefreshViewStateIdle:
                            if(offset > 0.0f) {
                                _rightRefreshView.state = MobilyDataRefreshViewStatePull;
                            }
                            break;
                        case MobilyDataRefreshViewStatePull:
                        case MobilyDataRefreshViewStateRelease:
                            if(offset < 0.0f) {
                                _rightRefreshView.state = MobilyDataRefreshViewStateIdle;
                            } else if(offset >= _rightRefreshThreshold) {
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
                    _constraintRightRefreshSize.constant = offset;
                } else {
                    _rightRefreshView.state = MobilyDataRefreshViewStateIdle;
                    _constraintRightRefreshSize.constant = 0.0f;
                }
            }
        }
    }
    if(_container != nil) {
        [_container _didScrollDragging:dragging decelerating:decelerating];
    }
}

- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if(_container != nil) {
        [_container _willEndDraggingWithVelocity:velocity contentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
    }
}

- (void)_didEndDraggingWillDecelerate:(BOOL)decelerate {
    if(self.pagingEnabled == NO) {
        if(_refreshDragging == YES) {
            if(_canTopRefresh == YES) {
                switch(_topRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewTopRefreshTriggered] == YES) {
                            [self showTopRefreshAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewTopRefreshTriggered byObject:_topRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self hideTopRefreshAnimated:YES complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    default: {
                        [self hideTopRefreshAnimated:YES complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                }
            }
            if(_canBottomRefresh == YES) {
                switch(_bottomRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewBottomRefreshTriggered] == YES) {
                            [self showBottomRefreshAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewBottomRefreshTriggered byObject:_bottomRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self hideBottomRefreshAnimated:YES complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    default: {
                        [self hideBottomRefreshAnimated:YES complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                }
            }
            if(_canLeftRefresh == YES) {
                switch(_leftRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewLeftRefreshTriggered] == YES) {
                            [self showLeftRefreshAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewLeftRefreshTriggered byObject:_leftRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self hideLeftRefreshAnimated:YES complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    default: {
                        [self hideLeftRefreshAnimated:YES complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                }
            }
            if(_canRightRefresh == YES) {
                switch(_rightRefreshView.state) {
                    case MobilyDataRefreshViewStateRelease: {
                        if([self containsEventForKey:MobilyDataViewRightRefreshTriggered] == YES) {
                            [self showRightRefreshAnimated:YES complete:^(BOOL finished __unused) {
                                [self fireEventForKey:MobilyDataViewRightRefreshTriggered byObject:_rightRefreshView];
                                self.refreshDragging = NO;
                            }];
                        } else {
                            [self hideRightRefreshAnimated:YES complete:^(BOOL finished) {
                                self.refreshDragging = NO;
                            }];
                        }
                        break;
                    }
                    default: {
                        [self hideRightRefreshAnimated:YES complete:^(BOOL finished) {
                            self.refreshDragging = NO;
                        }];
                        break;
                    }
                }
            }
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
    [_view _willEndDraggingWithVelocity:velocity contentOffset:targetContentOffset contentSize:scrollView.contentSize visibleSize:_view.boundsSize];
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
