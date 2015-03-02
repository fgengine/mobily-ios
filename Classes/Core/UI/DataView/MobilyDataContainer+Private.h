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

#import "MobilyDataContainer.h"
#import "MobilyDataItem+Private.h"
#import "MobilyGrid.h"
#import "MobilyMap.h"

/*--------------------------------------------------*/

@interface MobilyDataContainer () {
@protected
    __weak MobilyDataView* _view;
    __weak MobilyDataContainer* _parent;
}

@property(nonatomic, readwrite, weak) MobilyDataView* view;
@property(nonatomic, readwrite, weak) MobilyDataContainer* parent;

- (void)_willChangeView;
- (void)_didChangeView;
- (void)_willChangeParent;
- (void)_didChangeParent;

- (void)_didBeginUpdate;
- (void)_didEndUpdate;

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame;
- (void)_willLayoutForBounds:(CGRect)bounds;
- (void)_didLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSections () {
@protected
    NSMutableArray* _sections;
    CGRect _sectionsFrame;
}

- (CGRect)_validateSectionsForAvailableFrame:(CGRect)frame;
- (void)_willSectionsLayoutForBounds:(CGRect)bounds;
- (void)_didSectionsLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerSectionsList () {
    MobilyDataContainerOrientation _orientation;
    UIEdgeInsets _margin;
    UIOffset _spacing;
}

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItems () {
@protected
    NSMutableArray* _entries;
    CGRect _entriesFrame;
}

- (void)_prependEntry:(MobilyDataItem*)entry;
- (void)_prependEntries:(NSArray*)entries;
- (void)_appendEntry:(MobilyDataItem*)entry;
- (void)_appendEntries:(NSArray*)entries;
- (void)_insertEntry:(MobilyDataItem*)entry atIndex:(NSUInteger)index;
- (void)_insertEntries:(NSArray*)entries atIndex:(NSUInteger)index;
- (void)_replaceOriginEntry:(MobilyDataItem*)originEntry withEntry:(MobilyDataItem*)entry;
- (void)_replaceOriginEntries:(NSArray*)originEntries withEntries:(NSArray*)entries;
- (void)_deleteEntry:(MobilyDataItem*)entry;
- (void)_deleteEntries:(NSArray*)entries;
- (void)_deleteAllEntries;

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame;
- (void)_willEntriesLayoutForBounds:(CGRect)bounds;
- (void)_didEntriesLayoutForBounds:(CGRect)bounds;

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsList () {
    MobilyDataContainerOrientation _orientation;
    UIEdgeInsets _margin;
    UIOffset _spacing;
    NSMutableArray* _items;
}

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerItemsFlow () {
    MobilyDataContainerOrientation _orientation;
    UIEdgeInsets _margin;
    UIOffset _spacing;
    NSMutableArray* _items;
}

@end

/*--------------------------------------------------*/

@interface MobilyDataContainerCalendar () {
@protected
    NSCalendar* _calendar;
    BOOL _canShowMonth;
    UIEdgeInsets _monthMargin;
    CGFloat _monthHeight;
    CGFloat _monthSpacing;
    BOOL _canShowWeekdays;
    UIEdgeInsets _weekdaysMargin;
    CGFloat _weekdaysHeight;
    UIOffset _weekdaysSpacing;
    BOOL _canShowDays;
    UIEdgeInsets _daysMargin;
    CGFloat _daysHeight;
    UIOffset _daysSpacing;
    NSDate* _beginDate;
    NSDate* _endDate;
    MobilyDataItemCalendarMonth* _monthItem;
    NSMutableArray* _weekdayItems;
    MobilyMutableGrid* _dayItems;
}

@property(nonatomic, readwrite, strong) NSCalendar* calendar;
@property(nonatomic, readwrite, strong) NSDate* beginDate;
@property(nonatomic, readwrite, strong) NSDate* endDate;
@property(nonatomic, readwrite, strong) MobilyDataItemCalendarMonth* monthItem;
@property(nonatomic, readwrite, strong) NSMutableArray* weekdayItems;
@property(nonatomic, readwrite, strong) MobilyMutableGrid* dayItems;

@end

/*--------------------------------------------------*/
