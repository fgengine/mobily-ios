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

@class MobilyDialogController;

/*--------------------------------------------------*/

typedef void(^MobilyDialogControllerBlock)(MobilyDialogController* dialogController);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogController : UIViewController < MobilyObject >

@property(nonatomic, readwrite, assign) CGFloat animationDuration;

@property(nonatomic, readwrite, assign, getter=isBackgroundBlurred) BOOL backgroundBlurred;
@property(nonatomic, readwrite, assign) CGFloat backgroundBlurRadius;
@property(nonatomic, readwrite, assign) NSUInteger backgroundBlurIterations;
@property(nonatomic, readwrite, strong) UIColor* backgroundColor;
@property(nonatomic, readwrite, strong) UIColor* backgroundTintColor;
@property(nonatomic, readwrite, assign) CGFloat backgroundAlpha;

@property(nonatomic, readwrite, assign) CGSize contentMinSize;
@property(nonatomic, readwrite, assign) CGSize contentMaxSize;
@property(nonatomic, readwrite, assign) UIEdgeInsets contentInsets;

@property(nonatomic, readwrite, copy) MobilyDialogControllerBlock touchedOutsideContent;
@property(nonatomic, readwrite, copy) MobilyDialogControllerBlock dismiss;

- (instancetype)initWithContentController:(UIViewController*)contentController;

- (void)presentController:(UIViewController*)controller withCompletion:(MobilySimpleBlock)completion;
- (void)presentWithCompletion:(MobilySimpleBlock)completion;
- (void)dismissWithCompletion:(MobilySimpleBlock)completion;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilyDialogController)

@property(nonatomic, readwrite, weak) MobilyDialogController* dialogController;

@end

/*--------------------------------------------------*/
