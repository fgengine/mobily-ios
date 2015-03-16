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

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _sections = NSMutableArray.array;
}

#pragma mark Private propert private

- (void)_willChangeView {
}

- (void)_didChangeView {
    for(MobilyDataContainer* section in _sections) {
        section.view = _view;
    }
}

#pragma mark Private override

- (void)_didBeginUpdateAnimated:(BOOL)animated {
    [super _didBeginUpdateAnimated:animated];
    for(MobilyDataContainer* section in _sections) {
        [section _didBeginUpdateAnimated:animated];
    }
}

- (void)_didEndUpdateAnimated:(BOOL)animated {
    for(MobilyDataContainer* section in _sections) {
        [section _didEndUpdateAnimated:animated];
    }
    [super _didEndUpdateAnimated:animated];
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    if(_sections.count > 0) {
        _frame = [self _validateSectionsForAvailableFrame:frame];
    } else {
        _frame = CGRectNull;
    }
    return _frame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    [self _willSectionsLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    [self _didSectionsLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

#pragma mark Public override

- (NSArray*)allItems {
    NSMutableArray* result = NSMutableArray.array;
    for(MobilyDataContainer* section in _sections) {
        [result addObjectsFromArray:section.allItems];
    }
    return result;
}

- (MobilyDataItem*)itemForPoint:(CGPoint)point {
    for(MobilyDataContainer* section in _sections) {
        MobilyDataItem* item = [section itemForPoint:point];
        if(item != nil) {
            return item;
        }
    }
    return nil;
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

#pragma mark Public

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

#pragma mark Private override

- (CGPoint)_alignWithVelocity:(CGPoint)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize viewportSize:(CGSize)viewportSize {
    if(CGRectContainsPoint(_frame, contentOffset) == YES) {
        for(MobilyDataContainer* section in _sections) {
            contentOffset = [section _alignWithVelocity:velocity contentOffset:contentOffset contentSize:contentSize viewportSize:viewportSize];
        }
    }
    return contentOffset;
}

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
