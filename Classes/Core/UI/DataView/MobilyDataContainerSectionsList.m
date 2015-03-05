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

@implementation MobilyDataContainerSectionsList

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.margin = UIEdgeInsetsZero;
    self.spacing = UIOffsetZero;
}

- (void)dealloc {
}

#pragma mark Property

- (void)setOrientation:(MobilyDataContainerOrientation)orientation {
    if(_orientation != orientation) {
        _orientation = orientation;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMargin:(UIEdgeInsets)margin {
    if(UIEdgeInsetsEqualToEdgeInsets(_margin, margin) == NO) {
        _margin = margin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setSpacing:(UIOffset)spacing {
    if(UIOffsetEqualToOffset(_spacing, spacing) == NO) {
        _spacing = spacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

#pragma mark Private override

- (CGRect)_validateSectionsForAvailableFrame:(CGRect)frame {
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGSize restriction = CGSizeMake(frame.size.width - (_margin.left + _margin.right), frame.size.height - (_margin.left + _margin.right));
    CGSize cumulative = CGSizeZero;
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            for(MobilyDataContainer* container in _sections) {
                CGRect containerFrame = [container _validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, restriction.width, restriction.height)];
                if(CGRectIsNull(containerFrame) == NO) {
                    offset.y = (containerFrame.origin.y + containerFrame.size.height) + _spacing.vertical;
                    cumulative.width = MAX(containerFrame.size.width, restriction.width);
                    cumulative.height += containerFrame.size.height + _spacing.vertical;
                }
            }
            cumulative.height -= _spacing.vertical;
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            for(MobilyDataContainer* container in _sections) {
                CGRect containerFrame = [container _validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, restriction.width, restriction.height)];
                if(CGRectIsNull(containerFrame) == NO) {
                    offset.x = (containerFrame.origin.x + containerFrame.size.width) + _spacing.horizontal;
                    cumulative.width += containerFrame.size.width + _spacing.horizontal;
                    cumulative.height = MAX(containerFrame.size.height, restriction.height);
                }
            }
            cumulative.width -= _spacing.horizontal;
            break;
        }
    }
    return CGRectMake(frame.origin.x, frame.origin.y, _margin.left + cumulative.width + _margin.right, _margin.top + cumulative.height + _margin.bottom);
}

@end

/*--------------------------------------------------*/
