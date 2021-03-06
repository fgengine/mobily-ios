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

#import <MobilyCore/MobilyData.h>

/*--------------------------------------------------*/

@class MobilyDataView;
@class MobilyDataContainer;
@class MobilyDataCell;

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDataItem : NSObject< MobilyObject, NSCopying, MobilySearchBarDelegate >

@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readonly, weak) MobilyDataContainer* parent;
@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, assign) NSUInteger order;
@property(nonatomic, readwrite, strong) id data;
@property(nonatomic, readwrite, assign) CGRect originFrame;
@property(nonatomic, readwrite, assign) CGRect updateFrame;
@property(nonatomic, readwrite, assign) CGRect displayFrame;
@property(nonatomic, readonly, assign) CGRect frame;
@property(nonatomic, readwrite, assign, getter=isHidden) BOOL hidden;
@property(nonatomic, readonly, assign, getter=isHiddenInHierarchy) BOOL hiddenInHierarchy;
@property(nonatomic, readwrite, assign) BOOL allowsAlign;
@property(nonatomic, readwrite, assign) BOOL allowsSelection;
@property(nonatomic, readwrite, assign) BOOL allowsHighlighting;
@property(nonatomic, readwrite, assign) BOOL allowsEditing;
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@property(nonatomic, readwrite, assign, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, readwrite, assign, getter=isEditing) BOOL editing;
@property(nonatomic, readonly, strong) MobilyDataCell* cell;

+ (instancetype)itemWithDataItem:(MobilyDataItem*)dataItem;
+ (instancetype)itemWithIdentifier:(NSString*)identifier order:(NSUInteger)order data:(id)data;
+ (NSArray*)dataItemsWithIdentifier:(NSString*)identifier order:(NSUInteger)order dataArray:(NSArray*)dataArray;

- (instancetype)initWithDataItem:(MobilyDataItem*)dataItem;
- (instancetype)initWithIdentifier:(NSString*)identifier order:(NSUInteger)order data:(id)data;

- (void)setup NS_REQUIRES_SUPER;

- (BOOL)containsEventForKey:(id)key;
- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key;

- (void)fireEventForKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

- (void)didBeginUpdateAnimated:(BOOL)animated;
- (void)didEndUpdateAnimated:(BOOL)animated;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated NS_REQUIRES_SUPER;

- (void)setNeedUpdateSize;
- (CGSize)sizeForAvailableSize:(CGSize)size;

- (void)setNeedUpdateCell;

- (void)appear;
- (void)disappear;
- (void)validateLayoutForBounds:(CGRect)bounds;
- (void)invalidateLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendar : MobilyDataItem

@property(nonatomic, readonly, weak) NSCalendar* calendar;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarMonth : MobilyDataItemCalendar

@property(nonatomic, readonly, strong) NSDate* beginDate;
@property(nonatomic, readonly, strong) NSDate* endDate;
@property(nonatomic, readonly, strong) NSDate* displayBeginDate;
@property(nonatomic, readonly, strong) NSDate* displayEndDate;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarWeekday : MobilyDataItemCalendar

@property(nonatomic, readonly, weak) MobilyDataItemCalendarMonth* monthItem;
@property(nonatomic, readonly, strong) NSDate* date;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarDay : MobilyDataItemCalendar

@property(nonatomic, readonly, weak) MobilyDataItemCalendarMonth* monthItem;
@property(nonatomic, readonly, weak) MobilyDataItemCalendarWeekday* weekdayItem;
@property(nonatomic, readonly, strong) NSDate* date;

@end

/*--------------------------------------------------*/
