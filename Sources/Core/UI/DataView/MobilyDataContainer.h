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

typedef NS_OPTIONS(NSUInteger, MobilyDataContainerAlign) {
    MobilyDataContainerAlignNone = MobilyDataViewPositionNone,
    MobilyDataContainerAlignTop = MobilyDataViewPositionTop,
    MobilyDataContainerAlignCenteredVertically = MobilyDataViewPositionCenteredVertically,
    MobilyDataContainerAlignBottom = MobilyDataViewPositionBottom,
    MobilyDataContainerAlignLeft = MobilyDataViewPositionLeft,
    MobilyDataContainerAlignCenteredHorizontally = MobilyDataViewPositionCenteredHorizontally,
    MobilyDataContainerAlignRight = MobilyDataViewPositionRight,
    MobilyDataContainerAlignCentered = MobilyDataContainerAlignCenteredVertically | MobilyDataContainerAlignCenteredHorizontally,
};

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyDataContainer : NSObject< MobilyObject, MobilySearchBarDelegate >

@property(nonatomic, readonly, weak) MobilyDataView* view;
@property(nonatomic, readonly, weak) MobilyDataContainer* parent;
@property(nonatomic, readonly, assign) CGRect frame;
@property(nonatomic, readwrite, assign) BOOL allowAutoAlign;
@property(nonatomic, readwrite, assign) UIEdgeInsets alignInsets;
@property(nonatomic, readwrite, assign) MobilyDataContainerAlign alignPosition;
@property(nonatomic, readwrite, assign) UIOffset alignThreshold;

- (void)setup NS_REQUIRES_SUPER;

- (NSArray*)allItems;

- (MobilyDataItem*)itemForPoint:(CGPoint)point;
- (MobilyDataItem*)itemForData:(id)data;
- (MobilyDataCell*)cellForData:(id)data;

- (BOOL)containsEventForKey:(id)key;
- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key;

- (void)fireEventForKey:(id)key byObject:(id)object;
- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object;
- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object orDefault:(id)orDefault;
- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object;
- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object;
- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;
- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault;

- (CGPoint)alignPoint;
- (void)align;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSections : MobilyDataContainer

@property(nonatomic, readonly, strong) NSArray* sections;

- (void)prependSection:(MobilyDataContainer*)section;
- (void)appendSection:(MobilyDataContainer*)section;
- (void)insertSection:(MobilyDataContainer*)section atIndex:(NSUInteger)index;
- (void)replaceOriginSection:(MobilyDataContainer*)originSection withSection:(MobilyDataContainer*)section;
- (void)deleteSection:(MobilyDataContainer*)section;
- (void)deleteAllSections;

- (void)scrollToSection:(MobilyDataContainer*)section scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSectionsList : MobilyDataContainerSections

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readwrite, assign) BOOL pagingEnabled;
@property(nonatomic, readwrite, assign) NSUInteger currentSectionIndex;
@property(nonatomic, readwrite, strong) MobilyDataContainer* currentSection;

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation;

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation;

- (void)setCurrentSectionIndex:(NSUInteger)currentSectionIndex animated:(BOOL)animated;
- (void)setCurrentSection:(MobilyDataContainer*)currentSection animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataContainerCurrentSectionChanged;

/*--------------------------------------------------*/

@interface MobilyDataContainerItems : MobilyDataContainer

@property(nonatomic, readonly, strong) NSArray* entries;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsList : MobilyDataContainerItems

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readwrite, assign) CGSize defaultSize;
@property(nonatomic, readwrite, strong) MobilyDataItem* header;
@property(nonatomic, readwrite, strong) MobilyDataItem* footer;
@property(nonatomic, readonly, strong) NSArray* items;

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation;

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation;

- (void)prependIdentifier:(NSString*)identifier byData:(id)data;
- (void)prependItem:(MobilyDataItem*)item;
- (void)prependItems:(NSArray*)items;
- (void)appendIdentifier:(NSString*)identifier byData:(id)data;
- (void)appendItem:(MobilyDataItem*)item;
- (void)appendItems:(NSArray*)items;
- (void)insertIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index;
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
@property(nonatomic, readwrite, assign) CGSize defaultSize;
@property(nonatomic, readwrite, strong) MobilyDataItem* header;
@property(nonatomic, readwrite, strong) MobilyDataItem* footer;
@property(nonatomic, readonly, strong) NSArray* items;

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation;

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation;

- (void)prependIdentifier:(NSString*)identifier byData:(id)data;
- (void)prependItem:(MobilyDataItem*)item;
- (void)prependItems:(NSArray*)items;
- (void)appendIdentifier:(NSString*)identifier byData:(id)data;
- (void)appendItem:(MobilyDataItem*)item;
- (void)appendItems:(NSArray*)items;
- (void)insertIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index;
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
@property(nonatomic, readwrite, assign) CGSize defaultColumnSize;
@property(nonatomic, readwrite, assign) CGSize defaultRowSize;
@property(nonatomic, readonly, assign) NSUInteger numberOfColumns;
@property(nonatomic, readonly, assign) NSUInteger numberOfRows;
@property(nonatomic, readonly, strong) NSArray* headerColumns;
@property(nonatomic, readonly, strong) NSArray* footerColumns;
@property(nonatomic, readonly, strong) NSArray* headerRows;
@property(nonatomic, readonly, strong) NSArray* footerRows;
@property(nonatomic, readonly, strong) MobilyGrid* content;

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation;

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation;

- (void)prependColumnIdentifier:(NSString*)identifier byData:(id)data;
- (void)prependColumn:(MobilyDataItem*)column;
- (void)prependColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData;
- (void)prependColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData;
- (void)prependColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)columnFooter;
- (void)appendColumnIdentifier:(NSString*)identifier byData:(id)data;
- (void)appendColumn:(MobilyDataItem*)column;
- (void)appendColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData;
- (void)appendColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData;
- (void)appendColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)columnFooter;
- (void)insertColumnIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index;
- (void)insertColumn:(MobilyDataItem*)column atIndex:(NSUInteger)index;
- (void)insertColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData atIndex:(NSUInteger)index;
- (void)insertColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData atIndex:(NSUInteger)index;
- (void)insertColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)columnFooter atIndex:(NSUInteger)index;
- (void)deleteColumn:(MobilyDataItem*)column;
- (void)deleteAllColumns;

- (void)prependRowIdentifier:(NSString*)identifier byData:(id)data;
- (void)prependRow:(MobilyDataItem*)row;
- (void)prependRowIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData;
- (void)prependRowHeaderIdentifier:(NSString*)rowIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData;
- (void)prependRowHeader:(MobilyDataItem*)rowHeader andRowFooter:(MobilyDataItem*)rowFooter;
- (void)appendRowIdentifier:(NSString*)identifier byData:(id)data;
- (void)appendRow:(MobilyDataItem*)row;
- (void)appendRowIdentifier:(NSString*)rowIdentifier byHeaderData:(id)headerData byFooterData:(id)footerData;
- (void)appendRowHeaderIdentifier:(NSString*)rowIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData;
- (void)appendRowHeader:(MobilyDataItem*)rowHeader andRowFooter:(MobilyDataItem*)rowFooter;
- (void)insertRowIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index;
- (void)insertRow:(MobilyDataItem*)row atIndex:(NSUInteger)index;
- (void)insertRowIdentifier:(NSString*)rowIdentifier byHeaderData:(id)headerData byFooterData:(id)footerData atIndex:(NSUInteger)index;
- (void)insertRowHeaderIdentifier:(NSString*)rowIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData atIndex:(NSUInteger)index;
- (void)insertRowHeader:(MobilyDataItem*)rowHeader andRowFooter:(MobilyDataItem*)rowFooter atIndex:(NSUInteger)index;
- (void)deleteRow:(MobilyDataItem*)row;
- (void)deleteAllRows;

- (void)insertContentIdentifier:(NSString*)identifier byData:(id)data atColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)insertContent:(MobilyDataItem*)content atColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)deleteContentAtColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)deleteAllContent;

@end

/*--------------------------------------------------*/

@class MobilyDataItemCalendarMonth;
@class MobilyDataItemCalendarWeekday;
@class MobilyDataItemCalendarDay;

/*--------------------------------------------------*/

@interface MobilyDataContainerCalendar : MobilyDataContainerItems

@property(nonatomic, readonly, strong) NSCalendar* calendar;
@property(nonatomic, readonly, strong) NSDate* beginDate;
@property(nonatomic, readonly, strong) NSDate* endDate;
@property(nonatomic, readonly, strong) NSDate* displayBeginDate;
@property(nonatomic, readonly, strong) NSDate* displayEndDate;

@property(nonatomic, readwrite, assign) BOOL canShowMonth;
@property(nonatomic, readwrite, assign) BOOL canSelectMonth;
@property(nonatomic, readwrite, assign) UIEdgeInsets monthMargin;
@property(nonatomic, readwrite, assign) CGFloat monthHeight;
@property(nonatomic, readwrite, assign) CGFloat monthSpacing;

@property(nonatomic, readwrite, assign) BOOL canShowWeekdays;
@property(nonatomic, readwrite, assign) BOOL canSelectWeekdays;
@property(nonatomic, readwrite, assign) UIEdgeInsets weekdaysMargin;
@property(nonatomic, readwrite, assign) CGFloat weekdaysHeight;
@property(nonatomic, readwrite, assign) UIOffset weekdaysSpacing;

@property(nonatomic, readwrite, assign) BOOL canShowDays;
@property(nonatomic, readwrite, assign) BOOL canSelectDays;
@property(nonatomic, readwrite, assign) BOOL canSelectPreviousDays;
@property(nonatomic, readwrite, assign) BOOL canSelectNextDays;
@property(nonatomic, readwrite, assign) UIEdgeInsets daysMargin;
@property(nonatomic, readwrite, assign) CGFloat daysHeight;
@property(nonatomic, readwrite, assign) UIOffset daysSpacing;

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar;

- (instancetype)initWithCalendar:(NSCalendar*)calendar;

- (MobilyDataItemCalendarWeekday*)weekdayItemForDate:(NSDate*)date;
- (MobilyDataItemCalendarDay*)dayItemForDate:(NSDate*)date;

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
- (void)replaceDate:(NSDate*)date data:(id)data;
- (void)cleanup;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerCalendarDays : MobilyDataContainerItems

@property(nonatomic, readonly, strong) NSCalendar* calendar;

@property(nonatomic, readwrite, assign) MobilyDataContainerOrientation orientation;
@property(nonatomic, readwrite, assign) UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) UIOffset spacing;
@property(nonatomic, readwrite, assign) CGSize defaultSize;
@property(nonatomic, readonly, strong) NSArray* days;

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar orientation:(MobilyDataContainerOrientation)orientation;

- (instancetype)initWithCalendar:(NSCalendar*)calendar orientation:(MobilyDataContainerOrientation)orientation;

- (MobilyDataItemCalendarDay*)dayItemForDate:(NSDate*)date;
- (MobilyDataItemCalendarDay*)nearestDayItemForDate:(NSDate*)date;

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate interval:(NSTimeInterval)interval data:(id)data;
- (void)prependToDate:(NSDate*)date interval:(NSTimeInterval)interval data:(id)data;
- (void)prependDate:(NSDate*)date data:(id)data;
- (void)appendToDate:(NSDate*)date interval:(NSTimeInterval)interval data:(id)data;
- (void)appendDate:(NSDate*)date data:(id)data;
- (void)insertDate:(NSDate*)date data:(id)data atIndex:(NSUInteger)index;
- (void)replaceDate:(NSDate*)date data:(id)data;
- (void)deleteBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
- (void)deleteDate:(NSDate*)date;
- (void)deleteAllDates;

- (void)scrollToDate:(NSDate*)date scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataContainerCalendarMonthIdentifier;
extern NSString* MobilyDataContainerCalendarWeekdayIdentifier;
extern NSString* MobilyDataContainerCalendarDayIdentifier;

/*--------------------------------------------------*/
