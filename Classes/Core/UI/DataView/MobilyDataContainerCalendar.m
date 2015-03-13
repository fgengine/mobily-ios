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

#import "MobilyDataContainer+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataContainerCalendar

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize canShowMonth = _canShowMonth;
@synthesize monthMargin = _monthMargin;
@synthesize monthHeight = _monthHeight;
@synthesize monthSpacing = _monthSpacing;
@synthesize canShowWeekdays = _canShowWeekdays;
@synthesize weekdaysMargin = _weekdaysMargin;
@synthesize weekdaysHeight = _weekdaysHeight;
@synthesize weekdaysSpacing = _weekdaysSpacing;
@synthesize canShowDays = _canShowDays;
@synthesize daysMargin = _daysMargin;
@synthesize daysHeight = _daysHeight;
@synthesize daysSpacing = _daysSpacing;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;
@synthesize monthItem = _monthItem;
@synthesize weekdayItems = _weekdayItems;
@synthesize dayItems = _dayItems;


#pragma mark Init / Free

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar {
    return [[self alloc] initWithCalendar:calendar];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar {
    self = [super init];
    if(self != nil) {
        _calendar = calendar;
        _canShowMonth = YES;
        _monthMargin = UIEdgeInsetsZero;
        _monthHeight = 64.0f;
        _monthSpacing = 0.0f;
        _canShowWeekdays = YES;
        _weekdaysMargin = UIEdgeInsetsZero;
        _weekdaysHeight = 21.0f;
        _weekdaysSpacing = UIOffsetZero;
        _canShowDays = YES;
        _daysMargin = UIEdgeInsetsZero;
        _daysHeight = 44.0f;
        _daysSpacing = UIOffsetZero;
        _weekdayItems = NSMutableArray.array;
        _dayItems = MobilyMutableGrid.grid;
    }
    return self;
}

#pragma mark Property

- (void)setCanShowMonth:(BOOL)canShowMonth {
    if(_canShowMonth != canShowMonth) {
        _canShowMonth = canShowMonth;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMonthMargin:(UIEdgeInsets)monthMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_monthMargin, monthMargin) == NO) {
        _monthMargin = monthMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMonthHeight:(CGFloat)monthHeight {
    if(_monthHeight != monthHeight) {
        _monthHeight = monthHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMonthSpacing:(CGFloat)monthSpacing {
    if(_monthSpacing != monthSpacing) {
        _monthSpacing = monthSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanShowWeekdays:(BOOL)canShowWeekdays {
    if(_canShowWeekdays != canShowWeekdays) {
        _canShowWeekdays = canShowWeekdays;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setWeekdaysMargin:(UIEdgeInsets)weekdaysMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_weekdaysMargin, weekdaysMargin) == NO) {
        _weekdaysMargin = weekdaysMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setWeekdaysHeight:(CGFloat)weekdaysHeight {
    if(_weekdaysHeight != weekdaysHeight) {
        _weekdaysHeight = weekdaysHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setWeekdaysSpacing:(UIOffset)weekdaysSpacing {
    if(UIOffsetEqualToOffset(_weekdaysSpacing, weekdaysSpacing) == NO) {
        _weekdaysSpacing = weekdaysSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setCanShowDays:(BOOL)canShowDays {
    if(_canShowDays != canShowDays) {
        _canShowDays = canShowDays;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDaysMargin:(UIEdgeInsets)daysMargin {
    if(UIEdgeInsetsEqualToEdgeInsets(_daysMargin, daysMargin) == NO) {
        _daysMargin = daysMargin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDaysHeight:(CGFloat)daysHeight {
    if(_daysHeight != daysHeight) {
        _daysHeight = daysHeight;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDaysSpacing:(UIOffset)daysSpacing {
    if(UIOffsetEqualToOffset(_daysSpacing, daysSpacing) == NO) {
        _daysSpacing = daysSpacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (MobilyDataItemCalendarWeekday*)weekdayItemForDate:(NSDate*)date {
    NSDateComponents* dateComponents = [_calendar components:NSCalendarUnitWeekday fromDate:date];
    for(MobilyDataItemCalendarWeekday* weekdayItem in _weekdayItems) {
        NSDateComponents* weekdayComponents = [_calendar components:NSCalendarUnitWeekday fromDate:weekdayItem.date];
        if(weekdayComponents.weekday == dateComponents.weekday) {
            return weekdayItem;
        }
    }
    return nil;
}

- (MobilyDataItemCalendarDay*)dayItemForDate:(NSDate*)date {
    NSDate* beginDate = [date beginningOfDay];
    __block MobilyDataItemCalendarDay* result = nil;
    [_dayItems enumerateColumnsRowsUsingBlock:^(MobilyDataItemCalendarDay* dayItem, NSUInteger column, NSUInteger row, BOOL* stopColumn, BOOL* stopRow) {
        if([dayItem.date isEqualToDate:beginDate] == YES) {
            result = dayItem;
            *stopColumn = YES;
            *stopRow = YES;
        }
    }];
    return result;
}

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    NSDate* normalizedBeginDate = [beginDate beginningOfWeek];
    NSDate* normalizedEndDate = [endDate endOfWeek];
    if(([_beginDate isEqualToDate:normalizedBeginDate] == NO) || ([_endDate isEqualToDate:normalizedEndDate] == NO)) {
        _beginDate = normalizedBeginDate;
        _endDate = normalizedEndDate;
        
        if(_monthItem == nil) {
            _monthItem = [MobilyDataItemCalendarMonth itemWithCalendar:_calendar beginDate:_beginDate endDate:_endDate data:[NSNull null]];
            [self _appendEntry:_monthItem];
        }
        if(_weekdayItems.count < 7) {
            NSDate* weekdayDate = [_beginDate beginningOfWeek];
            for(NSUInteger weekdayIndex = 0; weekdayIndex < 7; weekdayIndex++) {
                MobilyDataItemCalendarWeekday* weekdayItem = [MobilyDataItemCalendarWeekday itemWithCalendar:_calendar date:weekdayDate data:[NSNull null]];
                [_weekdayItems addObject:weekdayItem];
                [self _appendEntry:weekdayItem];
                weekdayDate = [weekdayDate nextDay];
            }
        }
        NSDate* beginDayDate = [_beginDate beginningOfWeek];
        NSDate* endDayDate = [_endDate endOfWeek];
        NSInteger weekOfMonth = [beginDayDate weeksToDate:[endDayDate nextSecond]];
        if(weekOfMonth > 0) {
            [_dayItems setNumberOfColumns:7 numberOfRows:weekOfMonth];
            for(NSUInteger weekIndex = 0; weekIndex < weekOfMonth; weekIndex++) {
                for(NSUInteger weekdayIndex = 0; weekdayIndex < 7; weekdayIndex++) {
                    MobilyDataItemCalendarDay* dayItem = [_dayItems objectAtColumn:weekdayIndex atRow:weekIndex];
                    if(dayItem == nil) {
                        dayItem = [MobilyDataItemCalendarDay itemWithCalendar:_calendar date:beginDayDate data:[NSNull null]];
                        [_dayItems setObject:dayItem atColumn:weekdayIndex atRow:weekIndex];
                        [self _appendEntry:dayItem];
                    }
                    beginDayDate = [beginDayDate nextDay];
                }
            }
        }
    }
}

- (void)replaceDate:(NSDate*)date data:(id)data {
    __block NSUInteger foundColumn = NSNotFound, foundRow = NSNotFound;
    [_dayItems enumerateColumnsRowsUsingBlock:^(MobilyDataItemCalendarDay* day, NSUInteger column, NSUInteger row, BOOL* stopColumn, BOOL* stopRow) {
        if([day.date isEqualToDate:date] == YES) {
            foundColumn = column;
            foundRow = row;
            *stopColumn = YES;
            *stopRow = YES;
        }
    }];
    if((foundColumn != NSNotFound) && (foundRow != NSNotFound)) {
        MobilyDataItemCalendarDay* oldDayItem = [_dayItems objectAtColumn:foundColumn atRow:foundRow];
        MobilyDataItemCalendarDay* newDayItem = [MobilyDataItemCalendarDay itemWithCalendar:_calendar date:date data:data];
        [_dayItems setObject:newDayItem atColumn:foundColumn atRow:foundRow];
        [self _replaceOriginEntry:oldDayItem withEntry:newDayItem];
    }
}

- (void)cleanup {
    if(_monthItem != nil) {
        [self _deleteEntry:_monthItem];
        _monthItem = nil;
    }
    if(_weekdayItems.count > 0) {
        [self _deleteEntries:_weekdayItems];
        [_weekdayItems removeAllObjects];
    }
    if(_dayItems.count > 0) {
        [self _deleteEntries:_dayItems.objects];
        [_dayItems removeAllObjects];
    }
    _beginDate = nil;
    _endDate = nil;
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    BOOL canShowMonth = _canShowMonth;
    UIEdgeInsets monthMargin = (canShowMonth == YES) ? _monthMargin : UIEdgeInsetsZero;
    CGFloat monthHeight = (canShowMonth == YES) ? _monthHeight - (monthMargin.top + monthMargin.bottom) : 0.0f;
    CGFloat monthSpacing = (canShowMonth == YES) ? _monthSpacing : 0.0f;
    BOOL canShowWeekdays = _canShowWeekdays;
    UIEdgeInsets weekdaysMargin = (canShowWeekdays == YES) ? _weekdaysMargin : UIEdgeInsetsZero;
    CGFloat weekdaysHeight = (canShowWeekdays == YES) ? _weekdaysHeight - (weekdaysMargin.top + weekdaysMargin.bottom) : 0.0f;
    UIOffset weekdaysSpacing = (canShowWeekdays == YES) ? _weekdaysSpacing : UIOffsetZero;
    BOOL canShowDays = _canShowDays;
    UIEdgeInsets daysMargin = (canShowDays == YES) ? _daysMargin : UIEdgeInsetsZero;
    CGFloat daysHeight = (canShowDays == YES) ? _daysHeight - (daysMargin.top + daysMargin.bottom) : 0.0f;
    UIOffset daysSpacing = (canShowDays == YES) ? _daysSpacing : UIOffsetZero;
    CGFloat monthWidth = frame.size.width - (monthMargin.left + monthMargin.right);
    CGFloat availableWeekdaysWidth = monthWidth - (weekdaysMargin.left + weekdaysMargin.right) - (weekdaysSpacing.horizontal * 6);
    CGFloat defaultWeekdaysWidth = floor(availableWeekdaysWidth / 7);
    CGFloat lastWeekdaysWidth = availableWeekdaysWidth - (defaultWeekdaysWidth * 6);
    CGFloat availableDaysWidth = monthWidth - (daysMargin.left + daysMargin.right) - (daysSpacing.horizontal * 6);
    CGFloat defaultDaysWidth = floor(availableDaysWidth / 7);
    CGFloat lastDaysWidth = availableDaysWidth - (defaultDaysWidth * 6);
    __block CGPoint offset = CGPointMake(frame.origin.x + monthMargin.left, frame.origin.y + monthMargin.top);
    __block CGSize cumulative = CGSizeMake(monthWidth, 0.0f);
    if(canShowMonth == YES) {
        _monthItem.updateFrame = CGRectMake(offset.x, offset.y, monthWidth, monthHeight);
        cumulative.height += monthHeight;
        offset.y += monthHeight;
    }
    if(canShowWeekdays == YES) {
        NSUInteger lastIndex = _weekdayItems.count - 1;
        __block CGFloat weekdayOffset = offset.x + weekdaysMargin.left;
        cumulative.height += weekdaysMargin.top;
        offset.y += weekdaysMargin.top;
        [_weekdayItems eachWithIndex:^(MobilyDataItemCalendarWeekday* weekdayItem, NSUInteger index) {
            if(index != lastIndex) {
                weekdayItem.updateFrame = CGRectMake(weekdayOffset, offset.y, defaultWeekdaysWidth, weekdaysHeight);
                weekdayOffset += defaultWeekdaysWidth + weekdaysSpacing.horizontal;
            } else {
                weekdayItem.updateFrame = CGRectMake(weekdayOffset, offset.y, lastWeekdaysWidth, weekdaysHeight);
                cumulative.height += weekdaysHeight + weekdaysSpacing.vertical;
                offset.y += weekdaysHeight + weekdaysSpacing.vertical;
            }
        }];
        cumulative.height += weekdaysMargin.bottom - weekdaysSpacing.vertical;
        offset.y += weekdaysMargin.bottom - weekdaysSpacing.vertical;
    }
    if(canShowDays == YES) {
        NSUInteger lastColumn = _dayItems.numberOfColumns - 1;
        __block CGFloat dayOffset = offset.x + daysMargin.left;
        cumulative.height += daysMargin.top;
        offset.y += daysMargin.top;
        [_dayItems eachRowsColumns:^(MobilyDataItemCalendarDay* dayItem, NSUInteger column, NSUInteger row) {
            if(column != lastColumn) {
                dayItem.updateFrame = CGRectMake(dayOffset, offset.y, defaultDaysWidth, daysHeight);
                dayOffset += defaultDaysWidth + daysSpacing.horizontal;
            } else {
                dayItem.updateFrame = CGRectMake(dayOffset, offset.y, lastDaysWidth, daysHeight);
                cumulative.height += daysHeight + daysSpacing.vertical;
                offset.y += daysHeight + daysSpacing.vertical;
                dayOffset = offset.x + daysMargin.left;
            }
        }];
        cumulative.height += daysMargin.bottom - daysSpacing.vertical;
        offset.y += daysMargin.bottom - daysSpacing.vertical;
    }
    if(canShowMonth == YES) {
        cumulative.height += monthSpacing - monthSpacing;
    }
    return CGRectMake(frame.origin.x, frame.origin.y, monthMargin.left + cumulative.width + monthMargin.right, monthMargin.top + cumulative.height + monthMargin.bottom);
}

- (void)_willEntriesLayoutForBounds:(CGRect)bounds {
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataContainerCalendarMonthIdentifier = @"MobilyDataContainerCalendarMonthIdentifier";
NSString* MobilyDataContainerCalendarWeekdayIdentifier = @"MobilyDataContainerCalendarWeekdayIdentifier";
NSString* MobilyDataContainerCalendarDayIdentifier = @"MobilyDataContainerCalendarDayIdentifier";

/*--------------------------------------------------*/
