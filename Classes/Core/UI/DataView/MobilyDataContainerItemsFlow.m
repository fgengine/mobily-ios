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

#import "MobilyDataContainer+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataContainerItemsFlow

#pragma mark Synthesize

@synthesize orientation = _orientation;
@synthesize margin = _margin;
@synthesize spacing = _spacing;
@synthesize header = _header;
@synthesize footer = _footer;
@synthesize items = _items;

#pragma mark Init / Free

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation {
    return [[self alloc] initWithOrientation:orientation];
}

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation {
    self = [super init];
    if(self != nil) {
        _orientation = orientation;
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _orientation = MobilyDataContainerOrientationVertical;
    _margin = UIEdgeInsetsZero;
    _spacing = UIOffsetZero;
    _defaultSize = CGSizeMake(44.0f, 44.0f);
    _items = NSMutableArray.array;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setOrientation:(MobilyDataContainerOrientation)orientation {
    if(_orientation != orientation) {
        _orientation = orientation;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMargin:(UIEdgeInsets)margin {
    if(UIEdgeInsetsEqualToEdgeInsets(_margin, margin) == NO) {
        _margin = margin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setSpacing:(UIOffset)spacing {
    if(UIOffsetEqualToOffset(_spacing, spacing) == NO) {
        _spacing = spacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setHeader:(MobilyDataItem*)header {
    if(_header != header) {
        if(_header != nil) {
            [self _deleteEntry:_header];
        }
        _header = header;
        if(_header != nil) {
            [self _appendEntry:_header];
        }
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setFooter:(MobilyDataItem*)footer {
    if(_footer != footer) {
        if(_footer != nil) {
            [self _deleteEntry:_footer];
        }
        _footer = footer;
        if(_footer != nil) {
            [self _appendEntry:_footer];
        }
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (void)prependItem:(MobilyDataItem*)item {
    [_items insertObject:item atIndex:0];
    if(_header != nil) {
        [self _insertEntry:item atIndex:[_entries indexOfObject:_header] + 1];
    } else {
        [self _prependEntry:item];
    }
}

- (void)prependItems:(NSArray*)items {
    [_items insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)]];
    if(_header != nil) {
        [self _insertEntries:items atIndex:[_entries indexOfObject:_header] + 1];
    } else {
        [self _prependEntries:items];
    }
}

- (void)appendItem:(MobilyDataItem*)item {
    [_items addObject:item];
    if(_footer != nil) {
        [self _insertEntry:item atIndex:[_entries indexOfObject:_footer] - 1];
    } else {
        [self _appendEntry:item];
    }
}

- (void)appendItems:(NSArray*)items {
    [_items addObjectsFromArray:items];
    if(_footer != nil) {
        [self _insertEntries:items atIndex:[_entries indexOfObject:_footer] - 1];
    } else {
        [self _appendEntries:items];
    }
}

- (void)insertItem:(MobilyDataItem*)item atIndex:(NSUInteger)index {
    [_items insertObject:item atIndex:index];
    if(_header != nil) {
        index = MAX(index, [_entries indexOfObject:_header] + 1);
    }
    if(_footer != nil) {
        index = MIN(index, [_entries indexOfObject:_footer] - 1);
    }
    [self _insertEntry:item atIndex:index];
}

- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index {
    [_items insertObjects:items atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, items.count)]];
    if(_header != nil) {
        index = MAX(index, [_entries indexOfObject:_header] + 1);
    }
    if(_footer != nil) {
        index = MIN(index, [_entries indexOfObject:_footer] - 1);
    }
    [self _insertEntries:items atIndex:index];
}

- (void)replaceOriginItem:(MobilyDataItem*)originItem withItem:(MobilyDataItem*)item {
    NSUInteger index = [_items indexOfObject:originItem];
    if(index != NSNotFound) {
        _items[index] = item;
        [self _replaceOriginEntry:originItem withEntry:item];
    }
}

- (void)replaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items {
    NSIndexSet* indexSet = [_items indexesOfObjectsPassingTest:^BOOL(MobilyDataItem* originItem, NSUInteger index, BOOL* stop) {
        return [originItems containsObject:originItem];
    }];
    if(indexSet.count == items.count) {
        [_items replaceObjectsAtIndexes:indexSet withObjects:items];
        [self _replaceOriginEntries:originItems withEntries:items];
    }
}

- (void)deleteItem:(MobilyDataItem*)item {
    if([_items containsObject:item] == YES) {
        [_items removeObject:item];
        [self _deleteEntry:item];
    }
}

- (void)deleteItems:(NSArray*)items {
    if([_items containsObjectsInArray:items] == YES) {
        [_items removeObjectsInArray:items];
        [self _deleteEntries:items];
    }
}

- (void)deleteAllItems {
    if(_items.count > 0) {
        NSArray* items = [NSArray arrayWithArray:_items];
        [self _deleteEntries:items];
        [_items removeAllObjects];
    }
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGSize restriction = CGSizeMake(frame.size.width - (_margin.left + _margin.right), frame.size.height - (_margin.top + _margin.bottom));
    CGSize cumulative = CGSizeZero, cumulativeRow = CGSizeZero;
    NSUInteger countOfRow = 0;
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            for(MobilyDataItem* entry in _entries) {
                CGSize entrySize = [entry sizeForAvailableSize:CGSizeMake(restriction.width, (_defaultSize.height > 0) ? _defaultSize.height : FLT_MAX)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    if((countOfRow > 0) && (cumulativeRow.width + entrySize.width > restriction.width)) {
                        offset.x = 0.0f;
                        offset.y += cumulativeRow.height + _spacing.vertical;
                        cumulative.width = MAX(restriction.width, _margin.left + cumulativeRow.width + _margin.right);
                        cumulative.height += cumulativeRow.height + _spacing.vertical;
                        cumulativeRow = CGSizeZero;
                        countOfRow = 0;
                    }
                    entry.updateFrame = CGRectMake(offset.x, offset.y, entrySize.width, entrySize.height);
                    offset.x += entrySize.width + _spacing.horizontal;
                    cumulativeRow.width += entrySize.width + _spacing.horizontal;
                    cumulativeRow.height = MAX(entrySize.height, cumulativeRow.height);
                    countOfRow++;
                }
            }
            cumulative.width -= _spacing.horizontal;
            cumulative.height -= _spacing.vertical;
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            for(MobilyDataItem* entry in _entries) {
                CGSize entrySize = [entry sizeForAvailableSize:CGSizeMake((_defaultSize.width > 0) ? _defaultSize.width : FLT_MAX, restriction.height)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    if((countOfRow > 0) && (cumulativeRow.height + entrySize.height > restriction.height)) {
                        offset.x += cumulativeRow.width + _spacing.horizontal;
                        offset.y = 0.0f;
                        cumulative.width = cumulativeRow.width + _spacing.horizontal;
                        cumulative.height += MAX(restriction.height, _margin.top + cumulativeRow.height + _margin.bottom);
                        cumulativeRow = CGSizeZero;
                        countOfRow = 0;
                    }
                    entry.updateFrame = CGRectMake(offset.x, offset.y, entrySize.width, entrySize.height);
                    offset.y += entrySize.height + _spacing.vertical;
                    cumulativeRow.width = MAX(entrySize.width, cumulativeRow.width);
                    cumulativeRow.height += entrySize.height + _spacing.vertical;
                    countOfRow++;
                }
            }
            cumulative.width -= _spacing.horizontal;
            cumulative.height -= _spacing.vertical;
            break;
        }
    }
    return CGRectMake(frame.origin.x, frame.origin.y, _margin.left + cumulative.width + _margin.right, _margin.top + cumulative.height + _margin.bottom);
}

- (void)_willEntriesLayoutForBounds:(CGRect)bounds {
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            CGFloat boundsBefore = bounds.origin.y;
            CGFloat boundsAfter = bounds.origin.y + bounds.size.height;
            CGFloat entriesBefore = _entriesFrame.origin.y;
            CGFloat entriesAfter = _entriesFrame.origin.y + _entriesFrame.size.height;
            if(_header != nil) {
                CGRect headerFrame = _header.updateFrame;
                headerFrame.origin.y = boundsBefore;
                if(_footer != nil) {
                    CGRect footerFrame = _footer.updateFrame;
                    headerFrame.origin.y = MIN(headerFrame.origin.y, (boundsAfter - (_spacing.vertical + footerFrame.size.height)) - headerFrame.size.height);
                } else {
                    headerFrame.origin.y = MIN(headerFrame.origin.y, boundsAfter - headerFrame.size.height);
                }
                headerFrame.origin.y = MAX(entriesBefore, MIN(headerFrame.origin.y, entriesAfter - headerFrame.size.height));
                _header.displayFrame = headerFrame;
            }
            if(_footer != nil) {
                CGRect footerFrame = _footer.updateFrame;
                footerFrame.origin.y = boundsAfter - footerFrame.size.height;
                if(_header != nil) {
                    CGRect headerFrame = _header.updateFrame;
                    footerFrame.origin.y = MAX(footerFrame.origin.y, (boundsBefore + _spacing.vertical) + headerFrame.size.height);
                } else {
                    footerFrame.origin.y = MAX(footerFrame.origin.y, boundsBefore);
                }
                footerFrame.origin.y = MAX(entriesBefore, MIN(footerFrame.origin.y, entriesAfter - footerFrame.size.height));
                _footer.displayFrame = footerFrame;
            }
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            CGFloat boundsBefore = bounds.origin.x;
            CGFloat boundsAfter = bounds.origin.x + bounds.size.width;
            CGFloat entriesBefore = _entriesFrame.origin.x;
            CGFloat entriesAfter = _entriesFrame.origin.x + _entriesFrame.size.width;
            if(_header != nil) {
                CGRect headerFrame = _header.updateFrame;
                headerFrame.origin.x = boundsBefore;
                if(_footer != nil) {
                    CGRect footerFrame = _footer.updateFrame;
                    headerFrame.origin.x = MIN(headerFrame.origin.x, (boundsAfter - (_spacing.horizontal + footerFrame.size.width)) - headerFrame.size.width);
                } else {
                    headerFrame.origin.x = MIN(headerFrame.origin.x, boundsAfter - headerFrame.size.width);
                }
                headerFrame.origin.x = MAX(entriesBefore, MIN(headerFrame.origin.x, entriesAfter - headerFrame.size.width));
                _header.displayFrame = headerFrame;
            }
            if(_footer != nil) {
                CGRect footerFrame = _footer.updateFrame;
                footerFrame.origin.x = boundsAfter - footerFrame.size.width;
                if(_header != nil) {
                    CGRect headerFrame = _header.updateFrame;
                    footerFrame.origin.x = MAX(footerFrame.origin.x, (boundsBefore + _spacing.horizontal) + headerFrame.size.width);
                } else {
                    footerFrame.origin.x = MAX(footerFrame.origin.x, boundsBefore);
                }
                footerFrame.origin.x = MAX(entriesBefore, MIN(footerFrame.origin.x, entriesAfter - footerFrame.size.width));
                _footer.displayFrame = footerFrame;
            }
            break;
        }
    }
}

@end

/*--------------------------------------------------*/
