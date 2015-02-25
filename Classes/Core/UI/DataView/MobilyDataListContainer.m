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

@implementation MobilyDataListContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.margin = UIEdgeInsetsZero;
    self.spacing = 0.0f;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setMargin:(UIEdgeInsets)margin {
    if(UIEdgeInsetsEqualToEdgeInsets(_margin, margin) == NO) {
        _margin = margin;
        if(self.widget != nil) {
            [self.widget setNeedValidateLayout];
        }
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if(_spacing != spacing) {
        _spacing = spacing;
        if(self.widget != nil) {
            [self.widget setNeedValidateLayout];
        }
    }
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataVerticalListContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.containersHeight = -1.0f;
}

#pragma mark Property

- (void)setContainersHeight:(CGFloat)containersHeight {
    if(_containersHeight != containersHeight) {
        _containersHeight = containersHeight;
        if(self.widget != nil) {
            [self.widget setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (CGRect)validateContainersLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    CGFloat spacing = self.spacing;
    CGFloat containerSize = _containersHeight;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(frame.size.width - (margin.left + margin.right), ((containerSize < 0.0f) ? frame.size.height : containerSize) - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(size.width, 0.0f);
    for(id< MobilyDataContainer > container in self.containers) {
        CGRect validateFrame = [container validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, size.width, size.height)];
        if(CGRectIsNull(validateFrame) == NO) {
            offset.y = (validateFrame.origin.y + validateFrame.size.height) + spacing;
            cumulative.height += validateFrame.size.height + spacing;
        }
    }
    cumulative.height -= spacing;
    return CGRectMake(frame.origin.x, frame.origin.y, cumulative.width, cumulative.height);
}

- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    CGFloat spacing = self.spacing;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat restriction = frame.size.width - (margin.left + margin.right);
    CGFloat cumulative = 0.0f;
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(restriction, FLT_MAX)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            item.updateFrame = CGRectMake(offset.x, offset.y + cumulative, restriction, itemSize.height);
            cumulative += itemSize.height + spacing;
        }
    }
    cumulative -= spacing;
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, margin.top + cumulative + margin.bottom);
}

- (void)snapForBounds:(CGRect)bounds {
    CGFloat boundsBeforeEdge = bounds.origin.y;
    CGFloat boundsAfterEdge = bounds.origin.y + bounds.size.height;
    NSMutableArray* beforeItems = NSMutableArray.array;
    NSMutableArray* centerItems = NSMutableArray.array;
    NSMutableArray* afterItems = NSMutableArray.array;
    for(id< MobilyDataItem > item in self.snapToEdgeItems) {
        CGRect itemUpdateFrame = item.updateFrame;
        CGFloat itemBeforeEdge = itemUpdateFrame.origin.y;
        CGFloat itemAfterEdge = itemUpdateFrame.origin.y + itemUpdateFrame.size.height;
        if(itemBeforeEdge < boundsBeforeEdge) {
            [beforeItems addObject:item];
        } else if(itemAfterEdge > boundsAfterEdge) {
            [afterItems addObject:item];
        } else {
            [centerItems addObject:item];
        }
    }
    id< MobilyDataItem > beforeItem = beforeItems.lastObject;
    if(beforeItem != nil) {
        CGRect beforeItemFrame = beforeItem.updateFrame;
        beforeItemFrame.origin.y = boundsBeforeEdge;
        id< MobilyDataItem > centerFirstItem = centerItems.firstObject;
        if(centerFirstItem != nil) {
            CGRect centerFirstItemFrame = centerFirstItem.updateFrame;
            CGFloat centerFirstItemBeforeEdge = centerFirstItemFrame.origin.y - self.spacing;
            if(beforeItemFrame.origin.y + beforeItemFrame.size.height > centerFirstItemBeforeEdge) {
                beforeItemFrame.origin.y = centerFirstItemBeforeEdge - beforeItemFrame.size.height;
            }
        } else {
            beforeItemFrame.origin.y = MIN(boundsBeforeEdge, boundsAfterEdge - beforeItemFrame.size.height);
        }
        beforeItem.displayFrame = beforeItemFrame;
    }
    for(id< MobilyDataItem > centerItem in centerItems) {
        centerItem.displayFrame = centerItem.updateFrame;
    }
    id< MobilyDataItem > afterItem = afterItems.firstObject;
    if(afterItem != nil) {
        CGRect afterItemFrame = afterItem.updateFrame;
        if(boundsAfterEdge - boundsBeforeEdge > afterItemFrame.size.height) {
            afterItemFrame.origin.y = boundsAfterEdge - afterItemFrame.size.height;
        }
        id< MobilyDataItem > centerLastItem = centerItems.lastObject;
        if(centerLastItem != nil) {
            CGRect centerLastItemFrame = centerLastItem.updateFrame;
            CGFloat centerLastItemAfterEdge = (centerLastItemFrame.origin.y + centerLastItemFrame.size.height) + self.spacing;
            if(afterItemFrame.origin.y < centerLastItemAfterEdge) {
                afterItemFrame.origin.y = centerLastItemAfterEdge;
            }
        }
        afterItem.displayFrame = afterItemFrame;
    }
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataHorizontalListContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.containersWidth = -1.0f;
}

#pragma mark Property

- (void)setContainersWidth:(CGFloat)containersWidth {
    if(_containersWidth != containersWidth) {
        _containersWidth = containersWidth;
        if(self.widget != nil) {
            [self.widget setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (CGRect)validateContainersLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    CGFloat spacing = self.spacing;
    CGFloat containerSize = _containersWidth;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(((containerSize < 0.0f) ? frame.size.width : containerSize) - (margin.left + margin.right), frame.size.height - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(0.0f, size.height);
    for(id< MobilyDataContainer > container in self.containers) {
        CGRect validateFrame = [container validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, size.width, size.height)];
        if(CGRectIsNull(validateFrame) == NO) {
            offset.x = (validateFrame.origin.x + validateFrame.size.width) + spacing;
            cumulative.width += validateFrame.size.width + spacing;
        }
    }
    cumulative.width -= spacing;
    return CGRectMake(frame.origin.x, frame.origin.y, cumulative.width, cumulative.height);
}

- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    CGFloat spacing = self.spacing;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat restriction = frame.size.height - (margin.top + margin.bottom);
    CGFloat cumulative = 0.0f;
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(FLT_MAX, restriction)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            item.updateFrame = CGRectMake(offset.x + cumulative, offset.y, itemSize.width, restriction);
            cumulative += itemSize.width + spacing;
        }
    }
    cumulative -= spacing;
    return CGRectMake(frame.origin.x, frame.origin.y, margin.left + cumulative + margin.right, frame.size.height);
}

- (void)snapForBounds:(CGRect)bounds {
    CGFloat boundsBeforeEdge = bounds.origin.x;
    CGFloat boundsAfterEdge = bounds.origin.x + bounds.size.width;
    NSMutableArray* beforeItems = NSMutableArray.array;
    NSMutableArray* centerItems = NSMutableArray.array;
    NSMutableArray* afterItems = NSMutableArray.array;
    for(id< MobilyDataItem > item in self.snapToEdgeItems) {
        CGRect itemUpdateFrame = item.updateFrame;
        CGFloat itemBeforeEdge = itemUpdateFrame.origin.x;
        CGFloat itemAfterEdge = itemUpdateFrame.origin.x + itemUpdateFrame.size.width;
        if(itemBeforeEdge < boundsBeforeEdge) {
            [beforeItems addObject:item];
        } else if(itemAfterEdge > boundsAfterEdge) {
            [afterItems addObject:item];
        } else {
            [centerItems addObject:item];
        }
    }
    id< MobilyDataItem > beforeItem = beforeItems.lastObject;
    if(beforeItem != nil) {
        CGRect beforeItemFrame = beforeItem.updateFrame;
        beforeItemFrame.origin.x = boundsBeforeEdge;
        id< MobilyDataItem > centerFirstItem = centerItems.firstObject;
        if(centerFirstItem != nil) {
            CGRect centerFirstItemFrame = centerFirstItem.updateFrame;
            CGFloat centerFirstItemBeforeEdge = centerFirstItemFrame.origin.x - self.spacing;
            if(beforeItemFrame.origin.x + beforeItemFrame.size.width > centerFirstItemBeforeEdge) {
                beforeItemFrame.origin.x = centerFirstItemBeforeEdge - beforeItemFrame.size.width;
            }
        } else {
            beforeItemFrame.origin.x = MIN(boundsBeforeEdge, boundsAfterEdge - beforeItemFrame.size.width);
        }
        beforeItem.displayFrame = beforeItemFrame;
    }
    for(id< MobilyDataItem > centerItem in centerItems) {
        centerItem.displayFrame = centerItem.updateFrame;
    }
    id< MobilyDataItem > afterItem = afterItems.firstObject;
    if(afterItem != nil) {
        CGRect afterItemFrame = afterItem.updateFrame;
        if(boundsAfterEdge - boundsBeforeEdge > afterItemFrame.size.width) {
            afterItemFrame.origin.x = boundsAfterEdge - afterItemFrame.size.width;
        }
        id< MobilyDataItem > centerLastItem = centerItems.lastObject;
        if(centerLastItem != nil) {
            CGRect centerLastItemFrame = centerLastItem.updateFrame;
            CGFloat centerLastItemAfterEdge = (centerLastItemFrame.origin.x + centerLastItemFrame.size.width) + self.spacing;
            if(afterItemFrame.origin.x < centerLastItemAfterEdge) {
                afterItemFrame.origin.x = centerLastItemAfterEdge;
            }
        }
        afterItem.displayFrame = afterItemFrame;
    }
}

@end

/*--------------------------------------------------*/
