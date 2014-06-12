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

#import "MobilyViewElementsLayout.h"

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutList

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setMargin:2.0f];
        [self setSpacing:2.0f];
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    return CGSizeZero;
}

@end

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutListVertical

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    CGRect bounds = [elements bounds];
    CGFloat margin = [self margin];
    CGFloat spacing = [self spacing];
    
    __block CGFloat offset = margin;
    if([layoutItems count] > 0) {
        [layoutItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            [layoutItem setInitialFrameOrigin:CGPointMake(margin, offset)];
            [layoutItem setInitialFrameSizeWidth:bounds.size.width - (margin + margin)];
            [layoutItem setFrame:[layoutItem initialFrame]];
            offset += [layoutItem initialFrameSizeHeight] + spacing;
        }];
        offset -= spacing;
    }
    offset += margin;
    return CGSizeMake(bounds.size.width, offset);
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertRange:(NSRange)insertRange insertItems:(NSArray*)insertItems {
    CGRect bounds = [elements bounds];
    CGFloat margin = [self margin];
    CGFloat spacing = [self spacing];
    
    __block CGFloat insertItemsOffset = 0.0f;
    if(insertRange.location > 0) {
        MobilyViewElementsItem* layoutItem = [layoutItems objectAtIndex:(insertRange.location - 1)];
        insertItemsOffset = ([layoutItem frameOriginY] + [layoutItem frameSizeHeight]) + spacing;
    }
    __block CGFloat insertItemsSize = 0.0f;
    [insertItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setInitialFrameOrigin:CGPointMake(margin, insertItemsOffset)];
        [layoutItem setInitialFrameSizeWidth:bounds.size.width - (margin + margin)];
        [layoutItem setFrame:[layoutItem initialFrame]];
        insertItemsOffset += [layoutItem frameSizeHeight] + spacing;
        insertItemsSize += [layoutItem frameSizeHeight] + spacing;
    }];
    NSUInteger index = insertRange.location + insertRange.length;
    NSUInteger count = [layoutItems count] - index;
    [layoutItems enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, count)] options:0 usingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setFrameOriginY:[layoutItem frameOriginY] + insertItemsSize];
    }];
    return CGSizeMake(itemsSize.width, itemsSize.height + insertItemsSize);
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteRange:(NSRange)deleteRange deleteItems:(NSArray*)deleteItems {
    CGFloat spacing = [self spacing];

    __block CGFloat deleteItemsSize = 0.0f;
    if([deleteItems count] > 0) {
        [deleteItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            deleteItemsSize += [layoutItem frameSizeHeight] + spacing;
        }];
    }
    NSUInteger index = deleteRange.location + deleteRange.length;
    NSUInteger count = [layoutItems count] - index;
    [layoutItems enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, count)] options:0 usingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setFrameOriginY:[layoutItem frameOriginY] - deleteItemsSize];
    }];
    return CGSizeMake(itemsSize.width, itemsSize.height - deleteItemsSize);
}

@end

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutListHorizontal

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    CGRect bounds = [elements bounds];
    CGFloat margin = [self margin];
    CGFloat margin2 = margin + margin;
    CGFloat spacing = [self spacing];
    
    __block CGFloat offset = margin;
    if([layoutItems count] > 0) {
        [layoutItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            [layoutItem setInitialFrameOrigin:CGPointMake(offset, margin)];
            [layoutItem setInitialFrameSizeHeight:bounds.size.height - (margin2)];
            [layoutItem setFrame:[layoutItem initialFrame]];
            offset += [layoutItem initialFrameSizeWidth] + spacing;
        }];
        offset -= spacing;
    }
    offset += margin;
    return CGSizeMake(offset, bounds.size.height);
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize insertRange:(NSRange)insertRange insertItems:(NSArray*)insertItems {
    CGRect bounds = [elements bounds];
    CGFloat margin = [self margin];
    CGFloat spacing = [self spacing];
    
    __block CGFloat insertItemsOffset = 0.0f;
    if(insertRange.location > 0) {
        MobilyViewElementsItem* layoutItem = [layoutItems objectAtIndex:(insertRange.location - 1)];
        insertItemsOffset = ([layoutItem frameOriginX] + [layoutItem frameSizeWidth]) + spacing;
    }
    __block CGFloat insertItemsSize = 0.0f;
    [insertItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setInitialFrameOrigin:CGPointMake(insertItemsOffset, margin)];
        [layoutItem setInitialFrameSizeHeight:bounds.size.height - (margin + margin)];
        [layoutItem setFrame:[layoutItem initialFrame]];
        insertItemsOffset += [layoutItem frameSizeWidth] + spacing;
        insertItemsSize += [layoutItem frameSizeWidth] + spacing;
    }];
    NSUInteger index = insertRange.location + insertRange.length;
    NSUInteger count = [layoutItems count] - index;
    [layoutItems enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, count)] options:0 usingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setFrameOriginX:[layoutItem frameOriginX] + insertItemsSize];
    }];
    return CGSizeMake(itemsSize.width + insertItemsSize, itemsSize.height);
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteRange:(NSRange)deleteRange deleteItems:(NSArray*)deleteItems {
    CGFloat spacing = [self spacing];
    
    __block CGFloat deleteItemsSize = 0.0f;
    if([deleteItems count] > 0) {
        [deleteItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            deleteItemsSize += [layoutItem frameSizeWidth] + spacing;
        }];
    }
    NSUInteger index = deleteRange.location + deleteRange.length;
    NSUInteger count = [layoutItems count] - index;
    [layoutItems enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, count)] options:0 usingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
        [layoutItem setFrameOriginX:[layoutItem frameOriginX] - deleteItemsSize];
    }];
    return CGSizeMake(itemsSize.width - deleteItemsSize, itemsSize.height);
}

@end

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutGrid

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setMargin:CGSizeMake(2.0f, 2.0f)];
        [self setSpacing:CGSizeMake(2.0f, 2.0f)];
    }
    return self;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    return CGSizeZero;
}

@end

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutGridVertical

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    CGRect bounds = [elements bounds];
    CGSize margin = [self margin];
    CGSize spacing = [self spacing];
    
    __block CGPoint offset = CGPointMake(margin.width, margin.height);
    __block CGSize size = CGSizeMake(margin.width + margin.width, margin.height + margin.height);
    if([layoutItems count] > 0) {
        __block CGSize rowSize = CGSizeZero;
        NSMutableArray* rowItems = [NSMutableArray array];
        [layoutItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            CGSize elementsItemSize = [layoutItem initialFrameSize];
            if([rowItems count] > 0) {
                if(offset.x + elementsItemSize.width > (bounds.origin.x + bounds.size.width) - margin.width) {
                    offset.x = margin.width;
                    offset.y += rowSize.height + spacing.height;
                    size.width = MAX(size.width, margin.width + rowSize.width + margin.width);
                    size.height += rowSize.height + spacing.height;
                    
                    [rowItems removeAllObjects];
                    rowSize = CGSizeZero;
                }
            }
            [layoutItem setInitialFrameOrigin:offset];
            [layoutItem setFrame:[layoutItem initialFrame]];
            offset.x += elementsItemSize.width + spacing.width;
            rowSize.width += elementsItemSize.width + spacing.width;
            rowSize.height = MAX(elementsItemSize.height, rowSize.height);
            [rowItems addObject:layoutItem];
        }];
        size.width = MAX(size.width, margin.width + rowSize.width + margin.width);
        size.height += rowSize.height + spacing.height;
    }
    return size;
}

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems itemsSize:(CGSize)itemsSize deleteRange:(NSRange)deleteRange deleteItems:(NSArray*)deleteItems {
    CGRect bounds = [elements bounds];
    CGSize margin = [self margin];
    CGSize spacing = [self spacing];
    
    __block CGPoint offset = CGPointMake(margin.width, margin.height);
    __block CGSize size = CGSizeMake(margin.width + margin.width, margin.height + margin.height);
    if([layoutItems count] > 0) {
        __block CGSize rowSize = CGSizeZero;
        NSMutableArray* rowItems = [NSMutableArray array];
        [layoutItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            if(NSLocationInRange(elementsIndex, deleteRange) == NO) {
                CGSize elementsItemSize = [layoutItem frameSize];
                if([rowItems count] > 0) {
                    if(offset.x + elementsItemSize.width > (bounds.origin.x + bounds.size.width) - margin.width) {
                        offset.x = margin.width;
                        offset.y += rowSize.height + spacing.height;
                        size.width = MAX(size.width, margin.width + rowSize.width + margin.width);
                        size.height += rowSize.height + spacing.height;
                        
                        [rowItems removeAllObjects];
                        rowSize = CGSizeZero;
                    }
                }
                [layoutItem setFrameOrigin:offset];
                offset.x += elementsItemSize.width + spacing.width;
                rowSize.width += elementsItemSize.width + spacing.width;
                rowSize.height = MAX(elementsItemSize.height, rowSize.height);
                [rowItems addObject:layoutItem];
            }
        }];
        size.width = MAX(size.width, margin.width + rowSize.width + margin.width);
        size.height += rowSize.height + spacing.height;
    }
    return size;
}

@end

/*--------------------------------------------------*/

@implementation MobilyViewElementsLayoutGridHorizontal

- (CGSize)elements:(MobilyViewElements*)elements layoutItems:(NSArray*)layoutItems {
    CGRect bounds = [elements bounds];
    CGSize margin = [self margin];
    CGSize spacing = [self spacing];
    
    __block CGPoint offset = CGPointMake(margin.width, margin.height);
    __block CGSize size = CGSizeMake(margin.width + margin.width, margin.height + margin.height);
    if([layoutItems count] > 0) {
        __block CGSize rowSize = CGSizeZero;
        NSMutableArray* rowItems = [NSMutableArray array];
        [layoutItems enumerateObjectsUsingBlock:^(MobilyViewElementsItem* layoutItem, NSUInteger elementsIndex, BOOL* stop) {
            CGSize elementsItemSize = [layoutItem initialFrameSize];
            if([rowItems count] > 0) {
                if(offset.y + elementsItemSize.height > (bounds.origin.y + bounds.size.height) - margin.height) {
                    offset.x += rowSize.width + spacing.width;
                    offset.y = margin.height;
                    size.width += rowSize.width + spacing.width;
                    size.height = MAX(size.height, margin.height + rowSize.height + margin.height);
                    
                    [rowItems removeAllObjects];
                    rowSize = CGSizeZero;
                }
            }
            [layoutItem setInitialFrameOrigin:offset];
            [layoutItem setFrame:[layoutItem initialFrame]];
            offset.y += elementsItemSize.height + spacing.height;
            rowSize.width = MAX(elementsItemSize.width, rowSize.width);
            rowSize.height += elementsItemSize.height + spacing.height;
            [rowItems addObject:layoutItem];
        }];
        size.width += rowSize.width + spacing.width;
        size.height = MAX(size.height, margin.height + rowSize.height + margin.height);
    }
    return size;
}

@end

/*--------------------------------------------------*/
