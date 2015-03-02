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

#import "DemoCalendarController.h"

/*--------------------------------------------------*/

@implementation DemoCalendarController

- (void)setup {
    [super setup];
    
    self.title = @"Calendar";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataCalendar = [MobilyDataContainerCalendar containerWithCalendar:NSCalendar.currentCalendar];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem addLeftBarFixedSpace:-16.0f animated:NO];
    [self.navigationItem addLeftBarButtonNormalImage:[UIImage imageNamed:@"menu-back.png"] target:self action:@selector(pressedBack) animated:NO];
    
    [_dataView registerIdentifier:MobilyDataCalendarMonthIdentifier withViewClass:DemoCalendarMonthCell.class];
    [_dataView registerIdentifier:MobilyDataCalendarWeekdayIdentifier withViewClass:DemoCalendarWeekdayCell.class];
    [_dataView registerIdentifier:MobilyDataCalendarDayIdentifier withViewClass:DemoCalendarDayCell.class];

    [_dataCalendar prepareBeginDate:NSDate.date.previousWeek endDate:NSDate.date.nextWeek];
    
    [_dataView setContainer:_dataCalendar];
}

#pragma mark Action

- (IBAction)pressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCalendarMonthCell

- (void)prepareForUse {
    [super prepareForUse];
    
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"MMMM"];
    }
    
    MobilyDataItemCalendarMonth* calendarItem = (MobilyDataItemCalendarMonth*)self.item;
    _textView.text = [dateFormatter stringFromDate:calendarItem.beginDate];
}

- (void)prepareForUnuse {
    _textView.text = @"";
    
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCalendarWeekdayCell

- (void)prepareForUse {
    [super prepareForUse];
    
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"EEE"];
    }
    
    MobilyDataItemCalendarWeekday* calendarItem = (MobilyDataItemCalendarWeekday*)self.item;
    _textView.text = [dateFormatter stringFromDate:calendarItem.date];
}

- (void)prepareForUnuse {
    _textView.text = @"";
    
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCalendarDayCell

- (void)prepareForUse {
    [super prepareForUse];
    
    static NSDateFormatter* dateFormatter = nil;
    if(dateFormatter == nil) {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"dd"];
    }
    
    MobilyDataItemCalendarDay* calendarItem = (MobilyDataItemCalendarDay*)self.item;
    _textView.text = [dateFormatter stringFromDate:calendarItem.date];
}

- (void)prepareForUnuse {
    _textView.text = @"";
    
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/
