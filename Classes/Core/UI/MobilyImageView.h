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

#import "MobilyBuilder.h"

/*--------------------------------------------------*/

typedef void (^MobilyImageViewBlock)();

/*--------------------------------------------------*/

@interface MobilyImageView : UIImageView< MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBInspectable BOOL roundCorners;
@property(nonatomic, readwrite, strong) IBInspectable UIImage* defaultImage;
@property(nonatomic, readwrite, strong) IBInspectable NSURL* imageUrl;

- (void)setImageUrl:(NSURL*)imageUrl complete:(MobilyImageViewBlock)complete failure:(MobilyImageViewBlock)failure;

@end

/*--------------------------------------------------*/

typedef void (^MobilyImageDownloaderCompleteBlock)(UIImage* image, NSURL* url);
typedef void (^MobilyImageDownloaderFailureBlock)(NSURL* url);

/*--------------------------------------------------*/

@interface MobilyImageDownloader : NSObject

+ (instancetype)shared;

- (BOOL)isExistImageWithUrl:(NSURL*)url;
- (void)setImage:(UIImage*)image byUrl:(NSURL*)url;
- (void)removeByUrl:(NSURL*)url;
- (void)cleanup;

- (UIImage*)imageWithUrl:(NSURL*)url;

- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeBlock:(MobilyImageDownloaderCompleteBlock)completeBlock failureBlock:(MobilyImageDownloaderFailureBlock)failureBlock;
- (void)cancelByUrl:(NSURL*)url;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/
