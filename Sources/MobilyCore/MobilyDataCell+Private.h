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

#import <MobilyCore/MobilyDataCell.h>
#import <MobilyCore/MobilyDataItem+Private.h>
#import <MobilyCore/MobilyDataView+Private.h>

/*--------------------------------------------------*/

@interface MobilyDataCell () {
@protected
    NSString* _identifier;
    __weak MobilyDataView* _view;
    __weak MobilyDataItem* _item;
    BOOL _selected;
    BOOL _highlighted;
    BOOL _editing;
    UILongPressGestureRecognizer* _pressGestureRecognizer;
    UITapGestureRecognizer* _tapGestureRecognizer;
    UILongPressGestureRecognizer* _longPressGestureRecognizer;
    UIView* _rootView;
    UIOffset _rootOffsetOfCenter;
    UIOffset _rootMarginSize;
    NSLayoutConstraint* _constraintRootViewCenterX;
    NSLayoutConstraint* _constraintRootViewCenterY;
    NSLayoutConstraint* _constraintRootViewWidth;
    NSLayoutConstraint* _constraintRootViewHeight;
}

@property(nonatomic, readwrite, weak) MobilyDataView* view;
@property(nonatomic, readwrite, strong) UILongPressGestureRecognizer* pressGestureRecognizer;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property(nonatomic, readwrite, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewCenterX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRootViewHeight;

- (void)_pressed;
- (void)_longPressed;

- (void)_handlerPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer;
- (void)_handlerTapGestureRecognizer:(UITapGestureRecognizer*)gestureRecognizer;
- (void)_handlerLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataCellSwipeDirection) {
    MobilyDataCellSwipeDirectionUnknown,
    MobilyDataCellSwipeDirectionLeft,
    MobilyDataCellSwipeDirectionRight
};

/*--------------------------------------------------*/

@interface MobilyDataCellSwipe () {
@protected
    UIPanGestureRecognizer* _panGestureRecognizer;
    BOOL _swipeEnabled;
    MobilyDataSwipeCellStyle _swipeStyle;
    CGFloat _swipeThreshold;
    CGFloat _swipeVelocity;
    CGFloat _swipeSpeed;
    BOOL _swipeDragging;
    BOOL _swipeDecelerating;
    BOOL _showedLeftSwipeView;
    BOOL _leftSwipeEnabled;
    UIView* _leftSwipeView;
    CGFloat _leftSwipeOffset;
    CGFloat _leftSwipeSize;
    CGFloat _leftSwipeStretchThreshold;
    BOOL _showedRightSwipeView;
    BOOL _rightSwipeEnabled;
    UIView* _rightSwipeView;
    CGFloat _rightSwipeOffset;
    CGFloat _rightSwipeSize;
    CGFloat _rightSwipeStretchThreshold;
    NSLayoutConstraint* _constraintLeftSwipeViewOffsetX;
    NSLayoutConstraint* _constraintLeftSwipeViewCenterY;
    NSLayoutConstraint* _constraintLeftSwipeViewWidth;
    NSLayoutConstraint* _constraintLeftSwipeViewHeight;
    NSLayoutConstraint* _constraintRightSwipeViewOffsetX;
    NSLayoutConstraint* _constraintRightSwipeViewCenterY;
    NSLayoutConstraint* _constraintRightSwipeViewWidth;
    NSLayoutConstraint* _constraintRightSwipeViewHeight;
    CGFloat _panSwipeLastOffset;
    CGFloat _panSwipeLastVelocity;
    CGFloat _panSwipeProgress;
    CGFloat _panSwipeLeftWidth;
    CGFloat _panSwipeRightWidth;
    MobilyDataCellSwipeDirection _panSwipeDirection;
}

@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGestureRecognizer;
@property(nonatomic, readwrite, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readwrite, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewOffsetX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewHeight;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewOffsetX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewHeight;

@property(nonatomic, readwrite, assign) CGFloat panSwipeLastOffset;
@property(nonatomic, readwrite, assign) CGFloat panSwipeLastVelocity;
@property(nonatomic, readwrite, assign) CGFloat panSwipeProgress;
@property(nonatomic, readwrite, assign) CGFloat panSwipeLeftWidth;
@property(nonatomic, readwrite, assign) CGFloat panSwipeRightWidth;
@property(nonatomic, readwrite, assign) MobilyDataCellSwipeDirection panSwipeDirection;

- (UIOffset)_rootViewOffsetOfCenterBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)_leftViewOffsetBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)_leftViewSizeBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)_rightViewOffsetBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)_rightViewSizeBySwipeProgress:(CGFloat)swipeProgress;

- (void)_updateSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe;

- (void)_handlerPanGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer;

@end

/*--------------------------------------------------*/
