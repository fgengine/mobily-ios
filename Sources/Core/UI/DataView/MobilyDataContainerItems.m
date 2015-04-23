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

#import <MobilyDataContainer+Private.h>

/*--------------------------------------------------*/

@implementation MobilyDataContainerItems

#pragma mark Synthesize

@synthesize entries = _entries;

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _entries = NSMutableArray.array;
}

#pragma mark Private property private

- (void)_willChangeView {
}

- (void)_didChangeView {
    for(MobilyDataItem* entry in _entries) {
        entry.view = _view;
    }
}

#pragma mark Private override

- (void)_didBeginUpdateAnimated:(BOOL)animated {
    [super _didBeginUpdateAnimated:animated];
    for(MobilyDataItem* entry in _entries) {
        [entry didBeginUpdateAnimated:animated];
    }
}

- (void)_didEndUpdateAnimated:(BOOL)animated {
    for(MobilyDataItem* entry in _entries) {
        [entry didEndUpdateAnimated:animated];
    }
    [super _didEndUpdateAnimated:animated];
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    _frame = [self _validateEntriesForAvailableFrame:frame];
    return _frame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    [self _willEntriesLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    [self _didEntriesLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

#pragma mark Public override

- (NSArray*)allEntries {
    return [_entries copy];
}

- (MobilyDataItem*)itemForPoint:(CGPoint)point {
    for(MobilyDataItem* entry in _entries) {
        if(CGRectContainsPoint(entry.frame, point) == YES) {
            return entry;
        }
    }
    return nil;
}

- (MobilyDataItem*)itemForData:(id)data {
    for(MobilyDataItem* entry in _entries) {
        id entryData = entry.data;
        if([entryData isEqual:data] == YES) {
            return entry;
        }
    }
    return nil;
}

#pragma mark Private

- (void)_prependEntry:(MobilyDataItem*)entry {
    [_entries insertObject:entry atIndex:0];
    entry.parent = self;
    if(_view != nil) {
        [_view _didInsertItems:@[ entry ]];
    }
}

- (void)_prependEntries:(NSArray*)entries {
    [_entries insertObjects:entries atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, entries.count)]];
    for(MobilyDataItem* entry in entries) {
        entry.parent = self;
    }
    if(_view != nil) {
        [_view _didInsertItems:entries];
    }
}

- (void)_appendEntry:(MobilyDataItem*)entry {
    [_entries addObject:entry];
    entry.parent = self;
    if(_view != nil) {
        [_view _didInsertItems:@[ entry ]];
    }
}

- (void)_appendEntries:(NSArray*)entries {
    [_entries addObjectsFromArray:entries];
    for(MobilyDataItem* entry in entries) {
        entry.parent = self;
    }
    if(_view != nil) {
        [_view _didInsertItems:entries];
    }
}

- (void)_insertEntry:(MobilyDataItem*)entry atIndex:(NSUInteger)index {
    [_entries insertObject:entry atIndex:index];
    entry.parent = self;
    if(_view != nil) {
        [_view _didInsertItems:@[ entry ]];
    }
}

- (void)_insertEntries:(NSArray*)entries atIndex:(NSUInteger)index {
    [_entries insertObjects:entries atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, entries.count)]];
    for(MobilyDataItem* entry in entries) {
        entry.parent = self;
    }
    if(_view != nil) {
        [_view _didInsertItems:entries];
    }
}

- (void)_replaceOriginEntry:(MobilyDataItem*)originEntry withEntry:(MobilyDataItem*)entry {
    NSUInteger index = [_entries indexOfObject:originEntry];
    entry.parent = self;
    _entries[index] = entry;
    if(_view != nil) {
        [_view _didReplaceOriginItems:@[ originEntry ] withItems:@[ entry ]];
    }
}

- (void)_replaceOriginEntries:(NSArray*)originEntries withEntries:(NSArray*)entries {
    NSIndexSet* indexSet = [_entries indexesOfObjectsPassingTest:^BOOL(MobilyDataItem* originEntry, NSUInteger index __unused, BOOL* stop __unused) {
        return [originEntries containsObject:originEntry];
    }];
    for(MobilyDataItem* entry in entries) {
        entry.parent = self;
    }
    [_entries replaceObjectsAtIndexes:indexSet withObjects:entries];
    if(_view != nil) {
        [_view _didReplaceOriginItems:originEntries withItems:entries];
    }
}

- (void)_deleteEntry:(MobilyDataItem*)entry {
    [_entries removeObject:entry];
    if(_view != nil) {
        [_view _didDeleteItems:@[ entry ]];
    }
}

- (void)_deleteEntries:(NSArray*)entries {
    [_entries removeObjectsInArray:entries];
    if(_view != nil) {
        [_view _didDeleteItems:entries];
    }
}

- (void)_deleteAllEntries {
    [self _deleteEntries:[_entries copy]];
}

- (CGPoint)_alignWithVelocity:(CGPoint __unused)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if((_allowAutoAlign == YES) && (_hidden == NO)) {
        CGPoint alingPoint = [self _alignPointWithContentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
        if(CGRectContainsPoint(_frame, alingPoint) == YES) {
            for(MobilyDataItem* item in _entries) {
                if(item.allowsAlign == YES) {
                    CGPoint alingItemCorner = CGPointZero;
                    if((_alignPosition & MobilyDataContainerAlignLeft) != 0) {
                        alingItemCorner.x = CGRectGetMinX(item.updateFrame);
                    } else if((_alignPosition & MobilyDataContainerAlignCenteredHorizontally) != 0) {
                        alingItemCorner.x = CGRectGetMidX(item.updateFrame);
                    } else if((_alignPosition & MobilyDataContainerAlignRight) != 0) {
                        alingItemCorner.x = CGRectGetMaxX(item.updateFrame);
                    } else {
                        alingItemCorner.x = alingPoint.x;
                    }
                    if((_alignPosition & MobilyDataContainerAlignTop) != 0) {
                        alingItemCorner.y = CGRectGetMinY(item.updateFrame);
                    } else if((_alignPosition & MobilyDataContainerAlignCenteredVertically) != 0) {
                        alingItemCorner.y = CGRectGetMidY(item.updateFrame);
                    } else if((_alignPosition & MobilyDataContainerAlignBottom) != 0) {
                        alingItemCorner.y = CGRectGetMaxY(item.updateFrame);
                    } else {
                        alingItemCorner.y = alingPoint.y;
                    }
                    CGFloat dx = alingPoint.x - alingItemCorner.x;
                    CGFloat dy = alingPoint.y - alingItemCorner.y;
                    if((ABS(alingItemCorner.x - contentOffset.x) > FLT_EPSILON) && (ABS(dx) <= _alignThreshold.horizontal)) {
                        contentOffset.x -= dx;
                        alingPoint.x -= dx;
                    }
                    if((ABS(alingItemCorner.y - contentOffset.y) > FLT_EPSILON) && (ABS(dy) <= _alignThreshold.vertical)) {
                        contentOffset.y -= dy;
                        alingPoint.y -= dy;
                    }
                }
            }
        }
    }
    return contentOffset;
}

- (CGRect)_validateEntriesForAvailableFrame:(CGRect __unused)frame {
    return CGRectNull;
}

- (void)_willEntriesLayoutForBounds:(CGRect __unused)bounds {
}

- (void)_didEntriesLayoutForBounds:(CGRect)bounds {
    for(MobilyDataItem* entry in _entries) {
        [entry validateLayoutForBounds:bounds];
    }
}

#pragma mark MobilySearchBarDelegate

- (void)searchBarBeginSearch:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarBeginSearch:searchBar];
    }
}

- (void)searchBarEndSearch:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarEndSearch:searchBar];
    }
}

- (void)searchBarBeginEditing:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarBeginEditing:searchBar];
    }
}

- (void)searchBar:(MobilySearchBar*)searchBar textChanged:(NSString*)textChanged {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBar:searchBar textChanged:textChanged];
    }
}

- (void)searchBarEndEditing:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarEndEditing:searchBar];
    }
}

- (void)searchBarPressedClear:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarPressedClear:searchBar];
    }
}

- (void)searchBarPressedReturn:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarPressedReturn:searchBar];
    }
}

- (void)searchBarPressedCancel:(MobilySearchBar*)searchBar {
    for(MobilyDataItem* entry in _entries) {
        [entry searchBarPressedCancel:searchBar];
    }
}

@end

/*--------------------------------------------------*/
