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

#import "MobilyViewImage.h"
#import "MobilyTaskManager.h"

/*--------------------------------------------------*/

#include "MobilyCG.h"

/*--------------------------------------------------*/

typedef void (^MobilyImageLoaderBlock)();

/*--------------------------------------------------*/

@interface MobilyImageLoader ()

@property(nonatomic, readwrite, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, strong) NSCache* cache;

+ (MobilyImageLoader*)shared;

- (NSString*)cacheKeyByImageUrl:(NSString*)imageUrl;

- (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl;
- (UIImage*)imageWithImageUrl:(NSString*)imageUrl;
- (void)addImage:(UIImage*)image byImageUrl:(NSString*)imageUrl;
- (void)removeByImageUrl:(NSString*)imageUrl;
- (void)cleanup;

- (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock;
- (void)cancelByImageUrl:(NSString*)imageUrl;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyTaskImageLoader : MobilyTask

@property(nonatomic, readwrite, weak) MobilyImageLoader* imageLoader;
@property(nonatomic, readwrite, strong) id target;
@property(nonatomic, readwrite, strong) NSString* imageUrl;
@property(nonatomic, readwrite, strong) NSString* cacheKey;
@property(nonatomic, readwrite, strong) UIImage* image;
@property(nonatomic, readwrite, strong) id< MobilyEvent > completeEvent;
@property(nonatomic, readwrite, strong) id< MobilyEvent > failureEvent;

- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target;
- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewImage

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
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

- (void)setupView {
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
            [MobilyImageLoader cancelByTarget:self];
        }
        _imageUrl = imageUrl;
        if(_defaultImage != nil) {
        }
        [super setImage:_defaultImage];
        [MobilyImageLoader loadWithImageUrl:_imageUrl target:self completeBlock:^(UIImage* image, NSString* imageUrl) {
            [self setImage:image];
            if(complete != nil) {
                complete(image, imageUrl);
            }
        } failureBlock:failure];
    } else {
        if(complete != nil) {
            complete([self image], imageUrl);
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static MobilyImageLoader* MOBILY_IMAGE_LOADER = nil;

/*--------------------------------------------------*/

#define FG_IMAGE_LOADER_FOLDER                      @"MobilyImageLoaderCache"
#define FG_IMAGE_LOADER_MAX_CONCURRENT_TASK         5
#define FG_IMAGE_LOADER_COUNT_LIMIT                 512

/*--------------------------------------------------*/

@implementation MobilyImageLoader

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setTaskManager:[[MobilyTaskManager alloc] init]];
        if(_taskManager != nil) {
            [_taskManager setMaxConcurrentTask:FG_IMAGE_LOADER_MAX_CONCURRENT_TASK];
        }
        [self setCache:[[NSCache alloc] init]];
        if(_cache != nil) {
            [_cache setName:FG_IMAGE_LOADER_FOLDER];
            [_cache setCountLimit:FG_IMAGE_LOADER_COUNT_LIMIT];
        }
    }
    return self;
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setCache:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

+ (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl {
    return [[self shared] isExistImageWithImageUrl:imageUrl];
}

+ (UIImage*)imageWithImageUrl:(NSString*)imageUrl {
    return [[self shared] imageWithImageUrl:imageUrl];
}

+ (void)addImage:(UIImage*)image byImageUrl:(NSString*)imageUrl {
    [[self shared] addImage:image byImageUrl:imageUrl];
}

+ (void)removeByImageUrl:(NSString*)imageUrl {
    [[self shared] removeByImageUrl:imageUrl];
}

+ (void)cleanup {
    [[self shared] cleanup];
}

+ (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    [[self shared] loadWithImageUrl:imageUrl target:target completeSelector:completeSelector failureSelector:failureSelector];
}

+ (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock {
    [[self shared] loadWithImageUrl:imageUrl target:target completeBlock:completeBlock failureBlock:failureBlock];
}

+ (void)cancelByImageUrl:(NSString*)imageUrl {
    [[self shared] cancelByImageUrl:imageUrl];
}

+ (void)cancelByTarget:(id)target {
    [[self shared] cancelByTarget:target];
}

#pragma mark Private

+ (MobilyImageLoader*)shared {
    if(MOBILY_IMAGE_LOADER == nil) {
        @synchronized(self) {
            if(MOBILY_IMAGE_LOADER == nil) {
                MOBILY_IMAGE_LOADER = [[self alloc] init];
            }
        }
    }
    return MOBILY_IMAGE_LOADER;
}

- (NSString*)cacheKeyByImageUrl:(NSString*)imageUrl {
    NSString* lowercaseImageUrl = [[imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    return [[[lowercaseImageUrl lastPathComponent] stringByMD5] stringByAppendingPathExtension:[lowercaseImageUrl pathExtension]];
}

- (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl {
    return ([_cache objectForKey:[self cacheKeyByImageUrl:imageUrl]] != nil);
}

- (UIImage*)imageWithImageUrl:(NSString*)imageUrl {
    NSData* imageData = [NSData dataWithContentsOfFile:[_cache objectForKey:[self cacheKeyByImageUrl:imageUrl]]];
    if(imageData != nil) {
        return [UIImage imageWithData:imageData];
    }
    return nil;
}

- (void)addImage:(UIImage*)image byImageUrl:(NSString*)imageUrl {
    NSData* imageData = UIImagePNGRepresentation(image);
    if(imageData != nil) {
        [_cache setObject:imageData forKey:[self cacheKeyByImageUrl:imageUrl]];
    }
}

- (void)removeByImageUrl:(NSString*)imageUrl {
    [_cache removeObjectForKey:[self cacheKeyByImageUrl:imageUrl]];
}

- (void)cleanup {
    [_cache removeAllObjects];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    UIImage* image = [self imageWithImageUrl:imageUrl];
    if(image == nil) {
        MobilyTaskImageLoader* task = [[MobilyTaskImageLoader alloc] initWithImageUrl:imageUrl target:target completeSelector:completeSelector failureSelector:failureSelector];
        if(task != nil) {
            [_taskManager updating];
            [_taskManager addTask:task];
            [_taskManager updated];
        } else {
            if([target respondsToSelector:failureSelector] == YES) {
                [target performSelector:failureSelector withObject:imageUrl];
            }
        }
    } else {
        if([target respondsToSelector:completeSelector] == YES) {
            [target performSelector:completeSelector withObject:image withObject:imageUrl];
        }
    }
}
#pragma clang diagnostic pop

- (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock {
    UIImage* image = [self imageWithImageUrl:imageUrl];
    if(image == nil) {
        MobilyTaskImageLoader* task = [[MobilyTaskImageLoader alloc] initWithImageUrl:imageUrl target:target completeBlock:completeBlock failureBlock:failureBlock];
        if(task != nil) {
            [_taskManager updating];
            [_taskManager addTask:task];
            [_taskManager updated];
        } else {
            if(failureBlock != nil) {
                failureBlock(imageUrl);
            }
        }
    } else {
        if(completeBlock != nil) {
            completeBlock(image, imageUrl);
        }
    }
}

- (void)cancelByImageUrl:(NSString*)imageUrl {
    [_taskManager enumirateTasksUsingBlock:^(MobilyTaskImageLoader* task, BOOL* stop) {
        if([[task imageUrl] isEqualToString:imageUrl] == YES) {
            [task cancel];
        }
    }];
}

- (void)cancelByTarget:(id)target {
    [_taskManager enumirateTasksUsingBlock:^(MobilyTaskImageLoader* task, BOOL* stop) {
        if([task target] == target) {
            [task cancel];
        }
    }];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTaskImageLoader

- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target {
    self = [super init];
    if(self != nil) {
        [self setImageLoader:[MobilyImageLoader shared]];
        [self setTarget:target];
        [self setImageUrl:imageUrl];
        [self setCacheKey:[_imageLoader cacheKeyByImageUrl:_imageUrl]];
    }
    return self;
}

- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    self = [self initWithImageUrl:imageUrl target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventSelector callbackWithTarget:target action:completeSelector inMainThread:YES]];
        [self setFailureEvent:[MobilyEventSelector callbackWithTarget:target action:failureSelector inMainThread:YES]];
    }
    return self;
}

- (id)initWithImageUrl:(NSString*)imageUrl target:(id)target completeBlock:(MobilyImageLoaderCompleteBlock)completeBlock failureBlock:(MobilyImageLoaderFailureBlock)failureBlock {
    self = [self initWithImageUrl:imageUrl target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(completeBlock != nil) {
                completeBlock(_image, _imageUrl);
            }
            return nil;
        } inMainQueue:YES]];
        [self setFailureEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(failureBlock != nil) {
                failureBlock(_imageUrl);
            }
            return nil;
        } inMainQueue:YES]];
    }
    return self;
}

- (void)working {
    UIImage* image = [_imageLoader imageWithImageUrl:_imageUrl];
    if(image == nil) {
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        if(data != nil) {
            image = [UIImage imageWithData:data];
            if(image != nil) {
                [_imageLoader addImage:image byImageUrl:_cacheKey];
                [self setImage:image];
            }
        } else {
#if defined(MOBILY_DEBUG)
            NSLog(@"Failure load image:%@", _imageUrl);
#endif
            [self setNeedRework:YES];
        }
    } else {
        [self setImage:image];
    }
}

- (void)didComplete {
    if(_image != nil) {
        [_completeEvent fireSender:_image object:_imageUrl];
    } else {
        [_failureEvent fireSender:_imageUrl object:nil];
    }
}

@end

/*--------------------------------------------------*/
