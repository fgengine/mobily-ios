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

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.masksToBounds = YES;
}

- (void)dealloc {
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
    
    self.defaultImage = nil;
    self.imageUrl = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds unionWithArray:self.subviews];
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
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

#pragma mark Property override

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if(_roundCorners == YES) {
        self.cornerRadius = ceil(MAX(frame.size.width - 1, frame.size.height - 1) * 0.5f);
    }
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if(_roundCorners == YES) {
        self.cornerRadius = ceil(MAX(bounds.size.width - 1, bounds.size.height - 1) * 0.5f);
    }
}

#pragma mark Property

- (void)setRoundCorners:(BOOL)roundCorners {
    if(_roundCorners != roundCorners) {
        _roundCorners = roundCorners;
        if(_roundCorners == YES) {
            self.cornerRadius = ceil(MAX(self.frameWidth - 1, self.frameHeight - 1) * 0.5f);
        } else {
            self.cornerRadius = 0.0f;
        }
    }
}

- (void)setImage:(UIImage*)image {
    if(image == nil) {
        image = _defaultImage;
    }
    super.image = image;
}

- (void)setImageUrl:(NSURL*)imageUrl {
    [self setImageUrl:imageUrl complete:nil failure:nil];
}

- (void)setImageUrl:(NSURL*)imageUrl complete:(MobilyImageViewBlock)complete failure:(MobilyImageViewBlock)failure {
    if([_imageUrl isEqual:imageUrl] == NO) {
        if(_imageUrl != nil) {
            [[MobilyImageDownloader shared] cancelByTarget:self];
        }
        _imageUrl = imageUrl;
        super.image = _defaultImage;
        [[MobilyImageDownloader shared] downloadWithUrl:_imageUrl byTarget:self completeBlock:^(UIImage* image, NSURL* url __unused) {
            super.image = image;
            if(complete != nil) {
                complete();
            }
        } failureBlock:^(NSURL* url __unused) {
            if(failure != nil) {
                failure();
            }
        }];
    } else {
        if(complete != nil) {
            complete();
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyImageDownloader

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        self.downloader = [[MobilyDownloader alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc {
    self.downloader = nil;
}

#pragma mark Public

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [self new];
            }
        }
    }
    return shared;
}

- (BOOL)isExistImageWithUrl:(NSURL*)url {
    return [_downloader isExistEntryByUrl:url];
}

- (UIImage*)imageWithUrl:(NSURL*)url {
    return [_downloader entryByUrl:url];
}

- (void)setImage:(UIImage*)image byUrl:(NSURL*)url {
    [_downloader setEntry:image byUrl:url];
}

- (void)removeByUrl:(NSURL*)url {
    [_downloader removeEntryByUrl:url];
}

- (void)cleanup {
    [_downloader cleanup];
}

- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    [_downloader downloadWithUrl:url byTarget:target completeSelector:completeSelector failureSelector:failureSelector];
}

- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeBlock:(MobilyImageDownloaderCompleteBlock)completeBlock failureBlock:(MobilyImageDownloaderFailureBlock)failureBlock {
    [_downloader downloadWithUrl:url byTarget:target completeBlock:completeBlock failureBlock:failureBlock];
}

- (void)cancelByUrl:(NSURL*)url {
    [_downloader cancelByUrl:url];
}

- (void)cancelByTarget:(id)target {
    [_downloader cancelByTarget:target];
}

#pragma mark MobilyDownloaderDelegate

- (id)downloader:(MobilyDownloader* __unused)mobilyDownloader entryFromData:(NSData*)data {
    return [UIImage imageWithData:data];
}

- (NSData*)downloader:(MobilyDownloader* __unused)mobilyDownloader entryToData:(id)entry {
    return UIImagePNGRepresentation(entry);
}

@end

/*--------------------------------------------------*/
