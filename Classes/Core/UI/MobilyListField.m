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

#import "MobilyListField.h"

/*--------------------------------------------------*/

@interface MobilyListField () < UIPickerViewDataSource, UIPickerViewDelegate >

@property(nonatomic, readwrite, strong) UIPickerView* pickerView;

@end

/*--------------------------------------------------*/

@implementation MobilyListField

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

#pragma mark Public

- (void)didBeginEditing {
    [super didBeginEditing];
    
    if(_pickerView == nil) {
        self.pickerView = [UIPickerView new];
        if(_pickerView != nil) {
            _pickerView.delegate = self;
        }
        self.inputView = _pickerView;
    }
    if(_pickerView != nil) {
        [_pickerView reloadAllComponents];
        if(_selectedItem != nil) {
            [_pickerView selectRow:[_items indexOfObject:_selectedItem] inComponent:0 animated:NO];
        }
    }
}

- (void)didEndEditing {
    [super didEndEditing];
    
    [self setSelectedItem:_items[[_pickerView selectedRowInComponent:0]] animated:YES emitted:YES];
}

#pragma mark Property

- (void)setItems:(NSArray*)items {
    if([_items isEqualToArray:items] == NO) {
        _items = items;
        
        if([self isEditing] == YES) {
            [_pickerView reloadAllComponents];
        }
        if((_selectedItem == nil) && (_items.count > 0)) {
            _selectedItem = _items[0];
            self.text = [_selectedItem title];
            if([self isEditing] == YES) {
                [_pickerView selectRow:[_items indexOfObject:_selectedItem] inComponent:0 animated:NO];
            }
        } else {
            self.text = @"";
        }
    }
}

- (void)setSelectedItem:(MobilyListFieldItem*)selectedItem {
    [self setSelectedItem:selectedItem animated:NO emitted:NO];
}

- (void)setSelectedItem:(MobilyListFieldItem*)selectedItem animated:(BOOL)animated {
    [self setSelectedItem:selectedItem animated:animated emitted:NO];
}

#pragma mark Private

- (void)setSelectedItem:(MobilyListFieldItem*)selectedItem animated:(BOOL)animated emitted:(BOOL)emitted {
    if(_selectedItem != selectedItem) {
        _selectedItem = selectedItem;
        
        if(_selectedItem != nil) {
            self.text = [_selectedItem title];
        } else {
            self.text = @"";
        }
        if([self isEditing] == YES) {
            [_pickerView selectRow:[_items indexOfObject:_selectedItem] inComponent:0 animated:animated];
        }
        if(emitted == YES) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView* __unused)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView* __unused)pickerView numberOfRowsInComponent:(NSInteger __unused)component {
    return _items.count;
}

#pragma mark UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView* __unused)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger __unused)component {
    return [_items[row] title];
}

- (NSAttributedString*)pickerView:(UIPickerView* __unused)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger __unused)component {
    MobilyListFieldItem* listItem = _items[row];
    return [[NSAttributedString alloc] initWithString:[listItem title] attributes:@{
        NSFontAttributeName : [listItem font],
        NSForegroundColorAttributeName: [listItem color]
    }];
}

- (void)pickerView:(UIPickerView* __unused)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger __unused)component {
    [self setSelectedItem:_items[row] animated:YES emitted:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyListFieldItem

#pragma mark Init / Free

- (instancetype)initWithTitle:(NSString*)title value:(id)value {
    self = [super init];
    if(self != nil) {
        self.title = title;
        self.font = [UIFont systemFontOfSize:UIFont.systemFontSize];
        self.color = UIColor.blackColor;
        self.value = value;
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title color:(UIColor*)color value:(id)value {
    self = [super init];
    if(self != nil) {
        self.title = title;
        self.font = [UIFont systemFontOfSize:UIFont.systemFontSize];
        self.color = color;
        self.value = value;
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color value:(id)value {
    self = [super init];
    if(self != nil) {
        self.title = title;
        self.font = font;
        self.color = color;
        self.value = value;
        [self setup];
    }
    return self;
}

- (void)setup {
}

@end

/*--------------------------------------------------*/
