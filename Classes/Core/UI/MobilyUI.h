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

#import "MobilyObject.h"
#import "MobilyCG.h"
#import "MobilyCA.h"

/*--------------------------------------------------*/

#import "MobilyEvent.h"

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyVerticalAlignment) {
    MobilyVerticalAlignmentTop,
    MobilyVerticalAlignmentCenter,
    MobilyVerticalAlignmentBottom
};

typedef NS_OPTIONS(NSUInteger, MobilyHorizontalAlignment) {
    MobilyHorizontalAlignmentLeft,
    MobilyHorizontalAlignmentCenter,
    MobilyHorizontalAlignmentRight
};

/*--------------------------------------------------*/

@interface NSString (MobilyUI)

- (CGSize)implicitSizeWithFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)implicitSizeWithFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)implicitSizeWithFont:(UIFont*)font forSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (UIEdgeInsets)convertToEdgeInsets;
- (UIEdgeInsets)convertToEdgeInsetsSeparated:(NSString*)separated;

- (UIBezierPath*)convertToBezierPath;
- (UIBezierPath*)convertToBezierPathSeparated:(NSString*)separated;

- (UIFont*)convertToFont;
- (UIFont*)convertToFontSeparated:(NSString*)separated;
- (UIImage*)convertToImage;
- (UIImage*)convertToImageSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated;
- (NSArray*)convertToImages;
- (NSArray*)convertToImagesSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated frameSeparated:(NSString*)frameSeparated;

- (UIRemoteNotificationType)convertToRemoteNotificationType;
- (UIRemoteNotificationType)convertToRemoteNotificationTypeSeparated:(NSString*)separated;
- (UIInterfaceOrientationMask)convertToInterfaceOrientationMask;
- (UIInterfaceOrientationMask)convertToInterfaceOrientationMaskSeparated:(NSString*)separated;

- (UIStatusBarStyle)convertToStatusBarStyle;
- (UIStatusBarAnimation)convertToStatusBarAnimation;

- (UIViewAutoresizing)convertToViewAutoresizing;
- (UIViewAutoresizing)convertToViewAutoresizingSeparated:(NSString*)separated;
- (UIViewContentMode)convertToViewContentMode;
- (UIControlContentHorizontalAlignment)convertToControlContentHorizontalAlignment;
- (UIControlContentVerticalAlignment)convertToControlContentVerticalAlignment;
- (UITextAutocapitalizationType)convertToTextAutocapitalizationType;
- (UITextAutocorrectionType)convertToTextAutocorrectionType;
- (UITextSpellCheckingType)convertToTestSpellCheckingType;
- (UIKeyboardType)convertToKeyboardType;
- (UIReturnKeyType)convertToReturnKeyType;
- (UIBaselineAdjustment)convertToBaselineAdjustment;

- (UIScrollViewIndicatorStyle)convertToScrollViewIndicatorStyle;
- (UIScrollViewKeyboardDismissMode)convertToScrollViewKeyboardDismissMode;
- (UIBarStyle)convertToBarStyle;
- (UITabBarItemPositioning)convertToTabBarItemPositioning;
- (UISearchBarStyle)convertToSearchBarStyle;
- (UIProgressViewStyle)convertToProgressViewStyle;
- (UITextBorderStyle)convertToTextBorderStyle;

- (void)drawAtPoint:(CGPoint)point font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)drawInRect:(CGRect)rect font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

/*--------------------------------------------------*/
/* BASE                                             */
/*--------------------------------------------------*/

#define MOBILY_COLOR_RGB(R, G, B)                   [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0f]
#define MOBILY_COLOR_RGBA(R, G, B, A)               [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A) / 255.0f]

/*--------------------------------------------------*/

typedef struct {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} MobilyColorHSB;

/*--------------------------------------------------*/

BOOL MobilyColorHSBEqualToColorHSB(MobilyColorHSB color1, MobilyColorHSB color2);

/*--------------------------------------------------*/

@interface UIColor (MobilyUI)

+ (UIColor*)colorWithString:(NSString*)string;
+ (CGFloat)colorComponentFromString:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length;

-(MobilyColorHSB)hsb;

@end

/*--------------------------------------------------*/

@interface UIImage (MobilyUI)

+ (UIImage*)imageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets;

- (UIImage*)scaleToSize:(CGSize)size;

- (UIImage*)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor*)tintColor;

@end

/*--------------------------------------------------*/

@interface UINib (MobilyUI)

+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class;
+ (id)viewWithNibName:(NSString*)nibName withClass:(Class)class withOwner:(id)owner;

+ (UINib*)nibWithBaseName:(NSString*)baseName bundle:(NSBundle*)bundle;
+ (UINib*)nibWithClass:(Class)class bundle:(NSBundle*)bundle;

- (id)instantiateWithClass:(Class)class owner:(id)owner options:(NSDictionary*)options;

@end

/*--------------------------------------------------*/

@interface UIResponder (MobilyUI)

+ (id)currentFirstResponderInView:(UIView*)view;
+ (id)currentFirstResponder;

+ (UIResponder*)prevResponderFromView:(UIView*)view;
+ (UIResponder*)nextResponderFromView:(UIView*)view;

@end

/*--------------------------------------------------*/
/* VIEWS                                            */
/*--------------------------------------------------*/

@interface UIWindow (MobilyUI)

@property(nonatomic, readonly, strong) UIViewController* currentViewController;

#ifdef __IPHONE_7_0

@property(nonatomic, readonly, strong) UIViewController* viewControllerForStatusBarStyle;
@property(nonatomic, readonly, strong) UIViewController* viewControllerForStatusBarHidden;

#endif

@end

/*--------------------------------------------------*/

@interface UIView (MobilyUI)

@property(nonatomic, readwrite, assign) CGPoint framePosition;
@property(nonatomic, readwrite, assign) CGPoint frameCenter;
@property(nonatomic, readwrite, assign) CGSize frameSize;
@property(nonatomic, readwrite, assign) CGFloat frameSX;
@property(nonatomic, readwrite, assign) CGFloat frameCX;
@property(nonatomic, readwrite, assign) CGFloat frameEX;
@property(nonatomic, readwrite, assign) CGFloat frameSY;
@property(nonatomic, readwrite, assign) CGFloat frameCY;
@property(nonatomic, readwrite, assign) CGFloat frameEY;
@property(nonatomic, readwrite, assign) CGFloat frameWidth;
@property(nonatomic, readwrite, assign) CGFloat frameHeight;
@property(nonatomic, readwrite, assign) CGFloat frameLeft;
@property(nonatomic, readwrite, assign) CGFloat frameRight;
@property(nonatomic, readwrite, assign) CGFloat frameTop;
@property(nonatomic, readwrite, assign) CGFloat frameBottom;

@property(nonatomic, readonly, assign) CGPoint boundsPosition;
@property(nonatomic, readonly, assign) CGPoint boundsCenter;
@property(nonatomic, readonly, assign) CGSize boundsSize;
@property(nonatomic, readonly, assign) CGFloat boundsCX;
@property(nonatomic, readonly, assign) CGFloat boundsCY;
@property(nonatomic, readonly, assign) CGFloat boundsWidth;
@property(nonatomic, readonly, assign) CGFloat boundsHeight;

@property(nonatomic, readwrite, assign) IBInspectable CGFloat zPosition;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* borderColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* shadowColor;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat shadowOpacity;
@property(nonatomic, readwrite, assign) IBInspectable CGSize shadowOffset;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat shadowRadius;
@property(nonatomic, readwrite, strong) UIBezierPath* shadowPath;

- (NSArray*)responders;

- (BOOL)isContainsSubview:(UIView*)subview;

- (void)removeSubview:(UIView*)subview;

- (void)setSubviews:(NSArray*)subviews;
- (void)removeAllSubviews;

- (void)blinkBackgroundColor:(UIColor*)color duration:(NSTimeInterval)duration timeout:(NSTimeInterval)timeout;

@end

/*--------------------------------------------------*/

@interface UIScrollView (MobilyUI)

@property(nonatomic, readwrite, assign) IBInspectable UIEdgeInsets keyboardInset;

@property(nonatomic, readwrite, assign) CGFloat contentOffsetX;
@property(nonatomic, readwrite, assign) CGFloat contentOffsetY;
@property(nonatomic, readwrite, assign) CGFloat contentSizeWidth;
@property(nonatomic, readwrite, assign) CGFloat contentSizeHeight;
@property(nonatomic, readwrite, assign) CGFloat contentInsetTop;
@property(nonatomic, readwrite, assign) CGFloat contentInsetRight;
@property(nonatomic, readwrite, assign) CGFloat contentInsetBottom;
@property(nonatomic, readwrite, assign) CGFloat contentInsetLeft;
@property(nonatomic, readwrite, assign) CGFloat scrollIndicatorInsetTop;
@property(nonatomic, readwrite, assign) CGFloat scrollIndicatorInsetRight;
@property(nonatomic, readwrite, assign) CGFloat scrollIndicatorInsetBottom;
@property(nonatomic, readwrite, assign) CGFloat scrollIndicatorInsetLeft;
@property(nonatomic, readonly, assign) CGRect visibleBounds;

- (void)setContentOffsetX:(CGFloat)contentOffsetX animated:(BOOL)animated;
- (void)setContentOffsetY:(CGFloat)contentOffsetY animated:(BOOL)animated;

- (void)registerAdjustmentResponder;
- (void)unregisterAdjustmentResponder;

@end

/*--------------------------------------------------*/

@interface UITabBar (MobilyUI)

@property(nonatomic, readwrite, assign) NSUInteger selectedItemIndex;

@end

/*--------------------------------------------------*/

@interface UINavigationBar (MobilyUI)



@end

/*--------------------------------------------------*/

@interface UILabel (MobilyUI)

- (CGSize)implicitSize;
- (CGSize)implicitSizeForWidth:(CGFloat)width;
- (CGSize)implicitSizeForSize:(CGSize)size;

@end

/*--------------------------------------------------*/

@interface UIButton (MobilyUI)

@property(nonatomic, readwrite, strong) NSString* normalTitle;
@property(nonatomic, readwrite, strong) UIColor* normalTitleColor;
@property(nonatomic, readwrite, strong) UIColor* normalTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* normalImage;
@property(nonatomic, readwrite, strong) UIImage* normalBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* highlightedTitle;
@property(nonatomic, readwrite, strong) UIColor* highlightedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* highlightedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* highlightedImage;
@property(nonatomic, readwrite, strong) UIImage* highlightedBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* disabledTitle;
@property(nonatomic, readwrite, strong) UIColor* disabledTitleColor;
@property(nonatomic, readwrite, strong) UIColor* disabledTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* disabledImage;
@property(nonatomic, readwrite, strong) UIImage* disabledBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* selectedTitle;
@property(nonatomic, readwrite, strong) UIColor* selectedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* selectedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* selectedImage;
@property(nonatomic, readwrite, strong) UIImage* selectedBackgroundImage;

@end

/*--------------------------------------------------*/
/* CONTROLLERS                                      */
/*--------------------------------------------------*/

@interface UIViewController (MobilyUI)

- (void)loadViewIfNeed;
- (void)unloadViewIfPossible;
- (void)unloadView;

- (UIViewController*)currentViewController;

@end

/*--------------------------------------------------*/

@interface UINavigationController (MobilyUI)

@property(nonatomic, readwrite, assign, getter=isTranslucent) BOOL translucent NS_AVAILABLE_IOS(3_0);
@property(nonatomic, readwrite, retain) UIColor* tintColor;
@property(nonatomic, readwrite, retain) UIColor* barTintColor NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* shadowImage NS_AVAILABLE_IOS(6_0);
@property(nonatomic, readwrite, copy) NSDictionary* titleTextAttributes NS_AVAILABLE_IOS(5_0);
@property(nonatomic, readwrite, retain) UIImage* backIndicatorImage NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* backIndicatorTransitionMaskImage NS_AVAILABLE_IOS(7_0);

- (UIViewController*)rootViewController;

@end

/*--------------------------------------------------*/

@interface UINavigationItem (MobilyUI)

- (UIBarButtonItem*)addLeftBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated;
- (UIBarButtonItem*)addRightBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated;

- (UIButton*)addLeftBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;

- (UIButton*)addLeftBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)addRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;

- (UIBarButtonItem*)addLeftBarView:(UIView*)view animated:(BOOL)animated;
- (UIBarButtonItem*)addRightBarView:(UIView*)view animated:(BOOL)animated;
- (void)addLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)addRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)removeLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)removeRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)removeAllLeftBarButtonItemsAnimated:(BOOL)animated;
- (void)removeAllRightBarButtonItemsAnimated:(BOOL)animated;

- (void)setLeftBarAutomaticAlignmentAnimated:(BOOL)animated;
- (void)setRightBarAutomaticAlignmentAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
/* OTHER                                            */
/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyDeviceFamily) {
    MobilyDeviceFamilyUnknown = 0,
    MobilyDeviceFamilyPhone,
    MobilyDeviceFamilyPad,
    MobilyDeviceFamilyPod,
    MobilyDeviceFamilySimulator,
};

typedef NS_ENUM(NSInteger, MobilyDeviceModel) {
    MobilyDeviceModelUnknown = 0,
    MobilyDeviceModelSimulatorPhone,
    MobilyDeviceModelSimulatorPad,
    MobilyDeviceModelPhone1,
    MobilyDeviceModelPhone3G,
    MobilyDeviceModelPhone3GS,
    MobilyDeviceModelPhone4,
    MobilyDeviceModelPhone4S,
    MobilyDeviceModelPhone5,
    MobilyDeviceModelPhone5C,
    MobilyDeviceModelPhone5S,
    MobilyDeviceModelPhone6,
    MobilyDeviceModelPhone6Plus,
    MobilyDeviceModelPad1,
    MobilyDeviceModelPad2,
    MobilyDeviceModelPad3,
    MobilyDeviceModelPad4,
    MobilyDeviceModelPadMini1,
    MobilyDeviceModelPadMini2,
    MobilyDeviceModelPadMini3,
    MobilyDeviceModelPadAir1,
    MobilyDeviceModelPadAir2,
    MobilyDeviceModelPod1,
    MobilyDeviceModelPod2,
    MobilyDeviceModelPod3,
    MobilyDeviceModelPod4,
    MobilyDeviceModelPod5,
};

typedef NS_ENUM(NSInteger, MobilyDeviceDisplay) {
    MobilyDeviceDisplayUnknown = 0,
    MobilyDeviceDisplayPad,
    MobilyDeviceDisplayPhone35Inch,
    MobilyDeviceDisplayPhone4Inch,
    MobilyDeviceDisplayPhone47Inch,
    MobilyDeviceDisplayPhone55Inch,
};

/*--------------------------------------------------*/

@interface UIDevice (MobilyUI)

+ (CGFloat)systemVersion;

+ (BOOL)isSimulator;
+ (BOOL)isIPhone;
+ (BOOL)isIPad;

+ (NSString*)deviceTypeString;
+ (NSString*)deviceVersionString;

+ (MobilyDeviceFamily)family;
+ (MobilyDeviceModel)model;
+ (MobilyDeviceDisplay)display;

@end

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_STRING(name) \
- (BOOL)validate##name:(inout id*)value error:(out NSError** __unused)error { \
    return [*value isKindOfClass:NSString.class]; \
}

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_STRING_BASED(name, resultClass, convertValue) \
- (BOOL)validate##name:(inout id*)value error:(out NSError** __unused)error { \
    if([*value isKindOfClass:NSString.class] == YES) { \
        *value = convertValue; \
    } \
    return [*value isKindOfClass:resultClass.class]; \
}

#define MOBILY_DEFINE_VALIDATE_BOOL(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithBool:[*value convertToBool]])
#define MOBILY_DEFINE_VALIDATE_NUMBER(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [*value convertToNumber])
#define MOBILY_DEFINE_VALIDATE_RECT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGRect:[*value convertToRect]])
#define MOBILY_DEFINE_VALIDATE_POINT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGPoint:[*value convertToPoint]])
#define MOBILY_DEFINE_VALIDATE_SIZE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGSize:[*value convertToSize]])
#define MOBILY_DEFINE_VALIDATE_EDGE_INSETS(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithUIEdgeInsets:[*value convertToEdgeInsets]])
#define MOBILY_DEFINE_VALIDATE_COLOR(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIColor, [UIColor colorWithString:*value])
#define MOBILY_DEFINE_VALIDATE_BEZIER_PATH(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIBezierPath, [*value convertToBezierPath])
#define MOBILY_DEFINE_VALIDATE_IMAGE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIImage, [*value convertToImage])
#define MOBILY_DEFINE_VALIDATE_FONT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIFont, [*value convertToFont])
#define MOBILY_DEFINE_VALIDATE_REMOTE_NOTIFICATION_TYPE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToRemoteNotificationType]])
#define MOBILY_DEFINE_VALIDATE_INTERFACE_ORIENTATION_MASK(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToInterfaceOrientationMask]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToStatusBarStyle]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_ANIMATION(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToStatusBarAnimation]])
#define MOBILY_DEFINE_VALIDATE_AUTORESIZING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToViewAutoresizing]])
#define MOBILY_DEFINE_VALIDATE_CONTENT_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToViewContentMode]])
#define MOBILY_DEFINE_VALIDATE_TEXT_ALIGNMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTextAlignment]])
#define MOBILY_DEFINE_VALIDATE_LINE_BREAKMODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToLineBreakMode]])
#define MOBILY_DEFINE_VALIDATE_BASELINE_ADJUSTMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToBaselineAdjustment]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_INDICATOR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToScrollViewIndicatorStyle]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_KEYBOARD_DISMISS_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToScrollViewKeyboardDismissMode]])
#define MOBILY_DEFINE_VALIDATE_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToBarStyle]])
#define MOBILY_DEFINE_VALIDATE_TAB_BAR_ITEM_POSITIONING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTabBarItemPositioning]])
#define MOBILY_DEFINE_VALIDATE_SEARCH_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToSearchBarStyle]])
#define MOBILY_DEFINE_VALIDATE_PROGRESS_VIEW_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToProgressViewStyle]])
#define MOBILY_DEFINE_VALIDATE_TEXT_BORDER_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value convertToTextBorderStyle]])

/*--------------------------------------------------*/

#define MOBILY_DEFINE_SETTER_LAYOUT_CONSTRAINT(property, field, view, unuseBlock, useBlock) \
- (void)set##property:(NSLayoutConstraint*)field { \
    if(_##field != field) { \
        if(_##field != nil) { \
            unuseBlock \
            [view removeConstraint:_##field]; \
        } \
        _##field = field; \
        if(_##field != nil) { \
            useBlock \
            [view addConstraint:_##field]; \
        } \
    } \
}

/*--------------------------------------------------*/
