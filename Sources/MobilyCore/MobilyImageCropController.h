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

typedef NS_ENUM(NSUInteger, MobilyImageCropMode) {
    MobilyImageCropModeCircle,
    MobilyImageCropModeSquare
};

/*--------------------------------------------------*/

@class MobilyImageCropController;

/*--------------------------------------------------*/

typedef void(^MobilyImageCropControllerChoose)(MobilyImageCropController* contoller, UIImage* image, CGRect cropRect, CGFloat angle);
typedef void(^MobilyImageCropControllerCancel)(MobilyImageCropController* contoller);

/*--------------------------------------------------*/

@interface MobilyImageCropController : MobilyController

- (instancetype)initWithImage:(UIImage*)originalImage;
- (instancetype)initWithImage:(UIImage*)originalImage cropMode:(MobilyImageCropMode)cropMode;

@property(nonatomic, readwrite, strong) UIImage* originalImage;
@property(nonatomic, readwrite, strong) UIBezierPath* maskPath;
@property(nonatomic, readwrite, strong) UIColor* maskColor;
@property(nonatomic, readonly, assign) CGRect maskRect;

@property(nonatomic, readonly, assign) MobilyImageCropMode cropMode;
@property(nonatomic, readwrite, assign) CGRect cropRect;
@property(nonatomic, readwrite, assign) CGFloat angle;
@property(nonatomic, readonly, assign) CGFloat scale;

@property(nonatomic, readwrite, assign) BOOL avoidEmptySpaceAroundImage;
@property(nonatomic, readwrite, assign) BOOL applyMaskToCroppedImage;
@property(nonatomic, readwrite, assign, getter=isRotationEnabled) BOOL rotationEnabled;

@property(nonatomic, readwrite, copy) MobilyImageCropControllerChoose didChoose;
@property(nonatomic, readwrite, copy) MobilyImageCropControllerCancel didCancel;

@property(nonatomic, readonly, strong) UILabel* titleLabel;
@property(nonatomic, readonly, strong) UIButton* chooseButton;
@property(nonatomic, readonly, strong) UIButton* cancelButton;

@end

/*--------------------------------------------------*/
