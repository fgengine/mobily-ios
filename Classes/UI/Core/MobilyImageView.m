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

#import "MobilyImageView.h"
#import "MobilyLoader.h"

/*--------------------------------------------------*/

@interface MobilyImageLoader () < MobilyLoaderDelegate >

@property(nonatomic, readwrite, strong) MobilyLoader* loader;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyImageView

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    [self setDefaultImage:nil];
    [self setImageUrl:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild]];
        [self removeSubview:(UIView*)objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark Public

- (void)setup {
    [[self layer] setMasksToBounds:YES];
}

#pragma mark Property

- (void)setImage:(UIImage*)image {
    if(image == nil) {
        image = _defaultImage;
    }
    [super setImage:image];
}

- (void)setImageUrl:(NSString*)imageUrl {
    [self setImageUrl:imageUrl complete:nil failure:nil];
}

- (void)setImageUrl:(NSString*)imageUrl complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure {
    if([_imageUrl isEqualToString:imageUrl] == NO) {
        if(_imageUrl != nil) {
            [[MobilyImageLoader shared] cancelByTarget:self];
        }
        _imageUrl = imageUrl;
        [super setImage:_defaultImage];
        [[MobilyImageLoader shared] loadWithPath:_imageUrl target:self completeBlock:^(UIImage* image, NSString* path) {
            [super setImage:image];
            if(complete != nil) {
                complete(image, _imageUrl);
            }
        } failureBlock:failure];
    } else {
        if(complete != nil) {
            complete([self image], _imageUrl);
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyImageLoader

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setLoader:[[MobilyLoader alloc] initWithDelegate:self]];
    }
    return self;
}

- (void)dealloc {
    [self setLoader:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [[self alloc] init];
            }
        }
    }
    return shared;
}

- (BOOL)isExistImageWithPath:(NSString*)path {
    return [_loader isExistEntryByPath:path];
}

- (UIImage*)imageWithPath:(NSString*)path {
    return [_loader entryByPath:path];
}

- (void)setImage:(UIImage*)image byPath:(NSString*)path {
    [_loader setEntry:image byPath:path];
}

- (void)removeByPath:(NSString*)path {
    [[_loader cache] removeCacheDataForKey:path];
}

- (void)cleanup {
    [[_loader cache] removeAllCachedData];
}

- (void)loadWithPath:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    [_loader loadWithPath:path target:target completeSelector:completeSelector failureSelector:failureSelector];
}

- (void)loadWithPath:(NSString*)path target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock {
    [_loader loadWithPath:path target:target completeBlock:completeBlock failureBlock:failureBlock];
}

- (void)cancelByPath:(NSString*)path {
    [_loader cancelByPath:path];
}

- (void)cancelByTarget:(id)target {
    [_loader cancelByTarget:target];
}

#pragma mark MobilyLoaderDelegatec

- (id)loader:(MobilyLoader*)mobilyLoader entryFromData:(NSData*)data {
    return [UIImage imageWithData:data];
}

- (NSData*)loader:(MobilyLoader*)mobilyLoader entryToData:(id)entry {
    return UIImagePNGRepresentation(entry);
}

@end

/*--------------------------------------------------*/
