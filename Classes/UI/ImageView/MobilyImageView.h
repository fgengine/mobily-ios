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

typedef void (^MobilyImageLoaderCompleteBlock)(UIImage* image, NSString* imageUrl);
typedef void (^MobilyImageLoaderFailureBlock)(NSString* imageUrl);

/*--------------------------------------------------*/

@interface MobilyImageView : UIImageView< MobilyBuilderObject >

@property(nonatomic, readwrite, strong) IBInspectable UIImage* defaultImage;
@property(nonatomic, readwrite, strong) IBInspectable NSString* imageUrl;

- (void)setupView;

- (void)setImageUrl:(NSString*)imageUrl complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure;

@end

/*--------------------------------------------------*/

@interface MobilyImageLoader : NSObject

+ (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl;
+ (UIImage*)imageWithImageUrl:(NSString*)imageUrl;
+ (void)removeByImageUrl:(NSString*)imageUrl;
+ (void)cleanup;

+ (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
+ (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock;
+ (void)cancelByImageUrl:(NSString*)imageUrl;
+ (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/
