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

#import "MobilyLoadedView.h"

/*--------------------------------------------------*/

@interface MobilyLoadedView () {
@protected
    UIView* _rootView;
    UIOffset _rootOffsetOfCenter;
    UIOffset _rootMarginSize;
    NSLayoutConstraint* _constraintRootViewCenterX;
    NSLayoutConstraint* _constraintRootViewCenterY;
    NSLayoutConstraint* _constraintRootViewWidth;
    NSLayoutConstraint* _constraintRootViewHeight;
}

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewCenterX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewHeight;


@end

/*--------------------------------------------------*/

@implementation MobilyLoadedView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize rootView = _rootView;
@synthesize rootOffsetOfCenter = _rootOffsetOfCenter;
@synthesize rootMarginSize = _rootMarginSize;
@synthesize constraintRootViewCenterX = _constraintRootViewCenterX;
@synthesize constraintRootViewCenterY = _constraintRootViewCenterY;
@synthesize constraintRootViewWidth = _constraintRootViewWidth;
@synthesize constraintRootViewHeight = _constraintRootViewHeight;

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
    UINib* nib = [UINib nibWithClass:self.class bundle:nil];
    if(nib != nil) {
        [nib instantiateWithOwner:self options:nil];
    }
    self.clipsToBounds = YES;
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

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [_rootView removeFromSuperview];
        }
        _rootView = rootView;
        if(_rootView != nil) {
            _rootView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_rootView];
        }
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

@end

/*--------------------------------------------------*/
