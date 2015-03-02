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

#import "MobilyDataItem+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataItem

#pragma mark Synthesize

@synthesize view = _view;
@synthesize parent = _parent;
@synthesize identifier = _identifier;
@synthesize data = _data;
@synthesize cell = _cell;
@synthesize originFrame = _originFrame;
@synthesize updateFrame = _updateFrame;
@synthesize displayFrame = _displayFrame;
@synthesize zOrder = _zOrder;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsHighlighting = _allowsHighlighting;
@synthesize allowsEditing = _allowsEditing;
@synthesize selected = _selected;
@synthesize highlighted = _highlighted;
@synthesize editing = _editing;

#pragma mark Init / Free

+ (instancetype)dataItemWithIdentifier:(NSString*)identifier data:(id)data {
    return [[self alloc] initWithIdentifier:identifier data:data];
}

+ (NSArray*)dataItemsWithIdentifier:(NSString*)identifier dataArray:(NSArray*)dataArray {
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:dataArray.count];
    for(id data in dataArray) {
        [items addObject:[self dataItemWithIdentifier:identifier data:data]];
    }
    return items;
}

- (instancetype)initWithIdentifier:(NSString*)identifier data:(id)data {
    self = [super init];
    if(self != nil) {
        _identifier = identifier;
        _data = data;
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
                _cell.item = self;
                if(CGRectIsNull(_originFrame) == NO) {
                    _cell.frame = _originFrame;
                }
                _cell.zPosition = _zOrder;
                _cell.selected = _selected;
                _cell.highlighted = _highlighted;
            }];
            _cell.frame = self.frame;
        }
    }
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

- (void)setDisplayFrame:(CGRect)displayFrame {
    if(CGRectEqualToRect(_displayFrame, displayFrame) == NO) {
        _displayFrame = displayFrame;
        if((_cell != nil) && (CGRectIsNull(_displayFrame) == NO)) {
            _cell.frame = _displayFrame;
        }
    }
}

- (CGRect)displayFrame {
    if(CGRectIsNull(_displayFrame) == YES) {
        return _updateFrame;
    }
    return _displayFrame;
}

- (CGRect)frame {
    if(CGRectIsNull(_displayFrame) == NO) {
        return _displayFrame;
    } else if(CGRectIsNull(_updateFrame) == NO) {
        return _updateFrame;
    }
    return _originFrame;
}

- (void)setZOrder:(CGFloat)zOrder {
    if(_zOrder != zOrder) {
        _zOrder = zOrder;
        if(_cell != nil) {
            _cell.zPosition = zOrder;
        }
    }
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

- (id)fireEventForKey:(id)key byObject:(id)object {
    return [_view fireEventForKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:self byObject:object orDefault:orDefault];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_view fireEventForKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (void)didBeginUpdate {
}

- (void)didEndUpdate {
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
                if([_view isSelectedItem:self] == NO) {
                    [_view selectItem:self animated:animated];
                }
            } else {
                if([_view isSelectedItem:self] == YES) {
                    [_view deselectItem:self animated:animated];
                }
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
                if([_view isHighlightedItem:self] == NO) {
                    [_view highlightItem:self animated:animated];
                }
            } else {
                if([_view isHighlightedItem:self] == YES) {
                    [_view unhighlightItem:self animated:animated];
                }
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
                if([_view isEditingItem:self] == NO) {
                    [_view beganEditItem:self animated:animated];
                }
            } else {
                if([_view isEditingItem:self] == YES) {
                    [_view endedEditItem:self animated:animated];
                }
            }
        }
        if(_cell != nil) {
            [_cell setEditing:_editing animated:NO];
        }
    }
}

- (CGSize)sizeForAvailableSize:(CGSize)size {
    Class cellClass = [_view cellClassWithItem:self];
    if(cellClass != nil) {
        return [cellClass sizeForItem:_data availableSize:size];
    }
    return CGSizeZero;
}

- (void)appear {
    [_view _appearItem:self];
}

- (void)disappear {
    [_view _disappearItem:self];
}

- (void)validateLayoutForBounds:(CGRect)bounds {
    if(_cell == nil) {
        if(CGRectIntersectsRect(bounds, CGRectUnion(_originFrame, self.frame)) == YES) {
            [self appear];
        }
    } else {
        [_cell validateLayoutForBounds:bounds];
    }
}

- (void)invalidateLayoutForBounds:(CGRect)bounds {
    if(_cell != nil) {
        if(CGRectIntersectsRect(bounds, self.frame) == NO) {
            [self disappear];
        } else {
            [_cell invalidateLayoutForBounds:bounds];
        }
    }
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarMonth

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;

#pragma mark Init / Free

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate data:(id)data {
    return [[self alloc] initWithCalendar:calendar beginDate:beginDate endDate:endDate data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar beginDate:(NSDate*)beginDate endDate:(NSDate*)endDate data:(id)data {
    self = [super initWithIdentifier:MobilyDataCalendarMonthIdentifier data:data];
    if(self != nil) {
        _calendar = calendar;
        _beginDate = beginDate;
        _endDate = endDate;
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarWeekday

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize date = _date;

#pragma mark Init / Free

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithCalendar:calendar date:date data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataCalendarWeekdayIdentifier data:data];
    if(self != nil) {
        _calendar = calendar;
        _date = date;
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation MobilyDataItemCalendarDay

#pragma mark Synthesize

@synthesize calendar = _calendar;
@synthesize date = _date;

#pragma mark Init / Free

+ (instancetype)dataItemWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    return [[self alloc] initWithCalendar:calendar date:date data:data];
}

- (instancetype)initWithCalendar:(NSCalendar*)calendar date:(NSDate*)date data:(id)data {
    self = [super initWithIdentifier:MobilyDataCalendarDayIdentifier data:data];
    if(self != nil) {
        _calendar = calendar;
        _date = date;
    }
    return self;
}

@end

/*--------------------------------------------------*/
