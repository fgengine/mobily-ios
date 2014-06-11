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
@property(nonatomic, readwrite, strong) NSString* directory;

+ (MobilyImageLoader*)shared;

- (void)sync:(MobilyImageLoaderBlock)block;

- (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl;
- (UIImage*)imageWithImageUrl:(NSString*)imageUrl;
- (void)removeByImageUrl:(NSString*)imageUrl;
- (void)cleanup;

- (void)loadWithImageUrl:(NSString*)imageUrl size:(CGSize)size complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure;
- (NSString*)saveImage:(UIImage*)image;

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
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovedObject:objectChild]];
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
        _imageUrl = imageUrl;
        [super setImage:_defaultImage];
        
        CGSize size = CGSizeZero;
        if(_thumbnail == YES) {
            CGFloat scale = [[UIScreen mainScreen] scale];
            CGRect bounds = [self bounds];
            size.width = bounds.size.width * scale;
            size.height = bounds.size.height * scale;
        }
        [MobilyImageLoader loadWithImageUrl:_imageUrl
                                   size:size
                               complete:^(UIImage* image) {
                                   [self setImage:image];
                                   if(complete != nil) {
                                       complete(image);
                                   }
                               } failure:^{
                                   if(failure != nil) {
                                       failure();
                                   }
                               }];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static MobilyImageLoader* MOBILY_IMAGE_LOADER = nil;

/*--------------------------------------------------*/

#define FG_IMAGE_LOADER_FOLDER                      @"MobilyImageLoaderCache"
#define FG_IMAGE_LOADER_STEP                        64

/*--------------------------------------------------*/

@implementation MobilyImageLoader

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setTaskManager:[[MobilyTaskManager alloc] init]];
        if(_taskManager != nil) {
            [_taskManager setMaxConcurrentTask:5];
        }
        
        [self setDirectory:[[NSFileManager cachesDirectory] stringByAppendingPathComponent:FG_IMAGE_LOADER_FOLDER]];
        if([[NSFileManager defaultManager] fileExistsAtPath:_directory] == NO) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return self;
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setDirectory:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

+ (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl {
    return [[self shared] isExistImageWithImageUrl:imageUrl];
}

+ (UIImage*)imageWithImageUrl:(NSString*)imageUrl {
    return [[self shared] imageWithImageUrl:imageUrl];
}

+ (void)removeByImageUrl:(NSString*)imageUrl {
    [[self shared] removeByImageUrl:imageUrl];
}

+ (void)cleanup {
    [[self shared] cleanup];
}

+ (void)loadWithImageUrl:(NSString*)imageUrl target:(id)target complete:(SEL)complete failure:(SEL)failure {
    [self loadWithImageUrl:imageUrl size:CGSizeZero target:target complete:complete failure:failure];
}

+ (void)loadWithImageUrl:(NSString*)imageUrl size:(CGSize)size target:(id)target complete:(SEL)complete failure:(SEL)failure {
    if([target respondsToSelector:complete] == YES) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[self shared] sync:^{
            [[self shared] loadWithImageUrl:imageUrl
                                       size:size
                                   complete:^(UIImage* image) {
                                       [target performSelector:complete withObject:image];
                                   }
                                    failure:^{
                                        if([target respondsToSelector:failure] == YES) {
                                            [target performSelector:failure];
                                        }
                                    }];
        }];
#pragma clang diagnostic pop
    }
}

+ (void)loadWithImageUrl:(NSString*)imageUrl complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure {
    [self loadWithImageUrl:imageUrl size:CGSizeZero complete:complete failure:nil];
}

+ (void)loadWithImageUrl:(NSString*)imageUrl size:(CGSize)size complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure {
    [[self shared] sync:^{
        [[self shared] loadWithImageUrl:imageUrl size:size complete:complete failure:nil];
    }];
}

+ (NSString*)saveImage:(UIImage*)image {
    return [[self shared] saveImage:image];
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

- (void)sync:(MobilyImageLoaderBlock)block {
    NSThread* currentThread = [NSThread currentThread];
    NSThread* mainThread = [NSThread mainThread];
    if(currentThread != mainThread) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

- (BOOL)isExistImageWithImageUrl:(NSString*)imageUrl {
    BOOL result = NO;
    
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([imageUrl length] > 0) {
        NSString* fileExt = [imageUrl pathExtension];
        NSString* fileName = [[imageUrl lowercaseString] stringByMD5];
        NSString* filePath = [[_directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:fileExt];
        result = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    }
    return result;
}

- (UIImage*)imageWithImageUrl:(NSString*)imageUrl {
    UIImage* image = nil;
    
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([imageUrl length] > 0) {
        NSString* fileExt = [imageUrl pathExtension];
        NSString* fileName = [[imageUrl lowercaseString] stringByMD5];
        NSString* filePath = [[_directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:fileExt];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
            NSData* imageData = [NSData dataWithContentsOfFile:filePath];
            if(imageData != nil) {
                image = [UIImage imageWithData:imageData];
            }
        }

    }
    return image;
}

- (void)removeByImageUrl:(NSString*)imageUrl {
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([imageUrl length] > 0) {
        NSString* fileExt = [imageUrl pathExtension];
        NSString* fileName = [[imageUrl lowercaseString] stringByMD5];
        NSString* filePath = [[_directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:fileExt];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        NSString* thumbnailDirectory = [_directory stringByAppendingPathComponent:fileName];
        if([[NSFileManager defaultManager] fileExistsAtPath:thumbnailDirectory] == YES) {
            [[NSFileManager defaultManager] removeItemAtPath:thumbnailDirectory error:nil];
        }
    }
}

- (void)cleanup {
    if([[NSFileManager defaultManager] fileExistsAtPath:_directory] == YES) {
        [[NSFileManager defaultManager] removeItemAtPath:_directory error:nil];
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:_directory] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (void)loadWithImageUrl:(NSString*)imageUrl size:(CGSize)size complete:(MobilyImageLoaderCompleteBlock)complete failure:(MobilyImageLoaderFailureBlock)failure {
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([imageUrl length] > 0) {
        UIImage* existsImage = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:imageUrl] == YES) {
            NSData* data = [NSData dataWithContentsOfFile:imageUrl];
            if(data != nil) {
                existsImage = [UIImage imageWithData:data];
            }
        }
        if(existsImage == nil) {
            CGFloat nearestWidth = FG_IMAGE_LOADER_STEP;
            while(nearestWidth < size.width) {
                nearestWidth += FG_IMAGE_LOADER_STEP;
            }
            CGFloat nearestHeight = FG_IMAGE_LOADER_STEP;
            while(nearestHeight < size.height) {
                nearestHeight += FG_IMAGE_LOADER_STEP;
            }
            CGSize nearestSize = CGSizeMake(nearestWidth, nearestHeight);
            NSString* fileExt = [imageUrl pathExtension];
            NSString* thumbnailName = [NSString stringWithFormat:@"%lux%lu", (unsigned long)nearestSize.width, (unsigned long)nearestSize.height];
            NSString* fileName = [[imageUrl lowercaseString] stringByMD5];
            NSString* filePath = [[_directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:fileExt];
            NSString* thumbnailDirectory = [_directory stringByAppendingPathComponent:fileName];
            NSString* thumbnailPath = [[thumbnailDirectory stringByAppendingPathComponent:thumbnailName] stringByAppendingPathExtension:fileExt];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) {
                if(CGSizeEqualToSize(size, CGSizeZero) == NO) {
                    if([[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath] == YES) {
                        NSData* data = [NSData dataWithContentsOfFile:thumbnailPath];
                        if(data != nil) {
                            existsImage = [UIImage imageWithData:data];
                        }
                    }
                } else {
                    NSData* data = [NSData dataWithContentsOfFile:filePath];
                    if(data != nil) {
                        existsImage = [UIImage imageWithData:data];
                    }
                }
            }
            if(existsImage == nil) {
                MobilyTask* task = [MobilyTask new];
                if(task != nil) {
                    [task setWorkingCallback:^BOOL(MobilyTask* task) {
                        BOOL result = NO;
                        UIImage* loadImage = nil;
                        if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
                            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                            if(data != nil) {
                                loadImage = [UIImage imageWithData:data];
                                if(loadImage != nil) {
                                    if([data writeToFile:filePath atomically:YES] == YES) {
                                        [task setObject:loadImage];
                                        result = YES;
                                    }
                                }
                            } else {
                                NSLog(@"Failure load image:%@", imageUrl);
                                result = YES;
                            }
                        } else {
                            loadImage = [UIImage imageWithContentsOfFile:filePath];
                            if(loadImage != nil) {
                                [task setObject:loadImage];
                                result = YES;
                            }
                        }
                        return result;
                    }];
                    [task setCompleteCallback:^(MobilyTask* task) {
                        UIImage* resultImage = nil;
                        UIImage* loadImage = [task object];
                        if(CGSizeEqualToSize(size, CGSizeZero) == NO) {
                            if([[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath] == YES) {
                                NSData* data = [NSData dataWithContentsOfFile:thumbnailPath];
                                if(data != nil) {
                                    resultImage = [UIImage imageWithData:data];
                                }
                            } else {
                                BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:thumbnailDirectory];
                                if(folderExists == NO) {
                                    folderExists = [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
                                }
                                if(folderExists == YES) {
                                    resultImage = [self scaleImage:loadImage toSize:nearestSize];
                                    if(resultImage != nil) {
                                        NSData* data = UIImagePNGRepresentation(resultImage);
                                        if([data writeToFile:thumbnailPath atomically:YES] == NO) {
                                            resultImage = nil;
                                        }
                                    }
                                }
                            }
                        } else {
                            resultImage = loadImage;
                        }
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if(resultImage != nil) {
                                if(complete != nil) {
                                    complete(resultImage);
                                }
                            } else {
                                if(failure != nil) {
                                    failure();
                                }
                            }
                        });
                    }];
                    [_taskManager updating];
                    [_taskManager addTask:task];
                    [_taskManager updated];
                } else {
                    if(failure != nil) {
                        failure();
                    }
                }
            } else {
                if(complete != nil) {
                    complete(existsImage);
                }
            }
        } else {
            if(complete != nil) {
                complete(existsImage);
            }
        }
    } else {
        if(failure != nil) {
            failure();
        }
    }
}

- (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size {
    UIImage* result = nil;
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    if(colourSpace != NULL) {
        CGRect drawRect = CGRectAspectFitFromBoundsAndSize(CGRectMake(0.0f, 0.0f, size.width, size.height), [image size]);
        drawRect.size.width = floorf(drawRect.size.width);
        drawRect.size.height = floorf(drawRect.size.height);
        
        CGContextRef context = CGBitmapContextCreate(NULL, drawRect.size.width, drawRect.size.height, 8, drawRect.size.width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
        if(context != NULL) {
            CGContextClearRect(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height));
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, drawRect.size.width, drawRect.size.height), [image CGImage]);
            
            CGImageRef imageRef = CGBitmapContextCreateImage(context);
            if(imageRef != NULL) {
                result = [UIImage imageWithCGImage:imageRef scale:[image scale] orientation:[image imageOrientation]];
                CGImageRelease(imageRef);
            }
            CGContextRelease(context);
        }
        CGColorSpaceRelease(colourSpace);
    }
    return result;
}

- (NSString*)saveImage:(UIImage*)image {
    NSString* filePath = nil;
    while(true) {
        NSString* fileName = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)arc4random(), (unsigned long)[[NSDate date] timeIntervalSinceNow]];
        filePath = [_directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [fileName stringByMD5]]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
            NSData* data = UIImagePNGRepresentation(image);
            if([data writeToFile:filePath atomically:YES] == YES) {
                break;
            }
        }
    }
    return filePath;
}

@end

/*--------------------------------------------------*/
