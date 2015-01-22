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
#import "MobilyDownloader.h"

/*--------------------------------------------------*/

@interface MobilyImageDownloader () < MobilyDownloaderDelegate >

@property(nonatomic, readwrite, strong) MobilyDownloader* downloader;

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

- (void)setImageUrl:(NSString*)imageUrl complete:(MobilyImageDownloaderCompleteBlock)complete failure:(MobilyImageDownloaderFailureBlock)failure {
    if([_imageUrl isEqualToString:imageUrl] == NO) {
        if(_imageUrl != nil) {
            [[MobilyImageDownloader shared] cancelByTarget:self];
        }
        _imageUrl = imageUrl;
        [super setImage:_defaultImage];
        [[MobilyImageDownloader shared] downloadWithPath:_imageUrl target:self completeBlock:^(UIImage* image, NSString* path) {
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

@implementation MobilyImageDownloader

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setDownloader:[[MobilyDownloader alloc] initWithDelegate:self]];
    }
    return self;
}

- (void)dealloc {
    [self setDownloader:nil];
    
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
    return [_downloader isExistEntryByPath:path];
}

- (UIImage*)imageWithPath:(NSString*)path {
    return [_downloader entryByPath:path];
}

- (void)setImage:(UIImage*)image byPath:(NSString*)path {
    [_downloader setEntry:image byPath:path];
}

- (void)removeByPath:(NSString*)path {
    [_downloader removeEntryByPath:path];
}

- (void)cleanup {
    [_downloader cleanup];
}

- (void)downloadWithPath:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    [_downloader downloadWithPath:path target:target completeSelector:completeSelector failureSelector:failureSelector];
}

- (void)downloadWithPath:(NSString*)path target:(id)target completeBlock:(MobilyImageDownloaderCompleteBlock)completeBlock failureBlock:(MobilyImageDownloaderFailureBlock)failureBlock {
    [_downloader downloadWithPath:path target:target completeBlock:completeBlock failureBlock:failureBlock];
}

- (void)cancelByPath:(NSString*)path {
    [_downloader cancelByPath:path];
}

- (void)cancelByTarget:(id)target {
    [_downloader cancelByTarget:target];
}

#pragma mark MobilyDownloaderDelegate

- (id)downloader:(MobilyDownloader*)mobilyDownloader entryFromData:(NSData*)data {
    return [UIImage imageWithData:data];
}

- (NSData*)downloader:(MobilyDownloader*)mobilyDownloader entryToData:(id)entry {
    return UIImagePNGRepresentation(entry);
}

@end

/*--------------------------------------------------*/
