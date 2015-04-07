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

#import "MobilyScrollView.h"

/*--------------------------------------------------*/

@interface MobilyScrollView ()

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewL;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewT;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewR;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewB;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewW;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewH;

- (void)linkConstraint;
- (void)unlinkConstraint;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyScrollView

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
    self.direction = MobilyScrollViewDirectionVertical;
    
    [self registerAdjustmentResponder];
}

- (void)dealloc {
    [self unregisterAdjustmentResponder];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds unionWithArray:self.subviews];
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

#pragma mark Public

#pragma mark Property

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewL, constraintRootViewL, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewT, constraintRootViewT, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewR, constraintRootViewR, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewB, constraintRootViewB, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewW, constraintRootViewW, self, {
}, {
})

MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(ConstraintRootViewH, constraintRootViewH, self, {
}, {
})

- (void)setDirection:(MobilyScrollViewDirection)direction {
    if(_direction != direction) {
        if(_rootView != nil) {
            [self unlinkConstraint];
        }
        _direction = direction;
        if(_rootView != nil) {
            [self linkConstraint];
        }
        [self setNeedsLayout];
    }
}

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [self unlinkConstraint];
            [_rootView removeFromSuperview];
        }
        _rootView = rootView;
        if(_rootView != nil) {
            _rootView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_rootView];
            [self linkConstraint];
        }
        [self setNeedsLayout];
    }
}

#pragma mark Private

- (void)linkConstraint {
    switch(_direction) {
        case MobilyScrollViewDirectionStretch:
            self.constraintRootViewL = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            self.constraintRootViewT = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            self.constraintRootViewR = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
            self.constraintRootViewB = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            self.constraintRootViewW = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
            self.constraintRootViewH = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
            break;
        case MobilyScrollViewDirectionVertical:
            self.constraintRootViewT = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            self.constraintRootViewB = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            self.constraintRootViewL = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
            self.constraintRootViewR = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
            self.constraintRootViewW = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
            break;
        case MobilyScrollViewDirectionHorizontal:
            self.constraintRootViewT = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            self.constraintRootViewB = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            self.constraintRootViewL = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
            self.constraintRootViewR = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
            self.constraintRootViewH = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
            break;
    }
}

- (void)unlinkConstraint {
    self.constraintRootViewL = nil;
    self.constraintRootViewT = nil;
    self.constraintRootViewR = nil;
    self.constraintRootViewB = nil;
    self.constraintRootViewW = nil;
    self.constraintRootViewH = nil;
}

@end

/*--------------------------------------------------*/
