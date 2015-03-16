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

@implementation MobilyDataContainerCalendarDays

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize orientation = _orientation;
@synthesize margin = _margin;
@synthesize spacing = _spacing;

#pragma mark Init / Free

+ (instancetype)containerWithCalendar:(NSCalendar*)calendar orientation:(MobilyDataContainerOrientation)orientation {
    return [[self alloc] initWithCalendar:calendar orientation:orientation];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar orientation:(MobilyDataContainerOrientation)orientation {
    self = [super init];
    if(self != nil) {
        if(calendar != nil) {
            _calendar = calendar;
        }
        _orientation = orientation;
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _calendar = NSCalendar.currentCalendar;
    _orientation = MobilyDataContainerOrientationVertical;
    _margin = UIEdgeInsetsZero;
    _spacing = UIOffsetZero;
    _defaultSize = CGSizeMake(44.0f, 44.0f);
}

#pragma mark Property

- (void)setOrientation:(MobilyDataContainerOrientation)orientation {
    if(_orientation != orientation) {
        _orientation = orientation;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMargin:(UIEdgeInsets)margin {
    if(UIEdgeInsetsEqualToEdgeInsets(_margin, margin) == NO) {
        _margin = margin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setSpacing:(UIOffset)spacing {
    if(UIOffsetEqualToOffset(_spacing, spacing) == NO) {
        _spacing = spacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (NSArray*)days {
    return _entries;
}

#pragma mark Public

- (MobilyDataItemCalendarDay*)dayItemForDate:(NSDate*)date {
    for(MobilyDataItemCalendarDay* calendarDay in _entries) {
        if([date isEqualToDate:calendarDay.date] == YES) {
            return calendarDay;
        }
    }
    return nil;
}

- (MobilyDataItemCalendarDay*)nearestDayItemForDate:(NSDate*)date {
    MobilyDataItemCalendarDay* prevCalendarDay = nil;
    for(MobilyDataItemCalendarDay* calendarDay in _entries) {
        switch([date compare:calendarDay.date]) {
            case NSOrderedDescending: prevCalendarDay = calendarDay; break;
            case NSOrderedSame: return calendarDay;
            case NSOrderedAscending: if(prevCalendarDay != nil) { return prevCalendarDay; } break;
        }
    }
    return nil;
}

- (void)prepareBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate interval:(NSTimeInterval)interval data:(id)data {
    NSTimeInterval timeInterval = beginDate.timeIntervalSince1970;
    NSTimeInterval endTimeInterval = endDate.timeIntervalSince1970;
    while(endTimeInterval - timeInterval >= interval) {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        MobilyDataItemCalendarDay* calendarDay = [self dayItemForDate:date];
        if(calendarDay == nil) {
            [self appendDate:date data:data];
        }
        timeInterval += interval;
    }
    [_entries sortUsingComparator:^NSComparisonResult(MobilyDataItemCalendarDay* calendarDay1, MobilyDataItemCalendarDay* calendarDay2) {
        return [calendarDay1.date compare:calendarDay2.date];
    }];
}

- (void)prependToDate:(NSDate*)date interval:(NSTimeInterval)interval data:(id)data {
    [self prepareBeginDate:date endDate:(_entries.count > 0) ? [_entries.firstObject date] : [NSDate date] interval:interval data:data];
}

- (void)prependDate:(NSDate*)date data:(id)data {
    [self _prependEntry:[MobilyDataItemCalendarDay itemWithCalendar:_calendar date:date data:data]];
}

- (void)appendToDate:(NSDate*)date interval:(NSTimeInterval)interval data:(id)data {
    [self prepareBeginDate:(_entries.count > 0) ? [_entries.lastObject date] : [NSDate date] endDate:date interval:interval data:data];
}

- (void)appendDate:(NSDate*)date data:(id)data {
    [self _appendEntry:[MobilyDataItemCalendarDay itemWithCalendar:_calendar date:date data:data]];
}

- (void)insertDate:(NSDate*)date data:(id)data atIndex:(NSUInteger)index {
    [self _insertEntry:[MobilyDataItemCalendarDay itemWithCalendar:_calendar date:date data:data] atIndex:index];
}

- (void)replaceDate:(NSDate*)date data:(id)data {
    NSUInteger index = [_entries indexOfObjectPassingTest:^BOOL(MobilyDataItemCalendarDay* calendarDay, NSUInteger index, BOOL* stop) {
        return [calendarDay.date isEqualToDate:date];
    }];
    if(index != NSNotFound) {
        [self _replaceOriginEntry:_entries[index] withEntry:[MobilyDataItemCalendarDay itemWithCalendar:_calendar date:date data:data]];
    }
}

- (void)deleteBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    NSTimeInterval beginTimeInterval = beginDate.timeIntervalSince1970;
    NSTimeInterval endTimeInterval = endDate.timeIntervalSince1970;
    NSIndexSet* indexSet = [_entries indexesOfObjectsPassingTest:^BOOL(MobilyDataItemCalendarDay* calendarDay, NSUInteger index, BOOL* stop) {
        NSComparisonResult timeInterval = calendarDay.date.timeIntervalSince1970;
        if((timeInterval >= beginTimeInterval) || (timeInterval <= endTimeInterval)) {
            return YES;
        }
        return NO;
    }];
    if(indexSet.count > 0) {
        [self _deleteEntries:[_entries objectsAtIndexes:indexSet]];
    }
}

- (void)deleteDate:(NSDate*)date {
    NSUInteger index = [_entries indexOfObjectPassingTest:^BOOL(MobilyDataItemCalendarDay* calendarDay, NSUInteger index, BOOL* stop) {
        return [calendarDay.date isEqualToDate:date];
    }];
    if(index != NSNotFound) {
        [self _deleteEntry:_entries[index]];
    }
}

- (void)deleteAllDates {
    [self _deleteAllEntries];
}

- (void)scrollToDate:(NSDate*)date scrollPosition:(MobilyDataViewPosition)scrollPosition animated:(BOOL)animated {
    MobilyDataItem* calendarDay = [self nearestDayItemForDate:date];
    if(calendarDay != nil) {
        [_view scrollToItem:calendarDay scrollPosition:scrollPosition animated:animated];
    }
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGSize restriction = CGSizeMake(frame.size.width - (_margin.left + _margin.right), frame.size.height - (_margin.top + _margin.bottom));
    CGSize cumulative = CGSizeZero;
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            cumulative.width = restriction.width;
            for(MobilyDataItemCalendarDay* calendarDay in _entries) {
                CGSize entrySize = [calendarDay sizeForAvailableSize:CGSizeMake(restriction.width, (_defaultSize.height > 0) ? _defaultSize.height : FLT_MAX)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    calendarDay.updateFrame = CGRectMake(offset.x, offset.y + cumulative.height, restriction.width, entrySize.height);
                    cumulative.height += entrySize.height + _spacing.vertical;
                }
            }
            cumulative.height -= _spacing.vertical;
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            cumulative.height = restriction.height;
            for(MobilyDataItemCalendarDay* calendarDay in _entries) {
                CGSize entrySize = [calendarDay sizeForAvailableSize:CGSizeMake((_defaultSize.width > 0) ? _defaultSize.width : FLT_MAX, restriction.height)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    calendarDay.updateFrame = CGRectMake(offset.x + cumulative.width, offset.y, entrySize.width, restriction.height);
                    cumulative.width += entrySize.width + _spacing.horizontal;
                }
            }
            cumulative.width -= _spacing.horizontal;
            break;
        }
    }
    return CGRectMake(frame.origin.x, frame.origin.y, _margin.left + cumulative.width + _margin.right, _margin.top + cumulative.height + _margin.bottom);
}

@end

/*--------------------------------------------------*/
