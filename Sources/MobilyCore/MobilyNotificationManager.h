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

@class MobilyNotificationView;

/*--------------------------------------------------*/

typedef void(^MobilyNotificationPressed)(MobilyNotificationView* notificationView);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyNotificationManager : NSObject

+ (void)setParentWindow:(UIWindow*)parentWindow;
+ (UIWindow*)parentWindow;

+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
+ (UIStatusBarStyle)statusBarStyle;

+ (void)setStatusBarHidden:(BOOL)statusBarHidden;
+ (BOOL)statusBarHidden;

+ (MobilyNotificationView*)showView:(UIView*)view;
+ (MobilyNotificationView*)showView:(UIView*)view pressed:(MobilyNotificationPressed)pressed;
+ (MobilyNotificationView*)showView:(UIView*)view duration:(NSTimeInterval)duration;
+ (MobilyNotificationView*)showView:(UIView*)view duration:(NSTimeInterval)duration pressed:(MobilyNotificationPressed)pressed;

+ (void)hideNotificationView:(MobilyNotificationView*)notificationView animated:(BOOL)animated;
+ (void)hideAllAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyNotificationView : UIView

@property(nonatomic, readonly, strong) UIView* view;
@property(nonatomic, readonly, assign) NSTimeInterval duration;
@property(nonatomic, readonly, copy) MobilyNotificationPressed pressed;

- (void)hideAnimated:(BOOL)animated;

- (void)willShow;
- (void)didShow;
- (void)willHide;
- (void)didHide;

@end

/*--------------------------------------------------*/

@interface UIView (MobilyNotification)

@property(nonatomic, readwrite, weak) MobilyNotificationView* moNotificationView;

@end

/*--------------------------------------------------*/
