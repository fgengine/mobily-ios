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

#import <MobilyCore/MobilyObject.h>
#import <MobilyCore/MobilyCG.h>
#import <MobilyCore/MobilyCA.h>

/*--------------------------------------------------*/

#import <MobilyCore/MobilyEvent.h>

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

- (CGSize)moImplicitSizeWithFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)moImplicitSizeWithFont:(UIFont*)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)moImplicitSizeWithFont:(UIFont*)font forSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (UIEdgeInsets)moConvertToEdgeInsets;
- (UIEdgeInsets)moConvertToEdgeInsetsSeparated:(NSString*)separated;

- (UIBezierPath*)moConvertToBezierPath;
- (UIBezierPath*)moConvertToBezierPathSeparated:(NSString*)separated;

- (UIFont*)moConvertToFont;
- (UIFont*)moConvertToFontSeparated:(NSString*)separated;
- (UIImage*)moConvertToImage;
- (UIImage*)moConvertToImageSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated;
- (NSArray*)moConvertToImages;
- (NSArray*)moConvertToImagesSeparated:(NSString*)separated edgeInsetsSeparated:(NSString*)edgeInsetsSeparated frameSeparated:(NSString*)frameSeparated;

- (UIRemoteNotificationType)moConvertToRemoteNotificationType;
- (UIRemoteNotificationType)moConvertToRemoteNotificationTypeSeparated:(NSString*)separated;
- (UIInterfaceOrientationMask)moConvertToInterfaceOrientationMask;
- (UIInterfaceOrientationMask)moConvertToInterfaceOrientationMaskSeparated:(NSString*)separated;

- (UIStatusBarStyle)moConvertToStatusBarStyle;
- (UIStatusBarAnimation)moConvertToStatusBarAnimation;

- (UIViewAutoresizing)moConvertToViewAutoresizing;
- (UIViewAutoresizing)moConvertToViewAutoresizingSeparated:(NSString*)separated;
- (UIViewContentMode)moConvertToViewContentMode;
- (UIControlContentHorizontalAlignment)moConvertToControlContentHorizontalAlignment;
- (UIControlContentVerticalAlignment)moConvertToControlContentVerticalAlignment;
- (UITextAutocapitalizationType)moConvertToTextAutocapitalizationType;
- (UITextAutocorrectionType)moConvertToTextAutocorrectionType;
- (UITextSpellCheckingType)moConvertToTestSpellCheckingType;
- (UIKeyboardType)moConvertToKeyboardType;
- (UIReturnKeyType)moConvertToReturnKeyType;
- (UIBaselineAdjustment)moConvertToBaselineAdjustment;

- (UIScrollViewIndicatorStyle)moConvertToScrollViewIndicatorStyle;
- (UIScrollViewKeyboardDismissMode)moConvertToScrollViewKeyboardDismissMode;
- (UIBarStyle)moConvertToBarStyle;
- (UITabBarItemPositioning)moConvertToTabBarItemPositioning;
- (UISearchBarStyle)moConvertToSearchBarStyle;
- (UIProgressViewStyle)moConvertToProgressViewStyle;
- (UITextBorderStyle)moConvertToTextBorderStyle;

- (void)moDrawAtPoint:(CGPoint)point font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)moDrawInRect:(CGRect)rect font:(UIFont*)font color:(UIColor*)color vAlignment:(MobilyVerticalAlignment)vAlignment hAlignment:(MobilyHorizontalAlignment)hAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

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

+ (UIColor*)moColorWithString:(NSString*)string;
+ (CGFloat)moColorComponentFromString:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length;

- (UIColor*)moMultiplyColor:(UIColor*)color percent:(CGFloat)percent;
- (UIColor*)moMultiplyBrightness:(CGFloat)brightness;

-(MobilyColorHSB)moHsb;

@end

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyImageAlignment) {
    MobilyImageAlignmentStretch,
    MobilyImageAlignmentAspectFill,
    MobilyImageAlignmentAspectFit
};

/*--------------------------------------------------*/

@interface UIImage (MobilyUI)

+ (UIImage*)moImageNamed:(NSString*)name capInsets:(UIEdgeInsets)capInsets;
+ (UIImage*)moImageWithColor:(UIColor*)color size:(CGSize)size;

- (UIImage*)moUnrotate;
- (UIImage*)moScaleToSize:(CGSize)size;
- (UIImage*)moRotateToAngleInRadians:(CGFloat)angleInRadians;

- (UIImage*)moGrayscale;
- (UIImage*)moBlackAndWhite;
- (UIImage*)moInvertColors;

- (UIImage*)moBlurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor*)tintColor;

- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment;
- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment radius:(CGFloat)radius;
- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)moDrawInRect:(CGRect)rect alignment:(MobilyImageAlignment)alignment corners:(UIRectCorner)corners radius:(CGFloat)radius blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

@end

/*--------------------------------------------------*/

typedef NS_OPTIONS(NSUInteger, MobilyBezierPathSeparatorEdges) {
    MobilyBezierPathSeparatorEdgeTop = 1 << 0,
    MobilyBezierPathSeparatorEdgeRight = 1 << 1,
    MobilyBezierPathSeparatorEdgeBottom = 1 << 2,
    MobilyBezierPathSeparatorEdgeLeft = 1 << 3,
    MobilyBezierPathSeparatorEdgeAll  = (MobilyBezierPathSeparatorEdgeTop | MobilyBezierPathSeparatorEdgeLeft | MobilyBezierPathSeparatorEdgeBottom | MobilyBezierPathSeparatorEdgeRight)
};

/*--------------------------------------------------*/

@interface UIBezierPath (MobilyUI)

+ (void)moDrawRect:(CGRect)rect fillColor:(UIColor*)fillColor;
+ (void)moDrawRect:(CGRect)rect fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth;

+ (void)moDrawOvalInRect:(CGRect)rect fillColor:(UIColor*)fillColor;
+ (void)moDrawOvalInRect:(CGRect)rect fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth;

+ (void)moDrawRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor*)fillColor;
+ (void)moDrawRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth;

+ (void)moDrawRoundedRect:(CGRect)rect corners:(UIRectCorner)corners radius:(CGSize)radius fillColor:(UIColor*)fillColor;
+ (void)moDrawRoundedRect:(CGRect)rect corners:(UIRectCorner)corners radius:(CGSize)radius fillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth;

+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges width:(CGFloat)width fillColor:(UIColor*)fillColor;
+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges width:(CGFloat)width edgeInsets:(UIEdgeInsets)edgeInsets fillColor:(UIColor*)fillColor;
+ (void)moDrawSeparatorRect:(CGRect)rect edges:(MobilyBezierPathSeparatorEdges)edges widthEdges:(UIEdgeInsets)widthEdges edgeInsets:(UIEdgeInsets)edgeInsets fillColor:(UIColor*)fillColor;

@end

/*--------------------------------------------------*/

@interface UINib (MobilyUI)

+ (id)moViewWithNibName:(NSString*)nibName withClass:(Class)class;
+ (id)moViewWithNibName:(NSString*)nibName withClass:(Class)class withOwner:(id)owner;

+ (UINib*)moNibWithBaseName:(NSString*)baseName bundle:(NSBundle*)bundle;
+ (UINib*)moNibWithClass:(Class)class bundle:(NSBundle*)bundle;

- (id)moInstantiateWithClass:(Class)class owner:(id)owner options:(NSDictionary*)options;

@end

/*--------------------------------------------------*/

@interface UIResponder (MobilyUI)

+ (id)moCurrentFirstResponderInView:(UIView*)view;
+ (id)moCurrentFirstResponder;

+ (UIResponder*)moPrevResponderFromView:(UIView*)view;
+ (UIResponder*)moNextResponderFromView:(UIView*)view;

@end

/*--------------------------------------------------*/
/* VIEWS                                            */
/*--------------------------------------------------*/

@interface UIWindow (MobilyUI)

@property(nonatomic, readonly, strong) UIViewController* moCurrentController;

#ifdef __IPHONE_7_0

@property(nonatomic, readonly, strong) UIViewController* moControllerForStatusBarStyle;
@property(nonatomic, readonly, strong) UIViewController* moControllerForStatusBarHidden;

#endif

@end

/*--------------------------------------------------*/

@interface UIView (MobilyUI)

@property(nonatomic, readwrite, assign) CGPoint moFramePosition;
@property(nonatomic, readwrite, assign) CGPoint moFrameCenter;
@property(nonatomic, readwrite, assign) CGSize moFrameSize;
@property(nonatomic, readwrite, assign) CGFloat moFrameSX;
@property(nonatomic, readwrite, assign) CGFloat moFrameCX;
@property(nonatomic, readwrite, assign) CGFloat moFrameEX;
@property(nonatomic, readwrite, assign) CGFloat moFrameSY;
@property(nonatomic, readwrite, assign) CGFloat moFrameCY;
@property(nonatomic, readwrite, assign) CGFloat moFrameEY;
@property(nonatomic, readwrite, assign) CGFloat moFrameWidth;
@property(nonatomic, readwrite, assign) CGFloat moFrameHeight;
@property(nonatomic, readwrite, assign) CGFloat moFrameLeft;
@property(nonatomic, readwrite, assign) CGFloat moFrameRight;
@property(nonatomic, readwrite, assign) CGFloat moFrameTop;
@property(nonatomic, readwrite, assign) CGFloat moFrameBottom;

@property(nonatomic, readonly, assign) CGPoint moBoundsPosition;
@property(nonatomic, readonly, assign) CGPoint moBoundsCenter;
@property(nonatomic, readonly, assign) CGSize moBoundsSize;
@property(nonatomic, readonly, assign) CGFloat moBoundsCX;
@property(nonatomic, readonly, assign) CGFloat moBoundsCY;
@property(nonatomic, readonly, assign) CGFloat moBoundsWidth;
@property(nonatomic, readonly, assign) CGFloat moBoundsHeight;

@property(nonatomic, readwrite, assign) IBInspectable CGFloat moZPosition;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat moCornerRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat moBorderWidth;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* moBorderColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* moShadowColor;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat moShadowOpacity;
@property(nonatomic, readwrite, assign) IBInspectable CGSize moShadowOffset;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat moShadowRadius;
@property(nonatomic, readwrite, strong) UIBezierPath* moShadowPath;

- (NSArray*)moResponders;

- (BOOL)moIsContainsSubview:(UIView*)subview;

- (void)moRemoveSubview:(UIView*)subview;

- (void)moSetSubviews:(NSArray*)subviews;
- (void)moRemoveAllSubviews;

- (void)moBlinkBackgroundColor:(UIColor*)color duration:(NSTimeInterval)duration timeout:(NSTimeInterval)timeout;

- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant priority:(UILayoutPriority)priority;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier;

- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier;

- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority;
- (NSLayoutConstraint*)addConstraintAttribute:(NSLayoutAttribute)constraintAttribute relation:(NSLayoutRelation)relation view:(UIView*)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant priority:(UILayoutPriority)priority multiplier:(CGFloat)multiplier;

@end

/*--------------------------------------------------*/

@interface UIScrollView (MobilyUI)

@property(nonatomic, readwrite, assign) IBInspectable UIEdgeInsets moKeyboardInset;

@property(nonatomic, readwrite, assign) CGFloat moContentOffsetX;
@property(nonatomic, readwrite, assign) CGFloat moContentOffsetY;
@property(nonatomic, readwrite, assign) CGFloat moContentSizeWidth;
@property(nonatomic, readwrite, assign) CGFloat moContentSizeHeight;
@property(nonatomic, readwrite, assign) CGFloat moContentInsetTop;
@property(nonatomic, readwrite, assign) CGFloat moContentInsetRight;
@property(nonatomic, readwrite, assign) CGFloat moContentInsetBottom;
@property(nonatomic, readwrite, assign) CGFloat moContentInsetLeft;
@property(nonatomic, readwrite, assign) CGFloat moScrollIndicatorInsetTop;
@property(nonatomic, readwrite, assign) CGFloat moScrollIndicatorInsetRight;
@property(nonatomic, readwrite, assign) CGFloat moScrollIndicatorInsetBottom;
@property(nonatomic, readwrite, assign) CGFloat moScrollIndicatorInsetLeft;
@property(nonatomic, readonly, assign) CGRect moVisibleBounds;

- (void)setMoContentOffsetX:(CGFloat)moContentOffsetX animated:(BOOL)animated;
- (void)setMoContentOffsetY:(CGFloat)moContentOffsetY animated:(BOOL)animated;

- (void)moRegisterAdjustmentResponder;
- (void)moUnregisterAdjustmentResponder;

@end

/*--------------------------------------------------*/

@interface UITabBar (MobilyUI)

@property(nonatomic, readwrite, assign) NSUInteger moSelectedItemIndex;

@end

/*--------------------------------------------------*/

@interface UINavigationBar (MobilyUI)



@end

/*--------------------------------------------------*/

@interface UILabel (MobilyUI)

- (CGSize)moImplicitSize;
- (CGSize)moImplicitSizeForWidth:(CGFloat)width;
- (CGSize)moImplicitSizeForSize:(CGSize)size;

@end

/*--------------------------------------------------*/

@interface UIButton (MobilyUI)

@property(nonatomic, readwrite, strong) NSString* moNormalTitle;
@property(nonatomic, readwrite, strong) UIColor* moNormalTitleColor;
@property(nonatomic, readwrite, strong) UIColor* moNormalTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* moNormalImage;
@property(nonatomic, readwrite, strong) UIImage* moNormalBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* moHighlightedTitle;
@property(nonatomic, readwrite, strong) UIColor* moHighlightedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* moHighlightedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* moHighlightedImage;
@property(nonatomic, readwrite, strong) UIImage* moHighlightedBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* moSelectedTitle;
@property(nonatomic, readwrite, strong) UIColor* moSelectedTitleColor;
@property(nonatomic, readwrite, strong) UIColor* moSelectedTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* moSelectedImage;
@property(nonatomic, readwrite, strong) UIImage* moSelectedBackgroundImage;

@property(nonatomic, readwrite, strong) NSString* moDisabledTitle;
@property(nonatomic, readwrite, strong) UIColor* moDisabledTitleColor;
@property(nonatomic, readwrite, strong) UIColor* moDisabledTitleShadowColor;
@property(nonatomic, readwrite, strong) UIImage* moDisabledImage;
@property(nonatomic, readwrite, strong) UIImage* moDisabledBackgroundImage;

@end

/*--------------------------------------------------*/
/* CONTROLLERS                                      */
/*--------------------------------------------------*/

@interface UIViewController (MobilyUI)

- (void)moLoadViewIfNeed;
- (void)moUnloadViewIfPossible;
- (void)moUnloadView;

- (UIViewController*)moCurrentController;

@end

/*--------------------------------------------------*/

@interface UINavigationController (MobilyUI)

@property(nonatomic, readwrite, assign) BOOL moTranslucent NS_AVAILABLE_IOS(3_0);
@property(nonatomic, readwrite, retain) UIColor* moTintColor;
@property(nonatomic, readwrite, retain) UIColor* moBarTintColor NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* moShadowImage NS_AVAILABLE_IOS(6_0);
@property(nonatomic, readwrite, copy) NSDictionary* moTitleTextAttributes NS_AVAILABLE_IOS(5_0);
@property(nonatomic, readwrite, retain) UIImage* moBackIndicatorImage NS_AVAILABLE_IOS(7_0);
@property(nonatomic, readwrite, retain) UIImage* moBackIndicatorTransitionMaskImage NS_AVAILABLE_IOS(7_0);

- (UIViewController*)moRootController;

@end

/*--------------------------------------------------*/

@class MobilyImageView;

/*--------------------------------------------------*/

@interface UINavigationItem (MobilyUI)

- (UIBarButtonItem*)moAddLeftBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated;
- (UIBarButtonItem*)moAddRightBarFixedSpace:(CGFloat)fixedSpaceWidth animated:(BOOL)animated;

- (MobilyImageView*)moAddLeftBarImageUrl:(NSURL*)imageUrl defaultImage:(UIImage*)defaultImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (MobilyImageView*)moAddRightBarImageUrl:(NSURL*)imageUrl defaultImage:(UIImage*)defaultImage target:(id)target action:(SEL)action animated:(BOOL)animated;

- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;

- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalImage:(UIImage*)normalImage highlightedImage:(UIImage*)highlightedImage selectedImage:(UIImage*)selectedImage disabledImage:(UIImage*)disabledImage target:(id)target action:(SEL)action animated:(BOOL)animated;

- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font frame:(CGRect)frame target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddLeftBarButtonNormalTitle:(NSString*)normalTitle
                          highlightedTitle:(NSString*)highlightedTitle
                             selectedTitle:(NSString*)selectedTitle
                             disabledTitle:(NSString*)disabledTitle
                          normalTitleColor:(UIColor*)normatTitleColor
                     highlightedTitleColor:(UIColor*)highlightedTitleColor
                        selectedTitleColor:(UIColor*)selectedTitleColor
                        disabledTitleColor:(UIColor*)disabledTitleColor
                                      font:(UIFont*)font
                                     frame:(CGRect)frame
                                    target:(id)target
                                    action:(SEL)action
                                  animated:(BOOL)animated;

- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle normalTitleColor:(UIColor*)normatTitleColor font:(UIFont*)font frame:(CGRect)frame target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle highlightedTitle:(NSString*)highlightedTitle selectedTitle:(NSString*)selectedTitle disabledTitle:(NSString*)disabledTitle target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIButton*)moAddRightBarButtonNormalTitle:(NSString*)normalTitle
                           highlightedTitle:(NSString*)highlightedTitle
                              selectedTitle:(NSString*)selectedTitle
                              disabledTitle:(NSString*)disabledTitle
                           normalTitleColor:(UIColor*)normatTitleColor
                      highlightedTitleColor:(UIColor*)highlightedTitleColor
                         selectedTitleColor:(UIColor*)selectedTitleColor
                         disabledTitleColor:(UIColor*)disabledTitleColor
                                       font:(UIFont*)font
                                      frame:(CGRect)frame
                                     target:(id)target
                                     action:(SEL)action
                                   animated:(BOOL)animated;

- (UIBarButtonItem*)moAddLeftBarView:(UIView*)view animated:(BOOL)animated;
- (UIBarButtonItem*)moAddRightBarView:(UIView*)view animated:(BOOL)animated;
- (UIBarButtonItem*)moAddLeftBarView:(UIView*)view target:(id)target action:(SEL)action animated:(BOOL)animated;
- (UIBarButtonItem*)moAddRightBarView:(UIView*)view target:(id)target action:(SEL)action animated:(BOOL)animated;
- (void)moAddLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)moAddRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)moRemoveLeftBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)moRemoveRightBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)animated;
- (void)moRemoveAllLeftBarButtonItemsAnimated:(BOOL)animated;
- (void)moRemoveAllRightBarButtonItemsAnimated:(BOOL)animated;

- (void)moSetLeftBarAutomaticAlignmentAnimated:(BOOL)animated;
- (void)moSetRightBarAutomaticAlignmentAnimated:(BOOL)animated;

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

+ (CGFloat)moSystemVersion;

+ (BOOL)moIsSimulator;
+ (BOOL)moIsIPhone;
+ (BOOL)moIsIPad;

+ (NSString*)moDeviceTypeString;
+ (NSString*)moDeviceVersionString;

+ (MobilyDeviceFamily)moFamily;
+ (MobilyDeviceModel)moModel;
+ (MobilyDeviceDisplay)moDisplay;

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

#define MOBILY_DEFINE_VALIDATE_BOOL(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithBool:[*value moConvertToBool]])
#define MOBILY_DEFINE_VALIDATE_NUMBER(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [*value moConvertToNumber])
#define MOBILY_DEFINE_VALIDATE_RECT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGRect:[*value moConvertToRect]])
#define MOBILY_DEFINE_VALIDATE_POINT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGPoint:[*value moConvertToPoint]])
#define MOBILY_DEFINE_VALIDATE_SIZE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithCGSize:[*value moConvertToSize]])
#define MOBILY_DEFINE_VALIDATE_EDGE_INSETS(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSValue, [NSValue valueWithUIEdgeInsets:[*value moConvertToEdgeInsets]])
#define MOBILY_DEFINE_VALIDATE_COLOR(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIColor, [UIColor moColorWithString:*value])
#define MOBILY_DEFINE_VALIDATE_BEZIER_PATH(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIBezierPath, [*value moConvertToBezierPath])
#define MOBILY_DEFINE_VALIDATE_IMAGE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIImage, [*value moConvertToImage])
#define MOBILY_DEFINE_VALIDATE_FONT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, UIFont, [*value moConvertToFont])
#define MOBILY_DEFINE_VALIDATE_REMOTE_NOTIFICATION_TYPE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToRemoteNotificationType]])
#define MOBILY_DEFINE_VALIDATE_INTERFACE_ORIENTATION_MASK(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToInterfaceOrientationMask]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToStatusBarStyle]])
#define MOBILY_DEFINE_VALIDATE_STATUS_BAR_ANIMATION(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToStatusBarAnimation]])
#define MOBILY_DEFINE_VALIDATE_AUTORESIZING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToViewAutoresizing]])
#define MOBILY_DEFINE_VALIDATE_CONTENT_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToViewContentMode]])
#define MOBILY_DEFINE_VALIDATE_TEXT_ALIGNMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToTextAlignment]])
#define MOBILY_DEFINE_VALIDATE_LINE_BREAKMODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToLineBreakMode]])
#define MOBILY_DEFINE_VALIDATE_BASELINE_ADJUSTMENT(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToBaselineAdjustment]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_INDICATOR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToScrollViewIndicatorStyle]])
#define MOBILY_DEFINE_VALIDATE_SCROLL_VIEW_KEYBOARD_DISMISS_MODE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToScrollViewKeyboardDismissMode]])
#define MOBILY_DEFINE_VALIDATE_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToBarStyle]])
#define MOBILY_DEFINE_VALIDATE_TAB_BAR_ITEM_POSITIONING(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToTabBarItemPositioning]])
#define MOBILY_DEFINE_VALIDATE_SEARCH_BAR_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToSearchBarStyle]])
#define MOBILY_DEFINE_VALIDATE_PROGRESS_VIEW_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToProgressViewStyle]])
#define MOBILY_DEFINE_VALIDATE_TEXT_BORDER_STYLE(name) MOBILY_DEFINE_VALIDATE_STRING_BASED(name, NSNumber, [NSNumber numberWithUnsignedInt:[*value moConvertToTextBorderStyle]])

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
