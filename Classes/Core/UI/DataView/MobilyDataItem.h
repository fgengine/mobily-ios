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

#import "MobilyData.h"

/*--------------------------------------------------*/

@class MobilyDataView;
@class MobilyDataContainer;
@class MobilyDataCell;

/*--------------------------------------------------*/

@interface MobilyDataItem : NSObject< MobilyObject >

@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readonly, weak) MobilyDataContainer* parent;
@property(nonatomic, readonly, strong) NSString* identifier;
@property(nonatomic, readonly, strong) id data;
@property(nonatomic, readonly, strong) MobilyDataCell* cell;
@property(nonatomic, readwrite, assign) CGRect originFrame;
@property(nonatomic, readwrite, assign) CGRect updateFrame;
@property(nonatomic, readwrite, assign) CGRect displayFrame;
@property(nonatomic, readonly, assign) CGRect frame;
@property(nonatomic, readwrite, assign) CGFloat zOrder;
@property(nonatomic, readwrite, assign) BOOL allowsSelection;
@property(nonatomic, readwrite, assign) BOOL allowsHighlighting;
@property(nonatomic, readwrite, assign) BOOL allowsEditing;
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@property(nonatomic, readwrite, assign, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, readwrite, assign, getter=isEditing) BOOL editing;

+ (instancetype)dataItemWithIdentifier:(NSString*)identifier data:(id)data;
+ (NSArray*)dataItemsWithIdentifier:(NSString*)identifier dataArray:(NSArray*)dataArray;

- (instancetype)initWithIdentifier:(NSString*)identifier data:(id)data;

- (BOOL)containsEventForKey:(id)key;

- (id)fireEventForKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

- (void)didBeginUpdate;
- (void)didEndUpdate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (CGSize)sizeForAvailableSize:(CGSize)size;

- (void)appear;
- (void)disappear;
- (void)validateLayoutForBounds:(CGRect)bounds;
- (void)invalidateLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarMonth : MobilyDataItem

@property(nonatomic, readonly, weak) NSCalendar* calendar;
@property(nonatomic, readonly, strong) NSDate* beginDate;
@property(nonatomic, readonly, strong) NSDate* endDate;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarWeekday : MobilyDataItem

@property(nonatomic, readonly, weak) NSCalendar* calendar;
@property(nonatomic, readonly, strong) NSDate* date;

@end

/*--------------------------------------------------*/

@interface MobilyDataItemCalendarDay : MobilyDataItem

@property(nonatomic, readonly, weak) NSCalendar* calendar;
@property(nonatomic, readonly, strong) NSDate* date;

@end

/*--------------------------------------------------*/
