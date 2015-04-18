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

#import <MobilyUI.h>

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialog : NSObject

+ (void)pushDialogController:(UIViewController*)viewController animated:(BOOL)animated complete:(MobilySimpleBlock)complete;
+ (void)popDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;
+ (void)popAllDialogControllerAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;

@end

/*--------------------------------------------------*/

@class MobilyDialogStyle;

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogView : UIView

@property(nonatomic, readonly, strong) UIViewController* viewController;
@property(nonatomic, readonly, strong) MobilyDialogStyle* style;
@property(nonatomic, readonly, assign, getter=isPresented) BOOL presented;
@property(nonatomic, readonly, assign, getter=isBlocked) BOOL blocked;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDialogStyle : NSObject

@property(nonatomic, readwrite, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, assign) CGFloat damping;
@property(nonatomic, readwrite, assign) CGFloat velocity;

@property(nonatomic, readwrite, assign) BOOL backgroundBlurred;
@property(nonatomic, readwrite, assign) CGFloat backgroundBlurRadius;
@property(nonatomic, readwrite, assign) NSUInteger backgroundBlurIterations;
@property(nonatomic, readwrite, strong) UIColor* backgroundColor;
@property(nonatomic, readwrite, assign) CGFloat backgroundAlpha;

@property(nonatomic, readwrite, strong) UIColor* dialogColor;
@property(nonatomic, readwrite, assign) CGFloat dialogAlpha;
@property(nonatomic, readwrite, assign) CGFloat dialogCornerRadius;
@property(nonatomic, readwrite, assign) CGFloat dialogBorderWidth;
@property(nonatomic, readwrite, strong) UIColor* dialogBorderColor;
@property(nonatomic, readwrite, strong) UIColor* dialogShadowColor;
@property(nonatomic, readwrite, assign) CGFloat dialogShadowOpacity;
@property(nonatomic, readwrite, assign) CGSize dialogShadowOffset;
@property(nonatomic, readwrite, assign) CGFloat dialogShadowRadius;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilyDialog)

@property(nonatomic, readwrite, strong) MobilyDialogView* dialogView;

@end

/*--------------------------------------------------*/
