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
    
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
    
    self.rootView = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds relativeComplement:self.subviews];
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

- (void)setConstraintRootViewL:(NSLayoutConstraint*)constraintRootViewL {
    if(_constraintRootViewL != constraintRootViewL) {
        if(_constraintRootViewL != nil) {
            [self removeConstraint:_constraintRootViewL];
        }
        _constraintRootViewL = constraintRootViewL;
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
        _constraintRootViewT = constraintRootViewT;
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
        _constraintRootViewR = constraintRootViewR;
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
        _constraintRootViewB = constraintRootViewB;
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
        _constraintRootViewW = constraintRootViewW;
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
        _constraintRootViewH = constraintRootViewH;
        if(_constraintRootViewH != nil) {
            [self addConstraint:_constraintRootViewH];
        }
    }
}

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
