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
    _frame = [self _validateSectionsForAvailableFrame:frame];
    return _frame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    CGRect intersect = CGRectIntersection(bounds, _frame);
    if(CGRectIsEmpty(intersect) == NO) {
        [self _willSectionsLayoutForBounds:intersect];
    }
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    CGRect intersect = CGRectIntersection(bounds, _frame);
    if(CGRectIsEmpty(intersect) == NO) {
        [self _didSectionsLayoutForBounds:intersect];
    }
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

- (void)scrollToSection:(MobilyDataContainer*)section scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated {
    [_view scrollToRect:section.frame scrollPosition:scrollPosition animated:animated];
}

#pragma mark Private override

- (CGPoint)_alignWithVelocity:(CGPoint)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if((_allowAutoAlign == YES) && (_hidden == NO)) {
        CGPoint alingPoint = [self _alignPointWithContentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
        if(CGRectContainsPoint(_frame, alingPoint) == YES) {
            for(MobilyDataContainer* section in _sections) {
                if(section.allowAutoAlign == YES) {
                    CGPoint alingSectionCorner = CGPointZero;
                    if((_alignPosition & MobilyDataContainerAlignLeft) != 0) {
                        alingSectionCorner.x = CGRectGetMinX(section.frame);
                    } else if((_alignPosition & MobilyDataContainerAlignCenteredHorizontally) != 0) {
                        alingSectionCorner.x = CGRectGetMidX(section.frame);
                    } else if((_alignPosition & MobilyDataContainerAlignRight) != 0) {
                        alingSectionCorner.x = CGRectGetMaxX(section.frame);
                    } else {
                        alingSectionCorner.x = alingPoint.x;
                    }
                    if((_alignPosition & MobilyDataContainerAlignTop) != 0) {
                        alingSectionCorner.y = CGRectGetMinY(section.frame);
                    } else if((_alignPosition & MobilyDataContainerAlignCenteredVertically) != 0) {
                        alingSectionCorner.y = CGRectGetMidY(section.frame);
                    } else if((_alignPosition & MobilyDataContainerAlignBottom) != 0) {
                        alingSectionCorner.y = CGRectGetMaxY(section.frame);
                    } else {
                        alingSectionCorner.y = alingPoint.y;
                    }
                    CGFloat dx = alingPoint.x - alingSectionCorner.x;
                    CGFloat dy = alingPoint.y - alingSectionCorner.y;
                    if((ABS(alingSectionCorner.x - contentOffset.x) > FLT_EPSILON) && (ABS(dx) <= _alignThreshold.horizontal)) {
                        contentOffset.x -= dx;
                        alingPoint.x -= dx;
                    }
                    if((ABS(alingSectionCorner.y - contentOffset.y) > FLT_EPSILON) && (ABS(dy) <= _alignThreshold.vertical)) {
                        contentOffset.y -= dy;
                        alingPoint.y -= dy;
                    }
                }
            }
        }
    }
    if(CGRectContainsPoint(_frame, contentOffset) == YES) {
        for(MobilyDataContainer* section in _sections) {
            contentOffset = [section _alignWithVelocity:velocity contentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
        }
    }
    return contentOffset;
}

- (CGRect)_validateSectionsForAvailableFrame:(CGRect __unused)frame {
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

#pragma mark MobilySearchBarDelegate

- (void)searchBarBeginSearch:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarBeginSearch:searchBar];
    }
}

- (void)searchBarEndSearch:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarEndSearch:searchBar];
    }
}

- (void)searchBarBeginEditing:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarBeginEditing:searchBar];
    }
}

- (void)searchBar:(MobilySearchBar*)searchBar textChanged:(NSString*)textChanged {
    for(MobilyDataContainer* section in _sections) {
        [section searchBar:searchBar textChanged:textChanged];
    }
}

- (void)searchBarEndEditing:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarEndEditing:searchBar];
    }
}

- (void)searchBarPressedClear:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarPressedClear:searchBar];
    }
}

- (void)searchBarPressedReturn:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarPressedReturn:searchBar];
    }
}

- (void)searchBarPressedCancel:(MobilySearchBar*)searchBar {
    for(MobilyDataContainer* section in _sections) {
        [section searchBarPressedCancel:searchBar];
    }
}

@end

/*--------------------------------------------------*/
