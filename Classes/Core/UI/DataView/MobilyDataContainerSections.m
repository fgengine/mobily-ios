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

@implementation MobilyDataContainerSections

#pragma mark Synthesize

@synthesize sections = _sections;
@synthesize sectionsFrame = _sectionsFrame;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _sections = NSMutableArray.array;
}

- (void)dealloc {
}

#pragma mark Property private

- (void)_willChangeView {
}

- (void)_didChangeView {
    for(MobilyDataContainer* section in _sections) {
        section.view = _view;
    }
}

#pragma mark Public override

- (void)_didBeginUpdate {
    [super _didBeginUpdate];
    for(MobilyDataContainer* section in _sections) {
        [section _didBeginUpdate];
    }
}

- (void)_didEndUpdate {
    for(MobilyDataContainer* section in _sections) {
        [section _didEndUpdate];
    }
    [super _didEndUpdate];
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    if(_sections.count > 0) {
        _sectionsFrame = [self _validateSectionsForAvailableFrame:frame];
    } else {
        _sectionsFrame = CGRectNull;
    }
    return _sectionsFrame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    [self _willSectionsLayoutForBounds:CGRectIntersection(bounds, _sectionsFrame)];
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    [self _didSectionsLayoutForBounds:CGRectIntersection(bounds, _sectionsFrame)];
}

#pragma mark Public

- (NSArray*)allItems {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataContainer* section in _sections) {
        [result addObjectsFromArray:section.allItems];
    }
    return result;
}

- (MobilyDataItem*)itemForData:(id)data {
    for(MobilyDataContainer* section in _sections) {
        MobilyDataItem* item = [section itemForData:data];
        if(item != nil) {
            return item;
        }
    }
    return nil;
}

- (MobilyDataCell*)cellForData:(id)data {
    MobilyDataItem* item = [self itemForData:data];
    if(item != nil) {
        return item.cell;
    }
    return nil;
}

- (void)prependSection:(MobilyDataContainer*)section {
    section.parent = self;
    [_sections insertObject:section atIndex:0];
    if(_view != nil) {
        [_view _didInsertItems:section.allItems];
    }
}

- (void)appendSection:(MobilyDataContainer*)section {
    section.parent = self;
    [_sections addObject:section];
    if(_view != nil) {
        [_view _didInsertItems:section.allItems];
    }
}

- (void)insertSection:(MobilyDataContainer*)section atIndex:(NSUInteger)index {
    section.parent = self;
    [_sections insertObject:section atIndex:index];
    if(_view != nil) {
        [_view _didInsertItems:section.allItems];
    }
}

- (void)replaceOriginSection:(MobilyDataContainer*)originSection withSection:(MobilyDataContainer*)section {
    NSUInteger index = [_sections indexOfObject:originSection];
    if(index != NSNotFound) {
        section.parent = self;
        _sections[index] = section;
        if(_view != nil) {
            [_view _didReplaceOriginItems:originSection.allItems withItems:section.allItems];
        }
    }
}

- (void)deleteSection:(MobilyDataContainer*)section {
    [_sections removeObject:section];
    if(_view != nil) {
        [_view _didDeleteItems:section.allItems];
    }
}

- (void)deleteAllSections {
    if(_view != nil) {
        NSArray* allItems = self.allItems;
        [_sections removeAllObjects];
        [_view _didDeleteItems:allItems];
    } else {
        [_sections removeAllObjects];
    }
}

#pragma mark Private

- (CGRect)_validateSectionsForAvailableFrame:(CGRect)frame {
    return CGRectNull;
}

- (void)_willSectionsLayoutForBounds:(CGRect)bounds {
    for(MobilyDataContainer* section in _sections) {
        [section _willLayoutForBounds:bounds];
    }
}

- (void)_didSectionsLayoutForBounds:(CGRect)bounds {
    for(MobilyDataContainer* section in _sections) {
        [section _didLayoutForBounds:bounds];
    }
}

@end

/*--------------------------------------------------*/
