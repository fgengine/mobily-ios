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

#import "MobilyViewFieldDate.h"

/*--------------------------------------------------*/

@interface MobilyViewFieldDate ()

@property(nonatomic, readwrite, strong) UIDatePicker* pickerView;

@end

/*--------------------------------------------------*/

@implementation MobilyViewFieldDate

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (void)dealloc {
    [self setPickerView:nil];
    
    [self setDateFormatter:nil];
    [self setDate:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)setupView {
    [super setupView];
    
    [self setDate:[NSDate date]];
}

- (void)didBeginEditing {
    [super didBeginEditing];
    
    if(_pickerView == nil) {
        [self setPickerView:[[UIDatePicker alloc] init]];
        if(_pickerView != nil) {
            [_pickerView setDatePickerMode:_datePickerMode];
            [_pickerView addTarget:self action:@selector(changedDate:) forControlEvents:UIControlEventValueChanged];
        }
        [self setInputView:_pickerView];
    }
    if(_pickerView != nil) {
        if(_date != nil) {
            [_pickerView setDate:_date];
        }
    }
}

- (void)didEndEditing {
    [super didEndEditing];
}

#pragma mark Property

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    if(_datePickerMode != datePickerMode) {
        _datePickerMode = datePickerMode;
        
        if(_pickerView != nil) {
            [_pickerView setDatePickerMode:_datePickerMode];
        }
    }
}

- (void)setDateFormatter:(NSDateFormatter*)dateFormatter {
    if(_dateFormatter != dateFormatter) {
        _dateFormatter = dateFormatter;
        
        if(_date != nil) {
            if(_dateFormatter != nil) {
                [self setText:[_dateFormatter stringFromDate:_date]];
            } else {
                [self setText:[_date description]];
            }
        } else {
            [self setText:@""];
        }
    }
}

- (void)setDate:(NSDate*)date {
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate*)date animated:(BOOL)animated {
    if([_date isEqualToDate:date] == NO) {
        _date = date;
        
        if(_date != nil) {
            if(_dateFormatter != nil) {
                [self setText:[_dateFormatter stringFromDate:_date]];
            } else {
                [self setText:[_date description]];
            }
        } else {
            [self setText:@""];
        }
        if([self isEditing] == YES) {
            if(_date != nil) {
                [_pickerView setDate:_date animated:animated];
            }
        }
    }
}

#pragma mark Private

- (void)changedDate:(id)sender {
    [self setDate:[_pickerView date] animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end

/*--------------------------------------------------*/
