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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyCore/MobilyBlurView.h>

/*--------------------------------------------------*/

@class MobilyBlurLayer;

/*--------------------------------------------------*/

@interface MobilyBlurView ()

@property(nonatomic, readwrite, strong) NSDate* lastUpdate;

- (CALayer*)underlyingLayer;
- (MobilyBlurLayer*)blurLayer;
- (MobilyBlurLayer*)blurPresentationLayer;

- (UIImage*)snapshotOfUnderlyingView;
- (BOOL)shouldUpdate;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyBlurScheduler : NSObject

@property(nonatomic, readwrite, assign) BOOL blurEnabled;
@property(nonatomic, readwrite, strong) NSMutableArray* blurViews;
@property(nonatomic, readwrite, assign) NSUInteger blurViewIndex;
@property(nonatomic, readwrite, assign) NSUInteger updatesEnabled;
@property(nonatomic, readwrite, assign) BOOL updating;

+ (instancetype)sharedInstance;

- (void)setBlurEnabled:(BOOL)blurEnabled;
- (void)setUpdatesEnabled;
- (void)setUpdatesDisabled;

- (void)addBlurView:(MobilyBlurView*)blurView;
- (void)removeBlurView:(MobilyBlurView*)blurView;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyBlurLayer: CALayer

@property(nonatomic, readwrite, assign) CGFloat blurRadius;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBlurView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

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
    _blurEnabled = YES;
    self.blurLayer.blurRadius = 20.0f;
    _blurIterations = 4;
    _dynamic = YES;
    _updateInterval = 0.1f;
    self.layer.magnificationFilter = @"linear";
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds unionWithArrays:self.subviews, nil];
    }
    return self.subviews;
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

#pragma mark Public static override

+ (Class)layerClass {
    return [MobilyBlurLayer class];
}

#pragma mark Public static

+ (void)setBlurEnabled:(BOOL)blurEnabled {
    MobilyBlurScheduler.sharedInstance.blurEnabled = blurEnabled;
}

+ (void)setUpdatesEnabled {
    [MobilyBlurScheduler.sharedInstance setUpdatesEnabled];
}

+ (void)setUpdatesDisabled {
    [MobilyBlurScheduler.sharedInstance setUpdatesDisabled];
}

#pragma mark Property public

- (void)setBlurEnabled:(BOOL)blurEnabled {
    if (_blurEnabled != blurEnabled) {
        _blurEnabled = blurEnabled;
        [self schedule];
        if(_blurEnabled == YES) {
            [self setNeedsDisplay];
        }
    }
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    self.blurLayer.blurRadius = blurRadius;
}

- (CGFloat)blurRadius {
    return self.blurLayer.blurRadius;
}

- (void)setBlurIterations:(NSUInteger)blurIterations {
    if(_blurIterations != blurIterations) {
        _blurIterations = blurIterations;
        [self setNeedsDisplay];
    }
}

- (void)setDynamic:(BOOL)dynamic {
    if (_dynamic != dynamic) {
        _dynamic = dynamic;
        [self schedule];
        if(dynamic == NO) {
            [self setNeedsDisplay];
        }
    }
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval {
    _updateInterval = updateInterval;
    if(_updateInterval <= FLT_EPSILON) {
        _updateInterval = 1.0f / 60.0f;
    }
}

- (UIView*)underlyingView {
    if(_underlyingView == nil) {
        return self.superview;
    }
    return _underlyingView;
}

#pragma mark Property private

- (CALayer*)underlyingLayer {
    return self.underlyingView.layer;
}

- (CALayer*)underlyingPresentationLayer {
    CALayer* underlyingLayer = self.underlyingLayer;
    CALayer* presentationLayer = underlyingLayer.presentationLayer;
    if(presentationLayer == nil) {
        return underlyingLayer;
    }
    return presentationLayer;
}

- (MobilyBlurLayer*)blurLayer {
    return (MobilyBlurLayer*)self.layer;
}

- (MobilyBlurLayer*)blurPresentationLayer {
    MobilyBlurLayer* blurLayer = self.blurLayer;
    MobilyBlurLayer* presentationLayer = (MobilyBlurLayer*)blurLayer.presentationLayer;
    if(presentationLayer == nil) {
        return blurLayer;
    }
    return presentationLayer;
}

#pragma mark Public override

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.layer setNeedsDisplay];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self schedule];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

#pragma mark Public

- (void)updateAsynchronously:(BOOL)async completion:(MobilySimpleBlock)completion {
    if([self shouldUpdate] == YES) {
        UIImage *snapshot = [self snapshotOfUnderlyingView];
        if(async == YES) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* blurredImage = [self blurredSnapshot:snapshot radius:self.blurRadius];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self setLayerContents:blurredImage];
                    if(completion) {
                        completion();
                    }
                });
            });
        } else {
            [self setLayerContents:[self blurredSnapshot:snapshot radius:self.blurPresentationLayer.blurRadius]];
            if(completion) {
                completion();
            }
        }
    } else if(completion) {
        completion();
    }
}

#pragma mark Private

- (void)schedule {
    if((self.window != nil) && (_blurEnabled == YES) && (_dynamic == YES)) {
        [MobilyBlurScheduler.sharedInstance addBlurView:self];
    } else {
        [MobilyBlurScheduler.sharedInstance removeBlurView:self];
    }
}

- (BOOL)shouldUpdate {
    if(_blurEnabled == NO) {
        return NO;
    }
    MobilyBlurLayer* blurLayer = self.blurPresentationLayer;
    if(CGRectIsEmpty(blurLayer.bounds) == YES) {
        return NO;
    }
    CALayer* underlyingLayer = self.underlyingLayer;
    if((underlyingLayer == nil) || (underlyingLayer.hidden == YES) || (CGRectIsEmpty(underlyingLayer.bounds) == YES)) {
        return NO;
    }
    return YES;
}

- (UIImage*)snapshotOfUnderlyingView {
    CALayer* blurLayer = self.blurLayer;
    MobilyBlurLayer* blurPresentationLayer = self.blurPresentationLayer;
    CALayer* underlyingLayer = self.underlyingLayer;
    CGRect bounds = [blurPresentationLayer convertRect:blurPresentationLayer.bounds toLayer:underlyingLayer];
    _lastUpdate = [NSDate date];
    CGFloat scale = 0.5f;
    if(_blurIterations > 0) {
        CGFloat blockSize = 12.0f / _blurIterations;
        scale = blockSize / MAX(blockSize * 2.0f, blurPresentationLayer.blurRadius);
        scale = 1.0f / floorf(1.0f / scale);
    }
    CGSize size = bounds.size;
    switch(self.contentMode) {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeScaleAspectFill:
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeRedraw: {
            size.width = floorf(size.width * scale) / scale;
            size.height = floorf(size.height * scale) / scale;
            break;
        }
        default: {
            scale = 1.0f;
            break;
        }
    }
    while((blurLayer.superlayer != nil) && (blurLayer.superlayer != underlyingLayer)) {
        blurLayer = blurLayer.superlayer;
    }
    NSMutableArray* hiddenLayers = [NSMutableArray array];
    NSArray* underlyingSublayers = underlyingLayer.sublayers;
    NSUInteger index = [underlyingSublayers indexOfObject:blurLayer];
    if(index != NSNotFound) {
        for(NSUInteger i = index; i < underlyingSublayers.count; i++) {
            CALayer *layer = underlyingSublayers[i];
            if(layer.hidden == NO) {
                layer.hidden = YES;
                [hiddenLayers addObject:layer];
            }
        }
    }
    UIImage* snapshot = nil;
    if(floorf(size.width) * floorf(size.height) > FLT_EPSILON) {
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, -bounds.origin.x, -bounds.origin.y);
        [underlyingLayer renderInContext:context];
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    for(CALayer* layer in hiddenLayers) {
        layer.hidden = NO;
    }
    return snapshot;
}

- (UIImage*)blurredSnapshot:(UIImage*)snapshot radius:(CGFloat)blurRadius {
    return [snapshot blurredImageWithRadius:blurRadius iterations:_blurIterations tintColor:self.tintColor];
}

- (void)setLayerContents:(UIImage*)image {
    self.layer.contents = (id)image.CGImage;
    self.layer.contentsScale = image.scale;
}

#pragma mark CALayerDelegate

- (void)displayLayer:(CALayer* __unused)layer {
    [self updateAsynchronously:NO completion:NULL];
}

- (id< CAAction >)actionForLayer:(CALayer*)layer forKey:(NSString*)key {
    if([key isEqualToString:@"blurRadius"] == YES) {
        CAAnimation *action = (CAAnimation*)[super actionForLayer:layer forKey:@"backgroundColor"];
        if((NSNull*)action != [NSNull null]) {
            CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:key];
            animation.fromValue = [layer.presentationLayer valueForKey:key];
            animation.beginTime = action.beginTime;
            animation.duration = action.duration;
            animation.speed = action.speed;
            animation.timeOffset = action.timeOffset;
            animation.repeatCount = action.repeatCount;
            animation.repeatDuration = action.repeatDuration;
            animation.autoreverses = action.autoreverses;
            animation.fillMode = action.fillMode;
            animation.timingFunction = action.timingFunction;
            animation.delegate = action.delegate;
            return animation;
        }
    }
    return [super actionForLayer:layer forKey:key];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBlurScheduler

#pragma mark Singleton

+ (instancetype)sharedInstance {
    static MobilyBlurScheduler *sharedInstance = nil;
    if(sharedInstance == nil) {
        sharedInstance = [[MobilyBlurScheduler alloc] init];
    }
    return sharedInstance;
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _blurEnabled = YES;
        _blurViews = [NSMutableArray array];
        _updatesEnabled = 1;
    }
    return self;
}

#pragma mark Public

- (void)setBlurEnabled:(BOOL)blurEnabled {
    if(_blurEnabled != blurEnabled) {
        _blurEnabled = blurEnabled;
        if(_blurEnabled == YES) {
            for(MobilyBlurView* blurView in _blurViews) {
                [blurView setNeedsDisplay];
            }
            [self updateAsynchronously];
        }
    }
}

- (void)setUpdatesEnabled {
    _updatesEnabled++;
    [self updateAsynchronously];
}

- (void)setUpdatesDisabled {
    _updatesEnabled--;
}

- (void)addBlurView:(MobilyBlurView*)blurView {
    if([_blurViews containsObject:blurView] == NO) {
        [_blurViews addObject:blurView];
        [self updateAsynchronously];
    }
}

- (void)removeBlurView:(MobilyBlurView*)blurView {
    NSUInteger index = [_blurViews indexOfObject:blurView];
    if(index != NSNotFound) {
        if(index <= _blurViewIndex) {
            _blurViewIndex--;
        }
        [_blurViews removeObjectAtIndex:index];
    }
}

- (void)updateAsynchronously {
    if((_blurEnabled == YES) && (_updatesEnabled > 0) && (_updating == NO)) {
        NSUInteger blurViewsCount = _blurViews.count;
        if(blurViewsCount > 0) {
            NSTimeInterval timeUntilNextUpdate = 1.0f / 60.0f;
            _blurViewIndex = _blurViewIndex % blurViewsCount;
            for(NSUInteger i = _blurViewIndex; i < blurViewsCount; i++) {
                MobilyBlurView* view = _blurViews[i];
                if((view.window != nil) && (view.hidden == NO) && (view.alpha >= 0.05f) && (view.dynamic == YES) && ([view shouldUpdate] == YES)) {
                    NSTimeInterval nextUpdate = [view.lastUpdate timeIntervalSinceNow] + view.updateInterval;
                    if((view.lastUpdate == nil) || (nextUpdate <= 0)) {
                        self.updating = YES;
                        [view updateAsynchronously:YES completion:^{
                            self.updating = NO;
                            _blurViewIndex = i + 1;
                            [self updateAsynchronously];
                        }];
                        return;
                    } else {
                        timeUntilNextUpdate = MIN(timeUntilNextUpdate, nextUpdate);
                    }
                }
            }
            _blurViewIndex = 0;
            [self performSelector:@selector(updateAsynchronously) withObject:nil afterDelay:timeUntilNextUpdate inModes:@[ NSDefaultRunLoopMode, UITrackingRunLoopMode ]];
        }
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyBlurLayer

+ (BOOL)needsDisplayForKey:(NSString*)key {
    if([key isEqualToString:@"blurRadius"] == YES) {
        return YES;
    } else if([key isEqualToString:@"bounds"] == YES) {
        return YES;
    } else if([key isEqualToString:@"position"] == YES) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end

/*--------------------------------------------------*/
