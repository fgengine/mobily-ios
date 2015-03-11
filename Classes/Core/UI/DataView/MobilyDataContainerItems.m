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
@synthesize entriesFrame = _entriesFrame;

#pragma mark Init / Free

- (void)setup {
    _entries = NSMutableArray.array;
}

#pragma mark Property private

- (void)_willChangeView {
}

- (void)_didChangeView {
    for(MobilyDataItem* entry in _entries) {
        entry.view = _view;
    }
}

#pragma mark Public override

- (void)_didBeginUpdate {
    [super _didBeginUpdate];
    for(MobilyDataItem* entry in _entries) {
        [entry didBeginUpdate];
    }
}

- (void)_didEndUpdate {
    for(MobilyDataItem* entry in _entries) {
        [entry didEndUpdate];
    }
    [super _didEndUpdate];
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    if(_entries.count > 0) {
        _entriesFrame = [self _validateEntriesForAvailableFrame:frame];
    } else {
        _entriesFrame = CGRectNull;
    }
    return _entriesFrame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    [self _willEntriesLayoutForBounds:CGRectIntersection(bounds, _entriesFrame)];
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    [self _didEntriesLayoutForBounds:CGRectIntersection(bounds, _entriesFrame)];
}

#pragma mark Public

- (NSArray*)allEntries {
    return [_entries copy];
}

- (MobilyDataItem*)itemForData:(id)data {
    for(MobilyDataItem* entry in _entries) {
        id entryData = entry.data;
        if(entryData == data) {
            return entryData;
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
