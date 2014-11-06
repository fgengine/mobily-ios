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

#import "MobilyViewFieldList.h"

/*--------------------------------------------------*/

@interface MobilyViewFieldList () < UIPickerViewDataSource, UIPickerViewDelegate >

@property(nonatomic, readwrite, strong) UIPickerView* pickerView;

@end

/*--------------------------------------------------*/

@implementation MobilyViewFieldList

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (void)dealloc {
    [self setPickerView:nil];
    
    [self setItems:nil];
    [self setSelectedItem:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)didBeginEditing {
    [super didBeginEditing];
    
    if(_pickerView == nil) {
        [self setPickerView:[[UIPickerView alloc] init]];
        if(_pickerView != nil) {
            [_pickerView setDelegate:self];
        }
        [self setInputView:_pickerView];
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
}

#pragma mark Property

- (void)setItems:(NSArray*)items {
    if([_items isEqualToArray:items] == NO) {
        _items = items;
        
        if([self isEditing] == YES) {
            [_pickerView reloadAllComponents];
        }
        if((_selectedItem == nil) && ([_items count] > 0)) {
            _selectedItem = [_items objectAtIndex:0];
            [self setText:[_selectedItem title]];
            if([self isEditing] == YES) {
                [_pickerView selectRow:[_items indexOfObject:_selectedItem] inComponent:0 animated:NO];
            }
        } else {
            [self setText:@""];
        }
    }
}

- (void)setSelectedItem:(MobilyViewFieldListItem*)selectedItem {
    [self setSelectedItem:selectedItem animated:NO];
}

- (void)setSelectedItem:(MobilyViewFieldListItem*)selectedItem animated:(BOOL)animated {
    if(_selectedItem != selectedItem) {
        _selectedItem = selectedItem;
        
        if(_selectedItem != nil) {
            [self setText:[_selectedItem title]];
        } else {
            [self setText:@""];
        }
        if([self isEditing] == YES) {
            [_pickerView selectRow:[_items indexOfObject:_selectedItem] inComponent:0 animated:animated];
        }
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_items count];
}

#pragma mark UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[_items objectAtIndex:row] title];
}

- (NSAttributedString*)pickerView:(UIPickerView*)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    MobilyViewFieldListItem* listItem = [_items objectAtIndex:row];
    return [[NSAttributedString alloc] initWithString:[listItem title] attributes:@{
        NSFontAttributeName : [listItem font],
        NSForegroundColorAttributeName: [listItem color]
    }];
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    MobilyViewFieldListItem* listItem = [_items objectAtIndex:row];
    if(_selectedItem != listItem) {
        _selectedItem = listItem;
        
        if(_selectedItem != nil) {
            [self setText:[_selectedItem title]];
        } else {
            [self setText:@""];
        }
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyViewFieldListItem

#pragma mark Standart

- (id)initWithTitle:(NSString*)title value:(id)value {
    self = [super init];
    if(self != nil) {
        [self setTitle:title];
        [self setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [self setColor:[UIColor blackColor]];
        [self setValue:value];
    }
    return self;
}

- (id)initWithTitle:(NSString*)title color:(UIColor*)color value:(id)value {
    self = [super init];
    if(self != nil) {
        [self setTitle:title];
        [self setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [self setColor:color];
        [self setValue:value];
    }
    return self;
}

- (id)initWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color value:(id)value {
    self = [super init];
    if(self != nil) {
        [self setTitle:title];
        [self setFont:font];
        [self setColor:color];
        [self setValue:value];
    }
    return self;
}

- (void)dealloc {
    [self setTitle:nil];
    [self setFont:nil];
    [self setColor:nil];
    [self setValue:nil];
    
    MOBILY_SAFE_DEALLOC;
}

@end

/*--------------------------------------------------*/
