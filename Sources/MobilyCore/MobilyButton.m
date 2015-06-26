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
    [self _updateCurrentState];
    
    self.titleLabel.backgroundColor = UIColor.redColor;
    self.imageView.backgroundColor = UIColor.yellowColor;
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

- (CGSize)sizeThatFits:(CGSize __unused)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize result = CGSizeZero;
    NSString* title = self.currentTitle;
    UIImage* image = self.currentImage;
    if((self.window != nil) && (title.length > 0) && (image != nil)) {
        self.titleLabel.text = title;
        CGSize titleSize = [self.titleLabel intrinsicContentSize];
        titleSize.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        titleSize.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft:
            case MobilyButtonImageAlignmentRight:
                result.width += imageSize.width + titleSize.width;
                result.height += MAX(imageSize.height, titleSize.height);
                break;
            case MobilyButtonImageAlignmentTop:
            case MobilyButtonImageAlignmentBottom:
                result.width += MAX(imageSize.width, titleSize.width);
                result.height += imageSize.height + titleSize.height;
                break;
        }
        result.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        result.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    } else {
        result = [super intrinsicContentSize];
    }
    return result;
}
/*
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect result = CGRectZero;
    NSString* title = self.currentTitle;
    UIImage* image = self.currentImage;
    if((title.length > 0) && (image != nil)) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = [super imageRectForContentRect:contentRect];
        CGRect titleRect = [super titleRectForContentRect:contentRect];
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: {
                if(_imageWrap) {
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            titleRect.origin.x += _imageWrapValue/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentLeft: {
                            titleRect.origin.x += _imageWrapValue;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            break;
                        }
                        default:
                            break;
                    }
                }
                break;
            }
            case MobilyButtonImageAlignmentRight: {
                if(_imageWrap) {
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            titleRect.origin.x = imageRect.origin.x-_imageWrapValue/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentLeft: {
                            titleRect.origin.x = imageRect.origin.x;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            titleRect.origin.x = imageRect.origin.x-_imageWrapValue;
                            break;
                        }
                        default:
                            break;
                    }
                }
                break;
            }
            case MobilyButtonImageAlignmentTop: {
                
                break;
            }
            case MobilyButtonImageAlignmentBottom: {
                if(_imageWrap) {
                    CGFloat height = titleRect.size.height + imageRect.size.height + _imageWrapValue;
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            titleRect.origin.x = contentRect.size.width/2-titleRect.size.width/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentLeft: {
                            titleRect.origin.x = contentRect.origin.x;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            titleRect.origin.x = CGRectGetMaxX(contentRect)-titleRect.size.width;
                            break;
                        }
                        default:
                            break;
                    }
                    
                    switch(self.contentVerticalAlignment) {
                        case UIControlContentVerticalAlignmentTop:
                            titleRect.origin.y = 0.0f;
                            break;
                        case UIControlContentVerticalAlignmentCenter:
                            titleRect.origin.y = (contentRect.size.height - height)/2;
                            break;
                        case UIControlContentVerticalAlignmentBottom:
                            titleRect.origin.y = (contentRect.size.height - height);
                            break;
                        default:
                            break;
                    }
                }
                break;
            }
        }
        
        result = titleRect;
    } else {
        result = [super titleRectForContentRect:contentRect];
    }
    return result;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect result = CGRectZero;
    NSString* title = self.currentTitle;
    UIImage* image = self.currentImage;
    if((title.length > 0) && (image != nil)) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = [super imageRectForContentRect:contentRect];
        CGRect titleRect = [super titleRectForContentRect:contentRect];
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: {
                if(_imageWrap) {
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            imageRect.origin.x -= _imageWrapValue/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            imageRect.origin.x -= _imageWrapValue;
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    imageRect.origin.x = 0.0f;
                }
                break;
            }
            case MobilyButtonImageAlignmentRight: {
                // imageRect.origin.x = (_imageWrap) ? CGRectGetMaxX(titleRect)-imageRect.size.width+_imageWrapValue : CGRectGetMaxX(contentRect)-imageRect.size.width;
                
                if(_imageWrap) {
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            imageRect.origin.x = CGRectGetMaxX(titleRect)-imageRect.size.width+_imageWrapValue/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentLeft: {
                            imageRect.origin.x = CGRectGetMaxX(titleRect)-imageRect.size.width+_imageWrapValue;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            imageRect.origin.x = CGRectGetMaxX(titleRect)-imageRect.size.width;
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    imageRect.origin.x = CGRectGetMaxX(contentRect)-imageRect.size.width;
                }
                 
                break;
            }
            case MobilyButtonImageAlignmentTop: {
                
                break;
            }
            case MobilyButtonImageAlignmentBottom: {
                if(_imageWrap) {
                    CGFloat height = titleRect.size.height + imageRect.size.height + _imageWrapValue;
                    switch(self.contentHorizontalAlignment) {
                        case UIControlContentHorizontalAlignmentCenter: {
                            imageRect.origin.x = contentRect.size.width/2-imageRect.size.width/2;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentLeft: {
                            imageRect.origin.x = contentRect.origin.x;
                            break;
                        }
                        case UIControlContentHorizontalAlignmentRight: {
                            imageRect.origin.x = CGRectGetMaxX(contentRect)-imageRect.size.width;
                            break;
                        }
                        default:
                            break;
                    }
                    
                    switch(self.contentVerticalAlignment) {
                        case UIControlContentVerticalAlignmentTop:
                            imageRect.origin.y = titleRect.size.height + _imageWrapValue;
                            break;
                        case UIControlContentVerticalAlignmentCenter:
                            imageRect.origin.y = (contentRect.size.height-height)/2 + height - imageRect.size.height;
                            break;
                        case UIControlContentVerticalAlignmentBottom:
                            imageRect.origin.y = (contentRect.size.height - imageRect.size.height);
                            break;
                        default:
                            break;
                    }
                }
                break;
            }
        }
        result = imageRect;
    } else {
        result = [super imageRectForContentRect:contentRect];
    }
    return result;
}
*/


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect result = CGRectZero;
    NSString* title = self.currentTitle;
    UIImage* image = self.currentImage;
    if((title.length > 0) && (image != nil)) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = CGRectZero;
        CGRect titleRect = CGRectZero;
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMinXEdge); break;
            case MobilyButtonImageAlignmentRight: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMaxXEdge); break;
            case MobilyButtonImageAlignmentTop: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMinYEdge); break;
            case MobilyButtonImageAlignmentBottom: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMaxYEdge); break;
        }
        titleRect = UIEdgeInsetsInsetRect(titleRect, self.titleEdgeInsets);
        
        result = titleRect;
    } else {
        result = [super titleRectForContentRect:contentRect];
    }
    return result;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect result = CGRectZero;
    NSString* title = self.currentTitle;
    UIImage* image = self.currentImage;
    if((title.length > 0) && (image != nil)) {
        CGSize imageSize = image.size;
        imageSize.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        imageSize.height += self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
        CGRect imageRect = CGRectZero;
        CGRect titleRect = CGRectZero;
        switch(_imageAlignment) {
            case MobilyButtonImageAlignmentLeft: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMinXEdge); break;
            case MobilyButtonImageAlignmentRight: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.width, CGRectMaxXEdge); break;
            case MobilyButtonImageAlignmentTop: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMinYEdge); break;
            case MobilyButtonImageAlignmentBottom: CGRectDivide(contentRect, &imageRect, &titleRect, imageSize.height, CGRectMaxYEdge); break;
        }
        imageRect = UIEdgeInsetsInsetRect(imageRect, self.imageEdgeInsets);
        
        result = imageRect;
    } else {
        result = [super imageRectForContentRect:contentRect];
    }
    return result;
}


#pragma mark Private

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
