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

#import <MobilyData.h>

/*--------------------------------------------------*/

@class MobilyDataView;
@class MobilyDataItem;

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDataCell : UIView< MobilyObject, UIGestureRecognizerDelegate, MobilySearchBarDelegate >

@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readwrite, weak) MobilyDataItem* item;
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@property(nonatomic, readwrite, assign, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, readwrite, assign, getter=isEditing) BOOL editing;

@property(nonatomic, readonly, strong) UILongPressGestureRecognizer* pressGestureRecognizer;
@property(nonatomic, readonly, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property(nonatomic, readonly, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;

@property(nonatomic, readwrite, strong) IBOutlet UIView* rootView;
@property(nonatomic, readwrite, assign) UIOffset rootOffsetOfCenter;
@property(nonatomic, readwrite, assign) UIOffset rootMarginSize;

@property(nonatomic, readonly, strong) NSArray* orderedSubviews;

+ (CGSize)sizeForItem:(id)item availableSize:(CGSize)size;
+ (UILayoutPriority)fittingHorizontalPriority;
+ (UILayoutPriority)fittingVerticalPriority;

- (instancetype)initWithIdentifier:(NSString*)identifier;
- (instancetype)initWithIdentifier:(NSString*)identifier nib:(UINib*)nib;

- (void)setup NS_REQUIRES_SUPER;

- (void)prepareForUse;
- (void)prepareForUnuse;

- (BOOL)containsEventForKey:(id)key;
- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key;

- (void)fireEventForKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated NS_REQUIRES_SUPER;

- (void)validateLayoutForBounds:(CGRect)bounds;
- (void)invalidateLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataSwipeCellStyle) {
    MobilyDataSwipeCellStyleStands,
    MobilyDataSwipeCellStyleLeaves,
    MobilyDataSwipeCellStylePushes
};

/*--------------------------------------------------*/

@interface MobilyDataCellSwipe : MobilyDataCell

@property(nonatomic, readonly, strong) UIPanGestureRecognizer* panGestureRecognizer;

@property(nonatomic, readwrite, getter=isSwipeEnabled) BOOL swipeEnabled;
@property(nonatomic, readwrite, assign) IBInspectable MobilyDataSwipeCellStyle swipeStyle;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeThreshold;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeVelocity;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeSpeed;
@property(nonatomic, readonly, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readonly, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, assign, getter=isShowedLeftSwipeView) IBInspectable BOOL showedLeftSwipeView;
@property(nonatomic, readwrite, assign, getter=isLeftSwipeEnabled) IBInspectable BOOL leftSwipeEnabled;
@property(nonatomic, readwrite, strong) IBOutlet UIView* leftSwipeView;
@property(nonatomic, readwrite, assign) CGFloat leftSwipeOffset;
@property(nonatomic, readwrite, assign) CGFloat leftSwipeSize;

@property(nonatomic, readwrite, assign, getter=isShowedRightSwipeView) IBInspectable BOOL showedRightSwipeView;
@property(nonatomic, readwrite, assign, getter=isRightSwipeEnabled) IBInspectable BOOL rightSwipeEnabled;
@property(nonatomic, readwrite, strong) IBOutlet UIView* rightSwipeView;
@property(nonatomic, readwrite, assign) CGFloat rightSwipeOffset;
@property(nonatomic, readwrite, assign) CGFloat rightSwipeSize;

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated;
- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated;
- (void)hideAnySwipeViewAnimated:(BOOL)animated;

- (void)willBeganSwipe NS_REQUIRES_SUPER;
- (void)didBeganSwipe NS_REQUIRES_SUPER;
- (void)movingSwipe:(CGFloat)progress NS_REQUIRES_SUPER;
- (void)willEndedSwipe NS_REQUIRES_SUPER;
- (void)didEndedSwipe NS_REQUIRES_SUPER;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataCellPressed;
extern NSString* MobilyDataCellLongPressed;

/*--------------------------------------------------*/
