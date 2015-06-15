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

typedef void(^MobilySlideControllerBlock)();

/*--------------------------------------------------*/

@interface MobilySlideController : MobilyController

@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeThreshold;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeVelocity;
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

- (void)setBackgroundController:(UIViewController*)backgroundController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;
- (void)setLeftController:(UIViewController*)leftController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;
- (void)setCenterController:(UIViewController*)centerController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;
- (void)setRightController:(UIViewController*)rightController animated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;

- (void)showLeftControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;
- (void)hideLeftControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;

- (void)showRightControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;
- (void)hideRightControllerAnimated:(BOOL)animated complete:(MobilySlideControllerBlock)complete;

@end

/*--------------------------------------------------*/

@protocol MobilySlideControllerDelegate < NSObject >

@optional
- (BOOL)canShowLeftControllerInSlideController:(MobilySlideController*)slideController;
- (void)willShowLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didShowLeftControllerInSlideController:(MobilySlideController*)slideController;
- (void)willHideLeftControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didHideLeftControllerInSlideController:(MobilySlideController*)slideController;

@optional
- (BOOL)canShowRightControllerInSlideController:(MobilySlideController*)slideController;
- (void)willShowRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didShowRightControllerInSlideController:(MobilySlideController*)slideController;
- (void)willHideRightControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didHideRightControllerInSlideController:(MobilySlideController*)slideController;

@optional
- (BOOL)canShowControllerInSlideController:(MobilySlideController*)slideController;
- (void)willShowControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didShowControllerInSlideController:(MobilySlideController*)slideController;
- (void)willHideControllerInSlideController:(MobilySlideController*)slideController duration:(CGFloat)duration;
- (void)didHideControllerInSlideController:(MobilySlideController*)slideController;

@end

/*--------------------------------------------------*/

@interface UIViewController (MobilySlideController)

@property(nonatomic, readwrite, weak) MobilySlideController* slideController;

@end

/*--------------------------------------------------*/
