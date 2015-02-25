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

#import "MobilyDataScrollView.h"

/*--------------------------------------------------*/

@class MobilyDataScrollViewDelegateProxy;

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDataScrollView ()

@property(nonatomic, readwrite, strong) MobilyDataScrollViewDelegateProxy* delegateProxy;

@property(nonatomic, readwrite, assign, getter=isUpdating) BOOL updating;
@property(nonatomic, readwrite, assign) BOOL invalidLayout;

@property(nonatomic, readwrite, strong) NSMutableArray* unsafeVisibleItems;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeSelectedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeHighlightedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeEditingItems;
@property(nonatomic, readwrite, strong) NSMutableDictionary* registersViews;
@property(nonatomic, readwrite, strong) MobilyEvents* registersEvents;
@property(nonatomic, readwrite, strong) NSMutableDictionary* queueViews;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedBeforeItems;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedAfterItems;
@property(nonatomic, readwrite, strong) NSMutableArray* deletedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* insertedItems;

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

- (void)notificationReceiveMemoryWarning:(NSNotification*)notification;

- (void)internalWillBeginDragging;
- (void)internalDidScroll;
- (void)internalDidEndDraggingWillDecelerate:(BOOL)decelerate;

- (void)internalBatchUpdate:(MobilyDataWidgetUpdateBlock)update;
- (void)internalBatchComplete:(MobilyDataWidgetUpdateBlock)complete;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDataScrollViewDelegateProxy : NSObject< UIScrollViewDelegate >

@property(nonatomic, readwrite, weak) MobilyDataScrollView* dataScrollView;
@property(nonatomic, readwrite, weak) id< UIScrollViewDelegate > delegate;

- (instancetype)initWithDataScrollView:(MobilyDataScrollView*)dataScrollView;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataScrollView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize allowsEditing = _allowsEditing;
@synthesize allowsMultipleEditing = _allowsMultipleEditing;
@synthesize container = _container;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        self.delegateProxy = [MobilyDataScrollViewDelegateProxy new];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.delegateProxy = [MobilyDataScrollViewDelegateProxy new];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bouncesTop = YES;
    self.bouncesLeft = YES;
    self.bouncesRight = YES;
    self.bouncesBottom = YES;
    
    self.allowsSelection = YES;
    self.allowsMultipleSelection = YES;
    self.allowsEditing = YES;
    self.allowsMultipleEditing = YES;
    
    self.unsafeVisibleItems = NSMutableArray.array;
    self.unsafeSelectedItems = NSMutableArray.array;
    self.unsafeHighlightedItems = NSMutableArray.array;
    self.unsafeEditingItems = NSMutableArray.array;
    self.registersViews = NSMutableDictionary.dictionary;
    self.registersEvents = [MobilyEvents new];
    self.queueViews = NSMutableDictionary.dictionary;
    self.reloadedBeforeItems = NSMutableArray.array;
    self.reloadedAfterItems = NSMutableArray.array;
    self.deletedItems = NSMutableArray.array;
    self.insertedItems = NSMutableArray.array;
    
    self.pullToRefreshHeight = -1.0f;
    self.pullToLoadHeight = -1.0f;
    
    [self registerAdjustmentResponder];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notificationReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [self unregisterAdjustmentResponder];
    
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
    
    self.delegateProxy = nil;
    
    self.unsafeVisibleItems = nil;
    self.unsafeSelectedItems = nil;
    self.unsafeHighlightedItems = nil;
    self.unsafeEditingItems = nil;
    self.registersViews = nil;
    self.registersEvents = nil;
    self.queueViews = nil;
    self.reloadedBeforeItems = nil;
    self.reloadedAfterItems = nil;
    self.deletedItems = nil;
    self.insertedItems = nil;
    
    self.constraintPullToRefreshBottom = nil;
    self.constraintPullToRefreshLeft = nil;
    self.constraintPullToRefreshRight = nil;
    self.constraintPullToRefreshHeight = nil;
    self.constraintPullToLoadTop = nil;
    self.constraintPullToLoadLeft = nil;
    self.constraintPullToLoadRight = nil;
    self.constraintPullToLoadHeight = nil;
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
    [self layoutForVisible];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self updateSuperviewConstraints];
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

- (void)setDelegateProxy:(MobilyDataScrollViewDelegateProxy*)delegateProxy {
    if(_delegateProxy != delegateProxy) {
        if(_delegateProxy != nil) {
            _delegateProxy.dataScrollView = nil;
        }
        super.delegate = nil;
        _delegateProxy = delegateProxy;
        super.delegate = _delegateProxy;
        if(_delegateProxy != nil) {
            _delegateProxy.dataScrollView = self;
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

- (void)setContainer:(id< MobilyDataContainer >)container {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %@", self.class, NSStringFromSelector(_cmd), container);
        return;
    }
#endif
    if(_container != container) {
        if(_container != nil) {
            [self setNeedValidateLayout];
            [UIView performWithoutAnimation:^{
                [self deselectAllItemsAnimated:NO];
                [self unhighlightAllItemsAnimated:NO];
                if(_unsafeVisibleItems.count > 0) {
                    for(id< MobilyDataItem > item in _unsafeVisibleItems) {
                        [self disappearItem:item];
                    }
                    [_unsafeVisibleItems removeAllObjects];
                }
            }];
            _container.widget = nil;
            [self validateLayoutIfNeed];
        }
        _container = container;
        if(_container != nil) {
            [self setNeedValidateLayout];
            _container.widget = self;
            [UIView performWithoutAnimation:^{
                [self validateLayoutIfNeed];
                [self layoutForVisible];
            }];
        }
    }
}

- (NSArray*)visibleItems {
    return _unsafeVisibleItems;
}

- (NSArray*)visibleViews {
    NSMutableArray* result = NSMutableArray.array;
    for(id< MobilyDataItem > item in _unsafeVisibleItems) {
        [result addObject:item.view];
    }
    return [NSArray arrayWithArray:result];
}

- (NSArray*)selectedItems {
    return _unsafeSelectedItems;
}

- (NSArray*)selectedViews {
    NSMutableArray* result = NSMutableArray.array;
    for(id< MobilyDataItem > item in _unsafeSelectedItems) {
        UIView< MobilyDataItemView >* itemView = item.view;
        if(itemView != nil) {
            [result addObject:itemView];
        }
    }
    return result;
}

- (NSArray*)highlightedItems {
    return _unsafeHighlightedItems;
}

- (NSArray*)highlightedViews {
    NSMutableArray* result = NSMutableArray.array;
    for(id< MobilyDataItem > item in _unsafeHighlightedItems) {
        UIView< MobilyDataItemView >* itemView = item.view;
        if(itemView != nil) {
            [result addObject:itemView];
        }
    }
    return result;
}

- (NSArray*)editingItems {
    return _unsafeEditingItems;
}

- (NSArray*)editingViews {
    NSMutableArray* result = NSMutableArray.array;
    for(id< MobilyDataItem > item in _unsafeEditingItems) {
        UIView< MobilyDataItemView >* itemView = item.view;
        if(itemView != nil) {
            [result addObject:itemView];
        }
    }
    return result;
}

- (void)setPullToRefreshView:(UIView< MobilyDataScrollRefreshView >*)pullToRefreshView {
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
                [self updateSuperviewConstraints];
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
            [self updateSuperviewConstraints];
        }
    }
}

- (void)setPullToLoadView:(UIView< MobilyDataScrollRefreshView >*)pullToLoadView {
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
                [self updateSuperviewConstraints];
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
            [self updateSuperviewConstraints];
        }
    }
}

#pragma mark Public

- (void)registerIdentifier:(NSString*)identifier withViewClass:(Class< MobilyDataItemView >)viewClass {
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

- (void)registerEventWithBlock:(MobilyEventBlockType)block forKey:(id)key {
    [_registersEvents addEventWithBlock:block forKey:key];
}

- (void)registerEvent:(id< MobilyEvent >)event forKey:(id)key {
    [_registersEvents addEvent:event forKey:key];
}

- (void)unregisterEventForKey:(id)key {
    [_registersEvents removeEventForKey:key];
}

- (void)unregisterAllEvents {
    [_registersEvents removeAllEvents];
}

- (BOOL)containsEventForKey:(id)key {
    return [_registersEvents containsEventForKey:key];
}

- (id)performEventForKey:(id)key byObject:(id)object {
    return [_registersEvents fireEventForKey:key bySender:self byObject:object];
}

- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult {
    return [_registersEvents fireEventForKey:key bySender:self byObject:object defaultResult:defaultResult];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_registersEvents fireEventForKey:key bySender:sender byObject:object];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult {
    return [_registersEvents fireEventForKey:key bySender:sender byObject:object defaultResult:defaultResult];
}

- (Class< MobilyDataItemView >)viewClassWithItem:(id< MobilyDataItem >)item {
    return _registersViews[item.identifier];
}

- (void)dequeueViewWithItem:(id< MobilyDataItem >)item {
    if(item.view == nil) {
        NSString* identifier = item.identifier;
        NSMutableArray* queue = _queueViews[identifier];
        UIView< MobilyDataItemView >* view = [queue lastObject];
        if(view == nil) {
            view = [[_registersViews[identifier] alloc] initWithIdentifier:identifier];
        } else {
            [queue removeLastObject];
        }
        item.view = view;
    }
}

- (void)enqueueViewWithItem:(id< MobilyDataItem >)item {
    UIView< MobilyDataItemView >* view = item.view;
    if(view != nil) {
        NSString* identifier = item.identifier;
        NSMutableArray* queue = _queueViews[identifier];
        if(queue == nil) {
            _queueViews[identifier] = [NSMutableArray arrayWithObject:view];
        } else {
            [queue addObject:view];
        }
        item.view = nil;
    }
}

- (id< MobilyDataItem >)itemForData:(id)data {
    return [_container itemForData:data];
}

- (UIView< MobilyDataItemView >*)itemViewForData:(id)data {
    return [_container itemViewForData:data];
}

- (BOOL)isSelectedItem:(id< MobilyDataItem >)item {
    return [_unsafeSelectedItems containsObject:item];
}

- (BOOL)shouldSelectItem:(id< MobilyDataItem >)item {
    if(_allowsSelection == YES) {
        return item.allowsSelection;
    }
    return _allowsSelection;
}

- (BOOL)shouldDeselectItem:(id< MobilyDataItem >)item {
    return YES;
}

- (void)selectItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeSelectedItems containsObject:item] == NO) {
        if([self shouldSelectItem:item] == YES) {
            if(_allowsMultipleSelection == YES) {
                [_unsafeSelectedItems addObject:item];
                [item setSelected:YES animated:NO];
            } else {
                if(_unsafeSelectedItems.count > 0) {
                    for(id< MobilyDataItem > item in _unsafeSelectedItems) {
                        [item setSelected:NO animated:NO];
                    }
                    [_unsafeSelectedItems removeAllObjects];
                }
                [_unsafeSelectedItems addObject:item];
                [item setSelected:YES animated:NO];
            }
        }
    }
}

- (void)deselectItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeSelectedItems containsObject:item] == YES) {
        if([self shouldDeselectItem:item] == YES) {
            [_unsafeSelectedItems removeObject:item];
            [item setSelected:NO animated:NO];
        }
    }
}

- (void)deselectAllItemsAnimated:(BOOL)animated {
    if(_unsafeSelectedItems.count > 0) {
        for(id< MobilyDataItem > item in _unsafeSelectedItems) {
            if([self shouldDeselectItem:item] == YES) {
                [_unsafeSelectedItems removeObject:item];
                [item setSelected:NO animated:NO];
            }
        }
        [_unsafeSelectedItems removeAllObjects];
    }
}

- (BOOL)isHighlightedItem:(id< MobilyDataItem >)item {
    return [_unsafeHighlightedItems containsObject:item];
}

- (BOOL)shouldHighlightItem:(id< MobilyDataItem >)item {
    return item.allowsHighlighting;
}

- (BOOL)shouldUnhighlightItem:(id< MobilyDataItem >)item {
    return YES;
}

- (void)highlightItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeHighlightedItems containsObject:item] == NO) {
        if([self shouldHighlightItem:item] == YES) {
            [_unsafeHighlightedItems addObject:item];
            [item setHighlighted:YES animated:NO];
        }
    }
}

- (void)unhighlightItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeHighlightedItems containsObject:item] == YES) {
        if([self shouldUnhighlightItem:item] == YES) {
            [_unsafeHighlightedItems removeObject:item];
            [item setHighlighted:NO animated:NO];
        }
    }
}

- (void)unhighlightAllItemsAnimated:(BOOL)animated {
    if(_unsafeHighlightedItems.count > 0) {
        for(id< MobilyDataItem > item in _unsafeHighlightedItems) {
            if([self shouldUnhighlightItem:item] == YES) {
                [_unsafeHighlightedItems removeObject:item];
                [item setHighlighted:NO animated:NO];
            }
        }
        [_unsafeHighlightedItems removeAllObjects];
    }
}

- (BOOL)isEditingItem:(id< MobilyDataItem >)item {
    return [_unsafeEditingItems containsObject:item];
}

- (BOOL)shouldBeganEditItem:(id< MobilyDataItem >)item {
    if(_allowsEditing == YES) {
        return item.allowsEditing;
    }
    return NO;
}

- (BOOL)shouldEndedEditItem:(id< MobilyDataItem >)item {
    return _allowsEditing;
}

- (void)beganEditItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeEditingItems containsObject:item] == NO) {
        if([self shouldBeganEditItem:item] == YES) {
            if(_allowsMultipleEditing == YES) {
                [_unsafeEditingItems addObject:item];
                [item setEditing:YES animated:NO];
            } else {
                if(_unsafeEditingItems.count > 0) {
                    for(id< MobilyDataItem > item in _unsafeEditingItems) {
                        [item setEditing:NO animated:NO];
                    }
                    [_unsafeEditingItems removeAllObjects];
                }
                [_unsafeEditingItems addObject:item];
                [item setEditing:YES animated:NO];
            }
        }
    }
}

- (void)endedEditItem:(id< MobilyDataItem >)item animated:(BOOL)animated {
    if([_unsafeEditingItems containsObject:item] == YES) {
        if([self shouldEndedEditItem:item] == YES) {
            [_unsafeEditingItems removeObject:item];
            [item setEditing:NO animated:NO];
        }
    }
}

- (void)endedEditAllItemsAnimated:(BOOL)animated {
    if(_unsafeEditingItems.count > 0) {
        for(id< MobilyDataItem > item in _unsafeEditingItems) {
            if([self shouldEndedEditItem:item] == YES) {
                [_unsafeEditingItems removeObject:item];
                [item setEditing:NO animated:NO];
            }
        }
        [_unsafeEditingItems removeAllObjects];
    }
}

- (void)appearItem:(id< MobilyDataItem >)item {
    [_unsafeVisibleItems addObject:item];
    [self dequeueViewWithItem:item];
}

- (void)disappearItem:(id< MobilyDataItem >)item {
    [_unsafeVisibleItems removeObject:item];
    [self enqueueViewWithItem:item];
}

- (void)performBatchUpdate:(MobilyDataWidgetUpdateBlock)update complete:(MobilyDataWidgetCompleteBlock)complete {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %@ - %@", self.class, NSStringFromSelector(_cmd), update, complete);
        return;
    }
#endif
    [self internalBatchUpdate:^{
        if(update != nil) {
            update();
        }
        [self internalBatchComplete:^() {
            if(complete != nil) {
                complete(YES);
            }
        }];
    }];
}

- (void)performBatchDuration:(NSTimeInterval)duration update:(MobilyDataWidgetUpdateBlock)update complete:(MobilyDataWidgetCompleteBlock)complete {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != NO) {
        NSLog(@"ERROR: [%@:%@] %0.2f - %@ - %@", self.class, NSStringFromSelector(_cmd), duration, update, complete);
        return;
    }
#endif
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:0
                     animations:^{
                         [self internalBatchUpdate:update];
                     }
                     completion:^(BOOL finished) {
                         [self internalBatchComplete:^() {
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
                     }];
}


- (void)didInsertItems:(NSArray*)items {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != YES) {
        NSLog(@"ERROR: [%@:%@] %@", self.class, NSStringFromSelector(_cmd), items);
        return;
    }
#endif
    [_insertedItems addObjectsFromArray:items];
    [self setNeedValidateLayout];
}

- (void)didDeleteItems:(NSArray*)items {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != YES) {
        NSLog(@"ERROR: [%@:%@] %@", self.class, NSStringFromSelector(_cmd), items);
        return;
    }
#endif
    [_unsafeVisibleItems removeObjectsInArray:items];
    [_unsafeSelectedItems removeObjectsInArray:items];
    [_unsafeHighlightedItems removeObjectsInArray:items];
    [_unsafeEditingItems removeObjectsInArray:items];
    [_deletedItems addObjectsFromArray:items];
    [self setNeedValidateLayout];
}

- (void)didReplaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(_updating != YES) {
        NSLog(@"ERROR: [%@:%@] %@ - %@", self.class, NSStringFromSelector(_cmd), originItems, items);
        return;
    }
#endif
    [_unsafeVisibleItems removeObjectsInArray:originItems];
    [_unsafeSelectedItems removeObjectsInArray:originItems];
    [_unsafeHighlightedItems removeObjectsInArray:originItems];
    [_unsafeEditingItems removeObjectsInArray:originItems];
    [_reloadedBeforeItems addObjectsFromArray:originItems];
    [_reloadedAfterItems addObjectsFromArray:items];
    [self setNeedValidateLayout];
}

- (void)setNeedValidateLayout {
    self.invalidLayout = YES;
    [self setNeedsLayout];
}

- (void)validateLayoutIfNeed {
    if(_invalidLayout == YES) {
        [self validateLayout];
        self.invalidLayout = NO;
    }
}

- (void)validateLayout {
    CGRect layoutRect = CGRectZero;
    if(_container != nil) {
        layoutRect = [_container validateLayoutForAvailableFrame:CGRectMakeOriginAndSize(CGPointZero, self.boundsSize)];
    }
    self.contentSize = layoutRect.size;
}

- (void)setNeedLayoutForVisible {
    [self setNeedsLayout];
}

- (void)layoutForVisibleIfNeed {
    [self layoutIfNeeded];
}

- (void)layoutForVisible {
    CGRect bounds = self.bounds;
    if(_updating == NO) {
        [_unsafeVisibleItems enumerateObjectsUsingBlock:^(id< MobilyDataItem > item, NSUInteger itemIndex, BOOL* itemStop) {
            [item invalidateLayoutForVisibleBounds:bounds];
        }];
    }
    [_container layoutForVisibleBounds:bounds snapBounds:UIEdgeInsetsInsetRect(bounds, self.contentInset)];
}

- (void)scrollToItem:(id< MobilyDataItem >)item scrollPosition:(MobilyDataScrollViewPosition)scrollPosition animated:(BOOL)animated {
    NSUInteger vPosition = scrollPosition & (MobilyDataScrollViewPositionTop | MobilyDataScrollViewPositionCenteredVertically | MobilyDataScrollViewPositionBottom);
    NSUInteger hPosition = scrollPosition & (MobilyDataScrollViewPositionLeft | MobilyDataScrollViewPositionCenteredHorizontally | MobilyDataScrollViewPositionRight);
    if((vPosition != MobilyDataScrollViewPositionNone) && (vPosition != MobilyDataScrollViewPositionTop) && (vPosition != MobilyDataScrollViewPositionCenteredVertically) && (vPosition != MobilyDataScrollViewPositionBottom)) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"MobilyDataScrollViewPosition: attempt to use a scroll position with multiple vertical positioning styles" userInfo:nil];
    }
    if((hPosition != MobilyDataScrollViewPositionNone) && (hPosition != MobilyDataScrollViewPositionLeft) && (hPosition != MobilyDataScrollViewPositionCenteredHorizontally) && (hPosition != MobilyDataScrollViewPositionRight)) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"MobilyDataScrollViewPosition: attempt to use a scroll position with multiple horizontal positioning styles" userInfo:nil];
    }
    CGRect visibleRect = self.bounds;
    UIEdgeInsets contentInset = self.contentInset;
    CGRect itemFrame = [item updateFrame];
    switch(vPosition) {
        case MobilyDataScrollViewPositionCenteredVertically: {
            CGFloat offset = fmax(itemFrame.origin.y - ((visibleRect.size.height * 0.5f) - (itemFrame.size.height * 0.5f)), -contentInset.top);
            itemFrame = CGRectMake(itemFrame.origin.x, offset, itemFrame.size.width, visibleRect.size.height);
            break;
        }
        case MobilyDataScrollViewPositionTop: {
            itemFrame = CGRectMake(itemFrame.origin.x, itemFrame.origin.y, itemFrame.size.width, visibleRect.size.height);
            break;
        }
        case MobilyDataScrollViewPositionBottom: {
            CGFloat offset = fmax(itemFrame.origin.y - (visibleRect.size.height - itemFrame.size.height), -contentInset.top);
            itemFrame = CGRectMake(itemFrame.origin.x, offset, itemFrame.size.width, visibleRect.size.height);
            break;
        }
    }
    switch(hPosition) {
        case MobilyDataScrollViewPositionLeft: {
            itemFrame = CGRectMake(itemFrame.origin.x, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
        case MobilyDataScrollViewPositionCenteredHorizontally: {
            CGFloat offset = itemFrame.origin.x - ((visibleRect.size.width * 0.5f) - (itemFrame.size.width * 0.5f));
            itemFrame = CGRectMake(offset, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
        case MobilyDataScrollViewPositionRight: {
            CGFloat offset = itemFrame.origin.x - (visibleRect.size.width - itemFrame.size.width);
            itemFrame = CGRectMake(offset, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
    }
    [self scrollRectToVisible:itemFrame animated:animated];
}

- (void)updateSuperviewConstraints {
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

- (void)showPullToRefreshAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete {
    if(_pullToRefreshView.state == MobilyDataScrollRefreshViewStateRelease) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.top = (_pullToRefreshHeight < 0.0f) ? _pullToRefreshView.frameHeight : _pullToRefreshHeight;
        _constraintPullToRefreshBottom.constant = contentInset.top;
        _pullToRefreshView.state = MobilyDataScrollRefreshViewStateLoading;
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

- (void)hidePullToRefreshAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete {
    if(_pullToRefreshView.state != MobilyDataScrollRefreshViewStateIdle) {
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
                                 _pullToRefreshView.state = MobilyDataScrollRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            _pullToRefreshView.state = MobilyDataScrollRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

- (void)showPullToLoadAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete {
    if(_pullToLoadView.state == MobilyDataScrollRefreshViewStateRelease) {
        UIEdgeInsets contentInset = self.contentInset;
        contentInset.bottom = (_pullToLoadHeight < 0.0f) ? _pullToLoadView.frameHeight : _pullToLoadHeight;
        _constraintPullToLoadTop.constant = -contentInset.bottom;
        _pullToLoadView.state = MobilyDataScrollRefreshViewStateLoading;
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

- (void)hidePullToLoadAnimated:(BOOL)animated complete:(MobilyDataWidgetCompleteBlock)complete {
    if(_pullToLoadView.state != MobilyDataScrollRefreshViewStateIdle) {
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
                                 _pullToLoadView.state = MobilyDataScrollRefreshViewStateIdle;
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            self.scrollIndicatorInsets = self.contentInset = contentInset;
            _pullToLoadView.state = MobilyDataScrollRefreshViewStateIdle;
            if(complete != nil) {
                complete(YES);
            }
        }
    }
}

#pragma mark NSNotificationCenter

- (void)notificationReceiveMemoryWarning:(NSNotification*)notification {
    [_queueViews removeAllObjects];
}

#pragma mark UIScrollViewDelegate

- (void)internalWillBeginDragging {
    if(_pullToRefreshView != nil) {
        self.canPullToRefresh = ([_pullToRefreshView state] != MobilyDataScrollRefreshViewStateLoading);
    } else {
        self.canPullToRefresh = NO;
    }
    if(_pullToLoadView != nil) {
        self.canPullToLoad = ([_pullToLoadView state] != MobilyDataScrollRefreshViewStateLoading);
    } else {
        self.canPullToLoad = NO;
    }
    if((_canPullToRefresh == YES) || (_canPullToLoad == YES)) {
        self.pullDragging = YES;
    } else {
        self.pullDragging = NO;
    }
}

- (void)internalDidScroll {
    if(self.isDragging == YES) {
        CGRect bounds = self.bounds;
        CGSize frameSize = self.frameSize;
        CGSize contentSize = self.contentSize;
        CGPoint contentOffset = self.contentOffset;
        UIEdgeInsets contentInset = self.contentInset;
        if([self bounces] == YES) {
            if([self alwaysBounceHorizontal] == YES) {
                if(_bouncesLeft == NO) {
                    contentOffset.x = MAX(0.0f, contentOffset.x);
                }
                if(_bouncesRight == NO) {
                    contentOffset.x = MIN(contentSize.width - frameSize.width, contentOffset.x);
                }
            }
            if([self alwaysBounceVertical] == YES) {
                if(_bouncesTop == NO) {
                    contentOffset.y = MAX(0.0f, contentOffset.y);
                }
                if(_bouncesBottom == NO) {
                    contentOffset.y = MIN(contentSize.height - frameSize.height, contentOffset.y);
                }
            }
        }
        if((_pullDragging == YES) && (self.isDecelerating == NO)) {
            if(_canPullToRefresh == YES) {
                CGFloat pullToRefreshSize = (_pullToRefreshHeight < 0.0f) ? _pullToRefreshView.frameHeight : _pullToRefreshHeight;
                CGFloat offset = MIN(pullToRefreshSize, -contentOffset.y);
                switch(_pullToRefreshView.state) {
                    case MobilyDataScrollRefreshViewStateIdle:
                        if(offset > 0.0f) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = 0.0f;
                            }
                            _pullToRefreshView.state = MobilyDataScrollRefreshViewStatePull;
                            contentInset.top = 0.0f;
                        }
                        break;
                    case MobilyDataScrollRefreshViewStatePull:
                    case MobilyDataScrollRefreshViewStateRelease:
                        if(offset < 0.0f) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = 0.0f;
                            }
                            _pullToRefreshView.state = MobilyDataScrollRefreshViewStateIdle;
                            contentInset.top = 0.0f;
                        } else if(offset >= pullToRefreshSize) {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = pullToRefreshSize;
                            }
                            if(_pullToRefreshView.state != MobilyDataScrollRefreshViewStateRelease) {
                                _pullToRefreshView.state = MobilyDataScrollRefreshViewStateRelease;
                                contentInset.top = offset;
                            }
                        } else {
                            if(_constraintPullToRefreshBottom != nil) {
                                _constraintPullToRefreshBottom.constant = offset;
                            }
                            _pullToRefreshView.state = MobilyDataScrollRefreshViewStatePull;
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
                        case MobilyDataScrollRefreshViewStateIdle:
                            if(offset > 0.0f) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -offset;
                                }
                                _pullToLoadView.state = MobilyDataScrollRefreshViewStatePull;
                                contentInset.bottom = offset;
                            }
                            break;
                        case MobilyDataScrollRefreshViewStatePull:
                        case MobilyDataScrollRefreshViewStateRelease:
                            if(offset < 0.0f) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = 0.0f;
                                }
                                _pullToLoadView.state = MobilyDataScrollRefreshViewStateIdle;
                                contentInset.bottom = 0.0f;
                            } else if(offset >= pullToLoadSize) {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -pullToLoadSize;
                                }
                                if(_pullToLoadView.state != MobilyDataScrollRefreshViewStateRelease) {
                                    _pullToLoadView.state = MobilyDataScrollRefreshViewStateRelease;
                                    contentInset.bottom = offset;
                                }
                            } else {
                                if(_constraintPullToLoadTop != nil) {
                                    _constraintPullToLoadTop.constant = -offset;
                                }
                                _pullToLoadView.state = MobilyDataScrollRefreshViewStatePull;
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
                    _pullToLoadView.state = MobilyDataScrollRefreshViewStateIdle;
                    contentInset.bottom = 0.0f;
                }
            }
        }
        self.scrollIndicatorInsets = contentInset;
        self.contentInset = contentInset;
        self.contentOffset = contentOffset;
    }
}

- (void)internalDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if(_pullDragging == YES) {
        if(_canPullToRefresh == YES) {
            switch(_pullToRefreshView.state) {
                case MobilyDataScrollRefreshViewStateRelease: {
                    if([self containsEventForKey:MobilyDataScrollViewPullToRefreshTriggered] == YES) {
                        [self showPullToRefreshAnimated:YES complete:^(BOOL finished) {
                            [self performEventForKey:MobilyDataScrollViewPullToRefreshTriggered byObject:_pullToRefreshView];
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
                case MobilyDataScrollRefreshViewStateRelease: {
                    if([self containsEventForKey:MobilyDataScrollViewPullToLoadTriggered] == YES) {
                        [self showPullToLoadAnimated:YES complete:^(BOOL finished) {
                            [self performEventForKey:MobilyDataScrollViewPullToLoadTriggered byObject:_pullToLoadView];
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

#pragma mark Private

- (void)internalBatchUpdate:(MobilyDataWidgetUpdateBlock)update {
    self.updating = YES;
    [_container didBeginUpdate];
    if(update != nil) {
        update();
    }
    [self validateLayoutIfNeed];
    [self layoutForVisible];
    for(id< MobilyDataItem > item in _reloadedBeforeItems) {
        UIView< MobilyDataItemView >* view = item.view;
        if(view != nil) {
            [view animateAction:MobilyDataItemViewActionReplaceOut];
        }
    }
    for(id< MobilyDataItem > item in _reloadedAfterItems) {
        UIView< MobilyDataItemView >* view = item.view;
        if(view != nil) {
            [view animateAction:MobilyDataItemViewActionReplaceIn];
        }
    }
    for(id< MobilyDataItem > item in _insertedItems) {
        UIView< MobilyDataItemView >* view = item.view;
        if(view != nil) {
            [view animateAction:MobilyDataItemViewActionInsert];
        }
    }
    for(id< MobilyDataItem > item in _deletedItems) {
        UIView< MobilyDataItemView >* view = item.view;
        if(view != nil) {
            [view animateAction:MobilyDataItemViewActionDelete];
        }
    }
}

- (void)internalBatchComplete:(MobilyDataWidgetUpdateBlock)complete {
    if(_reloadedBeforeItems.count > 0) {
        for(id< MobilyDataItem > item in _reloadedBeforeItems) {
            [item disappear];
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
        for(id< MobilyDataItem > item in _deletedItems) {
            [item disappear];
        }
        [_deletedItems removeAllObjects];
    }
    [_container didEndUpdate];
    self.updating = NO;
    [self layoutForVisible];
    
    if(complete != nil) {
        complete();
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataScrollViewDelegateProxy

#pragma mark Init / Free

- (instancetype)initWithDataScrollView:(MobilyDataScrollView*)dataScrollView {
    self = [super init];
    if(self != nil) {
        self.dataScrollView = dataScrollView;
    }
    return self;
}

- (void)dealloc {
    self.dataScrollView = nil;
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
    [_dataScrollView internalWillBeginDragging];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [_dataScrollView internalDidScroll];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [_dataScrollView internalDidEndDraggingWillDecelerate:decelerate];
    if([_delegate respondsToSelector:_cmd] == YES) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

NSString* MobilyDataScrollViewPullToRefreshTriggered = @"MobilyDataScrollViewPullToRefreshTriggered";
NSString* MobilyDataScrollViewPullToLoadTriggered = @"MobilyDataScrollViewPullToLoadTriggered";

/*--------------------------------------------------*/
