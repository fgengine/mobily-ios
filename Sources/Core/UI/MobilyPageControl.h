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

#import <MobilyBuilder.h>

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyPageControlAlignment) {
	MobilyPageControlAlignmentLeft = 1,
	MobilyPageControlAlignmentCenter,
	MobilyPageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, MobilyPageControlVerticalAlignment) {
	MobilyPageControlVerticalAlignmentTop = 1,
	MobilyPageControlVerticalAlignmentMiddle,
	MobilyPageControlVerticalAlignmentBottom
};

typedef NS_ENUM(NSUInteger, MobilyPageControlTapBehavior) {
	MobilyPageControlTapBehaviorStep = 1,
	MobilyPageControlTapBehaviorJump
};

/*--------------------------------------------------*/

@interface MobilyPageControl : UIControl < MobilyBuilderObject >

@property(nonatomic, readwrite, assign) IBInspectable NSInteger numberOfPages;
@property(nonatomic, readwrite, assign) IBInspectable NSInteger currentPage;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat indicatorMargin;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat indicatorDiameter;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat minHeight;
@property(nonatomic, readwrite, assign) IBInspectable MobilyPageControlAlignment alignment;
@property(nonatomic, readwrite, assign) IBInspectable MobilyPageControlVerticalAlignment verticalAlignment;
@property(nonatomic, readwrite, strong) IBInspectable UIImage* pageIndicatorImage;
@property(nonatomic, readwrite, strong) IBInspectable UIImage* pageIndicatorMaskImage;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* pageIndicatorTintColor;
@property(nonatomic, readwrite, strong) IBInspectable UIImage* currentPageIndicatorImage;
@property(nonatomic, readwrite, strong) IBInspectable UIColor* currentPageIndicatorTintColor;
@property(nonatomic, readwrite, assign) IBInspectable BOOL hidesForSinglePage;
@property(nonatomic, readwrite, assign) IBInspectable BOOL defersCurrentPageDisplay;
@property(nonatomic, readwrite, assign) IBInspectable MobilyPageControlTapBehavior tapBehavior;

- (void)setup NS_REQUIRES_SUPER;

- (void)updateCurrentPageDisplay;

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

- (void)setImage:(UIImage*)image forPage:(NSInteger)pageIndex;
- (UIImage*)imageForPage:(NSInteger)pageIndex;

- (void)setCurrentImage:(UIImage*)image forPage:(NSInteger)pageIndex;
- (UIImage*)currentImageForPage:(NSInteger)pageIndex;

- (void)setImageMask:(UIImage*)image forPage:(NSInteger)pageIndex;
- (UIImage*)imageMaskForPage:(NSInteger)pageIndex;

- (void)setScrollViewContentOffsetForCurrentPage:(UIScrollView*)scrollView animated:(BOOL)animated;
- (void)updatePageNumberForScrollView:(UIScrollView*)scrollView;

- (void)setName:(NSString*)name forPage:(NSInteger)pageIndex;
- (NSString*)nameForPage:(NSInteger)pageIndex;

@end

/*--------------------------------------------------*/
