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
@synthesize view = _view;
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

+ (CGSize)sizeForItem:(MobilyDataItem* __unused)item availableSize:(CGSize)size {
    return size;
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
            [_rootView removeGestureRecognizer:_pressGestureRecognizer];
        }
        _pressGestureRecognizer = pressGestureRecognizer;
        if(_pressGestureRecognizer != nil) {
            _pressGestureRecognizer.delaysTouchesBegan = YES;
            _pressGestureRecognizer.delaysTouchesEnded = YES;
            _pressGestureRecognizer.minimumPressDuration = 0.01f;
            _pressGestureRecognizer.delegate = self;
            [_rootView addGestureRecognizer:_pressGestureRecognizer];
        }
    }
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer*)tapGestureRecognizer {
    if(_tapGestureRecognizer != tapGestureRecognizer) {
        if(_tapGestureRecognizer != nil) {
            [_rootView removeGestureRecognizer:_tapGestureRecognizer];
        }
        _tapGestureRecognizer = tapGestureRecognizer;
        if(_tapGestureRecognizer != nil) {
            _tapGestureRecognizer.delaysTouchesBegan = YES;
            _tapGestureRecognizer.delaysTouchesEnded = YES;
            _tapGestureRecognizer.delegate = self;
            [_rootView addGestureRecognizer:_tapGestureRecognizer];
        }
    }
}

- (void)setLongPressGestureRecognizer:(UILongPressGestureRecognizer*)longPressGestureRecognizer {
    if(_longPressGestureRecognizer != longPressGestureRecognizer) {
        if(_longPressGestureRecognizer != nil) {
            [_rootView removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = longPressGestureRecognizer;
        if(_longPressGestureRecognizer != nil) {
            _longPressGestureRecognizer.delaysTouchesBegan = YES;
            _longPressGestureRecognizer.delaysTouchesEnded = YES;
            _longPressGestureRecognizer.delegate = self;
            [_rootView addGestureRecognizer:_longPressGestureRecognizer];
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

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewCenterX, constraintRootViewCenterX, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewCenterY, constraintRootViewCenterY, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewWidth, constraintRootViewWidth, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewHeight, constraintRootViewHeight, self, {
}, {
})

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

- (BOOL)containsEventForKey:(id)key {
    return [_view containsEventForKey:key];
}

- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key {
    return [_view containsEventForIdentifier:identifier forKey:key];
}

- (void)fireEventForKey:(id)key byObject:(id)object {
    [_view fireEventForIdentifier:_identifier forKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:_identifier forKey:key bySender:self byObject:object orDefault:orDefault];
}

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    [_view fireEventForIdentifier:_identifier forKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:_identifier forKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (void)setSelected:(BOOL)selected animated:(BOOL __unused)animated {
    _selected = selected;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL __unused)animated {
    _highlighted = highlighted;
}

- (void)setEditing:(BOOL)editing animated:(BOOL __unused)animated {
    _editing = editing;
}

- (void)validateLayoutForBounds:(CGRect __unused)bounds {
}

- (void)invalidateLayoutForBounds:(CGRect __unused)bounds {
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
        [_view _pressedItem:_item animated:YES];
        [self fireEventForKey:MobilyDataCellPressed byObject:_item];
    }
}

- (void)_handlerLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self fireEventForKey:MobilyDataCellLongPressed byObject:_item];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if((_view.isDragging == YES) || (_view.isDecelerating == YES)) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if((touch.view == _rootView) || (touch.view.canBecomeFirstResponder == NO)) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataCellPressed = @"MobilyDataCellPressed";
NSString* MobilyDataCellLongPressed = @"MobilyDataCellLongPressed";

/*--------------------------------------------------*/
