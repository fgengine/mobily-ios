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

#import <MobilyCore/MobilyUI.h>

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDialogControllerPresentationStyle) {
    MobilyDialogControllerPresentationStyleTop,
    MobilyDialogControllerPresentationStyleBottom,
    MobilyDialogControllerPresentationStyleUnderNavBar,
    MobilyDialogControllerPresentationStyleUnderToolbar,
    MobilyDialogControllerPresentationStyleCentered
};

typedef NS_ENUM(NSUInteger, MobilyDialogControllerHorizontalJustification) {
    MobilyDialogControllerHorizontalJustificationCentered,
    MobilyDialogControllerHorizontalJustificationLeft,
    MobilyDialogControllerHorizontalJustificationRight,
    MobilyDialogControllerHorizontalJustificationFull
};

/*--------------------------------------------------*/

@class MobilyDialogController;

/*--------------------------------------------------*/

typedef void(^MobilyDialogControllerTouchedOutsideContent)(MobilyDialogController* dialogController);

/*--------------------------------------------------*/

@interface MobilyDialogController : UIViewController < MobilyObject >

@property(nonatomic, readwrite, assign) CGFloat animationDuration;
@property(nonatomic, readwrite, assign) CGRect presentationRect;
@property(nonatomic, readwrite, assign) CGFloat slideInset;

@property(nonatomic, readwrite, assign, getter=isBackgroundBlurred) BOOL backgroundBlurred;
@property(nonatomic, readwrite, assign) CGFloat backgroundBlurRadius;
@property(nonatomic, readwrite, assign) NSUInteger backgroundBlurIterations;
@property(nonatomic, readwrite, strong) UIColor* backgroundColor;
@property(nonatomic, readwrite, strong) UIColor* backgroundTintColor;
@property(nonatomic, readwrite, assign) CGFloat backgroundAlpha;

@property(nonatomic, readwrite, strong) UIColor* contentColor;
@property(nonatomic, readwrite, assign) CGFloat contentAlpha;
@property(nonatomic, readwrite, assign) CGFloat contentCornerRadius;
@property(nonatomic, readwrite, assign) CGFloat contentBorderWidth;
@property(nonatomic, readwrite, strong) UIColor* contentBorderColor;
@property(nonatomic, readwrite, strong) UIColor* contentShadowColor;
@property(nonatomic, readwrite, assign) CGFloat contentShadowOpacity;
@property(nonatomic, readwrite, assign) CGSize contentShadowOffset;
@property(nonatomic, readwrite, assign) CGFloat contentShadowRadius;

@property(nonatomic, readwrite, assign) MobilyDialogControllerPresentationStyle presentationStyle;
@property(nonatomic, readwrite, assign) MobilyDialogControllerHorizontalJustification horizontalJustification;
@property(nonatomic, readwrite, copy) MobilyDialogControllerTouchedOutsideContent touchedOutsideContent;

- (instancetype)initWithViewController:(UIViewController*)viewController presentationStyle:(MobilyDialogControllerPresentationStyle)style;

- (void)presentFromViewController:(UIViewController*)presentingVC withCompletion:(MobilySimpleBlock)completion;
- (void)presentWithCompletion:(MobilySimpleBlock)completion;

- (void)dismissWithCompletion:(MobilySimpleBlock)completion;

- (void)adjustContentSize:(CGSize)newSize animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilyDialogController)

@property(nonatomic, readwrite, strong) MobilyDialogController* dialogController;

@end

/*--------------------------------------------------*/
