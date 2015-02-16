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

#import "MobilyDataContainer.h"

/*--------------------------------------------------*/

@interface MobilyDataContainer ()

@property(nonatomic, readwrite, strong) NSMutableArray* unsafeSnapToEdgeItems;
@property(nonatomic, readwrite, strong) NSMutableArray* unsafeContainers;
@property(nonatomic, readwrite, strong) NSMutableDictionary* unsafeItems;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataContainer

#pragma mark Synthesize

@synthesize widget = _widget;
@synthesize parentContainer = _parentContainer;
@synthesize containersFrame = _containersFrame;
@synthesize itemsFrame = _itemsFrame;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.unsafeSnapToEdgeItems = [NSMutableArray array];
    self.unsafeContainers = [NSMutableArray array];
    self.unsafeItems = [NSMutableDictionary dictionary];
}

- (void)dealloc {
    self.unsafeSnapToEdgeItems = nil;
    self.unsafeContainers = nil;
    self.unsafeItems = nil;
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setWidget:(UIView< MobilyDataWidget >*)widget {
    if(_widget != widget) {
        _widget = widget;
        for(id< MobilyDataContainer > container in _unsafeContainers) {
            container.widget = widget;
        }
        [_unsafeItems enumerateKeysAndObjectsUsingBlock:^(id type, NSArray* items, BOOL* stop) {
            for(id< MobilyDataItem > item in items) {
                item.widget = widget;
            }
        }];
    }
}

- (void)setParentContainer:(id< MobilyDataContainer >)parentContainer {
    if(_parentContainer != parentContainer) {
        if(_parentContainer != nil) {
        }
        _parentContainer = parentContainer;
        if(_parentContainer != nil) {
            self.widget = parentContainer.widget;
        } else {
            self.widget = nil;
        }
    }
}

- (NSArray*)snapToEdgeContainers {
    return _unsafeSnapToEdgeItems;
}

- (NSArray*)containers {
    return _unsafeContainers;
}

- (NSArray*)snapToEdgeItems {
    return _unsafeSnapToEdgeItems;
}

- (NSDictionary*)items {
    return _unsafeItems;
}

- (NSArray*)allItems {
    NSMutableArray* result = [NSMutableArray array];
    for(id< MobilyDataContainer > container in _unsafeContainers) {
        [result addObjectsFromArray:container.allItems];
    }
    [result addObjectsFromArray:[_unsafeItems allValues]];
    return result;
}

#pragma mark Public

- (id< MobilyDataItem >)itemForData:(id)data {
    __block id< MobilyDataItem > result = nil;
    for(id< MobilyDataContainer > container in _unsafeContainers) {
        id< MobilyDataItem > itemInContainer = [container itemForData:data];
        if(itemInContainer != nil) {
            result = itemInContainer;
            break;
        }
    }
    if(result == nil) {
        [_unsafeItems enumerateKeysAndObjectsUsingBlock:^(id type, NSArray* items, BOOL* stop) {
            for(id< MobilyDataItem > item in items) {
                id itemData = item.data;
                if(itemData == data) {
                    result = itemData;
                    *stop = YES;
                    break;
                }
            }
        }];
    }
    return result;
}

- (UIView< MobilyDataItemView >*)itemViewForData:(id)data {
    id< MobilyDataItem > item = [self itemForData:data];
    if(item != nil) {
        return item.view;
    }
    return nil;
}

- (void)addSnapToEdgeItem:(id< MobilyDataItem >)item {
    if([_unsafeSnapToEdgeItems containsObject:item] == NO) {
        [_unsafeSnapToEdgeItems addObject:item];
        item.allowsSnapToEdge = YES;
    }
}

- (void)removeSnapToEdgeItem:(id< MobilyDataItem >)item {
    if([_unsafeSnapToEdgeItems containsObject:item] == YES) {
        [_unsafeSnapToEdgeItems removeObject:item];
        item.allowsSnapToEdge = NO;
    }
}

- (void)prependContainer:(id< MobilyDataContainer >)container {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(container.parentContainer != nil) {
        NSLog(@"ERROR: [%@] prependContainer:%@", self.class, container);
        return;
    }
#endif
    container.parentContainer = self;
    [_unsafeContainers insertObject:container atIndex:0];
    if(_widget != nil) {
        [_widget didInsertItems:container.allItems];
    }
}

- (void)appendContainer:(id< MobilyDataContainer >)container {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(container.parentContainer != nil) {
        NSLog(@"ERROR: [%@] appendContainer:%@", self.class, container);
        return;
    }
#endif
    container.parentContainer = self;
    [_unsafeContainers addObject:container];
    if(_widget != nil) {
        [_widget didInsertItems:container.allItems];
    }
}

- (void)insertContainer:(id< MobilyDataContainer >)container atIndex:(NSUInteger)index {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(container.parentContainer != nil) {
        NSLog(@"ERROR: [%@] insertContainer:%@ atIndex:%d", self.class, container, (int)index);
        return;
    }
#endif
    container.parentContainer = self;
    [_unsafeContainers insertObject:container atIndex:index];
    if(_widget != nil) {
        [_widget didInsertItems:container.allItems];
    }
}

- (void)deleteContainer:(id< MobilyDataContainer >)container {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(container.parentContainer != self) {
        NSLog(@"ERROR: [%@] deleteContainer:%@", self.class, container);
        return;
    }
#endif
    container.parentContainer = nil;
    [_unsafeContainers removeObject:container];
    if(_widget != nil) {
        [_widget didDeleteItems:container.allItems];
    }
}

- (void)replaceOriginContainer:(id< MobilyDataContainer >)originContainer withContainer:(id< MobilyDataContainer >)container {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(originContainer.parentContainer != self) {
        NSLog(@"ERROR: [%@] replaceOriginContainer:%@ withContainer:%@", self.class, originContainer, container);
        return;
    }
    if(container.parentContainer != nil) {
        NSLog(@"ERROR: [%@] replaceOriginContainer:%@ withContainer:%@", self.class, originContainer, container);
        return;
    }
#endif
    NSUInteger containerIndex = [_unsafeContainers indexOfObject:originContainer];
    if(containerIndex != NSNotFound) {
        container.parentContainer = self;
        originContainer.parentContainer = nil;
        [_unsafeContainers replaceObjectAtIndex:containerIndex withObject:container];
        if(_widget != nil) {
            [_widget didReplaceOriginItems:originContainer.allItems withItems:container.allItems];
        }
    }
}

- (void)prependItem:(id< MobilyDataItem >)item {
    [self prependItem:item forType:MobilyDataContainerDefaultType];
}

- (void)prependItem:(id< MobilyDataItem >)item forType:(id)type {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(item.parentContainer != nil) {
        NSLog(@"ERROR: [%@] prependItem:%@", self.class, item);
        return;
    }
#endif
    NSMutableArray* unsafeItems = [_unsafeItems objectForKey:type];
    if(unsafeItems == nil) {
        [_unsafeItems setObject:[NSMutableArray arrayWithObject:item] forKey:type];
    } else {
        [unsafeItems addObject:item];
    }
    [unsafeItems insertObject:item atIndex:0];
    item.parentContainer = self;
    if(_widget != nil) {
        [_widget didInsertItems:@[ item ]];
    }
}

- (void)appendItem:(id< MobilyDataItem >)item {
    [self appendItem:item forType:MobilyDataContainerDefaultType];
}

- (void)appendItem:(id< MobilyDataItem >)item forType:(id)type {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(item.parentContainer != nil) {
        NSLog(@"ERROR: [%@] appendItem:%@", self.class, item);
        return;
    }
#endif
    NSMutableArray* unsafeItems = [_unsafeItems objectForKey:type];
    if(unsafeItems == nil) {
        [_unsafeItems setObject:[NSMutableArray arrayWithObject:item] forKey:type];
    } else {
        [unsafeItems addObject:item];
    }
    item.parentContainer = self;
    if(_widget != nil) {
        [_widget didInsertItems:@[ item ]];
    }
}

- (void)insertItem:(id< MobilyDataItem >)item atIndex:(NSUInteger)index {
    [self insertItem:item atIndex:index forType:MobilyDataContainerDefaultType];
}

- (void)insertItem:(id< MobilyDataItem >)item atIndex:(NSUInteger)index forType:(id)type {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(item.parentContainer != nil) {
        NSLog(@"ERROR: [%@] insertItem:%@ atIndex:%d", self.class, item, (int)index);
        return;
    }
#endif
    NSMutableArray* unsafeItems = [_unsafeItems objectForKey:type];
    if(unsafeItems == nil) {
        [_unsafeItems setObject:[NSMutableArray arrayWithObject:item] forKey:type];
    } else {
        [unsafeItems insertObject:item atIndex:index];
    }
    item.parentContainer = self;
    if(_widget != nil) {
        [_widget didInsertItems:@[ item ]];
    }
}

- (void)deleteItem:(id< MobilyDataItem >)item {
    [self deleteItem:item forType:MobilyDataContainerDefaultType];
}

- (void)deleteItem:(id< MobilyDataItem >)item forType:(id)type {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(item.parentContainer != self) {
        NSLog(@"ERROR: [%@] deleteItem:%@", self.class, item);
        return;
    }
#endif
    NSMutableArray* unsafeItems = [_unsafeItems objectForKey:type];
    if(unsafeItems != nil) {
        [unsafeItems removeObject:item];
        item.parentContainer = nil;
        if(_widget != nil) {
            [_widget didDeleteItems:@[ item ]];
        }
    }
}

- (void)replaceOriginItem:(id< MobilyDataItem >)originItem withItem:(id< MobilyDataItem >)item {
    [self replaceOriginItem:originItem withItem:item forType:MobilyDataContainerDefaultType];
}

- (void)replaceOriginItem:(id< MobilyDataItem >)originItem withItem:(id< MobilyDataItem >)item forType:(id)type {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if(originItem.parentContainer != self) {
        NSLog(@"ERROR: [%@] replaceOriginItem:%@ withItem:%@", self.class, originItem, item);
        return;
    }
    if(item.parentContainer != nil) {
        NSLog(@"ERROR: [%@] replaceOriginItem:%@ withItem:%@", self.class, originItem, item);
        return;
    }
#endif
    NSMutableArray* unsafeItems = [_unsafeItems objectForKey:type];
    if(unsafeItems != nil) {
        NSUInteger itemIndex = [unsafeItems indexOfObject:originItem];
        if(itemIndex != NSNotFound) {
            item.parentContainer = self;
            [unsafeItems replaceObjectAtIndex:itemIndex withObject:item];
            originItem.parentContainer = nil;
            if(_widget != nil) {
                [_widget didReplaceOriginItems:@[ originItem ] withItems:@[ item ]];
            }
        }
    }
}

- (BOOL)containsEventForKey:(id)key {
    return [_widget containsEventForKey:key];
}

- (id)performEventForKey:(id)key byObject:(id)object {
    return [_widget performEventForKey:key bySender:self byObject:object];
}

- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult {
    return [_widget performEventForKey:key bySender:self byObject:object defaultResult:defaultResult];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_widget performEventForKey:key bySender:sender byObject:object];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult {
    return [_widget performEventForKey:key bySender:sender byObject:object defaultResult:defaultResult];
}

- (void)didBeginUpdate {
    for(id< MobilyDataContainer > container in _unsafeContainers) {
        [container didBeginUpdate];
    };
    [_unsafeItems enumerateKeysAndObjectsUsingBlock:^(id type, NSArray* items, BOOL* stop) {
        for(id< MobilyDataItem > item in items) {
            [item didBeginUpdate];
        }
    }];
}

- (void)didEndUpdate {
    for(id< MobilyDataContainer > container in _unsafeContainers) {
        [container didEndUpdate];
    }
    [_unsafeItems enumerateKeysAndObjectsUsingBlock:^(id type, NSArray* items, BOOL* stop) {
        for(id< MobilyDataItem > item in items) {
            [item didEndUpdate];
        }
    }];
}

- (CGRect)validateLayoutForAvailableFrame:(CGRect)frame {
    CGRect result = CGRectNull;
    if(_unsafeContainers.count > 0) {
        self.containersFrame = [self validateContainersLayoutForAvailableFrame:frame];
        if(CGRectIsNull(_containersFrame) == NO) {
            result = _containersFrame;
        }
    }
    if(_unsafeItems.count > 0) {
        self.itemsFrame = [self validateItemsLayoutForAvailableFrame:frame];
        if(CGRectIsNull(_itemsFrame) == NO) {
            if(CGRectIsNull(result) == NO) {
                result = CGRectUnion(result, _itemsFrame);
            } else {
                result = _itemsFrame;
            }
        }
    }
    return result;
}

- (CGRect)validateContainersLayoutForAvailableFrame:(CGRect)frame {
    return CGRectNull;
}

- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame {
    return CGRectNull;
}

- (void)layoutForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds {
    if(_unsafeContainers.count > 0) {
        [self layoutContainersForVisibleBounds:bounds snapBounds:snapBounds];
    }
    if(_unsafeItems.count > 0) {
        if(_unsafeSnapToEdgeItems.count > 0) {
            [self layoutItemsForSnapBounds:CGRectIntersection(snapBounds, _itemsFrame)];
        }
        [self layoutItemsForVisibleBounds:bounds snapBounds:snapBounds];
    }
}

- (void)layoutContainersForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds {
    for(id< MobilyDataContainer > container in _unsafeContainers) {
        [container layoutForVisibleBounds:bounds snapBounds:snapBounds];
    };
}

- (void)layoutItemsForVisibleBounds:(CGRect)bounds snapBounds:(CGRect)snapBounds {
    [_unsafeItems enumerateKeysAndObjectsUsingBlock:^(id type, NSArray* items, BOOL* stop) {
        for(id< MobilyDataItem > item in items) {
            [item validateLayoutForVisibleBounds:bounds forType:type];
        }
    }];
}

- (void)layoutItemsForSnapBounds:(CGRect)bounds {
    for(id< MobilyDataItem > item in self.snapToEdgeItems) {
        item.displayFrame = item.updateFrame;
    }
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataContainerDefaultType = @"MobilyDataContainerDefaultType";

/*--------------------------------------------------*/
