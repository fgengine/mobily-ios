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

#import <MobilyCore/MobilyLayoutView.h>
#import <MobilyCore/MobilyKVO.h>

/*--------------------------------------------------*/

@interface MobilyLayoutView () {
    NSMutableArray* _hiddenObservers;
    NSMutableArray* _topConstraints;
    NSMutableArray* _bottomConstraints;
    NSMutableArray* _leftConstraints;
    NSMutableArray* _rightConstraints;
    NSMutableArray* _spacingConstraints;
}
 
@end

/*--------------------------------------------------*/

@implementation MobilyLayoutView

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _hiddenObservers = [NSMutableArray array];
    _topConstraints = [NSMutableArray array];
    _bottomConstraints = [NSMutableArray array];
    _leftConstraints = [NSMutableArray array];
    _rightConstraints = [NSMutableArray array];
    _spacingConstraints = [NSMutableArray array];
}

#pragma mark Property

- (void)setAxis:(UILayoutConstraintAxis)axis {
    if(_axis != axis) {
        _axis = axis;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setAlignment:(MobilyLayoutViewAlignment)alignment {
    if(_alignment != alignment) {
        _alignment = alignment;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setMargins:(UIEdgeInsets)margins{
    if(UIEdgeInsetsEqualToEdgeInsets(_margins, margins) == NO) {
        if(_margins.top != margins.top) {
            [_topConstraints moEach:^(NSLayoutConstraint* constraint) {
                constraint.constant = margins.top;
            }];
        }
        if(_margins.bottom != margins.bottom) {
            [_bottomConstraints moEach:^(NSLayoutConstraint* constraint) {
                constraint.constant = margins.bottom;
            }];
        }
        if(_margins.left != margins.left) {
            [_leftConstraints moEach:^(NSLayoutConstraint* constraint) {
                constraint.constant = margins.left;
            }];
        }
        if(_margins.right != margins.right) {
            [_rightConstraints moEach:^(NSLayoutConstraint* constraint) {
                constraint.constant = margins.right;
            }];
        }
        _margins = margins;
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if(_spacing != spacing) {
        _spacing = spacing;
        [_spacingConstraints moEach:^(NSLayoutConstraint* constraint) {
            constraint.constant = _spacing;
        }];
    }
}

#pragma mark Public override

- (void)didAddSubview:(UIView*)subview {
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [_hiddenObservers addObject:[[MobilyKVO alloc] initWithSubject:subview keyPath:@"hidden" block:^(MobilyKVO* kvo, id oldValue, id newValue) {
        [self setNeedsUpdateConstraints];
    }]];
    [super didAddSubview:subview];
    [self setNeedsUpdateConstraints];
}

- (void)willRemoveSubview:(UIView*)subview {
    [_hiddenObservers moEach:^(MobilyKVO* kvo) {
        if(kvo.subject == subview) {
            [kvo stopObservation];
            [_hiddenObservers removeObject:kvo];
        }
    }];
    [super willRemoveSubview:subview];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if(_topConstraints.count > 0) {
        [self removeConstraints:_topConstraints];
        [_topConstraints removeAllObjects];
    }
    if(_bottomConstraints.count > 0) {
        [self removeConstraints:_bottomConstraints];
        [_bottomConstraints removeAllObjects];
    }
    if(_rightConstraints.count > 0) {
        [self removeConstraints:_rightConstraints];
        [_rightConstraints removeAllObjects];
    }
    if(_leftConstraints.count > 0) {
        [self removeConstraints:_leftConstraints];
        [_leftConstraints removeAllObjects];
    }
    
    __block UIView* prevSubview = nil;
    [self.subviews moEach:^(UIView* subview) {
        switch(_axis) {
            case UILayoutConstraintAxisHorizontal:
                if(prevSubview == nil) {
                    [_leftConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual attribute:NSLayoutAttributeLeft constant:_margins.left]];
                } else {
                    [_spacingConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual view:prevSubview attribute:NSLayoutAttributeRight constant:_spacing]];
                }
                switch(_alignment) {
                    case MobilyLayoutViewAlignmentFill:
                        [_topConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual attribute:NSLayoutAttributeTop constant:_margins.top]];
                        [_bottomConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual attribute:NSLayoutAttributeBottom constant:_margins.bottom]];
                        break;
                    case MobilyLayoutViewAlignmentLeading:
                        [_topConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual attribute:NSLayoutAttributeTop constant:_margins.top]];
                        [_bottomConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeBottom constant:_margins.bottom]];
                        break;
                    case MobilyLayoutViewAlignmentCenter:
                        [subview moAddConstraintAttribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual attribute:NSLayoutAttributeCenterY constant:0.0f];
                        [_topConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeTop constant:_margins.top]];
                        [_bottomConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeBottom constant:_margins.bottom]];
                        break;
                    case MobilyLayoutViewAlignmentTrailing:
                        [_topConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeTop constant:_margins.top]];
                        [_bottomConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual attribute:NSLayoutAttributeBottom constant:_margins.bottom]];
                        break;
                }
                break;
            case UILayoutConstraintAxisVertical:
                if(prevSubview == nil) {
                    [_topConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual attribute:NSLayoutAttributeTop constant:_margins.top]];
                } else {
                    [_spacingConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual view:prevSubview attribute:NSLayoutAttributeBottom constant:_spacing]];
                }
                switch(_alignment) {
                    case MobilyLayoutViewAlignmentFill:
                        [_leftConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual attribute:NSLayoutAttributeLeft constant:_margins.left]];
                        [_rightConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual attribute:NSLayoutAttributeRight constant:_margins.right]];
                        break;
                    case MobilyLayoutViewAlignmentLeading:
                        [_leftConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual attribute:NSLayoutAttributeLeft constant:_margins.left]];
                        [_rightConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeRight constant:_margins.right]];
                        break;
                    case MobilyLayoutViewAlignmentCenter:
                        [subview moAddConstraintAttribute:NSLayoutAttributeCenterX relation:NSLayoutRelationEqual attribute:NSLayoutAttributeCenterX constant:0.0f];
                        [_leftConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeLeft constant:_margins.left]];
                        [_rightConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeRight constant:_margins.right]];
                        break;
                    case MobilyLayoutViewAlignmentTrailing:
                        [_leftConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationGreaterThanOrEqual attribute:NSLayoutAttributeLeft constant:_margins.left]];
                        [_rightConstraints addObject:[subview moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual attribute:NSLayoutAttributeRight constant:_margins.right]];
                        break;
                }
                break;
        }
        if(subview.isHidden == NO) {
            prevSubview = subview;
        }
    }];
    if(prevSubview != nil) {
        switch(_axis) {
            case UILayoutConstraintAxisHorizontal:
                [_rightConstraints addObject:[prevSubview moAddConstraintAttribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual attribute:NSLayoutAttributeRight constant:_margins.right]];
                break;
            case UILayoutConstraintAxisVertical:
                [_bottomConstraints addObject:[prevSubview moAddConstraintAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual attribute:NSLayoutAttributeBottom constant:_margins.bottom]];
                break;
        }
    }
    [super updateConstraints];
}

@end

/*--------------------------------------------------*/
