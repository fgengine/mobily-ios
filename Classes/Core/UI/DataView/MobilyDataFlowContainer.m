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
    
    self.margin = UIEdgeInsetsZero;
    self.spacing = UIOffsetZero;
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
    UIOffset spacing = self.spacing;
    CGFloat containerSize = _containersHeight;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(frame.size.width - (margin.left + margin.right), ((containerSize < 0.0f) ? frame.size.height : containerSize) - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(size.width, 0.0f);
    for(id< MobilyDataContainer > container in self.containers) {
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
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat restriction = frame.size.width - (margin.left + margin.right);
    CGSize cumulative = CGSizeZero, cumulativeRow = CGSizeZero;
    NSUInteger countOfRow = 0;
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(restriction, FLT_MAX)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            if((countOfRow > 0) && (cumulative.width + itemSize.width > restriction)) {
                offset.x = 0.0f;
                offset.y += cumulativeRow.height + spacing.vertical;
                cumulative.width = MAX(restriction, margin.left + cumulativeRow.width + margin.right);
                cumulative.height += cumulativeRow.height + spacing.vertical;
                cumulativeRow = CGSizeZero;
                countOfRow = 0;
            }
            item.updateFrame = CGRectMake(offset.x, offset.y, itemSize.width, itemSize.height);
            offset.x += itemSize.width + spacing.horizontal;
            cumulativeRow.width += itemSize.width + spacing.horizontal;
            cumulativeRow.height = MAX(itemSize.height, cumulativeRow.height);
            countOfRow++;
        }
    }
    cumulative.width -= spacing.horizontal;
    cumulative.height -= spacing.vertical;
    return CGRectMake(frame.origin.x, frame.origin.y, margin.left + cumulative.width + margin.right, margin.top + cumulative.height + margin.bottom);
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataHorizontalFlowContainer

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
    UIOffset spacing = self.spacing;
    CGFloat containerSize = _containersWidth;
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGSize size = CGSizeMake(((containerSize < 0.0f) ? frame.size.width : containerSize) - (margin.left + margin.right), frame.size.height - (margin.left + margin.right));
    CGSize cumulative = CGSizeMake(0.0f, size.height);
    for(id< MobilyDataContainer > container in self.containers) {
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
    CGPoint offset = CGPointMake(frame.origin.x + margin.left, frame.origin.y + margin.top);
    CGFloat restriction = frame.size.height - (margin.top + margin.bottom);
    CGSize cumulative = CGSizeZero, cumulativeRow = CGSizeZero;
    NSUInteger countOfRow = 0;
    for(id< MobilyDataItem > item in self.items) {
        CGSize itemSize = [item sizeForAvailableSize:CGSizeMake(FLT_MAX, restriction)];
        if((itemSize.width >= 0.0f) && (itemSize.height >= 0.0f)) {
            if((countOfRow > 0) && (cumulative.height + itemSize.height > restriction)) {
                offset.x += cumulativeRow.width + spacing.horizontal;
                offset.y = 0.0f;
                cumulative.width = cumulativeRow.width + spacing.horizontal;
                cumulative.height += MAX(restriction, margin.top + cumulativeRow.height + margin.bottom);
                cumulativeRow = CGSizeZero;
                countOfRow = 0;
            }
            item.updateFrame = CGRectMake(offset.x, offset.y, itemSize.width, itemSize.height);
            offset.y += itemSize.height + spacing.vertical;
            cumulativeRow.width = MAX(itemSize.width, cumulativeRow.width);
            cumulativeRow.height += itemSize.height + spacing.vertical;
            countOfRow++;
        }
    }
    cumulative.width -= spacing.horizontal;
    cumulative.height -= spacing.vertical;
    return CGRectMake(frame.origin.x, frame.origin.y, margin.left + cumulative.width + margin.right, margin.top + cumulative.height + margin.bottom);
}

@end

/*--------------------------------------------------*/
