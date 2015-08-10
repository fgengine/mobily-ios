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

#import <MobilyCore/MobilyBadgeView.h>

/*--------------------------------------------------*/

@interface MobilyBadgeView ()

@property(nonatomic, readwrite, strong) UILabel* label;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintMinWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintMinHeight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintMaxWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintMaxHeight;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBadgeView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

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
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor redColor];
    self.moCornerRadius = 9.0f;
    self.clipsToBounds = YES;
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    _textInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
    _minimumSize = CGSizeMake(18.0f, 18.0f);
    _maximumSize = CGSizeMake((_minimumSize.width * 3.0f), _minimumSize.height);
    
    self.label = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, _textInsets)];
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

#pragma mark Public override

- (CGSize)sizeThatFits:(CGSize)size {
    if(self.translatesAutoresizingMaskIntoConstraints == NO) {
        return [super sizeThatFits:size];
    }
    CGSize available = CGSizeMake(size.width, size.height);
    if(_minimumSize.width > 0.0f) {
        available.width = MAX(_minimumSize.width, available.width);
    }
    if(_minimumSize.height > 0.0f) {
        available.height = MAX(_minimumSize.height, available.height);
    }
    if(_maximumSize.width > 0.0f) {
        available.width = MIN(_maximumSize.width, available.width);
    }
    if(_maximumSize.height > 0.0f) {
        available.height = MIN(_maximumSize.height, available.height);
    }
    CGSize result = [_label sizeThatFits:CGSizeMake(available.width - (_textInsets.left + _textInsets.right), available.height - (_textInsets.top + _textInsets.bottom))];
    result.width += (_textInsets.left + _textInsets.right);
    result.height += (_textInsets.top + _textInsets.bottom);
    if(_minimumSize.width > 0.0f) {
        result.width = MAX(_minimumSize.width, result.width);
    }
    if(_minimumSize.height > 0.0f) {
        result.height = MAX(_minimumSize.height, result.height);
    }
    if(_maximumSize.width > 0.0f) {
        result.width = MIN(_maximumSize.width, result.width);
    }
    if(_maximumSize.height > 0.0f) {
        result.height = MIN(_maximumSize.height, result.height);
    }
    return result;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(self.translatesAutoresizingMaskIntoConstraints == YES) {
        _label.frame = UIEdgeInsetsInsetRect(self.bounds, _textInsets);
    }
}

- (void)updateConstraints {
    if(self.translatesAutoresizingMaskIntoConstraints == NO) {
        if(_label != nil) {
            if(_constraintLabelTop == nil) {
                self.constraintLabelTop = [_label moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual attribute:NSLayoutAttributeTop constant:_textInsets.top];
            } else {
                _constraintLabelTop.constant = _textInsets.top;
            }
            if(_constraintLabelBottom == nil) {
                self.constraintLabelBottom = [_label moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual attribute:NSLayoutAttributeBottom constant:-_textInsets.bottom];
            } else {
                _constraintLabelBottom.constant = -_textInsets.bottom;
            }
            if(_constraintLabelLeft == nil) {
                self.constraintLabelLeft = [_label moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual attribute:NSLayoutAttributeLeft constant:_textInsets.left];
            } else {
                _constraintLabelLeft.constant = _textInsets.left;
            }
            if(_constraintLabelRight == nil) {
                self.constraintLabelRight = [_label moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual attribute:NSLayoutAttributeRight constant:-_textInsets.right];
            } else {
                _constraintLabelRight.constant = -_textInsets.right;
            }
        } else {
            self.constraintLabelTop = nil;
            self.constraintLabelBottom = nil;
            self.constraintLabelLeft = nil;
            self.constraintLabelRight = nil;
        }
        if(_minimumSize.width > 0.0f) {
            if(_constraintMinWidth == nil) {
                self.constraintMinWidth = [self moAddConstraintAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual constant:_minimumSize.width];
            } else {
                _constraintMinWidth.constant = _minimumSize.width;
            }
        } else {
            self.constraintMinWidth = nil;
        }
        if(_maximumSize.width > 0.0f) {
            if(_constraintMaxWidth == nil) {
                self.constraintMaxWidth = [self moAddConstraintAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationLessThanOrEqual constant:_maximumSize.width];
            } else {
                _constraintMaxWidth.constant = _maximumSize.width;
            }
        } else {
            self.constraintMaxWidth = nil;
        }
        if(_minimumSize.height > 0.0f) {
            if(_constraintMinHeight == nil) {
                self.constraintMinHeight = [self moAddConstraintAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationGreaterThanOrEqual constant:_minimumSize.height];
            } else {
                _constraintMinHeight.constant = _minimumSize.height;
            }
        } else {
            self.constraintMinHeight = nil;
        }
        if(_maximumSize.height > 0.0f) {
            if(_constraintMaxHeight == nil) {
                self.constraintMaxHeight = [self moAddConstraintAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationLessThanOrEqual constant:_maximumSize.height];
            } else {
                _constraintMaxHeight.constant = _maximumSize.height;
            }
        } else {
            self.constraintMaxHeight = nil;
        }
    } else {
        self.constraintLabelTop = nil;
        self.constraintLabelBottom = nil;
        self.constraintLabelLeft = nil;
        self.constraintLabelRight = nil;
        self.constraintMinWidth = nil;
        self.constraintMaxWidth = nil;
        self.constraintMinHeight = nil;
        self.constraintMaxHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property override

- (void)setTranslatesAutoresizingMaskIntoConstraints:(BOOL)translatesAutoresizingMaskIntoConstraints {
    if(self.translatesAutoresizingMaskIntoConstraints != translatesAutoresizingMaskIntoConstraints) {
        [super setTranslatesAutoresizingMaskIntoConstraints:translatesAutoresizingMaskIntoConstraints];
        if(_label != nil) {
            _label.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        }
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
}

#pragma mark Property public

- (void)setText:(NSString*)text {
    _label.text = text;
    self.hidden = (text == nil);
}

- (NSString*)text {
    return _label.text;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    if(UIEdgeInsetsEqualToEdgeInsets(_textInsets, textInsets) == NO) {
        _textInsets = textInsets;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setTextColor:(UIColor*)textColor {
    _label.textColor = textColor;
}

- (UIColor*)textColor {
    return _label.textColor;
}

- (void)setTextFont:(UIFont*)textFont {
    _label.font = textFont;
}

- (UIFont*)textFont {
    return _label.font;
}

- (void)setTextShadowColor:(UIColor*)textShadowColor {
    _label.moShadowColor = textShadowColor;
}

- (UIColor*)textShadowColor {
    return _label.moShadowColor;
}

- (void)setTextShadowRadius:(CGFloat)textShadowRadius {
    _label.moShadowRadius = textShadowRadius;
}

- (CGFloat)textShadowRadius {
    return _label.moShadowRadius;
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
    _label.moShadowOffset = textShadowOffset;
}

- (CGSize)textShadowOffset {
    return _label.moShadowOffset;
}

- (void)setMinimumSize:(CGSize)minimumSize {
    if(CGSizeEqualToSize(_minimumSize, minimumSize) == NO) {
        _minimumSize = minimumSize;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMaximumSize:(CGSize)maximumSize {
    if(CGSizeEqualToSize(_maximumSize, maximumSize) == NO) {
        _maximumSize = maximumSize;
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark Property private

- (void)setLabel:(UILabel*)label {
    if(_label != label) {
        if(_label != nil) {
            [_label removeFromSuperview];
        }
        _label = label;
        if(_label != nil) {
            _label.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
            _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _label.textAlignment = NSTextAlignmentCenter;
            _label.font = [UIFont systemFontOfSize:12.0f];
            _label.textColor = [UIColor whiteColor];
            [self addSubview:_label];
        }
        [self setNeedsUpdateConstraints];
    }
}

@end

/*--------------------------------------------------*/
