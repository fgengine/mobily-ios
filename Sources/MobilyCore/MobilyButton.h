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

#import <MobilyCore/MobilyBuilder.h>

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyButtonImageAlignment) {
    MobilyButtonImageAlignmentLeft,
    MobilyButtonImageAlignmentRight,
    MobilyButtonImageAlignmentTop,
    MobilyButtonImageAlignmentBottom
};

/*--------------------------------------------------*/

#ifdef MOBILY_FRAMEWORK
IB_DESIGNABLE
#endif
@interface MobilyButton : UIButton< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBInspectable MobilyButtonImageAlignment imageAlignment;

@property(nonatomic, readwrite, strong) IBInspectable UIColor* normalBackgroundColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* selectedBackgroundColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* highlightedBackgroundColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* disabledBackgroundColor;
@property(nonatomic, readonly, strong) UIColor* currentBackgroundColor;

@property(nonatomic, readwrite, strong) IBInspectable UIColor* normalBorderColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* selectedBorderColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* highlightedBorderColor;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* disabledBorderColor;
@property(nonatomic, readonly, strong) UIColor* currentBorderColor;

@property(nonatomic, readwrite, assign) IBInspectable CGFloat normalBorderWidth;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat selectedBorderWidth;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat highlightedBorderWidth;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat disabledBorderWidth;
@property(nonatomic, readonly, assign) CGFloat currentBorderWidth;

@property(nonatomic, readwrite, assign) IBInspectable CGFloat normalCornerRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat selectedCornerRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat highlightedCornerRadius;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat disabledCornerRadius;
@property(nonatomic, readonly, assign) CGFloat currentCornerRadius;

- (void)setup NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/
