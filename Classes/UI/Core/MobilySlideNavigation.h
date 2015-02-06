/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
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

#import "MobilyController.h"

/*--------------------------------------------------*/

typedef void(^MobilySlideNavigationBlock)();

/*--------------------------------------------------*/

@interface MobilySlideNavigation : MobilyController

@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeThreshold;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeVelocity;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeSpeed;
@property(nonatomic, readwrite, strong) IBOutlet UIViewController* backgroundController;
@property(nonatomic, readwrite, assign, getter=isShowedLeftController) IBInspectable BOOL showedLeftController;
@property(nonatomic, readwrite, strong) IBOutlet UIViewController* leftController;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat leftControllerWidth;
@property(nonatomic, readwrite, strong) IBOutlet UIViewController* centerController;
@property(nonatomic, readwrite, assign, getter=isShowedRightController) IBInspectable BOOL showedRightController;
@property(nonatomic, readwrite, strong) IBOutlet UIViewController* rightController;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat rightControllerWidth;
@property(nonatomic, readonly, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readonly, getter=isSwipeDecelerating) BOOL swipeDecelerating;

- (void)setBackgroundController:(UIViewController*)backgroundController animated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;
- (void)setLeftController:(UIViewController*)leftController animated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;
- (void)setCenterController:(UIViewController*)centerController animated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;
- (void)setRightController:(UIViewController*)rightController animated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;

- (void)showLeftControllerAnimated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;
- (void)hideLeftControllerAnimated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;

- (void)showRightControllerAnimated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;
- (void)hideRightControllerAnimated:(BOOL)animated completed:(MobilySlideNavigationBlock)completed;

@end

/*--------------------------------------------------*/

@protocol MobilySlideNavigationDelegate < NSObject >

@optional
- (BOOL)canShowLeftControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;
- (void)willShowLeftControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation duration:(CGFloat)duration;
- (void)didShowLeftControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;
- (void)willHideLeftControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation duration:(CGFloat)duration;
- (void)didHideLeftControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;

@optional
- (BOOL)canShowRightControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;
- (void)willShowRightControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation duration:(CGFloat)duration;
- (void)didShowRightControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;
- (void)willHideRightControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation duration:(CGFloat)duration;
- (void)didHideRightControllerInSlideNavigation:(MobilySlideNavigation*)slideNavigation;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilySlideNavigation)

@property(nonatomic, readwrite, strong) MobilySlideNavigation* slideNavigation;

@end

/*--------------------------------------------------*/
