/*--------------------------------------------------*/

#import "MobilyViewScroll.h"

/*--------------------------------------------------*/

@interface MobilyViewScroll ()

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

@implementation MobilyViewScroll

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [self unregisterAdjustmentResponder];
    
    [self setRootView:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild]];
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

- (void)setupView {
    [self setDirection:MobilyViewScrollDirectionVertical];
    
    [self registerAdjustmentResponder];
}

#pragma mark Property

- (void)setConstraintRootViewL:(NSLayoutConstraint*)constraintRootViewL {
    if(_constraintRootViewL != constraintRootViewL) {
        if(_constraintRootViewL != nil) {
            [self removeConstraint:_constraintRootViewL];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewL, constraintRootViewL);
        if(_constraintRootViewL != nil) {
            [self addConstraint:_constraintRootViewL];
        }
    }
}

- (void)setConstraintRootViewT:(NSLayoutConstraint*)constraintRootViewT {
    if(_constraintRootViewT != constraintRootViewT) {
        if(_constraintRootViewT != nil) {
            [self removeConstraint:_constraintRootViewT];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewT, constraintRootViewT);
        if(_constraintRootViewT != nil) {
            [self addConstraint:_constraintRootViewT];
        }
    }
}

- (void)setConstraintRootViewR:(NSLayoutConstraint*)constraintRootViewR {
    if(_constraintRootViewR != constraintRootViewR) {
        if(_constraintRootViewR != nil) {
            [self removeConstraint:_constraintRootViewR];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewR, constraintRootViewR);
        if(_constraintRootViewR != nil) {
            [self addConstraint:_constraintRootViewR];
        }
    }
}

- (void)setConstraintRootViewB:(NSLayoutConstraint*)constraintRootViewB {
    if(_constraintRootViewB != constraintRootViewB) {
        if(_constraintRootViewB != nil) {
            [self removeConstraint:_constraintRootViewB];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewB, constraintRootViewB);
        if(_constraintRootViewB != nil) {
            [self addConstraint:_constraintRootViewB];
        }
    }
}

- (void)setConstraintRootViewW:(NSLayoutConstraint*)constraintRootViewW {
    if(_constraintRootViewW != constraintRootViewW) {
        if(_constraintRootViewW != nil) {
            [self removeConstraint:_constraintRootViewW];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewW, constraintRootViewW);
        if(_constraintRootViewW != nil) {
            [self addConstraint:_constraintRootViewW];
        }
    }
}

- (void)setConstraintRootViewH:(NSLayoutConstraint*)constraintRootViewH {
    if(_constraintRootViewH != constraintRootViewH) {
        if(_constraintRootViewH != nil) {
            [self removeConstraint:_constraintRootViewH];
        }
        MOBILY_SAFE_SETTER(_constraintRootViewH, constraintRootViewH);
        if(_constraintRootViewH != nil) {
            [self addConstraint:_constraintRootViewH];
        }
    }
}

- (void)setDirection:(MobilyViewScrollDirection)direction {
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
        MOBILY_SAFE_SETTER(_rootView, rootView);
        if(_rootView != nil) {
            [_rootView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:_rootView];
            [self linkConstraint];
        }
        [self setNeedsLayout];
    }
}

#pragma mark Private

- (void)linkConstraint {
    switch(_direction) {
        case MobilyViewScrollDirectionStretch:
            [self setConstraintRootViewT:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewB:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewL:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewR:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewW:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewH:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
            break;
        case MobilyViewScrollDirectionVertical:
            [self setConstraintRootViewT:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewB:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewL:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewR:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewW:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
            break;
        case MobilyViewScrollDirectionHorizontal:
            [self setConstraintRootViewT:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewB:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewL:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewR:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
            [self setConstraintRootViewH:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
            break;
    }
}

- (void)unlinkConstraint {
    [self setConstraintRootViewL:nil];
    [self setConstraintRootViewT:nil];
    [self setConstraintRootViewR:nil];
    [self setConstraintRootViewB:nil];
    [self setConstraintRootViewW:nil];
    [self setConstraintRootViewH:nil];
}

@end

/*--------------------------------------------------*/
