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

@implementation MobilyDataFlowContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _margin = UIEdgeInsetsZero;
    _spacing = UIOffsetZero;
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
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

- (void)setSpacing:(UIOffset)spacing {
    if(UIOffsetEqualToOffset(_spacing, spacing) == NO) {
        _spacing = spacing;
        if(self.widget != nil) {
            [self.widget setNeedValidateLayout];
        }
    }
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataVerticalFlowContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _containersHeight = -1.0f;
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
    NSArray* containers = self.containers;
    if(containers.count < 1) {
        return CGRectNull;
    }
    UIEdgeInsets margin = self.margin;
    UIOffset spacing = self.spacing;
    CGFloat containersHeight = _containersHeight;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(frame.size.width - (margin.left + margin.right), ((containersHeight < 0.0f) ? frame.size.height : containersHeight) - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(size.width, 0.0f);
    for(id< MobilyDataContainer > container in containers) {
        CGRect validateFrame = [container validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, size.width, size.height)];
        if(CGRectIsNull(validateFrame) == NO) {
            offset.y = (validateFrame.origin.y + validateFrame.size.height) + spacing.horizontal;
            cumulative.height += validateFrame.size.height + spacing.horizontal;
        }
    }
    cumulative.height -= spacing.horizontal;
    return CGRectMake(frame.origin.x, frame.origin.y, cumulative.width, cumulative.height);
}

- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    UIOffset spacing = self.spacing;
    CGPoint cumulative = CGPointZero;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat maxWidth = frame.size.width - (margin.left + margin.right);
    CGSize rowSize = CGSizeZero;
    NSMutableArray* rowItems = [NSMutableArray array];
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(maxWidth, FLT_MAX)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            if((rowItems.count > 0) && (cumulative.x + itemSize.width > maxWidth)) {
                offset.x = 0.0f;
                offset.y += rowSize.height + spacing.vertical;
                cumulative.x = MAX(maxWidth, margin.left + rowSize.width + margin.right);
                cumulative.y += rowSize.height + spacing.vertical;
                
                [rowItems removeAllObjects];
                rowSize = CGSizeZero;
            }
            item.updateFrame = CGRectMake(offset.x, offset.y, itemSize.width, itemSize.height);
            offset.x += itemSize.width + spacing.horizontal;
            rowSize.width += itemSize.width + spacing.horizontal;
            rowSize.height = MAX(itemSize.height, rowSize.height);
            [rowItems addObject:item];
        }
    }
    cumulative.x -= spacing.horizontal;
    cumulative.y -= spacing.vertical;
    return CGRectMake(frame.origin.x, frame.origin.y, margin.left + cumulative.x + margin.right, margin.top + cumulative.y + margin.bottom);
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataHorizontalFlowContainer

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _containersWidth = -1.0f;
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
    NSArray* containers = self.containers;
    if(containers.count < 1) {
        return CGRectNull;
    }
    UIEdgeInsets margin = self.margin;
    UIOffset spacing = self.spacing;
    CGFloat containersWidth = _containersWidth;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(((containersWidth < 0.0f) ? frame.size.width : containersWidth) - (margin.left + margin.right), frame.size.height - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(0.0f, size.height);
    for(id< MobilyDataContainer > container in containers) {
        CGRect validateFrame = [container validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, size.width, size.height)];
        if(CGRectIsNull(validateFrame) == NO) {
            offset.x = (validateFrame.origin.x + validateFrame.size.width) + spacing.horizontal;
            cumulative.width += validateFrame.size.width + spacing.horizontal;
        }
    }
    cumulative.width -= spacing.horizontal;
    return CGRectMake(frame.origin.x, frame.origin.y, cumulative.width, cumulative.height);
}

- (CGRect)validateItemsLayoutForAvailableFrame:(CGRect)frame {
    UIEdgeInsets margin = self.margin;
    UIOffset spacing = self.spacing;
    CGPoint cumulative = CGPointZero;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat maxHeight = frame.size.height - (margin.top + margin.bottom);
    CGSize rowSize = CGSizeZero;
    NSMutableArray* rowItems = [NSMutableArray array];
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(FLT_MAX, maxHeight)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            if((rowItems.count > 0) && (cumulative.y + itemSize.height > maxHeight)) {
                offset.x += rowSize.width + spacing.horizontal;
                offset.y = 0.0f;
                cumulative.x = rowSize.width + spacing.horizontal;
                cumulative.y += MAX(maxHeight, margin.top + rowSize.height + margin.bottom);
                
                [rowItems removeAllObjects];
                rowSize = CGSizeZero;
            }
            item.updateFrame = CGRectMake(offset.x, offset.y, itemSize.width, itemSize.height);
            offset.y += itemSize.height + spacing.vertical;
            rowSize.width = MAX(itemSize.width, rowSize.width);
            rowSize.height += itemSize.height + spacing.vertical;
            [rowItems addObject:item];
        }
    }
    cumulative.x -= spacing.horizontal;
    cumulative.y -= spacing.vertical;
    return CGRectMake(frame.origin.x, frame.origin.y, margin.left + cumulative.x + margin.right, margin.top + cumulative.y + margin.bottom);
}

@end

/*--------------------------------------------------*/
