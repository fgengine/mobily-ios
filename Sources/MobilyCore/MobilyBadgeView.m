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

@property(nonatomic, readwrite, strong) UILabel* badgeLabel;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelTop;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelBottom;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelLeft;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelRight;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelCenterX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLabelCenterY;
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
    
    _badgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    _minimumSize = CGSizeMake(20.0f, 20.0f);
    _maximumSize = CGSizeMake(80.0f, 20.0f);
    
    self.badgeLabel = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, _badgeInsets)];
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

- (void)updateConstraints {
    if(_badgeLabel != nil) {
        if(_constraintLabelTop == nil) {
            self.constraintLabelTop = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeTop constant:_badgeInsets.top];
        } else {
            _constraintLabelTop.constant = _badgeInsets.top;
        }
        if(_constraintLabelBottom == nil) {
            self.constraintLabelBottom = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeBottom constant:_badgeInsets.bottom];
        } else {
            _constraintLabelBottom.constant = _badgeInsets.bottom;
        }
        if(_constraintLabelLeft == nil) {
            self.constraintLabelLeft = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeLeft constant:_badgeInsets.left];
        } else {
            _constraintLabelLeft.constant = _badgeInsets.left;
        }
        if(_constraintLabelRight == nil) {
            self.constraintLabelRight = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeRight constant:_badgeInsets.right];
        } else {
            _constraintLabelRight.constant = _badgeInsets.right;
        }
        if(_constraintLabelCenterX == nil) {
            self.constraintLabelCenterX = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeCenterX relation:NSLayoutRelationEqual attribute:NSLayoutAttributeCenterX constant:0.0f];
        }
        if(_constraintLabelCenterY == nil) {
            self.constraintLabelCenterY = [_badgeLabel moAddConstraintAttribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual attribute:NSLayoutAttributeCenterY constant:0.0f];
        }
    } else {
        self.constraintLabelTop = nil;
        self.constraintLabelBottom = nil;
        self.constraintLabelLeft = nil;
        self.constraintLabelRight = nil;
        self.constraintLabelCenterX = nil;
        self.constraintLabelCenterY = nil;
    }
    if((_minimumSize.width > 0) || (_minimumSize.height > 0)) {
        if(_constraintMinWidth == nil) {
            self.constraintMinWidth = [self moAddConstraintAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual constant:_minimumSize.width];
        } else {
            _constraintMinWidth.constant = _minimumSize.width;
        }
        if(_constraintMinHeight == nil) {
            self.constraintMinHeight = [self moAddConstraintAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationGreaterThanOrEqual constant:_minimumSize.height];
        } else {
            _constraintMinHeight.constant = _minimumSize.height;
        }
    } else {
        self.constraintMinWidth = nil;
        self.constraintMinHeight = nil;
    }
    if((_maximumSize.width > 0) || (_maximumSize.height > 0)) {
        if(_constraintMaxWidth == nil) {
            self.constraintMaxWidth = [self moAddConstraintAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationLessThanOrEqual constant:_maximumSize.width];
        } else {
            _constraintMaxWidth.constant = _maximumSize.width;
        }
        if(_constraintMaxHeight == nil) {
            self.constraintMaxHeight = [self moAddConstraintAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationLessThanOrEqual constant:_maximumSize.height];
        } else {
            _constraintMaxHeight.constant = _maximumSize.height;
        }
    } else {
        self.constraintMaxWidth = nil;
        self.constraintMaxHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property public

- (void)setBadge:(NSString*)badge {
    _badgeLabel.text = badge;
    self.hidden = (_badgeLabel.text.length < 1);
}

- (NSString*)badge {
    return _badgeLabel.text;
}

- (void)setBadgeInsets:(UIEdgeInsets)badgeInsets {
    if(UIEdgeInsetsEqualToEdgeInsets(_badgeInsets, badgeInsets) == NO) {
        _badgeInsets = badgeInsets;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setBadgeColor:(UIColor*)badgeColor {
    _badgeLabel.textColor = badgeColor;
}

- (UIColor*)badgeColor {
    return _badgeLabel.textColor;
}

- (void)setBadgeFont:(UIFont*)badgeFont {
    _badgeLabel.font = badgeFont;
}

- (UIFont*)badgeFont {
    return _badgeLabel.font;
}

- (void)setBadgeShadowColor:(UIColor*)badgeShadowColor {
    _badgeLabel.moShadowColor = badgeShadowColor;
}

- (UIColor*)badgeShadowColor {
    return _badgeLabel.moShadowColor;
}

- (void)setBadgeShadowRadius:(CGFloat)badgeShadowRadius {
    _badgeLabel.moShadowRadius = badgeShadowRadius;
}

- (CGFloat)badgeShadowRadius {
    return _badgeLabel.moShadowRadius;
}

- (void)setBadgeShadowOffset:(CGSize)badgeShadowOffset {
    _badgeLabel.moShadowOffset = badgeShadowOffset;
}

- (CGSize)badgeShadowOffset {
    return _badgeLabel.moShadowOffset;
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

- (void)setBadgeLabel:(UILabel*)badgeLabel {
    if(_badgeLabel != badgeLabel) {
        if(_badgeLabel != nil) {
            [_badgeLabel removeFromSuperview];
        }
        _badgeLabel = badgeLabel;
        if(_badgeLabel != nil) {
            _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _badgeLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_badgeLabel];
        }
        [self setNeedsUpdateConstraints];
    }
}

@end

/*--------------------------------------------------*/
