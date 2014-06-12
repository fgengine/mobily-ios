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

#import "MobilyViewElements.h"

/*--------------------------------------------------*/

@interface MobilyViewElements ()

// Protocol access
@property(nonatomic, readwrite, assign) BOOL elementsDelegateShowCellAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateHideCellAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateShouldSelectItemAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateShouldDeselectItemAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateDidSelectItemAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateDidDeselectItemAtIndex;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateAnimationReloadBeforeElementsCell;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateAnimationReloadAfterElementsCell;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateAnimationInsertElementsCell;
@property(nonatomic, readwrite, assign) BOOL elementsDelegateAnimationDeleteElementsCell;

@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeReloadRangeBeloadBeforeItemsReloadAfterItems;
@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeReloadIndexSet;
@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeInsertRangeInsertItems;
@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeInsertIndexSet;
@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeDeleteRangeDeleteItems;
@property(nonatomic, readwrite, assign) BOOL elementsLayoutItemsItemsSizeDeleteIndexSet;

// Change access
@property(nonatomic, readwrite, strong) NSMutableArray* items;
@property(nonatomic, readwrite, strong) NSMutableIndexSet* mutableVisibleIndexSet;
@property(nonatomic, readwrite, strong) NSMutableIndexSet* mutableSelectedIndexSet;

@property(nonatomic, readwrite, assign, getter = isUpdating) BOOL updating;
@property(nonatomic, readwrite, assign) CGSize updatingContentSize;

// Private
@property(nonatomic, readwrite, strong) NSMutableDictionary* registersCells;
@property(nonatomic, readwrite, strong) NSMutableDictionary* queueCells;

@property(nonatomic, readwrite, strong) NSMutableArray* reloadedBeforeItems;
@property(nonatomic, readwrite, strong) NSMutableArray* reloadedAfterItems;
@property(nonatomic, readwrite, strong) NSMutableArray* deletedItems;
@property(nonatomic, readwrite, strong) NSMutableArray* insertedItems;

- (void)notificationReceiveMemoryWarning:(NSNotification*)notification;

- (MobilyViewElementsCell*)dequeueCellWithElementsItem:(MobilyViewElementsItem*)item;
- (void)enqueueCellWithElementsItem:(MobilyViewElementsItem*)item;

- (void)layoutItems;
- (void)applyLayoutItems;
- (void)updateVisibleItems;

- (void)selectItemAtElementsCell:(MobilyViewElementsCell*)cell animated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyViewElementsCell ()

@property(nonatomic, readwrite, weak) MobilyViewElements* elements;
@property(nonatomic, readwrite, weak) MobilyViewElementsItem* elementsItem;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyViewElementsItem ()

@property(nonatomic, readwrite, weak) MobilyViewElements* elements;
@property(nonatomic, readwrite, weak) MobilyViewElementsCell* elementsCell;

@property(nonatomic, readwrite, assign) NSUInteger index;
@property(nonatomic, readwrite, strong) NSString* identifier;
@property(nonatomic, readwrite, assign, getter = isSelected) BOOL selected;

- (id)initWithElements:(MobilyViewElements*)elements;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyViewElementsRegisterCell : NSObject

@property(nonatomic ,readwrite, assign) Class cellClass;
@property(nonatomic ,readwrite, strong) UINib* cellNib;

- (id)initWithCellClass:(Class)cellClass;
- (id)initWithCellClass:(Class)cellClass cellNib:(UINib*)cellNib;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewElements

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    [self setItems:nil];
    [self setMutableVisibleIndexSet:nil];
    [self setMutableSelectedIndexSet:nil];
    [self setRegistersCells:nil];
    [self setQueueCells:nil];
    [self setReloadedBeforeItems:nil];
    [self setReloadedAfterItems:nil];
    [self setDeletedItems:nil];
    [self setInsertedItems:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovedObject:objectChild]];
        [self removeSubview:(UIView*)objectChild];
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
    
    [self updateVisibleItems];
}

#pragma mark NSNotificationCenter

- (void)notificationReceiveMemoryWarning:(NSNotification*)notification {
    [_queueCells removeAllObjects];
}

#pragma mark UIKeyboarNotification

- (void)notificationKeyboardShow:(NSNotification*)notification {
    UIResponder* currentResponder = [UIResponder currentFirstResponder];
    if(currentResponder != nil) {
        if([currentResponder isKindOfClass:[UIView class]] == YES) {
            UIView* view = (UIView*)currentResponder;
            NSDictionary* info = [notification userInfo];
            if(info != nil) {
                CGRect screenRect = [[self window] bounds];
                CGRect scrollRect = [self convertRect:[self bounds] toView:[[[self window] rootViewController] view]];
                CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                UIEdgeInsets scrollInsets = [self contentInset];
                CGPoint scrollOffset = [self contentOffset];
                CGSize scrollSize = [self contentSize];
                
                CGFloat overallSize = 0.0f;
                switch([[UIApplication sharedApplication] statusBarOrientation]) {
                    case UIInterfaceOrientationPortrait:
                    case UIInterfaceOrientationPortraitUpsideDown:
                        overallSize = ABS((screenRect.size.height - keyboardRect.size.height) - (scrollRect.origin.y + scrollRect.size.height));
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                    case UIInterfaceOrientationLandscapeRight:
                        overallSize = ABS((screenRect.size.width - keyboardRect.size.width) - (scrollRect.origin.y + scrollRect.size.height));
                        break;
                }
                scrollInsets = UIEdgeInsetsMake(scrollInsets.top, scrollInsets.left, overallSize, scrollInsets.right);
                [self setScrollIndicatorInsets:scrollInsets];
                [self setContentInset:scrollInsets];
                
                scrollRect = UIEdgeInsetsInsetRect(scrollRect, scrollInsets);
                
                CGRect rect = [view convertRect:[view bounds] toView:self];
                scrollOffset.y = (rect.origin.y + (rect.size.height * 0.5f)) - (scrollRect.size.height * 0.5f);
                if(scrollOffset.y < 0.0f) {
                    scrollOffset.y = 0.0f;
                } else if(scrollOffset.y > scrollSize.height - scrollRect.size.height) {
                    scrollOffset.y = scrollSize.height - scrollRect.size.height;
                }
                [self setContentOffset:scrollOffset animated:YES];
            }
        }
    }
}

- (void)notificationKeyboardHide:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    if(info != nil) {
        NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration
                         animations:^{
                             [self setScrollIndicatorInsets:UIEdgeInsetsZero];
                             [self setContentInset:UIEdgeInsetsZero];
                         }];
    }
}

#pragma mark Public

- (void)setupView {
    [self setAllowsSelection:YES];
    [self setAllowsMultipleSelection:NO];
    
    [self setItems:[NSMutableArray array]];
    [self setMutableVisibleIndexSet:[NSMutableIndexSet indexSet]];
    [self setMutableSelectedIndexSet:[NSMutableIndexSet indexSet]];
    [self setRegistersCells:[NSMutableDictionary dictionary]];
    [self setQueueCells:[NSMutableDictionary dictionary]];
    [self setReloadedBeforeItems:[NSMutableArray array]];
    [self setReloadedAfterItems:[NSMutableArray array]];
    [self setDeletedItems:[NSMutableArray array]];
    [self setInsertedItems:[NSMutableArray array]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerCellClass:(Class)cellClass withIdentifier:(NSString*)identifier {
    [_registersCells setObject:[[MobilyViewElementsRegisterCell alloc] initWithCellClass:cellClass] forKey:identifier];
}

- (void)registerCellClass:(Class)cellClass fromNib:(UINib*)nib withIdentifier:(NSString*)identifier {
    [_registersCells setObject:[[MobilyViewElementsRegisterCell alloc] initWithCellClass:cellClass cellNib:nib] forKey:identifier];
}

- (void)unregisterCellWithIdentifier:(NSString*)identifier {
    [_registersCells removeObjectForKey:identifier];
}

- (MobilyViewElementsItem*)itemAtIndex:(NSUInteger)index {
    if(index >= [_items count]) {
        return nil;
    }
    return [_items objectAtIndex:index];
}

- (NSUInteger)indexAtItem:(MobilyViewElementsItem*)item {
    return [_items indexOfObject:item];
}

- (BOOL)isSelectedItem:(MobilyViewElementsItem*)item {
    return [self isSelectedItemAtIndex:[self indexAtItem:item]];
}

- (BOOL)isSelectedItemAtIndex:(NSUInteger)index {
    if(index >= [_items count]) {
        return NO;
    }
    return [_mutableSelectedIndexSet containsIndex:index];
}

- (BOOL)shouldSelectItem:(MobilyViewElementsItem*)item {
    return [self shouldSelectItemAtIndex:[self indexAtItem:item]];
}

- (BOOL)shouldSelectItemAtIndex:(NSUInteger)index {
    if(index >= [_items count]) {
        return NO;
    }
    if(_elementsDelegateShouldSelectItemAtIndex == YES) {
        return [_elementsDelegate elements:self shouldSelectItemAtIndex:index];
    }
    return YES;
}

- (BOOL)shouldDeselectItem:(MobilyViewElementsItem*)item {
    return [self shouldDeselectItemAtIndex:[self indexAtItem:item]];
}

- (BOOL)shouldDeselectItemAtIndex:(NSUInteger)index {
    if(index >= [_items count]) {
        return NO;
    }
    if(_elementsDelegateShouldDeselectItemAtIndex == YES) {
        return [_elementsDelegate elements:self shouldDeselectItemAtIndex:index];
    }
    return YES;
}

- (void)selectItem:(MobilyViewElementsItem*)item animated:(BOOL)animated {
    [self selectItemAtIndex:[self indexAtItem:item] animated:animated];
}

- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if(index >= [_items count]) {
        return;
    }
    if([_mutableSelectedIndexSet containsIndex:index] == NO) {
        if(_allowsMultipleSelection == YES) {
            if([self shouldSelectItemAtIndex:index] == YES) {
                [_mutableSelectedIndexSet addIndex:index];
                MobilyViewElementsItem* item = [_items objectAtIndex:index];
                [item setSelected:YES];
                MobilyViewElementsCell* cell = [item elementsCell];
                if(cell != nil) {
                    [cell setSelected:YES animated:animated];
                }
                if(_elementsDelegateDidSelectItemAtIndex == YES) {
                    [_elementsDelegate elements:self didSelectItemAtIndex:index];
                }
            }
        } else {
            if([self shouldSelectItemAtIndex:index] == YES) {
                if([_mutableSelectedIndexSet count] > 0) {
                    [_items enumerateObjectsAtIndexes:_mutableSelectedIndexSet options:0 usingBlock:^(MobilyViewElementsItem* item, NSUInteger elementsIndex, BOOL* stop) {
                        [item setSelected:NO];
                        MobilyViewElementsCell* cell = [item elementsCell];
                        if(cell != nil) {
                            [cell setSelected:NO animated:animated];
                        }
                    }];
                    [_mutableSelectedIndexSet removeAllIndexes];
                }
                [_mutableSelectedIndexSet addIndex:index];
                MobilyViewElementsItem* item = [_items objectAtIndex:index];
                [item setSelected:YES];
                MobilyViewElementsCell* cell = [item elementsCell];
                if(cell != nil) {
                    [cell setSelected:YES animated:animated];
                }
                if(_elementsDelegateDidSelectItemAtIndex == YES) {
                    [_elementsDelegate elements:self didSelectItemAtIndex:index];
                }
            }
        }
    }
}

- (void)deselectItem:(MobilyViewElementsItem*)item animated:(BOOL)animated {
    [self deselectItemAtIndex:[self indexAtItem:item] animated:animated];
}

- (void)deselectItemAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if(index >= [_items count]) {
        return;
    }
    if([_mutableSelectedIndexSet containsIndex:index] == YES) {
        if([self shouldDeselectItemAtIndex:index] == YES) {
            [_mutableSelectedIndexSet removeIndex:index];
            MobilyViewElementsItem* item = [_items objectAtIndex:index];
            [item setSelected:NO];
            MobilyViewElementsCell* cell = [item elementsCell];
            if(cell != nil) {
                [cell setSelected:NO animated:animated];
            }
            if(_elementsDelegateDidDeselectItemAtIndex == YES) {
                [_elementsDelegate elements:self didDeselectItemAtIndex:index];
            }
        }
    }
}

- (void)deselectAllSelectedItemsAnimated:(BOOL)animated {
    [_mutableSelectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger selectedIndex, BOOL* stop) {
        [self deselectItemAtIndex:selectedIndex animated:animated];
    }];
}

- (void)scrollToItem:(MobilyViewElementsItem*)item scrollPosition:(MobilyViewElementsScrollPosition)scrollPosition animated:(BOOL)animated {
    [self scrollToItemAtIndex:[self indexAtItem:item] scrollPosition:scrollPosition animated:animated];
}

- (void)scrollToItemAtIndex:(NSUInteger)index scrollPosition:(MobilyViewElementsScrollPosition)scrollPosition animated:(BOOL)animated {
    if(index >= [_items count]) {
        return;
    }
    NSUInteger vPosition = scrollPosition & 0x07;
    NSUInteger hPosition = scrollPosition & 0x38;
    if((vPosition != MobilyViewElementsScrollPositionNone) && (vPosition != MobilyViewElementsScrollPositionTop) && (vPosition != MobilyViewElementsScrollPositionCenteredVertically) && (vPosition != MobilyViewElementsScrollPositionBottom)) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"MobilyViewElementsScrollPosition: attempt to use a scroll position with multiple vertical positioning styles" userInfo:nil];
    }
    if((hPosition != MobilyViewElementsScrollPositionNone) && (hPosition != MobilyViewElementsScrollPositionLeft) && (hPosition != MobilyViewElementsScrollPositionCenteredHorizontally) && (hPosition != MobilyViewElementsScrollPositionRight)) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"MobilyViewElementsScrollPosition: attempt to use a scroll position with multiple horizontal positioning styles" userInfo:nil];
    }
    CGRect visibleRect = [self bounds];
    UIEdgeInsets contentInset = [self contentInset];
    MobilyViewElementsItem* item = [_items objectAtIndex:index];
    CGRect itemFrame = [item frame];
    switch(vPosition) {
        case MobilyViewElementsScrollPositionCenteredVertically: {
            CGFloat offset = fmax(itemFrame.origin.y - ((visibleRect.size.height * 0.5f) - (itemFrame.size.height * 0.5f)), -contentInset.top);
            itemFrame = CGRectMake(itemFrame.origin.x, offset, itemFrame.size.width, visibleRect.size.height);
            break;
        }
        case MobilyViewElementsScrollPositionTop: {
            itemFrame = CGRectMake(itemFrame.origin.x, itemFrame.origin.y, itemFrame.size.width, visibleRect.size.height);
            break;
        }
        case MobilyViewElementsScrollPositionBottom: {
            CGFloat offset = fmax(itemFrame.origin.y - (visibleRect.size.height - itemFrame.size.height), -contentInset.top);
            itemFrame = CGRectMake(itemFrame.origin.x, offset, itemFrame.size.width, visibleRect.size.height);
            break;
        }
    }
    switch(hPosition) {
        case MobilyViewElementsScrollPositionLeft: {
            itemFrame = CGRectMake(itemFrame.origin.x, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
        case MobilyViewElementsScrollPositionCenteredHorizontally: {
            CGFloat offset = itemFrame.origin.x - ((visibleRect.size.width * 0.5f) - (itemFrame.size.width * 0.5f));
            itemFrame = CGRectMake(offset, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
        case MobilyViewElementsScrollPositionRight: {
            CGFloat offset = itemFrame.origin.x - (visibleRect.size.width - itemFrame.size.width);
            itemFrame = CGRectMake(offset, itemFrame.origin.y, visibleRect.size.width, itemFrame.size.height);
            break;
        }
    }
    [self scrollRectToVisible:itemFrame animated:animated];
}

- (void)reloadItems {
    if(_updating == NO) {
        [UIView performWithoutAnimation:^{
            [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger elementsIndex, BOOL* stop) {
                [self enqueueCellWithElementsItem:item];
            }];
            [_mutableVisibleIndexSet removeAllIndexes];
            
            NSUInteger itemsCount = [_items count];
            NSUInteger count = [_elementsDataSource numberOfItemsInElements:self];
            if(itemsCount > count) {
                NSUInteger removeCount = itemsCount - count;
                NSRange removeRange = NSMakeRange(itemsCount - removeCount, removeCount);
                [_items removeObjectsInRange:removeRange];
                [_mutableSelectedIndexSet removeIndexesInRange:removeRange];
                itemsCount = count;
            }
            if([_items count] > 0) {
                [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger elementsIndex, BOOL* stop) {
                    [item setIdentifier:[_elementsDataSource elements:self itemIdentifierAtIndex:elementsIndex]];
                    [item setInitialFrameSize:[_elementsDataSource elements:self itemSizeAtIndex:elementsIndex]];
                    [item setFrame:[item initialFrame]];
                }];
            }
            if(count > 0) {
                for(NSUInteger index = itemsCount; index < count; index++) {
                    MobilyViewElementsItem* item = [[MobilyViewElementsItem alloc] initWithElements:self];
                    if(item != nil) {
                        [item setIndex:index];
                        [item setIdentifier:[_elementsDataSource elements:self itemIdentifierAtIndex:index]];
                        [item setInitialFrameSize:[_elementsDataSource elements:self itemSizeAtIndex:index]];
                        [item setFrame:[item initialFrame]];
                        
                        [_items addObject:item];
                    }
                }
                [self layoutItems];
            }
            [self updateVisibleItems];
            [self applyLayoutItems];
        }];
    } else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"reloadData - The method should be called in batch update block" userInfo:nil];
    }
}

- (void)reloadItemAtIndexSet:(NSIndexSet*)indexSet {
    if(_updating == YES) {
        if(indexSet == nil) {
            return;
        }
        if([indexSet count] > 0) {
            [indexSet enumerateRangesWithOptions:NSEnumerationReverse usingBlock:^(NSRange reloadRange, BOOL* stop) {
                [_mutableVisibleIndexSet removeIndexesInRange:reloadRange];
                
                NSArray* reloadBeforeItems = [_items subarrayWithRange:reloadRange];
                if(reloadBeforeItems != nil) {
                    [_reloadedBeforeItems addObjectsFromArray:reloadBeforeItems];
                }
                for(NSUInteger index = reloadRange.location; index < (reloadRange.location + reloadRange.length); index++) {
                    MobilyViewElementsItem* item = [[MobilyViewElementsItem alloc] initWithElements:self];
                    if(item != nil) {
                        [item setIndex:index];
                        [item setSelected:[_mutableSelectedIndexSet containsIndex:index]];
                        [item setIdentifier:[_elementsDataSource elements:self itemIdentifierAtIndex:index]];
                        [item setInitialFrameSize:[_elementsDataSource elements:self itemSizeAtIndex:index]];
                        [item setFrame:[item initialFrame]];
                        
                        [_items replaceObjectAtIndex:index withObject:item];
                    }
                }
                NSArray* reloadAfterItems = [_items subarrayWithRange:reloadRange];
                if(reloadAfterItems != nil) {
                    [_reloadedAfterItems addObjectsFromArray:reloadAfterItems];
                }
                if(_elementsLayoutItemsItemsSizeReloadRangeBeloadBeforeItemsReloadAfterItems == YES) {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize reloadRange:reloadRange reloadBeforeItems:reloadBeforeItems reloadAfterItems:reloadAfterItems]];
                }
            }];
            if(_elementsLayoutItemsItemsSizeReloadRangeBeloadBeforeItemsReloadAfterItems == NO) {
                if(_elementsLayoutItemsItemsSizeReloadIndexSet == YES) {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize reloadIndexSet:indexSet]];
                } else {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items]];
                }
            }
        }
    } else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"reloadItemAtIndexSet: - The method should be called in batch update block" userInfo:nil];
    }
}

- (void)insertItemAtIndexSet:(NSIndexSet*)indexSet {
    if(_updating == YES) {
        if(indexSet == nil) {
            return;
        }
        if([indexSet count] > 0) {
            [indexSet enumerateRangesWithOptions:NSEnumerationReverse usingBlock:^(NSRange insertRange, BOOL* stop) {
                [_mutableVisibleIndexSet shiftIndexesStartingAtIndex:insertRange.location by:insertRange.length];
                [_mutableSelectedIndexSet shiftIndexesStartingAtIndex:insertRange.location by:insertRange.length];
                
                NSMutableArray* insertItems = [NSMutableArray arrayWithCapacity:insertRange.length];
                for(NSUInteger index = insertRange.location; index < (insertRange.location + insertRange.length); index++) {
                    MobilyViewElementsItem* item = [[MobilyViewElementsItem alloc] initWithElements:self];
                    if(item != nil) {
                        [item setSelected:[_mutableSelectedIndexSet containsIndex:index]];
                        [item setIdentifier:[_elementsDataSource elements:self itemIdentifierAtIndex:index]];
                        [item setInitialFrameSize:[_elementsDataSource elements:self itemSizeAtIndex:index]];
                        [item setFrame:[item initialFrame]];
                        
                        [_items insertObject:item atIndex:index];
                        [insertItems addObject:item];
                    }
                }
                [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                    [item setIndex:index];
                }];
                [_insertedItems addObjectsFromArray:insertItems];
                if(_elementsLayoutItemsItemsSizeInsertRangeInsertItems == YES) {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize insertRange:insertRange insertItems:insertItems]];
                }
            }];
            if(_elementsLayoutItemsItemsSizeInsertRangeInsertItems == NO) {
                if(_elementsLayoutItemsItemsSizeInsertIndexSet == YES) {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize insertIndexSet:indexSet]];
                } else {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items]];
                }
            }
        }
    } else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"insertItemAtIndexSet: - The method should be called in batch update block" userInfo:nil];
    }
}

- (void)deleteItemAtIndexSet:(NSIndexSet*)indexSet {
    if(_updating == YES) {
        if(indexSet == nil) {
            return;
        }
        if([indexSet count] > 0) {
            [indexSet enumerateRangesWithOptions:NSEnumerationReverse usingBlock:^(NSRange deleteRange, BOOL* stop) {
                NSArray* deletedItems = [_items subarrayWithRange:deleteRange];
                if(deletedItems != nil) {
                    if(_elementsLayoutItemsItemsSizeDeleteRangeDeleteItems == YES) {
                        [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize deleteRange:deleteRange deleteItems:deletedItems]];
                    }
                    [_mutableVisibleIndexSet removeIndexesInRange:deleteRange];
                    [_mutableSelectedIndexSet removeIndexesInRange:deleteRange];
                    
                    [_items removeObjectsInRange:deleteRange];
                    [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                        [item setIndex:index];
                    }];
                    [_deletedItems addObjectsFromArray:deletedItems];
                }
            }];
            if(_elementsLayoutItemsItemsSizeDeleteRangeDeleteItems == NO) {
                if(_elementsLayoutItemsItemsSizeDeleteIndexSet == YES) {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items itemsSize:_updatingContentSize deleteIndexSet:indexSet]];
                } else {
                    [self setUpdatingContentSize:[_elementsLayout elements:self layoutItems:_items]];
                }
            }
        }
    } else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"deleteItemAtIndexSet: - The method should be called in batch update block" userInfo:nil];
    }
}

- (void)performBatchUpdate:(FGElementsUpdateBlock)update complete:(FGElementsCompleteBlock)complete {
    [self performBatchDuration:0.33f update:update complete:complete];
}

- (void)performBatchDuration:(NSTimeInterval)duration update:(FGElementsUpdateBlock)update complete:(FGElementsCompleteBlock)complete {
    if(_updating == NO) {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:0
                         animations:^{
                             [self setUpdating:YES];
                             [self setUpdatingContentSize:[self contentSize]];
                             
                             update();
                             
                             if([_items count] > 0) {
                                 [_mutableVisibleIndexSet removeIndexesInRange:NSMakeRange([_items count] - 1, INT_MAX)];
                             } else {
                                 [_mutableVisibleIndexSet removeAllIndexes];
                             }
                             [self setContentSize:_updatingContentSize];
                             [self updateVisibleItems];
                             [self applyLayoutItems];
                             
                             [_reloadedBeforeItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                 MobilyViewElementsCell* cell = [item elementsCell];
                                 if(cell != nil) {
                                     if(_elementsDelegateAnimationReloadBeforeElementsCell == YES) {
                                         [_elementsDelegate elements:self animationReloadBeforeElementsCell:cell];
                                     } else {
                                         [[cell layer] setZPosition:-1.0f];
                                         [cell setAlpha:0.0f];
                                     }
                                 }
                             }];
                             [_reloadedAfterItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                 MobilyViewElementsCell* cell = [item elementsCell];
                                 if(cell != nil) {
                                     if(_elementsDelegateAnimationReloadAfterElementsCell == YES) {
                                         [_elementsDelegate elements:self animationReloadAfterElementsCell:cell];
                                     } else {
                                         [UIView performWithoutAnimation:^{
                                             [cell setAlpha:0.0f];
                                         }];
                                         [[cell layer] setZPosition:1.0f];
                                         [cell setAlpha:1.0f];
                                     }
                                 }
                             }];
                             [_insertedItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                 MobilyViewElementsCell* cell = [item elementsCell];
                                 if(cell != nil) {
                                     if(_elementsDelegateAnimationInsertElementsCell == YES) {
                                         [_elementsDelegate elements:self animationInsertElementsCell:cell];
                                     } else {
                                         [UIView performWithoutAnimation:^{
                                             [cell setAlpha:0.0f];
                                         }];
                                         [[cell layer] setZPosition:-1.0f];
                                         [cell setAlpha:1.0f];
                                     }
                                 }
                             }];
                             [_deletedItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                 MobilyViewElementsCell* cell = [item elementsCell];
                                 if(cell != nil) {
                                     if(_elementsDelegateAnimationDeleteElementsCell == YES) {
                                         [_elementsDelegate elements:self animationDeleteElementsCell:cell];
                                     } else {
                                         [[cell layer] setZPosition:-1.0f];
                                         [cell setAlpha:0.0f];
                                     }
                                 }
                             }];
                         }
                         completion:^(BOOL finished) {
                             if([_reloadedBeforeItems count] > 0) {
                                 [_reloadedBeforeItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                     MobilyViewElementsCell* cell = [item elementsCell];
                                     if(cell != nil) {
                                         [cell setElementsItem:nil];
                                         [cell removeFromSuperview];
                                     }
                                 }];
                                 [_reloadedBeforeItems removeAllObjects];
                             }
                             if([_reloadedAfterItems count] > 0) {
                                 [_reloadedAfterItems removeAllObjects];
                             }
                             if([_insertedItems count] > 0) {
                                 [_insertedItems removeAllObjects];
                             }
                             if([_deletedItems count] > 0) {
                                 [_deletedItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                                     MobilyViewElementsCell* cell = [item elementsCell];
                                     if(cell != nil) {
                                         [cell setElementsItem:nil];
                                         [cell removeFromSuperview];
                                     }
                                 }];
                                 [_deletedItems removeAllObjects];
                             }
                             [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger elementsIndex, BOOL* stop) {
                                 [item setInitialFrame:[item frame]];
                             }];
                             [self setUpdating:NO];
                             [self updateVisibleItems];
                             [self applyLayoutItems];
                             
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
    }
}

#pragma mark Property

- (void)setElementsDataSource:(id< MobilyViewElementsDataSource >)elementsDataSource {
    if(_elementsDataSource != elementsDataSource) {
        _elementsDataSource = elementsDataSource;
    }
}

- (void)setElementsDelegate:(id< MobilyViewElementsDelegate >)elementsDelegate {
    if(_elementsDelegate != elementsDelegate) {
        _elementsDelegate = elementsDelegate;
        
        [self setElementsDelegateShowCellAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:showCell:atIndex:)]];
        [self setElementsDelegateHideCellAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:hideCell:atIndex:)]];
        [self setElementsDelegateShouldSelectItemAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:shouldSelectItemAtIndex:)]];
        [self setElementsDelegateShouldDeselectItemAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:shouldDeselectItemAtIndex:)]];
        [self setElementsDelegateDidSelectItemAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:didSelectItemAtIndex:)]];
        [self setElementsDelegateDidDeselectItemAtIndex:[_elementsDelegate respondsToSelector:@selector(elements:didDeselectItemAtIndex:)]];
        [self setElementsDelegateAnimationReloadBeforeElementsCell:[_elementsDelegate respondsToSelector:@selector(elements:animationReloadBeforeElementsCell:)]];
        [self setElementsDelegateAnimationReloadAfterElementsCell:[_elementsDelegate respondsToSelector:@selector(elements:animationReloadAfterElementsCell:)]];
        [self setElementsDelegateAnimationInsertElementsCell:[_elementsDelegate respondsToSelector:@selector(elements:animationInsertElementsCell:)]];
        [self setElementsDelegateAnimationDeleteElementsCell:[_elementsDelegate respondsToSelector:@selector(elements:animationDeleteElementsCell:)]];
    }
}

- (void)setElementsLayout:(id< MobilyViewElementsLayout >)elementsLayout {
    if(_elementsLayout != elementsLayout) {
        _elementsLayout = elementsLayout;
        
        [self setElementsLayoutItemsItemsSizeReloadRangeBeloadBeforeItemsReloadAfterItems:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:reloadRange:reloadBeforeItems:reloadAfterItems:)]];
        [self setElementsLayoutItemsItemsSizeReloadIndexSet:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:reloadIndexSet:)]];
        [self setElementsLayoutItemsItemsSizeInsertRangeInsertItems:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:insertRange:insertItems:)]];
        [self setElementsLayoutItemsItemsSizeInsertIndexSet:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:insertIndexSet:)]];
        [self setElementsLayoutItemsItemsSizeDeleteRangeDeleteItems:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:deleteRange:deleteItems:)]];
        [self setElementsLayoutItemsItemsSizeDeleteIndexSet:[_elementsLayout respondsToSelector:@selector(elements:layoutItems:itemsSize:deleteIndexSet:)]];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldFrame = [self frame];
    BOOL isSizeChanged = (CGSizeEqualToSize(oldFrame.size, frame.size) == NO);
    [super setFrame:frame];
    if(isSizeChanged == YES) {
        if((_updating == NO) && ([_items count] > 0)) {
            [self layoutItems];
            [self applyLayoutItems];
        }
    }
}

- (void)setBounds:(CGRect)bounds {
    CGRect oldBounds = [self bounds];
    BOOL isSizeChanged = (CGSizeEqualToSize(oldBounds.size, bounds.size) == NO);
    [super setBounds:bounds];
    if(isSizeChanged == YES) {
        if((_updating == NO) && ([_items count] > 0)) {
            [self layoutItems];
            [self applyLayoutItems];
        }
    }
}

- (NSIndexSet*)visibleIndexSet {
    return [_mutableVisibleIndexSet copy];
}

- (NSArray*)visibleItems {
    NSArray* result = [NSArray array];
    if([_items count] > 0) {
        if([_mutableVisibleIndexSet count] > 0) {
            result = [_items objectsAtIndexes:_mutableVisibleIndexSet];
        }
    }
    return result;
}

- (NSArray*)visibleCells {
    NSMutableArray* result = [NSMutableArray array];
    if([_items count] > 0) {
        if([_mutableVisibleIndexSet count] > 0) {
            [_items enumerateObjectsAtIndexes:_mutableVisibleIndexSet options:0 usingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
                if([item elementsCell] != nil) {
                    [result addObject:[item elementsCell]];
                }
            }];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (NSIndexSet*)selectedIndexSet {
    return [_mutableSelectedIndexSet copy];
}

- (NSUInteger)selectedIndex {
    if([_mutableSelectedIndexSet count] > 0) {
        return [_mutableSelectedIndexSet firstIndex];
    }
    return NSNotFound;
}

- (NSArray*)selectedItems {
    NSArray* result = [NSArray array];
    if([_items count] > 0) {
        result = [_items objectsAtIndexes:_mutableSelectedIndexSet];
    }
    return result;
}

- (NSArray*)selectedCells {
    NSMutableArray* result = [NSMutableArray array];
    if(([_items count] > 0) && ([_mutableSelectedIndexSet count] > 0)) {
        [_items enumerateObjectsAtIndexes:_mutableSelectedIndexSet options:0 usingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
            if([item elementsCell] != nil) {
                [result addObject:[item elementsCell]];
            }
        }];
    }
    return result;
}

#pragma mark Private

- (MobilyViewElementsCell*)dequeueCellWithElementsItem:(MobilyViewElementsItem*)item {
    NSString* identifier = [item identifier];
    NSMutableArray* queue = [_queueCells objectForKey:identifier];
    __block MobilyViewElementsCell* cell = [queue lastObject];
    if(cell != nil) {
        [queue removeLastObject];
    } else {
        MobilyViewElementsRegisterCell* registerCell = [_registersCells objectForKey:identifier];
        if(registerCell != nil) {
            Class cellClass = [registerCell cellClass];
            if(cellClass != nil) {
                UINib* cellNib = [registerCell cellNib];
                if(cellNib != nil) {
                    NSArray* nibObjects = [cellNib instantiateWithOwner:self options:nil];
                    [nibObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
                        if([object isKindOfClass:cellClass] == YES) {
                            [object setElements:self];
                            cell = object;
                            *stop = YES;
                        }
                    }];
                } else {
                    cell = [[cellClass alloc] initWithFrame:[item initialFrame]];
                    if(cell != nil) {
                        [cell setElements:self];
                    }
                }
            }
        }
    }
    if(cell != nil) {
        [self insertSubview:cell atIndex:0];
        [cell setElementsItem:item];
        if(_elementsDelegateShowCellAtIndex == YES) {
            [_elementsDelegate elements:self showCell:cell atIndex:[item index]];
        }
    }
    return cell;
}

- (void)enqueueCellWithElementsItem:(MobilyViewElementsItem*)item {
    MobilyViewElementsCell* cell = [item elementsCell];
    if(cell != nil) {
        NSMutableArray* queue = [_queueCells objectForKey:[item identifier]];
        if(queue == nil) {
            [_queueCells setObject:[NSMutableArray arrayWithObject:cell] forKey:[item identifier]];
        } else {
            [queue addObject:cell];
        }
        if(_elementsDelegateHideCellAtIndex == YES) {
            [_elementsDelegate elements:self hideCell:cell atIndex:[item index]];
        }
        [cell setElementsItem:nil];
        [cell removeFromSuperview];
    }
}

- (void)layoutItems {
    if(_elementsLayout != nil) {
        [self setContentSize:[_elementsLayout elements:self layoutItems:_items]];
    } else {
        @throw [NSException exceptionWithName:NSStringFromClass([self class]) reason:@"Not assigned layout" userInfo:nil];
    }
}

- (void)applyLayoutItems {
    [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
        MobilyViewElementsCell* cell = [item elementsCell];
        if(cell != nil) {
            [cell setFrame:[item frame]];
        }
    }];
}

- (void)updateVisibleItems {
    CGRect visibleRect = [self bounds];
    
    if(_updating == NO) {
        [_mutableVisibleIndexSet removeIndexesInRange:NSMakeRange([_items count] - 1, INT_MAX)];
        [_items enumerateObjectsAtIndexes:_mutableVisibleIndexSet options:0 usingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
            if(CGRectIntersectsRect([item frame], visibleRect) == NO) {
                [self enqueueCellWithElementsItem:item];
                [_mutableVisibleIndexSet removeIndex:index];
            }
        }];
    }
    [_items enumerateObjectsUsingBlock:^(MobilyViewElementsItem* item, NSUInteger index, BOOL* stop) {
        CGRect itemUnionFrame = CGRectUnion([item initialFrame], [item frame]);
        if(CGRectIntersectsRect(visibleRect, itemUnionFrame) == YES) {
            if([item elementsCell] == nil) {
                [_mutableVisibleIndexSet addIndex:index];
                [self dequeueCellWithElementsItem:item];
            }
        }
    }];
}

- (void)selectItemAtElementsCell:(MobilyViewElementsCell*)cell animated:(BOOL)animated {
    if(_allowsSelection == YES) {
        NSUInteger elementIndex = [[cell elementsItem] index];
        if([_mutableSelectedIndexSet containsIndex:elementIndex] == NO) {
            [self selectItemAtIndex:elementIndex animated:animated];
        } else {
            [self deselectItemAtIndex:elementIndex animated:animated];
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewElementsCell

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addTarget:self action:@selector(actionTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovedObject:objectChild]];
        [self removeSubview:(UIView*)objectChild];
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

#pragma mark Public

- (void)prepareItem:(MobilyViewElementsItem*)item {
}

- (void)updatingItem:(MobilyViewElementsItem*)item animated:(BOOL)animated {
}

- (void)cleanupItem:(MobilyViewElementsItem*)item {
}

#pragma mark Property

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if([self isSelected] != selected) {
        [super setSelected:selected];
        [self updatingItem:_elementsItem animated:animated];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if([self isHighlighted] != highlighted) {
        [super setHighlighted:highlighted];
        [self updatingItem:_elementsItem animated:animated];
    }
}

- (void)setElementsItem:(MobilyViewElementsItem*)elementsItem {
    if(_elementsItem != elementsItem) {
        if(_elementsItem != nil) {
            [UIView performWithoutAnimation:^{
                [self cleanupItem:_elementsItem];
            }];
            [_elementsItem setElementsCell:nil];
        }
        _elementsItem = elementsItem;
        if(_elementsItem != nil) {
            [_elementsItem setElementsCell:self];
            
            [UIView performWithoutAnimation:^{
                [[self layer] setZPosition:[_elementsItem zIndex]];
                [self setFrame:[_elementsItem initialFrame]];
                [self setSelected:[_elementsItem isSelected]];
                [self prepareItem:_elementsItem];
            }];
        }
    }
}

#pragma mark Action

- (IBAction)actionTouchUpInside:(id)sender {
    if(self == sender) {
        [_elements selectItemAtElementsCell:self animated:YES];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewElementsItem

#pragma mark Standart

- (id)initWithElements:(MobilyViewElements*)elements {
    self = [super init];
    if(self != nil) {
        [self setElements:elements];
    }
    return self;
}

- (void)dealloc {
    [self setElementsCell:nil];
    [self setElements:nil];
    [self setIdentifier:nil];
}

#pragma mark Property

- (void)setInitialFrameOrigin:(CGPoint)initialFrameOrigin {
    [self setInitialFrame:CGRectMake(initialFrameOrigin.x, initialFrameOrigin.y, _frame.size.width, _frame.size.height)];
}

- (CGPoint)initialFrameOrigin {
    return _initialFrame.origin;
}

- (void)setInitialFrameOriginX:(CGFloat)initialFrameOriginX {
    [self setInitialFrame:CGRectMake(initialFrameOriginX, _initialFrame.origin.y, _initialFrame.size.width, _initialFrame.size.height)];
}

- (CGFloat)initialFrameOriginX {
    return _initialFrame.origin.x;
}

- (void)setInitialFrameOriginY:(CGFloat)initialFrameOriginY {
    [self setInitialFrame:CGRectMake(_initialFrame.origin.x, initialFrameOriginY, _initialFrame.size.width, _initialFrame.size.height)];
}

- (CGFloat)initialFrameOriginY {
    return _initialFrame.origin.y;
}

- (void)setInitialFrameSize:(CGSize)initialFrameSize {
    [self setInitialFrame:CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y, initialFrameSize.width, initialFrameSize.height)];
}

- (CGSize)initialFrameSize {
    return _initialFrame.size;
}

- (void)setInitialFrameSizeWidth:(CGFloat)initialFrameSizeWidth {
    [self setInitialFrame:CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y, initialFrameSizeWidth, _initialFrame.size.height)];
}

- (CGFloat)initialFrameSizeWidth {
    return _initialFrame.size.width;
}

- (void)setInitialFrameSizeHeight:(CGFloat)initialFrameSizeHeight {
    [self setInitialFrame:CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y, _initialFrame.size.width, initialFrameSizeHeight)];
}

- (CGFloat)initialFrameSizeHeight {
    return _initialFrame.size.height;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    [self setFrame:CGRectMake(frameOrigin.x, frameOrigin.y, _frame.size.width, _frame.size.height)];
}

- (CGPoint)frameOrigin {
    return _frame.origin;
}

- (void)setFrameOriginX:(CGFloat)afterFrameOriginX {
    [self setFrame:CGRectMake(afterFrameOriginX, _frame.origin.y, _frame.size.width, _frame.size.height)];
}

- (CGFloat)frameOriginX {
    return _frame.origin.x;
}

- (void)setFrameOriginY:(CGFloat)afterFrameOriginY {
    [self setFrame:CGRectMake(_frame.origin.x, afterFrameOriginY, _frame.size.width, _frame.size.height)];
}

- (CGFloat)frameOriginY {
    return _frame.origin.y;
}

- (void)setFrameSize:(CGSize)frameSize {
    [self setFrame:CGRectMake(_frame.origin.x, _frame.origin.y, frameSize.width, frameSize.height)];
}

- (CGSize)frameSize {
    return _frame.size;
}

- (void)setFrameSizeWidth:(CGFloat)afterFrameSizeWidth {
    [self setFrame:CGRectMake(_frame.origin.x, _frame.origin.y, afterFrameSizeWidth, _frame.size.height)];
}

- (CGFloat)frameSizeWidth {
    return _frame.size.width;
}

- (void)setFrameSizeHeight:(CGFloat)frameSizeHeight {
    [self setFrame:CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, frameSizeHeight)];
}

- (CGFloat)frameSizeHeight {
    return _frame.size.height;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewElementsRegisterCell

#pragma mark Standart

- (id)initWithCellClass:(Class)cellClass {
    self = [super init];
    if(self != nil) {
        [self setCellClass:cellClass];
    }
    return self;
}

- (id)initWithCellClass:(Class)cellClass cellNib:(UINib*)cellNib {
    self = [super init];
    if(self != nil) {
        [self setCellClass:cellClass];
        [self setCellNib:cellNib];
    }
    return self;
}

- (void)dealloc {
    [self setCellClass:nil];
    [self setCellNib:nil];
}

@end

/*--------------------------------------------------*/
