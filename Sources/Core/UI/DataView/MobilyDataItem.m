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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyDataItem+Private.h>

/*--------------------------------------------------*/

@implementation MobilyDataItem

#pragma mark Synthesize

@synthesize view = _view;
@synthesize parent = _parent;
@synthesize identifier = _identifier;
@synthesize data = _data;
@synthesize size = _size;
@synthesize needUpdateSize = _needUpdateSize;
@synthesize originFrame = _originFrame;
@synthesize updateFrame = _updateFrame;
@synthesize displayFrame = _displayFrame;
@synthesize order = _order;
@synthesize hidden = _hidden;
@synthesize allowsAlign = _allowsAlign;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsHighlighting = _allowsHighlighting;
@synthesize allowsEditing = _allowsEditing;
@synthesize selected = _selected;
@synthesize highlighted = _highlighted;
@synthesize editing = _editing;
@synthesize cell = _cell;

#pragma mark Init / Free

+ (instancetype)itemWithDataItem:(MobilyDataItem*)dataItem {
    return [[self alloc] initWithDataItem:dataItem];
}

+ (instancetype)itemWithIdentifier:(NSString*)identifier order:(NSUInteger)order data:(id)data {
    return [[self alloc] initWithIdentifier:identifier order:order data:data];
}

+ (NSArray*)dataItemsWithIdentifier:(NSString*)identifier order:(NSUInteger)order dataArray:(NSArray*)dataArray {
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:dataArray.count];
    for(id data in dataArray) {
        [items addObject:[self itemWithIdentifier:identifier order:order data:data]];
    }
    return items;
}

- (instancetype)initWithDataItem:(MobilyDataItem*)dataItem {
    self = [super init];
    if(self != nil) {
        _identifier = dataItem.identifier;
        _order = dataItem.order;
        _data = dataItem.data;
        _size = dataItem.size;
        _needUpdateSize = dataItem.needUpdateSize;
        _originFrame = dataItem.originFrame;
        _updateFrame = dataItem.updateFrame;
        _displayFrame = dataItem.displayFrame;
        _hidden = dataItem.hidden;
        _allowsSelection = dataItem.allowsSelection;
        _allowsHighlighting = dataItem.allowsHighlighting;
        _allowsEditing = dataItem.allowsEditing;
        _needUpdateSize = YES;
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString*)identifier order:(NSUInteger)order data:(id)data {
    self = [super init];
    if(self != nil) {
        _identifier = identifier;
        _order = order;
        _data = data;
        _size = CGSizeZero;
        _needUpdateSize = YES;
        _originFrame = CGRectNull;
        _updateFrame = CGRectNull;
        _displayFrame = CGRectNull;
        _allowsSelection = YES;
        _allowsHighlighting = YES;
        _allowsEditing = YES;
        
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
}

#pragma mark NSCopying

- (id)copy {
    return [self copyWithZone:NSDefaultMallocZone()];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[self.class allocWithZone:zone] initWithDataItem:self];
}

#pragma mark Property

- (void)setParent:(MobilyDataContainer*)parent {
    if(_parent != parent) {
        _parent = parent;
        if(_parent != nil) {
            self.view = parent.view;
        } else {
            self.view = nil;
        }
    }
}

- (void)setCell:(MobilyDataCell*)cell {
    if(_cell != cell) {
        if(_cell != nil) {
            [UIView performWithoutAnimation:^{
                _cell.item = nil;
            }];
        }
        _cell = cell;
        if(_cell != nil) {
            [UIView performWithoutAnimation:^{
                _cell.frame = self.frame;
                _cell.selected = _selected;
                _cell.highlighted = _highlighted;
                _cell.editing = _editing;
                _cell.item = self;
            }];
        }
    }
}

- (CGRect)originFrame {
    [_view validateLayoutIfNeed];
    return _originFrame;
}

- (void)setUpdateFrame:(CGRect)updateFrame {
    if(CGRectEqualToRect(_updateFrame, updateFrame) == NO) {
        _updateFrame = updateFrame;
        if(CGRectIsNull(_originFrame) == YES) {
            _originFrame = _updateFrame;
        }
        if((_cell != nil) && ((CGRectIsNull(_updateFrame) == NO) && (CGRectIsNull(_displayFrame) == YES))) {
            _cell.frame = _updateFrame;
        }
    }
}

- (CGRect)updateFrame {
    [_view validateLayoutIfNeed];
    return _updateFrame;
}

- (void)setDisplayFrame:(CGRect)displayFrame {
    if(CGRectEqualToRect(_displayFrame, displayFrame) == NO) {
        _displayFrame = displayFrame;
        if((_cell != nil) && (CGRectIsNull(_displayFrame) == NO)) {
            _cell.frame = _displayFrame;
        }
    }
}

- (CGRect)displayFrame {
    [_view validateLayoutIfNeed];
    if(CGRectIsNull(_displayFrame) == YES) {
        return _updateFrame;
    }
    return _displayFrame;
}

- (CGRect)frame {
    [_view validateLayoutIfNeed];
    if(CGRectIsNull(_displayFrame) == NO) {
        return _displayFrame;
    } else if(CGRectIsNull(_updateFrame) == NO) {
        return _updateFrame;
    }
    return _originFrame;
}

- (void)setHidden:(BOOL)hidden {
    if(_hidden != hidden) {
        _hidden = hidden;
        if(_hidden == NO) {
            [_view _didInsertItems:@[ self ]];
        } else {
            [_view _didDeleteItems:@[ self ]];
        }
    }
}

- (BOOL)isHiddenInHierarchy {
    if(_hidden == YES) {
        return YES;
    }
    return (_parent != nil) ? _parent.hiddenInHierarchy : NO;
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

#pragma mark Public

- (BOOL)containsEventForKey:(id)key {
    return [_view containsEventForKey:key];
}

- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key {
    return [_view containsEventForIdentifier:identifier forKey:key];
}

- (void)fireEventForKey:(id)key byObject:(id)object {
    [_view fireEventForIdentifier:_identifier forKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:_identifier forKey:key bySender:self byObject:object orDefault:orDefault];
}

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    [_view fireEventForIdentifier:_identifier forKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:_identifier forKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (void)didBeginUpdateAnimated:(BOOL __unused)animated {
}

- (void)didEndUpdateAnimated:(BOOL __unused)animated {
    self.originFrame = _updateFrame;
    if(_cell != nil) {
        _cell.frame = self.frame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(_selected != selected) {
        _selected = selected;
        if(_cell != nil) {
            if(_selected == YES) {
                [_view selectItem:self animated:animated];
            } else {
                [_view deselectItem:self animated:animated];
            }
        }
        if(_cell != nil) {
            [_cell setSelected:_selected animated:animated];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(_highlighted != highlighted) {
        _highlighted = highlighted;
        if(_cell != nil) {
            if(_highlighted == YES) {
                [_view highlightItem:self animated:animated];
            } else {
                [_view unhighlightItem:self animated:animated];
            }
        }
        if(_cell != nil) {
            [_cell setHighlighted:_highlighted animated:animated];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if(_editing != editing) {
        _editing = editing;
        if(_cell != nil) {
            if(_editing == YES) {
                [_view beganEditItem:self animated:animated];
            } else {
                [_view endedEditItem:self animated:animated];
            }
            [_cell setEditing:_editing animated:animated];
        }
    }
}

- (void)setNeedUpdateSize {
    if(_needUpdateSize == NO) {
        _needUpdateSize = YES;
        [_view setNeedValidateLayout];
    }
}

- (CGSize)sizeForAvailableSize:(CGSize)size {
    if(_needUpdateSize == YES) {
        _needUpdateSize = NO;
        
        Class cellClass = [_view cellClassWithItem:self];
        if(cellClass != nil) {
            _size = [cellClass sizeForItem:self availableSize:size];
        }
    }
    return _size;
}

- (void)setNeedUpdateCell {
    MobilyDataCell* cell = _cell;
    self.cell = nil;
    self.cell = cell;
}

- (void)appear {
    [_view _appearItem:self];
}

- (void)disappear {
    [_view _disappearItem:self];
}

- (void)validateLayoutForBounds:(CGRect)bounds {
    if(_cell == nil) {
        if((CGRectIntersectsRect(bounds, CGRectUnion(_originFrame, self.frame)) == YES) && (self.hiddenInHierarchy == NO)) {
            [self appear];
        }
    } else {
        [_cell validateLayoutForBounds:bounds];
    }
}

- (void)invalidateLayoutForBounds:(CGRect)bounds {
    if(_cell != nil) {
        if((CGRectIntersectsRect(bounds, self.frame) == NO) || (self.hiddenInHierarchy == YES)) {
            [self disappear];
        } else {
            [_cell invalidateLayoutForBounds:bounds];
        }
    }
}

#pragma mark MobilySearchBarDelegate

- (void)searchBarBeginSearch:(MobilySearchBar*)searchBar {
    [_cell searchBarBeginSearch:searchBar];
}

- (void)searchBarEndSearch:(MobilySearchBar*)searchBar {
    [_cell searchBarEndSearch:searchBar];
}

- (void)searchBarBeginEditing:(MobilySearchBar*)searchBar {
    [_cell searchBarBeginEditing:searchBar];
}

- (void)searchBar:(MobilySearchBar*)searchBar textChanged:(NSString*)textChanged {
    [_cell searchBar:searchBar textChanged:textChanged];
}

- (void)searchBarEndEditing:(MobilySearchBar*)searchBar {
    [_cell searchBarEndEditing:searchBar];
}

- (void)searchBarPressedClear:(MobilySearchBar*)searchBar {
    [_cell searchBarPressedClear:searchBar];
}

- (void)searchBarPressedReturn:(MobilySearchBar*)searchBar {
    [_cell searchBarPressedReturn:searchBar];
}

- (void)searchBarPressedCancel:(MobilySearchBar*)searchBar {
    [_cell searchBarPressedCancel:searchBar];
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendar

#pragma mark Synthesize

@synthesize calendar = _calendar;

#pragma mark Init / Free

- (instancetype)initWithIdentifier:(NSString*)identifier order:(NSUInteger)order calendar:(NSCalendar*)calendar data:(id)data {
    self = [super initWithIdentifier:identifier order:order data:data];
    if(self != nil) {
        _calendar = calendar;
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarMonth

#pragma mark Synthesize

@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;
@synthesize displayBeginDate = _displayBeginDate;
@synthesize displayEndDate = _displayEndDate;

#pragma mark Init / Free

+ (instancetype)itemWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate displayBeginDate:(NSDate*)displayBeginDate displayEndDate:(NSDate*)displayEndDate data:(id)data {
    return [[self alloc] initWithCalendar:calendar beginDate:beginDate endDate:endDate displayBeginDate:displayBeginDate displayEndDate:displayEndDate data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate displayBeginDate:(NSDate*)displayBeginDate displayEndDate:(NSDate*)displayEndDate data:(id)data {
    self = [super initWithIdentifier:MobilyDataContainerCalendarMonthIdentifier order:3 calendar:calendar data:data];
    if(self != nil) {
        _beginDate = beginDate;
        _endDate = endDate;
        _displayBeginDate = displayBeginDate;
        _displayEndDate = displayEndDate;
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarWeekday

#pragma mark Synthesize

@synthesize monthItem = _monthItem;
@synthesize date = _date;

#pragma mark Init / Free

+ (instancetype)itemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithCalendar:calendar date:date data:data];
}

+ (instancetype)itemWithMonthItem:(MobilyDataItemCalendarMonth*)monthItem date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithMonthItem:monthItem date:date data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataContainerCalendarWeekdayIdentifier order:2 calendar:calendar data:data];
    if(self != nil) {
        _date = date;
    }
    return self;
}

- (instancetype)initWithMonthItem:(MobilyDataItemCalendarMonth*)monthItem date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataContainerCalendarWeekdayIdentifier order:2 calendar:monthItem.calendar data:data];
    if(self != nil) {
        _monthItem = monthItem;
        _date = date;
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarDay

#pragma mark Synthesize

@synthesize monthItem = _monthItem;
@synthesize weekdayItem = _weekdayItem;
@synthesize date = _date;

#pragma mark Init / Free

+ (instancetype)itemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithCalendar:calendar date:date data:data];
}

+ (instancetype)itemWithWeekdayItem:(MobilyDataItemCalendarWeekday*)weekdayItem date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithWeekdayItem:weekdayItem date:date data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataContainerCalendarDayIdentifier order:1 calendar:calendar data:data];
    if(self != nil) {
        _date = date;
    }
    return self;
}

- (instancetype)initWithWeekdayItem:(MobilyDataItemCalendarWeekday*)weekdayItem date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataContainerCalendarDayIdentifier order:1 calendar:weekdayItem.calendar data:data];
    if(self != nil) {
        _monthItem = weekdayItem.monthItem;
        _weekdayItem = weekdayItem;
        _date = date;
    }
    return self;
}

@end

/*--------------------------------------------------*/
