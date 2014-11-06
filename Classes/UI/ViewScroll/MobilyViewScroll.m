/*--------------------------------------------------*/

#import "MobilyViewScroll.h"

/*--------------------------------------------------*/

@interface MobilyViewScroll ()

@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewL;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewT;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewR;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewB;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewW;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* contrainRootViewH;

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

- (void)setContrainRootViewL:(NSLayoutConstraint*)contrainRootViewL {
    if(_contrainRootViewL != contrainRootViewL) {
        if(_contrainRootViewL != nil) {
            [self removeConstraint:_contrainRootViewL];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewL, contrainRootViewL);
        if(_contrainRootViewL != nil) {
            [self addConstraint:_contrainRootViewL];
        }
    }
}

- (void)setContrainRootViewT:(NSLayoutConstraint*)contrainRootViewT {
    if(_contrainRootViewT != contrainRootViewT) {
        if(_contrainRootViewT != nil) {
            [self removeConstraint:_contrainRootViewT];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewT, contrainRootViewT);
        if(_contrainRootViewT != nil) {
            [self addConstraint:_contrainRootViewT];
        }
    }
}

- (void)setContrainRootViewR:(NSLayoutConstraint*)contrainRootViewR {
    if(_contrainRootViewR != contrainRootViewR) {
        if(_contrainRootViewR != nil) {
            [self removeConstraint:_contrainRootViewR];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewR, contrainRootViewR);
        if(_contrainRootViewR != nil) {
            [self addConstraint:_contrainRootViewR];
        }
    }
}

- (void)setContrainRootViewB:(NSLayoutConstraint*)contrainRootViewB {
    if(_contrainRootViewB != contrainRootViewB) {
        if(_contrainRootViewB != nil) {
            [self removeConstraint:_contrainRootViewB];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewB, contrainRootViewB);
        if(_contrainRootViewB != nil) {
            [self addConstraint:_contrainRootViewB];
        }
    }
}

- (void)setContrainRootViewW:(NSLayoutConstraint*)contrainRootViewW {
    if(_contrainRootViewW != contrainRootViewW) {
        if(_contrainRootViewW != nil) {
            [self removeConstraint:_contrainRootViewW];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewW, contrainRootViewW);
        if(_contrainRootViewW != nil) {
            [self addConstraint:_contrainRootViewW];
        }
    }
}

- (void)setContrainRootViewH:(NSLayoutConstraint*)contrainRootViewH {
    if(_contrainRootViewH != contrainRootViewH) {
        if(_contrainRootViewH != nil) {
            [self removeConstraint:_contrainRootViewH];
        }
        MOBILY_SAFE_SETTER(_contrainRootViewH, contrainRootViewH);
        if(_contrainRootViewH != nil) {
            [self addConstraint:_contrainRootViewH];
        }
    }
}

- (void)setDirection:(MobilyViewScrollDirection)direction {
    if(_direction != direction) {
        _direction = direction;
        [self setNeedsLayout];
    }
}

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [self setContrainRootViewL:nil];
            [self setContrainRootViewT:nil];
            [self setContrainRootViewR:nil];
            [self setContrainRootViewB:nil];
            [self setContrainRootViewW:nil];
            [self setContrainRootViewH:nil];
            [_rootView removeFromSuperview];
        }
        MOBILY_SAFE_SETTER(_rootView, rootView);
        if(_rootView != nil) {
            [_rootView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:_rootView];
            switch(_direction) {
                case MobilyViewScrollDirectionVertical:
                    [self setContrainRootViewT:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewB:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewL:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewR:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewW:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
                    break;
                case MobilyViewScrollDirectionHorizontal:
                    [self setContrainRootViewT:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewB:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewL:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewR:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
                    [self setContrainRootViewH:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
                    break;
            }
            [_rootView setNeedsUpdateConstraints];
        }
        [self setNeedsLayout];
    }
}

@end

/*--------------------------------------------------*/
