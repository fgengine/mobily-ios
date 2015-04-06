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

#import "MobilyDataRefreshView+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataRefreshView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize view = _view;
@synthesize constraintOffset = _constraintOffset;
@synthesize constraintSize = _constraintSize;
@synthesize state = _state;
@synthesize size = _size;
@synthesize threshold = _threshold;

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
    _threshold = 40.0f;
    _size = 52.0f;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds unionWithArray:self.subviews];
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
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

#pragma mark UIView



#pragma mark Property

- (void)setState:(MobilyDataRefreshViewState)state {
    if(_state != state) {
        _state = state;
        switch(_state) {
            case MobilyDataRefreshViewStateIdle: [self didIdle]; break;
            case MobilyDataRefreshViewStatePull: [self didPull]; break;
            case MobilyDataRefreshViewStateRelease: [self didRelease]; break;
            case MobilyDataRefreshViewStateLoading: [self didLoading]; break;
            default: break;
        }
    }
}

- (void)setSize:(CGFloat)size {
    if(_size != size) {
        _size = size;
        if(_state == MobilyDataRefreshViewStateLoading) {
            _constraintSize.constant = _size;
        }
    }
}

#pragma mark Public

- (void)didIdle {
}

- (void)didPull {
}

- (void)didRelease {
}

- (void)didLoading {
}

#pragma mark Private

- (void)_showAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataRefreshViewCompleteBlock)complete {
    self.state = MobilyDataRefreshViewStateLoading;
    
    UIEdgeInsets refreshViewInsets = _view.refreshViewInsets;
    switch(_type) {
        case MobilyDataRefreshViewTypeTop:
            refreshViewInsets.top = _size;
            if(offset != NULL) {
                *offset = -_size;
            }
            break;
        case MobilyDataRefreshViewTypeBottom:
            refreshViewInsets.bottom = _size;
            break;
        case MobilyDataRefreshViewTypeLeft:
            refreshViewInsets.left = _size;
            if(offset != NULL) {
                *offset = -_size;
            }
            break;
        case MobilyDataRefreshViewTypeRight:
            refreshViewInsets.right = _size;
            break;
    }
    CGFloat fromConstraint = _constraintSize.constant;
    CGFloat toConstraint = _size;
    if(animated == YES) {
        [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / ABS(velocity)
                              delay:0.01f
                            options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             _view.refreshViewInsets = refreshViewInsets;
                             _constraintSize.constant = toConstraint;
                             [self.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
    } else {
        _view.refreshViewInsets = refreshViewInsets;
        _constraintSize.constant = toConstraint;
        if(complete != nil) {
            complete(YES);
        }
    }
}

- (void)_hideAnimated:(BOOL)animated velocity:(CGFloat)velocity offset:(inout CGFloat*)offset complete:(MobilyDataRefreshViewCompleteBlock)complete {
    UIEdgeInsets refreshViewInsets = _view.refreshViewInsets;
    switch(_type) {
        case MobilyDataRefreshViewTypeTop:
            refreshViewInsets.top = 0.0f;
            break;
        case MobilyDataRefreshViewTypeBottom:
            refreshViewInsets.bottom = 0.0f;
            break;
        case MobilyDataRefreshViewTypeLeft:
            refreshViewInsets.left = 0.0f;
            break;
        case MobilyDataRefreshViewTypeRight:
            refreshViewInsets.right = 0.0f;
            break;
    }
    CGFloat fromConstraint = _constraintSize.constant;
    CGFloat toConstraint = 0.0f;
    if(animated == YES) {
        [UIView animateWithDuration:ABS(toConstraint - fromConstraint) / ABS(velocity)
                              delay:0.01f
                            options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             _view.refreshViewInsets = refreshViewInsets;
                             _constraintSize.constant = toConstraint;
                             [self.superview layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             self.state = MobilyDataRefreshViewStateIdle;
                             if(complete != nil) {
                                 complete(finished);
                             }
                         }];
    } else {
        self.state = MobilyDataRefreshViewStateIdle;
        _view.refreshViewInsets = refreshViewInsets;
        _constraintSize.constant = toConstraint;
        if(complete != nil) {
            complete(YES);
        }
    }
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataRefreshViewTriggered = @"MobilyDataRefreshViewTriggered";

/*--------------------------------------------------*/
