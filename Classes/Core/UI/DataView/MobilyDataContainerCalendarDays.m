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

- (void)dealloc {
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

- (void)prependDate:(NSDate*)date data:(id)data {
    [self _prependEntry:[MobilyDataItemCalendarDay dataItemWithCalendar:_calendar date:date data:data]];
}

- (void)appendDate:(NSDate*)date data:(id)data {
    [self _appendEntry:[MobilyDataItemCalendarDay dataItemWithCalendar:_calendar date:date data:data]];
}

- (void)insertDate:(NSDate*)date data:(id)data atIndex:(NSUInteger)index {
    [self _insertEntry:[MobilyDataItemCalendarDay dataItemWithCalendar:_calendar date:date data:data] atIndex:index];
}

- (void)replaceDate:(NSDate*)date data:(id)data {
    NSUInteger index = [_entries indexOfObjectPassingTest:^BOOL(MobilyDataItemCalendarDay* item, NSUInteger index, BOOL* stop) {
        return [item.date isEqualToDate:date];
    }];
    if(index != NSNotFound) {
        [self _replaceOriginEntry:_entries[index] withEntry:[MobilyDataItemCalendarDay dataItemWithCalendar:_calendar date:date data:data]];
    }
}

- (void)deleteDate:(NSDate*)date {
    NSUInteger index = [_entries indexOfObjectPassingTest:^BOOL(MobilyDataItemCalendarDay* item, NSUInteger index, BOOL* stop) {
        return [item.date isEqualToDate:date];
    }];
    if(index != NSNotFound) {
        [self _deleteEntry:_entries[index]];
    }
}

- (void)deleteAllDates {
    [self _deleteAllEntries];
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGSize restriction = CGSizeMake(frame.size.width - (_margin.left + _margin.right), frame.size.height - (_margin.top + _margin.bottom));
    CGSize cumulative = CGSizeZero;
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            cumulative.width = restriction.width;
            for(MobilyDataItem* entry in _entries) {
                CGSize entrySize = [entry sizeForAvailableSize:CGSizeMake(restriction.width, (_defaultSize.height > 0) ? _defaultSize.height : FLT_MAX)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    entry.updateFrame = CGRectMake(offset.x, offset.y + cumulative.height, restriction.width, entrySize.height);
                    cumulative.height += entrySize.height + _spacing.vertical;
                }
            }
            cumulative.height -= _spacing.vertical;
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            cumulative.height = restriction.height;
            for(MobilyDataItem* entry in _entries) {
                CGSize entrySize = [entry sizeForAvailableSize:CGSizeMake((_defaultSize.width > 0) ? _defaultSize.width : FLT_MAX, restriction.height)];
                if((entrySize.width >= 0.0f) && (entrySize.height >= 0.0f)) {
                    entry.updateFrame = CGRectMake(offset.x + cumulative.width, offset.y, entrySize.width, restriction.height);
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
