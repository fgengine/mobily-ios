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

#import <MobilyCore/MobilyButton.h>
#import <MobilyCore/MobilyCG.h>

/*--------------------------------------------------*/

@interface MobilyButton ()

- (void)_updateCurrentState;

@end

/*--------------------------------------------------*/

@implementation MobilyButton

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds moUnionWithArrays:self.subviews, nil];
    }
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andRemovingObject:objectChild];
        [self moRemoveSubview:(UIView*)objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Property

- (void)setTitle:(NSString*)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

- (void)setAttributedTitle:(NSAttributedString*)attributedTitle forState:(UIControlState)state {
    [super setAttributedTitle:attributedTitle forState:state];
    [self setNeedsLayout];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    [super setTitleEdgeInsets:titleEdgeInsets];
    [self setNeedsLayout];
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    [super setImageEdgeInsets:imageEdgeInsets];
    [self setNeedsLayout];
}

- (void)setEnabled:(BOOL)enabled {
    if(self.enabled != enabled) {
        super.enabled = enabled;
        [self _updateCurrentState];
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected {
    if(self.selected != selected) {
        super.selected = selected;
        [self _updateCurrentState];
        [self setNeedsLayout];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if(self.highlighted != highlighted) {
        super.highlighted = highlighted;
        [self _updateCurrentState];
        [self setNeedsLayout];
    }
}

- (void)setImageAlignment:(MobilyButtonImageAlignment)imageAlignment {
    if(_imageAlignment != imageAlignment) {
        _imageAlignment = imageAlignment;
        [self setNeedsLayout];
    }
}

- (void)setNormalBackgroundColor:(UIColor*)normalBackgroundColor {
    if([_normalBackgroundColor isEqual:normalBackgroundColor] == NO) {
        _normalBackgroundColor = normalBackgroundColor;
        [self _updateCurrentState];
    }
}

- (void)setSelectedBackgroundColor:(UIColor*)selectedBackgroundColor {
    if([_selectedBackgroundColor isEqual:selectedBackgroundColor] == NO) {
        _selectedBackgroundColor = selectedBackgroundColor;
        [self _updateCurrentState];
    }
}

- (void)setHighlightedBackgroundColor:(UIColor*)highlightedBackgroundColor {
    if([_highlightedBackgroundColor isEqual:highlightedBackgroundColor] == NO) {
        _highlightedBackgroundColor = highlightedBackgroundColor;
        [self _updateCurrentState];
    }
}

- (void)setDisabledBackgroundColor:(UIColor*)disabledBackgroundColor {
    if([_disabledBackgroundColor isEqual:disabledBackgroundColor] == NO) {
        _disabledBackgroundColor = disabledBackgroundColor;
        [self _updateCurrentState];
    }
}

- (UIColor*)currentBackgroundColor {
    if(_normalBackgroundColor != nil) {
        if(self.isEnabled == NO) {
            if(_disabledBackgroundColor != nil) {
                return _disabledBackgroundColor;
            }
            return [_normalBackgroundColor moMultiplyBrightness:0.85f];
        } else if(self.isHighlighted == YES) {
            if(_highlightedBackgroundColor != nil) {
                return _highlightedBackgroundColor;
            }
            return [_normalBackgroundColor moMultiplyBrightness:1.35f];
        } else if(self.isSelected == YES) {
            if(_selectedBackgroundColor != nil) {
                return _selectedBackgroundColor;
            }
            return [_normalBackgroundColor moMultiplyBrightness:1.10f];
        }
    }
    return _normalBackgroundColor;
}

- (void)setNormalBorderColor:(UIColor*)normalBorderColor {
    if([_normalBorderColor isEqual:normalBorderColor] == NO) {
        _normalBorderColor = normalBorderColor;
        [self _updateCurrentState];
    }
}

- (void)setSelectedBorderColor:(UIColor*)selectedBorderColor {
    if([_selectedBorderColor isEqual:selectedBorderColor] == NO) {
        _selectedBorderColor = selectedBorderColor;
        [self _updateCurrentState];
    }
}

- (void)setHighlightedBorderColor:(UIColor*)highlightedBorderColor {
    if([_highlightedBorderColor isEqual:highlightedBorderColor] == NO) {
        _highlightedBorderColor = highlightedBorderColor;
        [self _updateCurrentState];
    }
}

- (void)setDisabledBorderColor:(UIColor*)disabledBorderColor {
    if([_disabledBorderColor isEqual:disabledBorderColor] == NO) {
        _disabledBorderColor = disabledBorderColor;
        [self _updateCurrentState];
    }
}

- (UIColor*)currentBorderColor {
    if(_normalBorderColor != nil) {
        if(self.isEnabled == NO) {
            if(_disabledBorderColor != nil) {
                return _disabledBorderColor;
            }
            return [_normalBorderColor moMultiplyBrightness:0.85f];
        } else if(self.isHighlighted == YES) {
            if(_highlightedBorderColor != nil) {
                return _highlightedBorderColor;
            }
            return [_normalBorderColor moMultiplyBrightness:1.35f];
        } else if(self.isSelected == YES) {
            if(_selectedBorderColor != nil) {
                return _selectedBorderColor;
            }
            return [_normalBorderColor moMultiplyBrightness:1.10f];
        }
    }
    return _normalBorderColor;
}

- (void)setNormalBorderWidth:(CGFloat)normalBorderWidth {
    if(_normalBorderWidth != normalBorderWidth) {
        _normalBorderWidth = normalBorderWidth;
        [self _updateCurrentState];
    }
}

- (void)setSelectedBorderWidth:(CGFloat)selectedBorderWidth {
    if(_selectedBorderWidth != selectedBorderWidth) {
        _selectedBorderWidth = selectedBorderWidth;
        [self _updateCurrentState];
    }
}

- (void)setHighlightedBorderWidth:(CGFloat)highlightedBorderWidth {
    if(_highlightedBorderWidth != highlightedBorderWidth) {
        _highlightedBorderWidth = highlightedBorderWidth;
        [self _updateCurrentState];
    }
}

- (void)setDisabledBorderWidth:(CGFloat)disabledBorderWidth {
    if(_disabledBorderWidth != disabledBorderWidth) {
        _disabledBorderWidth = disabledBorderWidth;
        [self _updateCurrentState];
    }
}

- (CGFloat)currentBorderWidth {
    if(_normalBorderWidth != 0.0f) {
        if(self.isEnabled == NO) {
            if(_disabledBorderWidth > MOBILY_EPSILON) {
                return _disabledBorderWidth;
            }
        } else if(self.isHighlighted == YES) {
            if(_highlightedBorderWidth > MOBILY_EPSILON) {
                return _highlightedBorderWidth;
            }
        } else if(self.isSelected == YES) {
            if(_selectedBorderWidth > MOBILY_EPSILON) {
                return _selectedBorderWidth;
            }
        }
    }
    return _normalBorderWidth;
}

- (void)setNormalCornerRadius:(CGFloat)normalCornerRadius {
    if(_normalCornerRadius != normalCornerRadius) {
        _normalCornerRadius = normalCornerRadius;
        [self _updateCurrentState];
    }
}

- (void)setSelectedCornerRadius:(CGFloat)selectedCornerRadius {
    if(_selectedCornerRadius != selectedCornerRadius) {
        _selectedCornerRadius = selectedCornerRadius;
        [self _updateCurrentState];
    }
}

- (void)setHighlightedCornerRadius:(CGFloat)highlightedCornerRadius {
    if(_highlightedCornerRadius != highlightedCornerRadius) {
        _highlightedCornerRadius = highlightedCornerRadius;
        [self _updateCurrentState];
    }
}

- (void)setDisabledCornerRadius:(CGFloat)disabledCornerRadius {
    if(_disabledCornerRadius != disabledCornerRadius) {
        _disabledCornerRadius = disabledCornerRadius;
        [self _updateCurrentState];
    }
}

- (CGFloat)currentCornerRadius {
    if(_normalCornerRadius != 0.0f) {
        if(self.isEnabled == NO) {
            if(_disabledCornerRadius > MOBILY_EPSILON) {
                return _disabledCornerRadius;
            }
        } else if(self.isHighlighted == YES) {
            if(_highlightedCornerRadius > MOBILY_EPSILON) {
                return _highlightedCornerRadius;
            }
        } else if(self.isSelected == YES) {
            if(_selectedCornerRadius > MOBILY_EPSILON) {
                return _selectedCornerRadius;
            }
        }
    }
    return _normalCornerRadius;
}

#pragma mark Public override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        CGRect contentRect = [self contentRectForBounds:self.bounds];
        self.titleLabel.frame = [self titleRectForContentRect:contentRect];
        self.imageView.frame = [self imageRectForContentRect:contentRect];
    }
}

- (CGSize)sizeThatFits:(CGSize __unused)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
        UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
        UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
        CGRect contentRect = [super contentRectForBounds:CGRectMake(0.0f, 0.0f, FLT_MAX, FLT_MAX)];
        CGRect titleRect = [super titleRectForContentRect:contentRect];
        CGRect imageRect = [super imageRectForContentRect:contentRect];
        CGSize fullTitleSize = CGSizeMake(titleEdgeInsets.left + titleRect.size.width + titleEdgeInsets.right, titleEdgeInsets.top + titleRect.size.height + titleEdgeInsets.bottom);
        CGSize fullImageSize = CGSizeMake(imageEdgeInsets.left + imageRect.size.width + imageEdgeInsets.right, imageEdgeInsets.top + imageRect.size.height + imageEdgeInsets.bottom);
        CGSize result = CGSizeMake(contentEdgeInsets.left + contentEdgeInsets.right, contentEdgeInsets.top + contentEdgeInsets.bottom);
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft:
            case MobilyButtonImageAlignmentRight:
                result.width += fullTitleSize.width + fullImageSize.width;
                result.height += MAX(fullTitleSize.height, fullImageSize.height);
                break;
            case MobilyButtonImageAlignmentTop:
            case MobilyButtonImageAlignmentBottom:
                result.width += MAX(fullTitleSize.width, fullImageSize.width);
                result.height += fullTitleSize.height + fullImageSize.height;
                break;
        }
        return result;
    }
    return [super intrinsicContentSize];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        CGRect titleRect = [super titleRectForContentRect:CGRectMake(0.0f, 0.0f, FLT_MAX, FLT_MAX)];
        CGRect imageRect = [super imageRectForContentRect:CGRectMake(0.0f, 0.0f, FLT_MAX, FLT_MAX)];
        [self _layoutContentRect:contentRect imageRect:&imageRect imageEdgeInsets:self.imageEdgeInsets imageSize:self.currentImage.size titleRect:&titleRect titleEdgeInsets:self.titleEdgeInsets];
        return titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        CGRect titleRect = [super titleRectForContentRect:CGRectMake(0.0f, 0.0f, FLT_MAX, FLT_MAX)];
        CGRect imageRect = [super imageRectForContentRect:CGRectMake(0.0f, 0.0f, FLT_MAX, FLT_MAX)];
        [self _layoutContentRect:contentRect imageRect:&imageRect imageEdgeInsets:self.imageEdgeInsets imageSize:self.currentImage.size titleRect:&titleRect titleEdgeInsets:self.titleEdgeInsets];
        return imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

#pragma mark Private

- (void)_layoutContentRect:(CGRect)contentRect imageRect:(CGRect*)imageRect imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets imageSize:(CGSize)imageSize titleRect:(CGRect*)titleRect titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    imageRect->size.width = imageSize.width;
    imageRect->size.height = imageSize.height;
    CGSize fullImageSize = CGSizeMake(imageEdgeInsets.left + imageRect->size.width + imageEdgeInsets.right, imageEdgeInsets.top + imageRect->size.height + imageEdgeInsets.bottom);
    CGSize fullTitleSize = CGSizeMake(titleEdgeInsets.left + titleRect->size.width + titleEdgeInsets.right, titleEdgeInsets.top + titleRect->size.height + titleEdgeInsets.bottom);
    CGSize fullSize = CGSizeMake(fullImageSize.width + fullTitleSize.width, fullImageSize.height + fullTitleSize.height);
    switch(self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.x = contentRect.origin.x + imageEdgeInsets.left;
                    titleRect->origin.x = contentRect.origin.x + titleEdgeInsets.left;
                    break;
                case MobilyButtonImageAlignmentLeft:
                    imageRect->origin.x = contentRect.origin.x + imageEdgeInsets.left;
                    titleRect->origin.x = (imageRect->origin.x + imageRect->size.width + imageEdgeInsets.right) + titleEdgeInsets.left;
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x = contentRect.origin.x + titleEdgeInsets.left;
                    imageRect->origin.x = (titleRect->origin.x + titleRect->size.width + titleEdgeInsets.right) + imageEdgeInsets.left;
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentCenter: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.x = (contentRect.origin.x + (contentRect.size.width * 0.5f)) - (imageRect->size.width * 0.5f);
                    titleRect->origin.x = (contentRect.origin.x + (contentRect.size.width * 0.5f)) - (titleRect->size.width * 0.5f);
                    break;
                case MobilyButtonImageAlignmentLeft:
                    imageRect->origin.x = ((contentRect.origin.x + (contentRect.size.width * 0.5f)) - (fullSize.width * 0.5f)) + imageEdgeInsets.left;
                    titleRect->origin.x = (imageRect->origin.x + imageRect->size.width + imageEdgeInsets.right) + titleEdgeInsets.left;
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x = ((contentRect.origin.x + (contentRect.size.width * 0.5f)) - (fullSize.width * 0.5f)) + titleEdgeInsets.left;
                    imageRect->origin.x = (titleRect->origin.x + titleRect->size.width + titleEdgeInsets.right) + imageEdgeInsets.left;
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentRight: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.x = (contentRect.origin.x + contentRect.size.width) - (imageRect->size.width + imageEdgeInsets.right);
                    titleRect->origin.x = (contentRect.origin.x + contentRect.size.width) - (titleRect->size.width + titleEdgeInsets.right);
                    break;
                case MobilyButtonImageAlignmentLeft:
                    titleRect->origin.x = (contentRect.origin.x + contentRect.size.width) - (titleRect->size.width + titleEdgeInsets.right);
                    imageRect->origin.x = (titleRect->origin.x - titleEdgeInsets.left) - (imageRect->size.width + imageEdgeInsets.right);
                    break;
                case MobilyButtonImageAlignmentRight:
                    imageRect->origin.x = (contentRect.origin.x + contentRect.size.width) - (imageRect->size.width + imageEdgeInsets.right);
                    titleRect->origin.x = (imageRect->origin.x - imageEdgeInsets.left) - (titleRect->size.width + titleEdgeInsets.right);
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentFill: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentLeft:
                    imageRect->origin.x = contentRect.origin.x + imageEdgeInsets.left;
                    titleRect->origin.x = (imageRect->origin.x + imageRect->size.width + imageEdgeInsets.right) + titleEdgeInsets.left;
                    titleRect->size.width = contentRect.size.width - (imageEdgeInsets.left + imageRect->size.width + imageEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right);
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x = contentRect.origin.x + titleEdgeInsets.left;
                    titleRect->size.width = contentRect.size.width - (imageEdgeInsets.left + imageRect->size.width + imageEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right);
                    imageRect->origin.x = (titleRect->origin.x + titleRect->size.width + titleEdgeInsets.right) + imageEdgeInsets.left;
                    break;
                default:
                    imageRect->origin.x = contentRect.origin.x + imageEdgeInsets.left;
                    imageRect->size.width = contentRect.size.width - (imageEdgeInsets.left + imageEdgeInsets.right);
                    titleRect->origin.x = contentRect.origin.x + titleEdgeInsets.left;
                    titleRect->size.width = contentRect.size.width - (titleEdgeInsets.left + titleEdgeInsets.right);
                    break;
            }
            break;
        }
    }
    switch(self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentTop: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    imageRect->origin.y = contentRect.origin.y + imageEdgeInsets.top;
                    titleRect->origin.y = (imageRect->origin.y + imageRect->size.height + imageEdgeInsets.bottom) + titleEdgeInsets.top;
                    break;
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.y = (contentRect.origin.y + contentRect.size.height) + imageEdgeInsets.top;
                    titleRect->origin.y = (imageRect->origin.y - imageEdgeInsets.top) + titleEdgeInsets.bottom;
                    break;
                case MobilyButtonImageAlignmentLeft:
                case MobilyButtonImageAlignmentRight:
                    imageRect->origin.y = contentRect.origin.y + imageEdgeInsets.top;
                    titleRect->origin.y = contentRect.origin.y + titleEdgeInsets.top;
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentCenter: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    imageRect->origin.y = ((contentRect.origin.y + (contentRect.size.height * 0.5f)) - (fullSize.height * 0.5f)) + imageEdgeInsets.top;
                    titleRect->origin.y = (imageRect->origin.y + imageRect->size.height + imageEdgeInsets.bottom) + titleEdgeInsets.top;
                    break;
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.y = ((contentRect.origin.y + (contentRect.size.height * 0.5f)) - (fullSize.height * 0.5f)) + titleEdgeInsets.top;
                    imageRect->origin.y = (titleRect->origin.y + titleRect->size.height + titleEdgeInsets.bottom) + imageEdgeInsets.top;
                    break;
                case MobilyButtonImageAlignmentLeft:
                case MobilyButtonImageAlignmentRight:
                    imageRect->origin.y = (contentRect.origin.y + (contentRect.size.height * 0.5f)) - (imageRect->size.height * 0.5f);
                    titleRect->origin.y = (contentRect.origin.y + (contentRect.size.height * 0.5f)) - (titleRect->size.height * 0.5f);
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentBottom: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    titleRect->origin.y = (contentRect.origin.y + contentRect.size.height) - (titleRect->size.width + titleEdgeInsets.bottom);
                    imageRect->origin.y = (titleRect->origin.y - titleEdgeInsets.top) - (imageRect->size.height + imageEdgeInsets.bottom);
                    break;
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.y = (contentRect.origin.y + contentRect.size.height) - (imageRect->size.width + imageEdgeInsets.bottom);
                    titleRect->origin.y = (imageRect->origin.y - imageEdgeInsets.top) - (titleRect->size.height + titleEdgeInsets.bottom);
                    break;
                case MobilyButtonImageAlignmentLeft:
                case MobilyButtonImageAlignmentRight:
                    imageRect->origin.y = (contentRect.origin.y + contentRect.size.height) - (imageRect->size.height + imageEdgeInsets.bottom);
                    titleRect->origin.y = (contentRect.origin.y + contentRect.size.height) - (titleRect->size.height + titleEdgeInsets.bottom);
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentFill: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    imageRect->origin.y = contentRect.origin.y + imageEdgeInsets.top;
                    titleRect->origin.y = (imageRect->origin.y + imageRect->size.height + imageEdgeInsets.bottom) + titleEdgeInsets.top;
                    titleRect->size.height = contentRect.size.height - (imageEdgeInsets.top + imageRect->size.height + imageEdgeInsets.bottom + titleEdgeInsets.top + titleEdgeInsets.bottom);
                    break;
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.y = contentRect.origin.y + titleEdgeInsets.top;
                    titleRect->size.height = contentRect.size.height - (imageEdgeInsets.top + imageRect->size.height + imageEdgeInsets.bottom + titleEdgeInsets.top + titleEdgeInsets.bottom);
                    imageRect->origin.y = (titleRect->origin.y + titleRect->size.height + titleEdgeInsets.bottom) + imageEdgeInsets.top;
                    break;
                default:
                    imageRect->origin.y = contentRect.origin.y + imageEdgeInsets.top;
                    imageRect->size.height = contentRect.size.height - (imageEdgeInsets.top + imageEdgeInsets.bottom);
                    titleRect->origin.y = contentRect.origin.y + titleEdgeInsets.top;
                    titleRect->size.height = contentRect.size.height - (titleEdgeInsets.top + titleEdgeInsets.bottom);
                    break;
            }
            break;
        }
    }
}

- (void)_updateCurrentState {
    UIColor* backgroundColor = [self currentBackgroundColor];
    if(backgroundColor != nil) {
        self.backgroundColor = backgroundColor;
    }
    self.moBorderColor = [self currentBorderColor];
    self.moBorderWidth = [self currentBorderWidth];
    self.moCornerRadius = [self currentCornerRadius];
}

@end

/*--------------------------------------------------*/
