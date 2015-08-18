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

#import <MobilyCore/MobilyPageControl.h>

/*--------------------------------------------------*/

#define DEFAULT_INDICATOR_WIDTH 6.0f
#define DEFAULT_INDICATOR_MARGIN 10.0f
#define DEFAULT_MIN_HEIGHT 36.0f

#define DEFAULT_INDICATOR_WIDTH_LARGE 7.0f
#define DEFAULT_INDICATOR_MARGIN_LARGE 9.0f
#define DEFAULT_MIN_HEIGHT_LARGE 36.0f

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyPageControlImageType) {
	MobilyPageControlImageTypeNormal = 1,
	MobilyPageControlImageTypeCurrent,
	MobilyPageControlImageTypeMask
};

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyPageControl () {
@private
    NSInteger _displayedPage;
    CGFloat _measuredIndicatorWidth;
    CGFloat	_measuredIndicatorHeight;
    CGImageRef _pageImageMask;
}

@property(nonatomic, readonly, strong) NSMutableDictionary* pageNames;
@property(nonatomic, readonly, strong) NSMutableDictionary* pageImages;
@property(nonatomic, readonly, strong) NSMutableDictionary* currentPageImages;
@property(nonatomic, readonly, strong) NSMutableDictionary* pageImageMasks;
@property(nonatomic, readonly, strong) NSMutableDictionary* cgImageMasks;
@property(nonatomic, readwrite, strong) NSArray* pageRects;
@property(nonatomic, readwrite, strong) UIPageControl* accessibilityPageControl;

- (void)_setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer;

- (CGFloat)_leftOffset;
- (CGFloat)_topOffsetForHeight:(CGFloat)height rect:(CGRect)rect;
- (void)_setImage:(UIImage*)image forPage:(NSInteger)pageIndex type:(MobilyPageControlImageType)type;
- (id)_imageForPage:(NSInteger)pageIndex type:(MobilyPageControlImageType)type;
- (CGImageRef)_createMaskForImage:(UIImage*)image CF_RETURNS_RETAINED;
- (void)_updateMeasuredIndicatorSizeWithSize:(CGSize)size;
- (void)_updateMeasuredIndicatorSizes;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyPageControl

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize pageNames = _pageNames;
@synthesize pageImages = _pageImages;
@synthesize currentPageImages = _currentPageImages;
@synthesize pageImageMasks = _pageImageMasks;
@synthesize cgImageMasks = _cgImageMasks;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _numberOfPages = 0;
    _indicatorDiameter = 7.0f;
    _indicatorMargin = 14.0f;
    _minHeight = 36.0f;
    _alignment = MobilyPageControlAlignmentCenter;
    _verticalAlignment = MobilyPageControlVerticalAlignmentMiddle;
    _pageIndicatorTintColor = [UIColor colorWithWhite:0.8f alpha:0.5f];
    _currentPageIndicatorTintColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    _tapBehavior = MobilyPageControlTapBehaviorStep;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    self.accessibilityPageControl = [[UIPageControl alloc] init];
}

- (void)dealloc {
	if(_pageImageMask != nil) {
		CGImageRelease(_pageImageMask);
	}	
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andRemovingObject:objectChild];
        [self moRemoveSubview:(UIView*)objectChild];
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

#pragma mark Property

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter {
    if(_indicatorDiameter != indicatorDiameter) {
        _indicatorDiameter = indicatorDiameter;
        if(_minHeight < indicatorDiameter) {
            self.minHeight = indicatorDiameter;
        }
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin {
    if(_indicatorMargin != indicatorMargin) {
        _indicatorMargin = indicatorMargin;
        [self setNeedsDisplay];
    }
}

- (void)setMinHeight:(CGFloat)minHeight {
    if(minHeight < _indicatorDiameter) {
        minHeight = _indicatorDiameter;
    }
    if(_minHeight != minHeight) {
        _minHeight = minHeight;
        if([self respondsToSelector:@selector(invalidateIntrinsicContentSize)] == YES) {
            [self invalidateIntrinsicContentSize];
        }
        [self setNeedsLayout];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if(_numberOfPages != numberOfPages) {
        _numberOfPages = MAX(0, numberOfPages);
        self.accessibilityPageControl.numberOfPages = _numberOfPages;
        if([self respondsToSelector:@selector(invalidateIntrinsicContentSize)] == YES) {
            [self invalidateIntrinsicContentSize];
        }
        [self updateAccessibilityValue];
        [self setNeedsDisplay];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self _setCurrentPage:currentPage sendEvent:NO canDefer:NO];
}

- (void)setCurrentPageIndicatorImage:(UIImage*)currentPageIndicatorImage {
    if([currentPageIndicatorImage isEqual:_currentPageIndicatorImage] == NO) {
        _currentPageIndicatorImage = currentPageIndicatorImage;
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

- (void)setPageIndicatorImage:(UIImage*)pageIndicatorImage {
    if([pageIndicatorImage isEqual:_pageIndicatorImage] == NO) {
        _pageIndicatorImage = pageIndicatorImage;
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

- (void)setPageIndicatorMaskImage:(UIImage*)pageIndicatorMaskImage {
    if([pageIndicatorMaskImage isEqual:_pageIndicatorMaskImage] == NO) {
        _pageIndicatorMaskImage = pageIndicatorMaskImage;
        if(_pageImageMask != NULL) {
            CGImageRelease(_pageImageMask);
        }
        _pageImageMask = [self _createMaskForImage:_pageIndicatorMaskImage];
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

- (NSMutableDictionary*)pageNames {
    if(_pageNames == nil) {
        _pageNames = [[NSMutableDictionary alloc] init];
    }
    return _pageNames;
}

- (NSMutableDictionary*)pageImages {
    if(_pageImages == nil) {
        _pageImages = [[NSMutableDictionary alloc] init];
    }
    return _pageImages;
}

- (NSMutableDictionary*)currentPageImages {
    if(_currentPageImages == nil) {
        _currentPageImages = [[NSMutableDictionary alloc] init];
    }
    return _currentPageImages;
}

- (NSMutableDictionary*)pageImageMasks {
    if(_pageImageMasks == nil) {
        _pageImageMasks = [[NSMutableDictionary alloc] init];
    }
    return _pageImageMasks;
}

- (NSMutableDictionary*)cgImageMasks {
    if(_cgImageMasks == nil) {
        _cgImageMasks = [[NSMutableDictionary alloc] init];
    }
    return _cgImageMasks;
}

#pragma mark Public override

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self sizeForNumberOfPages:_numberOfPages];
    sizeThatFits.height = MAX(sizeThatFits.height, _minHeight);
    return sizeThatFits;
}

- (CGSize)intrinsicContentSize {
    if((_numberOfPages < 1) || ((_numberOfPages < 2) && (_hidesForSinglePage == YES))) {
        return CGSizeMake(UIViewNoIntrinsicMetric, 0.0f);
    }
    return CGSizeMake(UIViewNoIntrinsicMetric, MAX(_measuredIndicatorHeight, _minHeight));
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableArray* pageRects = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    if((_hidesForSinglePage == NO) && (_numberOfPages >= 2)) {
        CGFloat left = [self _leftOffset];
        CGFloat xOffset = left;
        CGFloat yOffset = 0.0f;
        UIColor *fillColor = nil;
        UIImage *image = nil;
        CGImageRef maskingImage = nil;
        CGSize maskSize = CGSizeZero;
        for(NSInteger i = 0; i < _numberOfPages; i++) {
            NSNumber* indexNumber = @(i);
            if(i == _displayedPage) {
                fillColor = _currentPageIndicatorTintColor ? _currentPageIndicatorTintColor : [UIColor whiteColor];
                image = _currentPageImages[indexNumber];
                if(image == nil) {
                    image = _currentPageIndicatorImage;
                }
            } else {
                fillColor = _pageIndicatorTintColor ? _pageIndicatorTintColor : [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
                image = _pageImages[indexNumber];
                if(image == nil) {
                    image = _pageIndicatorImage;
                }
            }
            if(image == nil) {
                maskingImage = (__bridge CGImageRef)_cgImageMasks[indexNumber];
                UIImage* originalImage = _pageImageMasks[indexNumber];
                maskSize = originalImage.size;
                if(maskingImage == nil) {
                    maskingImage = _pageImageMask;
                    maskSize = _pageIndicatorMaskImage.size;
                }
            }
            [fillColor set];
            CGRect indicatorRect;
            if(image != nil) {
                yOffset = [self _topOffsetForHeight:image.size.height rect:rect];
                CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - image.size.width) / 2.0f);
                [image drawAtPoint:CGPointMake(centeredXOffset, yOffset)];
                indicatorRect = CGRectMake(centeredXOffset, yOffset, image.size.width, image.size.height);
            } else if(maskingImage != nil) {
                yOffset = [self _topOffsetForHeight:maskSize.height rect:rect];
                CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - maskSize.width) / 2.0f);
                indicatorRect = CGRectMake(centeredXOffset, yOffset, maskSize.width, maskSize.height);
                CGContextDrawImage(context, indicatorRect, maskingImage);
            } else {
                yOffset = [self _topOffsetForHeight:_indicatorDiameter rect:rect];
                CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - _indicatorDiameter) / 2.0f);
                indicatorRect = CGRectMake(centeredXOffset, yOffset, _indicatorDiameter, _indicatorDiameter);
                CGContextFillEllipseInRect(context, indicatorRect);
            }
            [pageRects addObject:[NSValue valueWithCGRect:indicatorRect]];
            maskingImage = NULL;
            xOffset += _measuredIndicatorWidth + _indicatorMargin;
        }
        self.pageRects = pageRects;
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(MobilyPageControlTapBehaviorJump == self.tapBehavior) {
        __block NSInteger tappedIndicatorIndex = NSNotFound;
        [self.pageRects enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger index, BOOL *stop) {
            CGRect indicatorRect = [value CGRectValue];
            if(CGRectContainsPoint(indicatorRect, point)) {
                tappedIndicatorIndex = index;
                *stop = YES;
            }
        }];
        if(tappedIndicatorIndex != NSNotFound) {
            [self _setCurrentPage:tappedIndicatorIndex sendEvent:YES canDefer:YES];
            return;
        }
    }
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = [self _leftOffset];
    CGFloat middle = left + (size.width / 2.0f);
    if(point.x < middle) {
        [self _setCurrentPage:self.currentPage - 1 sendEvent:YES canDefer:YES];
    } else {
        [self _setCurrentPage:self.currentPage + 1 sendEvent:YES canDefer:YES];
    }
}

#pragma mark Private

- (void)_setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer {
    currentPage = MIN(MAX(0, currentPage), _numberOfPages - 1);
    if(_currentPage != currentPage) {
        _currentPage = currentPage;
        self.accessibilityPageControl.currentPage = _currentPage;
        [self updateAccessibilityValue];
        if((self.defersCurrentPageDisplay == NO) || (defer == NO)) {
            _displayedPage = _currentPage;
            [self setNeedsDisplay];
        }
        if(sendEvent == YES) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (CGFloat)_leftOffset {
	CGRect rect = self.bounds;
	CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
	CGFloat left = 0.0f;
	switch(_alignment) {
		case MobilyPageControlAlignmentCenter: left = ceilf(CGRectGetMidX(rect) - (size.width / 2.0f)); break;
		case MobilyPageControlAlignmentRight: left = CGRectGetMaxX(rect) - size.width; break;
		default: break;
	}
	return left;
}

- (CGFloat)_topOffsetForHeight:(CGFloat)height rect:(CGRect)rect {
	CGFloat top = 0.0f;
	switch(_verticalAlignment) {
		case MobilyPageControlVerticalAlignmentMiddle: top = CGRectGetMidY(rect) - (height / 2.0f); break;
		case MobilyPageControlVerticalAlignmentBottom: top = CGRectGetMaxY(rect) - height; break;
		default: break;
	}
	return top;
}

- (void)_setImage:(UIImage*)image forPage:(NSInteger)pageIndex type:(MobilyPageControlImageType)type {
    if((pageIndex >= 0) && (pageIndex < _numberOfPages)) {
        NSMutableDictionary* dictionary = nil;
        switch(type) {
            case MobilyPageControlImageTypeCurrent: dictionary = self.currentPageImages; break;
            case MobilyPageControlImageTypeNormal: dictionary = self.pageImages; break;
            case MobilyPageControlImageTypeMask: dictionary = self.pageImageMasks; break;
            default: break;
        }
        if(image != nil) {
            dictionary[@(pageIndex)] = image;
        } else {
            [dictionary removeObjectForKey:@(pageIndex)];
        }
    }
}

- (id)_imageForPage:(NSInteger)pageIndex type:(MobilyPageControlImageType)type {
    if((pageIndex >= 0) && (pageIndex < _numberOfPages)) {
        NSDictionary* dictionary = nil;
        switch(type) {
            case MobilyPageControlImageTypeCurrent: dictionary = self.currentPageImages; break;
            case MobilyPageControlImageTypeNormal: dictionary = self.pageImages; break;
            case MobilyPageControlImageTypeMask: dictionary = self.pageImageMasks; break;
            default: break;
        }
        return dictionary[@(pageIndex)];
    }
    return nil;
}

- (CGImageRef)_createMaskForImage:(UIImage*)image CF_RETURNS_RETAINED {
    CGImageRef maskImage = NULL;
    size_t pixelsWide = image.size.width * image.scale;
    size_t pixelsHigh = image.size.height * image.scale;
    size_t bitmapBytesPerRow = (pixelsWide * 1);
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, CGImageGetBitsPerComponent(image.CGImage), bitmapBytesPerRow, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    if(context != nil) {
        CGContextTranslateCTM(context, 0.f, pixelsHigh);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, pixelsWide, pixelsHigh), image.CGImage);
        maskImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
    }
    return maskImage;
}

- (void)_updateMeasuredIndicatorSizeWithSize:(CGSize)size {
    _measuredIndicatorWidth = MAX(_measuredIndicatorWidth, size.width);
    _measuredIndicatorHeight = MAX(_measuredIndicatorHeight, size.height);
}

- (void)_updateMeasuredIndicatorSizes {
    _measuredIndicatorWidth = _indicatorDiameter;
    _measuredIndicatorHeight = _indicatorDiameter;
    if(((self.pageIndicatorImage != nil) || (self.pageIndicatorMaskImage != nil)) && (self.currentPageIndicatorImage != nil)) {
        _measuredIndicatorWidth = 0;
        _measuredIndicatorHeight = 0;
    }
    if(self.pageIndicatorImage != nil) {
        [self _updateMeasuredIndicatorSizeWithSize:self.pageIndicatorImage.size];
    }
    if(self.currentPageIndicatorImage != nil) {
        [self _updateMeasuredIndicatorSizeWithSize:self.currentPageIndicatorImage.size];
    }
    if(self.pageIndicatorMaskImage != nil) {
        [self _updateMeasuredIndicatorSizeWithSize:self.pageIndicatorMaskImage.size];
    }
    if([self respondsToSelector:@selector(invalidateIntrinsicContentSize)] == YES) {
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark Public

- (void)updateCurrentPageDisplay {
	_displayedPage = _currentPage;
	[self setNeedsDisplay];
}

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex {
    if((pageIndex >= 0) && (pageIndex < _numberOfPages)) {
        CGFloat left = [self _leftOffset];
        CGSize size = [self sizeForNumberOfPages:pageIndex + 1];
        return CGRectMake(left + size.width - _measuredIndicatorWidth, 0, _measuredIndicatorWidth, _measuredIndicatorWidth);
    }
    return CGRectZero;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
	CGFloat marginSpace = MAX(0, pageCount - 1) * _indicatorMargin;
	CGFloat indicatorSpace = pageCount * _measuredIndicatorWidth;
	CGSize size = CGSizeMake(marginSpace + indicatorSpace, _measuredIndicatorHeight);
	return size;
}

- (void)setImage:(UIImage*)image forPage:(NSInteger)pageIndex {
    [self _setImage:image forPage:pageIndex type:MobilyPageControlImageTypeNormal];
	[self _updateMeasuredIndicatorSizes];
}

- (UIImage*)imageForPage:(NSInteger)pageIndex {
    return [self _imageForPage:pageIndex type:MobilyPageControlImageTypeNormal];
}

- (void)setCurrentImage:(UIImage*)image forPage:(NSInteger)pageIndex {
	[self _setImage:image forPage:pageIndex type:MobilyPageControlImageTypeCurrent];;
	[self _updateMeasuredIndicatorSizes];
}

- (UIImage*)currentImageForPage:(NSInteger)pageIndex {
    return [self _imageForPage:pageIndex type:MobilyPageControlImageTypeCurrent];
}

- (void)setImageMask:(UIImage*)image forPage:(NSInteger)pageIndex {
	[self _setImage:image forPage:pageIndex type:MobilyPageControlImageTypeMask];
	if(image != nil) {
        CGImageRef maskImage = [self _createMaskForImage:image];
        if(maskImage != nil) {
            self.cgImageMasks[@(pageIndex)] = (__bridge id)maskImage;
            CGImageRelease(maskImage);
            [self _updateMeasuredIndicatorSizeWithSize:image.size];
            [self setNeedsDisplay];
        }
    } else {
		[self.cgImageMasks removeObjectForKey:@(pageIndex)];
	}
}

- (UIImage*)imageMaskForPage:(NSInteger)pageIndex {
	return [self _imageForPage:pageIndex type:MobilyPageControlImageTypeMask];
}

- (void)setScrollViewContentOffsetForCurrentPage:(UIScrollView*)scrollView animated:(BOOL)animated {
    CGPoint offset = scrollView.contentOffset;
    offset.x = scrollView.bounds.size.width * _currentPage;
    [scrollView setContentOffset:offset animated:animated];
}

- (void)updatePageNumberForScrollView:(UIScrollView*)scrollView {
	self.currentPage = (int)floorf(scrollView.contentOffset.x / scrollView.bounds.size.width);
}

#pragma mark - UIAccessibility

- (void)setName:(NSString*)name forPage:(NSInteger)pageIndex {
    if((pageIndex >= 0) && (pageIndex < _numberOfPages)) {
        self.pageNames[@(pageIndex)] = name;
	}
}

- (NSString*)nameForPage:(NSInteger)pageIndex {
    if((pageIndex >= 0) && (pageIndex < _numberOfPages)) {
        return _pageNames[@(pageIndex)];
    }
    return nil;
}

- (void)updateAccessibilityValue {
	NSString* pageName = [self nameForPage:self.currentPage];
	NSString* accessibilityValue = self.accessibilityPageControl.accessibilityValue;
	if(pageName != nil) {
		self.accessibilityValue = [NSString stringWithFormat:@"%@ - %@", pageName, accessibilityValue];
	} else {
		self.accessibilityValue = accessibilityValue;
	}
}

@end

/*--------------------------------------------------*/
