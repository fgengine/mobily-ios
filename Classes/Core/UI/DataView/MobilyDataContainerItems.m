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
    if(_entries.count > 0) {
        _frame = [self _validateEntriesForAvailableFrame:frame];
    } else {
        _frame = CGRectNull;
    }
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
    NSIndexSet* indexSet = [_entries indexesOfObjectsPassingTest:^BOOL(MobilyDataItem* originEntry, NSUInteger index, BOOL* stop) {
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

- (CGPoint)_alignWithVelocity:(CGPoint)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize viewportSize:(CGSize)viewportSize {
    if(CGRectContainsPoint(_frame, contentOffset) == YES) {
        MobilyDataItem* alingItem = nil;
        for(MobilyDataItem* item in _entries) {
            if(CGRectContainsPoint(item.originFrame, contentOffset) == YES) {
                alingItem = item;
                break;
            }
        }
        if(alingItem != nil) {
            CGRect alingItemFrame = alingItem.originFrame;
            CGFloat vex = ABS((contentOffset.x + viewportSize.width) - contentSize.width);
            CGFloat vey = ABS((contentOffset.y + viewportSize.height) - contentSize.height);
            if(_alignThreshold > FLT_EPSILON) {
                CGFloat dsx = ABS(contentOffset.x - alingItemFrame.origin.x);
                CGFloat dsy = ABS(contentOffset.y - alingItemFrame.origin.y);
                CGFloat dex = ABS(contentOffset.x - (alingItemFrame.origin.x + alingItemFrame.size.width));
                CGFloat dey = ABS(contentOffset.y - (alingItemFrame.origin.y + alingItemFrame.size.height));
                if(vex <= _alignThreshold) {
                    contentOffset.x = contentSize.width - viewportSize.width;
                } else if(dex <= _alignThreshold) {
                    contentOffset.x = alingItemFrame.origin.x + alingItemFrame.size.width;
                } else if(dsx <= _alignThreshold) {
                    contentOffset.x = alingItemFrame.origin.x;
                }
                if(vey <= _alignThreshold) {
                    contentOffset.y = contentSize.height - viewportSize.height;
                } else if(dey <= _alignThreshold) {
                    contentOffset.y = alingItemFrame.origin.y + alingItemFrame.size.height;
                } else if(dsy <= _alignThreshold) {
                    contentOffset.y = alingItemFrame.origin.y;
                }
            } else {
                if(vex > FLT_EPSILON) {
                    contentOffset.x = alingItemFrame.origin.x;
                } else {
                    contentOffset.x = contentSize.width - viewportSize.width;
                }
                if(vey > FLT_EPSILON) {
                    contentOffset.y = alingItemFrame.origin.y;
                } else {
                    contentOffset.y = contentSize.height - viewportSize.height;
                }
            }
        }
    }
    return contentOffset;
}

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    return CGRectNull;
}

- (void)_willEntriesLayoutForBounds:(CGRect)bounds {
}

- (void)_didEntriesLayoutForBounds:(CGRect)bounds {
    for(MobilyDataItem* entry in _entries) {
        [entry validateLayoutForBounds:bounds];
    }
}

@end

/*--------------------------------------------------*/
