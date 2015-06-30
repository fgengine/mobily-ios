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
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self _updateCurrentState];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds unionWithArrays:self.subviews, nil];
    }
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
        [self removeSubview:(UIView*)objectChild];
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

- (void)setEnabled:(BOOL)enabled {
    if(self.enabled != enabled) {
        super.enabled = enabled;
        [self _updateCurrentState];
    }
}

- (void)setSelected:(BOOL)selected {
    if(self.selected != selected) {
        super.selected = selected;
        [self _updateCurrentState];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if(self.highlighted != highlighted) {
        super.highlighted = highlighted;
        [self _updateCurrentState];
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
            return [_normalBackgroundColor multiplyBrightness:0.85f];
        } else if(self.isHighlighted == YES) {
            if(_highlightedBackgroundColor != nil) {
                return _highlightedBackgroundColor;
            }
            return [_normalBackgroundColor multiplyBrightness:1.35f];
        } else if(self.isSelected == YES) {
            if(_selectedBackgroundColor != nil) {
                return _selectedBackgroundColor;
            }
            return [_normalBackgroundColor multiplyBrightness:1.10f];
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
            return [_normalBorderColor multiplyBrightness:0.85f];
        } else if(self.isHighlighted == YES) {
            if(_highlightedBorderColor != nil) {
                return _highlightedBorderColor;
            }
            return [_normalBorderColor multiplyBrightness:1.35f];
        } else if(self.isSelected == YES) {
            if(_selectedBorderColor != nil) {
                return _selectedBorderColor;
            }
            return [_normalBorderColor multiplyBrightness:1.10f];
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
            if(_disabledBorderWidth > FLT_EPSILON) {
                return _disabledBorderWidth;
            }
        } else if(self.isHighlighted == YES) {
            if(_highlightedBorderWidth > FLT_EPSILON) {
                return _highlightedBorderWidth;
            }
        } else if(self.isSelected == YES) {
            if(_selectedBorderWidth > FLT_EPSILON) {
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
            if(_disabledCornerRadius > FLT_EPSILON) {
                return _disabledCornerRadius;
            }
        } else if(self.isHighlighted == YES) {
            if(_highlightedCornerRadius > FLT_EPSILON) {
                return _highlightedCornerRadius;
            }
        } else if(self.isSelected == YES) {
            if(_selectedCornerRadius > FLT_EPSILON) {
                return _selectedCornerRadius;
            }
        }
    }
    return _normalCornerRadius;
}

#pragma mark Public override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    self.titleLabel.frame = [self titleRectForContentRect:contentRect];
    self.imageView.frame = [self imageRectForContentRect:contentRect];
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
        CGRect titleRect = UIEdgeInsetsInsetRect([super titleRectForContentRect:contentRect], UIEdgeInsetsMake(-titleEdgeInsets.top, -titleEdgeInsets.left, -titleEdgeInsets.bottom, -titleEdgeInsets.right));
        CGRect imageRect = UIEdgeInsetsInsetRect([super imageRectForContentRect:contentRect], UIEdgeInsetsMake(-imageEdgeInsets.top, -imageEdgeInsets.left, -imageEdgeInsets.bottom, -imageEdgeInsets.right));
        CGSize result = CGSizeMake(contentEdgeInsets.left + contentEdgeInsets.right, contentEdgeInsets.top + contentEdgeInsets.bottom);
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft:
            case MobilyButtonImageAlignmentRight:
                result.width += titleRect.size.width + imageRect.size.width;
                result.height += MAX(titleRect.size.height, imageRect.size.height);
                break;
            case MobilyButtonImageAlignmentTop:
            case MobilyButtonImageAlignmentBottom:
                result.width += MAX(titleRect.size.width, imageRect.size.width);
                result.height += titleRect.size.height + imageRect.size.height;
                break;
        }
        return result;
    }
    return [super intrinsicContentSize];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
        UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
        CGRect titleRect = UIEdgeInsetsInsetRect([super titleRectForContentRect:contentRect], UIEdgeInsetsMake(-titleEdgeInsets.top, -titleEdgeInsets.left, -titleEdgeInsets.bottom, -titleEdgeInsets.right));
        CGRect imageRect = UIEdgeInsetsInsetRect([super imageRectForContentRect:contentRect], UIEdgeInsetsMake(-imageEdgeInsets.top, -imageEdgeInsets.left, -imageEdgeInsets.bottom, -imageEdgeInsets.right));
        [self _layoutContentRect:contentRect titleRect:&titleRect imageRect:&imageRect imageSize:self.currentImage.size];
        return UIEdgeInsetsInsetRect(titleRect, titleEdgeInsets);
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if(((self.currentTitle.length > 0) || (self.currentAttributedTitle.length > 0)) && (self.currentImage != nil)) {
        UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
        UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
        CGRect titleRect = UIEdgeInsetsInsetRect([super titleRectForContentRect:contentRect], UIEdgeInsetsMake(-titleEdgeInsets.top, -titleEdgeInsets.left, -titleEdgeInsets.bottom, -titleEdgeInsets.right));
        CGRect imageRect = UIEdgeInsetsInsetRect([super imageRectForContentRect:contentRect], UIEdgeInsetsMake(-imageEdgeInsets.top, -imageEdgeInsets.left, -imageEdgeInsets.bottom, -imageEdgeInsets.right));
        [self _layoutContentRect:contentRect titleRect:&titleRect imageRect:&imageRect imageSize:self.currentImage.size];
        return UIEdgeInsetsInsetRect(imageRect, imageEdgeInsets);
    }
    return [super imageRectForContentRect:contentRect];
}

#pragma mark Private

- (void)_layoutContentRect:(CGRect)contentRect titleRect:(CGRect*)titleRect imageRect:(CGRect*)imageRect imageSize:(CGSize)imageSize {
    switch(self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.x = imageRect->origin.x;
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x -= imageRect->size.width;
                    imageRect->origin.x += titleRect->size.width;
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentCenter: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.x -= imageRect->size.width * 0.5f;
                    imageRect->origin.x = (titleRect->origin.x + (titleRect->size.width * 0.5f)) - (imageRect->size.width * 0.5f);
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x -= imageRect->size.width;
                    imageRect->origin.x += titleRect->size.width;
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentRight: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.x = (titleRect->origin.x + titleRect->size.width) - imageRect->size.width ;
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    titleRect->origin.x -= imageRect->size.width;
                    imageRect->origin.x += titleRect->size.width;
                    break;
            }
            break;
        }
        case UIControlContentHorizontalAlignmentFill: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentLeft:
                    CGRectDivide(contentRect, imageRect, titleRect, imageSize.width, CGRectMinXEdge);
                    break;
                case MobilyButtonImageAlignmentRight:
                    CGRectDivide(contentRect, imageRect, titleRect, imageSize.width, CGRectMaxXEdge);
                    break;
                default:
                    imageRect->origin.x = contentRect.origin.x;
                    imageRect->size.width = contentRect.size.width;
                    titleRect->origin.x = contentRect.origin.x;
                    titleRect->size.width = contentRect.size.width;
                    break;
            }
            break;
        }
    }
    switch(self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentTop: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    titleRect->origin.y += imageRect->size.height;
                    break;
                case MobilyButtonImageAlignmentBottom:
                    imageRect->origin.y += titleRect->size.height;
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentCenter: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    titleRect->origin.y += (imageRect->size.height * 0.5f);
                    imageRect->origin.y -= (imageRect->size.height * 0.5f);
                    break;
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.y -= (imageRect->size.height * 0.5f);
                    imageRect->origin.y += (imageRect->size.height * 0.5f);
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentBottom: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                case MobilyButtonImageAlignmentBottom:
                    titleRect->origin.y -= imageRect->size.height;
                    break;
                case MobilyButtonImageAlignmentLeft:
                    break;
                case MobilyButtonImageAlignmentRight:
                    break;
            }
            break;
        }
        case UIControlContentVerticalAlignmentFill: {
            switch(_imageAlignment) {
                case MobilyButtonImageAlignmentTop:
                    CGRectDivide(contentRect, imageRect, titleRect, imageSize.height, CGRectMinYEdge);
                    break;
                case MobilyButtonImageAlignmentBottom:
                    CGRectDivide(contentRect, imageRect, titleRect, imageSize.height, CGRectMaxYEdge);
                    break;
                default:
                    imageRect->origin.y = contentRect.origin.y;
                    imageRect->size.height = contentRect.size.height;
                    titleRect->origin.y = contentRect.origin.y;
                    titleRect->size.height = contentRect.size.height;
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
    self.borderColor = [self currentBorderColor];
    self.borderWidth = [self currentBorderWidth];
    self.cornerRadius = [self currentCornerRadius];
}

@end

/*--------------------------------------------------*/
