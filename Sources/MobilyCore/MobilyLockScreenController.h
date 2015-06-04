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

#import <MobilyCore/MobilyViewController.h>

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyLockScreenMode) {
    MobilyLockScreenModeUnlock = 0,
    MobilyLockScreenModeAuth,
    MobilyLockScreenModeNew,
    MobilyLockScreenModeChange,
    MobilyLockScreenModeVerification,
};

/*--------------------------------------------------*/

typedef void (^MobilyLockScreenControllerChangeBlock)(NSString* pincode);
typedef void (^MobilyLockScreenControllerBlock)();

/*--------------------------------------------------*/

@class MobilyLockScreenPincodeView;

/*--------------------------------------------------*/

@interface MobilyLockScreenController : MobilyViewController

@property(nonatomic, readwrite, assign) MobilyLockScreenMode lockScreenMode;
@property(nonatomic, readwrite, strong) NSString* pincode;
@property(nonatomic, readwrite, assign) BOOL allowTouchID;

@property(nonatomic, readwrite, strong) IBInspectable NSString* titleText;
@property(nonatomic, readwrite, strong) IBInspectable NSString* subtitleText;
@property(nonatomic, readwrite, strong) IBInspectable NSString* confirmTitleText;
@property(nonatomic, readwrite, strong) IBInspectable NSString* confirmSubtitleText;
@property(nonatomic, readwrite, strong) IBInspectable NSString* invalidTitleText;
@property(nonatomic, readwrite, strong) IBInspectable NSString* invalidSubtitleText;

@property(nonatomic, readonly, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, readonly, weak) IBOutlet UILabel* subtitleLabel;
@property(nonatomic, readonly, weak) IBOutlet UIButton* cancelButton;
@property(nonatomic, readonly, weak) IBOutlet MobilyLockScreenPincodeView* pincodeView;

@property(nonatomic, readwrite, copy) MobilyLockScreenControllerBlock didSuccessfulBlock;
@property(nonatomic, readwrite, copy) MobilyLockScreenControllerChangeBlock didChangeBlock;
@property(nonatomic, readwrite, copy) MobilyLockScreenControllerBlock didCancelledBlock;
@property(nonatomic, readwrite, copy) MobilyLockScreenControllerBlock didFailureBlock;

@end

/*--------------------------------------------------*/
