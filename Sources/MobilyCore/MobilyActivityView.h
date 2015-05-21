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

typedef NS_ENUM(NSUInteger, MobilyActivityViewStyle) {
    MobilyActivityViewStyleNone,
    MobilyActivityViewStylePlane,
    MobilyActivityViewStyleCircleFlip,
    MobilyActivityViewStyleBounce,
    MobilyActivityViewStyleWave,
    MobilyActivityViewStyleWanderingCubes,
    MobilyActivityViewStylePulse,
    MobilyActivityViewStyleChasingDots,
    MobilyActivityViewStyleThreeBounce,
    MobilyActivityViewStyleCircle,
    MobilyActivityViewStyle9CubeGrid,
    MobilyActivityViewStyleWordPress,
    MobilyActivityViewStyleFadingCircle,
    MobilyActivityViewStyleFadingCircleAlt,
    MobilyActivityViewStyleArc,
    MobilyActivityViewStyleArcAlt
};

/*--------------------------------------------------*/

typedef void (^MobilyActivityViewBlock)();

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilyActivityView : UIView < MobilyObject >

@property(nonatomic, readonly, assign) MobilyActivityViewStyle style;
@property(nonatomic, readwrite, assign) CGFloat margin;
@property(nonatomic, readwrite, assign) CGFloat spacing;
@property(nonatomic, readwrite, strong) UIColor* panelColor;
@property(nonatomic, readwrite, assign) CGFloat panelCornerRadius;
@property(nonatomic, readwrite, strong) UIColor* spinnerColor;
@property(nonatomic, readwrite, assign) CGFloat spinnerSize;
@property(nonatomic, readwrite, strong) UIColor* textColor;
@property(nonatomic, readwrite, strong) UIFont* textFont;
@property(nonatomic, readonly, assign) CGFloat textWidth;
@property(nonatomic, readwrite, strong) NSString* text;
@property(nonatomic, readonly, assign, getter=isShowed) BOOL showed;

+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style;
+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text;
+ (instancetype)activityViewInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text textWidth:(NSUInteger)textWidth;

- (instancetype)initWithInView:(UIView*)view style:(MobilyActivityViewStyle)style text:(NSString*)text textWidth:(NSUInteger)textWidth;

- (void)setup NS_REQUIRES_SUPER;

- (void)show;
- (void)showComplete:(MobilyActivityViewBlock)complete;
- (void)showPrepare:(MobilyActivityViewBlock)prepare complete:(MobilyActivityViewBlock)complete;

- (void)hide;
- (void)hideComplete:(MobilyActivityViewBlock)complete;
- (void)hidePrepare:(MobilyActivityViewBlock)prepare complete:(MobilyActivityViewBlock)complete;

@end

/*--------------------------------------------------*/
