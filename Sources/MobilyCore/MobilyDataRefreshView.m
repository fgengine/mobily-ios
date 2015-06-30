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

#import <MobilyCore/MobilyDataRefreshView+Private.h>

/*--------------------------------------------------*/

@implementation MobilyDataRefreshView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize type = _type;
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
    _threshold = 64.0f;
    _size = 52.0f;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
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

- (void)_showAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataRefreshViewCompleteBlock)complete {
    if(_state != MobilyDataRefreshViewStateLoading) {
        self.state = MobilyDataRefreshViewStateLoading;
        
        UIEdgeInsets refreshViewInsets = _view.refreshViewInsets;
        CGPoint contentOffset = _view.contentOffset;
        switch(_type) {
            case MobilyDataRefreshViewTypeTop: refreshViewInsets.top = _size; refreshViewInsets.bottom = -_size; break;
            case MobilyDataRefreshViewTypeBottom: refreshViewInsets.top = -_size; refreshViewInsets.bottom = _size; break;
            case MobilyDataRefreshViewTypeLeft: refreshViewInsets.left = _size; refreshViewInsets.right = -_size; break;
            case MobilyDataRefreshViewTypeRight: refreshViewInsets.left = -_size; refreshViewInsets.right = _size; break;
        }
        _constraintOffset.constant = 0.0f;
        _constraintSize.constant = _size;
        if(animated == YES) {
            [UIView animateWithDuration:ABS(_size - _constraintSize.constant) / ABS(velocity)
                                  delay:0.01f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 _view.refreshViewInsets = refreshViewInsets;
                                 _view.contentOffset = contentOffset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            _view.refreshViewInsets = refreshViewInsets;
            _view.contentOffset = contentOffset;
            if(complete != nil) {
                complete(YES);
            }
        }
    } else {
        if(complete != nil) {
            complete(YES);
        }
    }
}

- (void)_hideAnimated:(BOOL)animated velocity:(CGFloat)velocity complete:(MobilyDataRefreshViewCompleteBlock)complete {
    if(_state != MobilyDataRefreshViewStateIdle) {
        self.state = MobilyDataRefreshViewStateIdle;
        
        UIEdgeInsets refreshViewInsets = _view.refreshViewInsets;
        CGPoint contentOffset = _view.contentOffset;
        switch(_type) {
            case MobilyDataRefreshViewTypeTop: refreshViewInsets.top = 0.0f; refreshViewInsets.bottom = 0.0f; break;
            case MobilyDataRefreshViewTypeBottom: refreshViewInsets.top = 0.0f; refreshViewInsets.bottom = 0.0f; break;
            case MobilyDataRefreshViewTypeLeft: refreshViewInsets.left = 0.0f; refreshViewInsets.right = 0.0f; break;
            case MobilyDataRefreshViewTypeRight: refreshViewInsets.left = 0.0f; refreshViewInsets.right = 0.0f; break;
        }
        switch(_type) {
            case MobilyDataRefreshViewTypeTop:
            case MobilyDataRefreshViewTypeLeft:
                _constraintOffset.constant = -_size;
                _constraintSize.constant = _size;
                break;
            case MobilyDataRefreshViewTypeBottom:
            case MobilyDataRefreshViewTypeRight:
                _constraintOffset.constant = _size;
                _constraintSize.constant = _size;
                break;
        }
        if(animated == YES) {
            [UIView animateWithDuration:_size / ABS(velocity)
                                  delay:0.00f
                                options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 _view.refreshViewInsets = refreshViewInsets;
                                 _view.contentOffset = contentOffset;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 if(complete != nil) {
                                     complete(finished);
                                 }
                             }];
        } else {
            _view.refreshViewInsets = refreshViewInsets;
            _view.contentOffset = contentOffset;
            if(complete != nil) {
                complete(YES);
            }
        }
    } else {
        if(complete != nil) {
            complete(YES);
        }
    }
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataRefreshViewTriggered = @"MobilyDataRefreshViewTriggered";

/*--------------------------------------------------*/
