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

#import "MobilyDataCell+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataCell

#pragma mark Synthesize

@synthesize identifier = _identifier;
@synthesize item = _item;
@synthesize selected = _selected;
@synthesize highlighted = _highlighted;
@synthesize editing = _editing;
@synthesize pressGestureRecognizer = _pressGestureRecognizer;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize rootView = _rootView;
@synthesize rootOffsetOfCenter = _rootOffsetOfCenter;
@synthesize rootMarginSize = _rootMarginSize;
@synthesize constraintRootViewCenterX = _constraintRootViewCenterX;
@synthesize constraintRootViewCenterY = _constraintRootViewCenterY;
@synthesize constraintRootViewWidth = _constraintRootViewWidth;
@synthesize constraintRootViewHeight = _constraintRootViewHeight;

#pragma mark Calculating size

+ (CGSize)sizeForItem:(MobilyDataItem*)item availableSize:(CGSize)size {
    return CGSizeZero;
}

#pragma mark Init / Free

- (instancetype)initWithIdentifier:(NSString*)identifier {
    return [self initWithIdentifier:identifier nib:[UINib nibWithClass:self.class bundle:nil]];
}

- (instancetype)initWithIdentifier:(NSString*)identifier nib:(UINib*)nib {
    self = [super init];
    if(self != nil) {
        _identifier = identifier;
        if(nib != nil) {
            [nib instantiateWithOwner:self options:nil];
        }
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.hidden = YES;
    self.pressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerPressGestureRecognizer:)];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerTapGestureRecognizer:)];
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerLongPressGestureRecognizer:)];
}

#pragma mark UIView

- (void)updateConstraints {
    if(_rootView != nil) {
        if(_constraintRootViewCenterX == nil) {
            self.constraintRootViewCenterX = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:_rootOffsetOfCenter.horizontal];
        }
        if(_constraintRootViewCenterY == nil) {
            self.constraintRootViewCenterY = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:_rootOffsetOfCenter.vertical];
        }
        if(_constraintRootViewWidth == nil) {
            self.constraintRootViewWidth = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:_rootMarginSize.horizontal];
        }
        if(_constraintRootViewHeight == nil) {
            self.constraintRootViewHeight = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_rootMarginSize.vertical];
        }
    } else {
        self.constraintRootViewCenterX = nil;
        self.constraintRootViewCenterY = nil;
        self.constraintRootViewWidth = nil;
        self.constraintRootViewHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property

- (void)setItem:(MobilyDataItem*)item {
    if(_item != item) {
        if(_item != nil) {
            [self prepareForUnuse];
            self.hidden = YES;
        }
        _item = item;
        if(_item != nil) {
            self.hidden = NO;
            [self prepareForUse];
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

- (void)setPressGestureRecognizer:(UILongPressGestureRecognizer*)pressGestureRecognizer {
    if(_pressGestureRecognizer != pressGestureRecognizer) {
        if(_pressGestureRecognizer != nil) {
            [self removeGestureRecognizer:_pressGestureRecognizer];
        }
        _pressGestureRecognizer = pressGestureRecognizer;
        if(_pressGestureRecognizer != nil) {
            _pressGestureRecognizer.minimumPressDuration = 0.01f;
            _pressGestureRecognizer.delegate = self;
            [self addGestureRecognizer:_pressGestureRecognizer];
        }
    }
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer*)tapGestureRecognizer {
    if(_tapGestureRecognizer != tapGestureRecognizer) {
        if(_tapGestureRecognizer != nil) {
            [self removeGestureRecognizer:_tapGestureRecognizer];
        }
        _tapGestureRecognizer = tapGestureRecognizer;
        if(_tapGestureRecognizer != nil) {
            _tapGestureRecognizer.delegate = self;
            [self addGestureRecognizer:_tapGestureRecognizer];
        }
    }
}

- (void)setLongPressGestureRecognizer:(UILongPressGestureRecognizer*)longPressGestureRecognizer {
    if(_longPressGestureRecognizer != longPressGestureRecognizer) {
        if(_longPressGestureRecognizer != nil) {
            [self removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = longPressGestureRecognizer;
        if(_longPressGestureRecognizer != nil) {
            _longPressGestureRecognizer.delegate = self;
            [self addGestureRecognizer:_longPressGestureRecognizer];
        }
    }
}

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [_rootView removeFromSuperview];
        }
        _rootView = rootView;
        if(_rootView != nil) {
            _rootView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        [self setSubviews:self.orderedSubviews];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setConstraintRootViewCenterX:(NSLayoutConstraint*)constraintRootViewCenterX {
    if(_constraintRootViewCenterX != constraintRootViewCenterX) {
        if(_constraintRootViewCenterX != nil) {
            [self removeConstraint:_constraintRootViewCenterX];
        }
        _constraintRootViewCenterX = constraintRootViewCenterX;
        if(_constraintRootViewCenterX != nil) {
            [self addConstraint:_constraintRootViewCenterX];
        }
    }
}

- (void)setConstraintRootViewCenterY:(NSLayoutConstraint*)constraintRootViewCenterY {
    if(_constraintRootViewCenterY != constraintRootViewCenterY) {
        if(_constraintRootViewCenterY != nil) {
            [self removeConstraint:_constraintRootViewCenterY];
        }
        _constraintRootViewCenterY = constraintRootViewCenterY;
        if(_constraintRootViewCenterY != nil) {
            [self addConstraint:_constraintRootViewCenterY];
        }
    }
}

- (void)setConstraintRootViewWidth:(NSLayoutConstraint*)constraintRootViewWidth {
    if(_constraintRootViewWidth != constraintRootViewWidth) {
        if(_constraintRootViewWidth != nil) {
            [self removeConstraint:_constraintRootViewWidth];
        }
        _constraintRootViewWidth = constraintRootViewWidth;
        if(_constraintRootViewWidth != nil) {
            [self addConstraint:_constraintRootViewWidth];
        }
    }
}

- (void)setConstraintRootViewHeight:(NSLayoutConstraint*)constraintRootViewHeight {
    if(_constraintRootViewHeight != constraintRootViewHeight) {
        if(_constraintRootViewHeight != nil) {
            [self removeConstraint:_constraintRootViewHeight];
        }
        _constraintRootViewHeight = constraintRootViewHeight;
        if(_constraintRootViewHeight != nil) {
            [self addConstraint:_constraintRootViewHeight];
        }
    }
}

- (void)setRootOffsetOfCenter:(UIOffset)rootOffsetOfCenter {
    if(UIOffsetEqualToOffset(_rootOffsetOfCenter, rootOffsetOfCenter) == NO) {
        _rootOffsetOfCenter = rootOffsetOfCenter;
        if(_constraintRootViewCenterX != nil) {
            _constraintRootViewCenterX.constant = _rootOffsetOfCenter.horizontal;
        }
        if(_constraintRootViewCenterY != nil) {
            _constraintRootViewCenterY.constant = _rootOffsetOfCenter.vertical;
        }
    }
}

- (void)setRootMarginSize:(UIOffset)rootMarginSize {
    if(UIOffsetEqualToOffset(_rootMarginSize, rootMarginSize) == NO) {
        _rootMarginSize = rootMarginSize;
        if(_constraintRootViewWidth != nil) {
            _constraintRootViewWidth.constant = _rootMarginSize.horizontal;
        }
        if(_constraintRootViewHeight != nil) {
            _constraintRootViewHeight.constant = _rootMarginSize.vertical;
        }
    }
}

- (NSArray*)orderedSubviews {
    if(_rootView != nil) {
        return @[ _rootView ];
    }
    return @[  ];
}

#pragma mark Public

- (void)prepareForUse {
}

- (void)prepareForUnuse {
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_item fireEventForKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_item fireEventForKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    _selected = selected;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    _highlighted = highlighted;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _editing = editing;
}

- (void)animateAction:(MobilyDataCellAction)action {
    switch(action) {
        case MobilyDataCellActionRestore: {
            self.zPosition = 0.0f;
            self.alpha = 1.0f;
            break;
        }
        case MobilyDataCellActionInsert: {
            [UIView performWithoutAnimation:^{
                self.alpha = 0.0f;
            }];
            self.zPosition = 0.0f;
            self.alpha = 1.0f;
            break;
        }
        case MobilyDataCellActionDelete: {
            self.zPosition = -1.0f;
            self.alpha = 0.0f;
            break;
        }
        case MobilyDataCellActionReplaceOut: {
            self.zPosition = -1.0f;
            self.alpha = 0.0f;
            break;
        }
        case MobilyDataCellActionReplaceIn: {
            [UIView performWithoutAnimation:^{
                self.alpha = 0.0f;
            }];
            self.zPosition = 0.0f;
            self.alpha = 1.0f;
            break;
        }
    }
}

- (void)validateLayoutForBounds:(CGRect)bounds {
}

- (void)invalidateLayoutForBounds:(CGRect)bounds {
}

#pragma mark Private

- (void)_handlerPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if(_highlighted == NO) {
            [_item setHighlighted:YES animated:NO];
        }
    } else if(_highlighted == YES) {
        [_item setHighlighted:NO animated:NO];
    }
}

- (void)_handlerTapGestureRecognizer:(UITapGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [_item setSelected:(_selected != YES) animated:YES];
    }
    [_item fireEventForKey:MobilyDataCellPressed bySender:self byObject:_item];
}

- (void)_handlerLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [_item fireEventForKey:MobilyDataCellLongPressed bySender:self byObject:_item];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    if((gestureRecognizer != _pressGestureRecognizer) && (otherGestureRecognizer != _tapGestureRecognizer) && (otherGestureRecognizer != _longPressGestureRecognizer)) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer == _pressGestureRecognizer) {
        return [_item.view shouldHighlightItem:_item];
    } else if(gestureRecognizer == _tapGestureRecognizer) {
        return [_item.view shouldSelectItem:_item];
    } else if(gestureRecognizer == _longPressGestureRecognizer) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataCellPressed = @"MobilyDataCellPressed";
NSString* MobilyDataCellLongPressed = @"MobilyDataCellLongPressed";

/*--------------------------------------------------*/
