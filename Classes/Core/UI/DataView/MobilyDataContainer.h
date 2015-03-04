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
@class MobilyDataItem;
@class MobilyDataCell;

/*--------------------------------------------------*/

@class MobilyMap;
@class MobilyGrid;

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataContainerOrientation) {
    MobilyDataContainerOrientationVertical,
    MobilyDataContainerOrientationHorizontal,
};

/*--------------------------------------------------*/

@interface MobilyDataContainer : NSObject< MobilyObject >

@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readonly, weak) MobilyDataContainer* parent;

- (NSArray*)allItems;

- (id)itemForData:(id)data;
- (MobilyDataCell*)cellForData:(id)data;

- (BOOL)containsEventForKey:(id)key;

- (id)fireEventForKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSections : MobilyDataContainer

@property(nonatomic, readonly, strong) NSArray* sections;
@property(nonatomic, readonly, assign) CGRect sectionsFrame;

- (void)prependSection:(MobilyDataContainer*)section;
- (void)appendSection:(MobilyDataContainer*)section;
- (void)insertSection:(MobilyDataContainer*)section atIndex:(NSUInteger)index;
- (void)replaceOriginSection:(MobilyDataContainer*)originSection withSection:(MobilyDataContainer*)section;
- (void)deleteSection:(MobilyDataContainer*)section;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSectionsList : MobilyDataContainerSections

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItems : MobilyDataContainer

@property(nonatomic, readonly, strong) NSArray* entries;
@property(nonatomic, readonly, assign) CGRect entriesFrame;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsList : MobilyDataContainerItems

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readwrite, assign) MobilyDataItem* header;
@property(nonatomic, readwrite, assign) MobilyDataItem* footer;
@property(nonatomic, readonly, strong) NSArray* items;

- (void)prependItem:(MobilyDataItem*)item;
- (void)prependItems:(NSArray*)items;
- (void)appendItem:(MobilyDataItem*)item;
- (void)appendItems:(NSArray*)items;
- (void)insertItem:(MobilyDataItem*)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index;
- (void)replaceOriginItem:(MobilyDataItem*)originItem withItem:(MobilyDataItem*)item;
- (void)replaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;
- (void)deleteItem:(MobilyDataItem*)item;
- (void)deleteItems:(NSArray*)items;
- (void)deleteAllItems;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsFlow : MobilyDataContainerItems

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readwrite, assign) MobilyDataItem* header;
@property(nonatomic, readwrite, assign) MobilyDataItem* footer;
@property(nonatomic, readonly, strong) NSArray* items;

- (void)prependItem:(MobilyDataItem*)item;
- (void)prependItems:(NSArray*)items;
- (void)appendItem:(MobilyDataItem*)item;
- (void)appendItems:(NSArray*)items;
- (void)insertItem:(MobilyDataItem*)item atIndex:(NSUInteger)index;
- (void)insertItems:(NSArray*)items atIndex:(NSUInteger)index;
- (void)replaceOriginItem:(MobilyDataItem*)originItem withItem:(MobilyDataItem*)item;
- (void)replaceOriginItems:(NSArray*)originItems withItems:(NSArray*)items;
- (void)deleteItem:(MobilyDataItem*)item;
- (void)deleteItems:(NSArray*)items;
- (void)deleteAllItems;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsGrid : MobilyDataContainerItems

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readonly, assign) NSUInteger numberOfColumns;
@property(nonatomic, readonly, assign) NSUInteger numberOfRows;
@property(nonatomic, readonly, strong) NSArray* headerColumns;
@property(nonatomic, readonly, strong) NSArray* footerColumns;
@property(nonatomic, readonly, strong) NSArray* headerRows;
@property(nonatomic, readonly, strong) NSArray* footerRows;
@property(nonatomic, readonly, strong) MobilyGrid* cells;

- (void)prependColumn:(MobilyDataItem*)column;
- (void)prependHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn;
- (void)appendColumn:(MobilyDataItem*)column;
- (void)appendHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn;
- (void)insertColumn:(MobilyDataItem*)column atIndex:(NSUInteger)index;
- (void)insertHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn atIndex:(NSUInteger)index;
- (void)deleteColumn:(MobilyDataItem*)column;
- (void)deleteAllColumns;

- (void)prependRow:(MobilyDataItem*)row;
- (void)prependHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow;
- (void)appendRow:(MobilyDataItem*)row;
- (void)appendHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow;
- (void)insertRow:(MobilyDataItem*)row atIndex:(NSUInteger)index;
- (void)insertHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow atIndex:(NSUInteger)index;
- (void)deleteRow:(MobilyDataItem*)row;
- (void)deleteAllRows;

- (void)insertCell:(MobilyDataItem*)cell atColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)deleteAtColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)deleteAllCells;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerCalendar : MobilyDataContainerItems

@property(nonatomic, readonly, strong) NSCalendar* calendar;
@property(nonatomic, readonly, strong) NSDate* beginDate;
@property(nonatomic, readonly, strong) NSDate* endDate;

@property(nonatomic, readwrite, assign) BOOL canShowMonth;
@property(nonatomic, readwrite, assign) UIEdgeInsets monthMargin;
@property(nonatomic, readwrite, assign) CGFloat monthHeight;
@property(nonatomic, readwrite, assign) CGFloat monthSpacing;
@property(nonatomic, readwrite, assign) BOOL canSnapToEdgeMonth;

@property(nonatomic, readwrite, assign) BOOL canShowWeekdays;
@property(nonatomic, readwrite, assign) UIEdgeInsets weekdaysMargin;
@property(nonatomic, readwrite, assign) CGFloat weekdaysHeight;
@property(nonatomic, readwrite, assign) UIOffset weekdaysSpacing;
@property(nonatomic, readwrite, assign) BOOL canSnapToEdgeWeekdays;

@property(nonatomic, readwrite, assign) BOOL canShowDays;
@property(nonatomic, readwrite, assign) UIEdgeInsets daysMargin;
@property(nonatomic, readwrite, assign) CGFloat daysHeight;
@property(nonatomic, readwrite, assign) UIOffset daysSpacing;

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar;

- (instancetype)initWithCalendar:(NSCalendar*)calendar;

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
- (void)cleanup;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataCalendarMonthIdentifier;
extern NSString* MobilyDataCalendarWeekdayIdentifier;
extern NSString* MobilyDataCalendarDayIdentifier;

/*--------------------------------------------------*/
