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

#import <MobilyController.h>

/*--------------------------------------------------*/

@protocol MobilyPageControllerDelegate;

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

@property(nonatomic, readwrite, weak) id< MobilyPageControllerDelegate > delegate;
@property(nonatomic, readwrite, assign) MobilyPageControllerOrientation orientation;
@property(nonatomic, readwrite, strong) UIViewController* controller;
@property(nonatomic, readwrite, assign) CGFloat draggingRate;
@property(nonatomic, readwrite, assign) CGFloat bounceRate;
@property(nonatomic, readwrite, assign) BOOL enableScroll;

- (void)setController:(UIViewController*)controller direction:(MobilyPageControllerDirection)direction animated:(BOOL)animated;
- (void)setController:(UIViewController*)controller direction:(MobilyPageControllerDirection)direction duration:(NSTimeInterval)duration animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

@protocol MobilyPageControllerDelegate < NSObject >

@optional
- (void)pageController:(MobilyPageController*)pageController willChangedController:(UIViewController*)controller;
- (void)pageController:(MobilyPageController*)pageController didChangedController:(UIViewController*)controller;

@required
- (UIViewController*)pageController:(MobilyPageController*)pageController controllerBeforeController:(UIViewController*)controller;
- (UIViewController*)pageController:(MobilyPageController*)pageController controllerAfterController:(UIViewController*)controller;

@optional
- (UIEdgeInsets)pageController:(MobilyPageController*)pageController decorInsetsBeforeController:(UIViewController*)controller;
- (UIEdgeInsets)pageController:(MobilyPageController*)pageController decorInsetsAfterController:(UIViewController*)controller;

@optional
- (CGSize)pageController:(MobilyPageController*)pageController decorSizeBeforeController:(UIViewController*)controller;
- (CGSize)pageController:(MobilyPageController*)pageController decorSizeAfterController:(UIViewController*)controller;

@optional
- (UIView*)pageController:(MobilyPageController*)pageController decorViewBeforeController:(UIViewController*)controller;
- (UIView*)pageController:(MobilyPageController*)pageController decorViewAfterController:(UIViewController*)controller;

@end

/*--------------------------------------------------*/
