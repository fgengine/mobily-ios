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

#import "MobilyBuilder.h"

/*--------------------------------------------------*/

typedef void (^MobilyImageDownloaderCompleteBlock)(UIImage* image, NSString* path);
typedef void (^MobilyImageDownloaderFailureBlock)(NSString* path);

/*--------------------------------------------------*/

@interface MobilyImageView : UIImageView< MobilyBuilderObject >

@property(nonatomic, readwrite, strong) IBInspectable UIImage* defaultImage;
@property(nonatomic, readwrite, strong) IBInspectable NSString* imageUrl;

- (void)setup;

- (void)setImageUrl:(NSString*)imageUrl complete:(MobilyImageDownloaderCompleteBlock)complete failure:(MobilyImageDownloaderFailureBlock)failure;

@end

/*--------------------------------------------------*/

@interface MobilyImageDownloader : NSObject

+ (instancetype)shared;

- (BOOL)isExistImageWithPath:(NSString*)path;
- (void)setImage:(UIImage*)image byPath:(NSString*)path;
- (void)removeByPath:(NSString*)path;
- (void)cleanup;

- (UIImage*)imageWithPath:(NSString*)path;

- (void)downloadWithPath:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (void)downloadWithPath:(NSString*)path target:(id)target completeBlock:(MobilyImageDownloaderCompleteBlock)completeBlock failureBlock:(MobilyImageDownloaderFailureBlock)failureBlock;
- (void)cancelByPath:(NSString*)path;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/
