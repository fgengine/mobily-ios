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

#import <MobilyCore/MobilyController.h>

/*--------------------------------------------------*/

@protocol MobilyPageControllerDelegate;
@protocol MobilyPageDecorDelegate;

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyPageControllerOrientation) {
    MobilyPageControllerOrientationHorizontal,
    MobilyPageControllerOrientationVertical
};

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyPageControllerDirection) {
    MobilyPageControllerDirectionForward,
    MobilyPageControllerDirectionReverse
};

/*--------------------------------------------------*/

@interface MobilyPageController : MobilyController

@property(nonatomic, readwrite, assign) IBInspectable MobilyPageControllerOrientation orientation;
@property(nonatomic, readwrite, strong) UIViewController< MobilyPageControllerDelegate >* controller;
@property(nonatomic, readonly, assign, getter = isAnimating) BOOL animating;
@property(nonatomic, readwrite, assign) IBInspectable BOOL userInteractionEnabled;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat draggingRate;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat bounceRate;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat thresholdHorizontal;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat thresholdVertical;

- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller direction:(MobilyPageControllerDirection)direction animated:(BOOL)animated;
- (void)setController:(UIViewController< MobilyPageControllerDelegate >*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

@protocol MobilyPageControllerDelegate < NSObject >

@required
- (BOOL)allowBeforeControllerInPageController:(MobilyPageController*)pageController;
- (BOOL)allowAfterControllerInPageController:(MobilyPageController*)pageController;

@optional
- (void)willAppearInPageController:(MobilyPageController*)pageController;
- (void)didAppearInPageController:(MobilyPageController*)pageController;
- (void)willDisappearInPageController:(MobilyPageController*)pageController;
- (void)didDisappearInPageController:(MobilyPageController*)pageController;

@optional
- (UIViewController< MobilyPageControllerDelegate >*)beforeControllerInPageController:(MobilyPageController*)pageController;
- (UIEdgeInsets)beforeDecorInsetsInPageController:(MobilyPageController*)pageController;
- (CGSize)beforeDecorSizeInPageController:(MobilyPageController*)pageController;
- (UIView< MobilyPageDecorDelegate >*)beforeDecorViewInPageController:(MobilyPageController*)pageController;

@optional
- (UIViewController< MobilyPageControllerDelegate >*)afterControllerInPageController:(MobilyPageController*)pageController;
- (UIEdgeInsets)afterDecorInsetsInPageController:(MobilyPageController*)pageController;
- (CGSize)afterDecorSizeInPageController:(MobilyPageController*)pageController;
- (UIView< MobilyPageDecorDelegate >*)afterDecorViewInPageController:(MobilyPageController*)pageController;

@end

/*--------------------------------------------------*/

@protocol MobilyPageDecorDelegate < NSObject >

@optional
- (void)pageController:(MobilyPageController*)pageController applyFromProgress:(CGFloat)progress;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilyPageController)

@property(nonatomic, readwrite, strong) MobilyPageController* pageController;

@end

/*--------------------------------------------------*/
