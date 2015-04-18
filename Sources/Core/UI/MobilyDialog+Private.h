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

#import <MobilyDialog.h>
#import <MobilyWindow.h>
#import <MobilyBlurView.h>

/*--------------------------------------------------*/

@class MobilyDialogController;
@class MobilyDialogBackgroundView;
@class MobilyDialogView;

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogWindow : MobilyWindow {
@protected
    __weak MobilyDialogController* _dialogController;
    __weak UIWindow* _lastWindow;
    BOOL _active;
}

@property(nonatomic, readwrite, weak) MobilyDialogController* dialogController;
@property(nonatomic, readwrite, assign, getter=isActive) BOOL active;
@property(nonatomic, readwrite, weak) UIWindow* lastWindow;

+ (instancetype)shared;

- (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogController : UIViewController {
    __weak MobilyDialogWindow* _dialogWindow;
    __weak MobilyDialogBackgroundView* _dialogBackgroundView;
    NSMutableArray* _dialogViews;
}

@property(nonatomic, readwrite, weak) MobilyDialogWindow* dialogWindow;
@property(nonatomic, readwrite, weak) MobilyDialogBackgroundView* dialogBackgroundView;
@property(nonatomic, readwrite, strong) NSMutableArray* dialogViews;

- (instancetype)initWithDialogWindow:(MobilyDialogWindow*)dialogWindow;

- (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogBackgroundView : MobilyBlurView {
@protected
    __weak MobilyDialogController* _dialogController;
}

@property(nonatomic, readwrite, weak) MobilyDialogController* dialogController;

- (instancetype)initWithDialogController:(MobilyDialogController*)dialogController;

- (void)applyStyle:(MobilyDialogStyle*)style;

@end

/*--------------------------------------------------*/

@interface MobilyDialogView () {
@protected
    __weak MobilyDialogController* _dialogController;
    UIViewController* _viewController;
    MobilyDialogStyle* _style;
    BOOL _presented;
    BOOL _blocked;
}

@property(nonatomic, readwrite, weak) MobilyDialogController* dialogController;
@property(nonatomic, readwrite, strong) UIViewController* viewController;
@property(nonatomic, readwrite, strong) MobilyDialogStyle* style;
@property(nonatomic, readwrite, assign, getter=isPresented) BOOL presented;
@property(nonatomic, readwrite, assign, getter=isBlocked) BOOL blocked;

- (instancetype)initWithDialogController:(MobilyDialogController*)dialogController viewController:(UIViewController*)viewController;

- (void)presentAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)dismissAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)pushAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)popAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;

- (void)applyStyle:(MobilyDialogStyle*)style;

@end

/*--------------------------------------------------*/

@interface MobilyDialogStyle () {
    __weak MobilyDialogView* _dialogView;
    NSTimeInterval _duration;
    CGFloat _damping;
    CGFloat _velocity;
    
    BOOL _backgroundBlurred;
    CGFloat _backgroundBlurRadius;
    NSUInteger _backgroundBlurIterations;
    UIColor* _backgroundColor;
    CGFloat _backgroundAlpha;
    
    UIColor* _dialogColor;
    CGFloat _dialogAlpha;
    CGFloat _dialogCornerRadius;
    CGFloat _dialogBorderWidth;
    UIColor* _dialogBorderColor;
    UIColor* _dialogShadowColor;
    CGFloat _dialogShadowOpacity;
    CGSize _dialogShadowOffset;
    CGFloat _dialogShadowRadius;
}

@property(nonatomic, readwrite, weak) MobilyDialogView* dialogView;

- (instancetype)initWithDialogView:(MobilyDialogView*)dialogView;

@end

/*--------------------------------------------------*/
