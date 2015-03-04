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

#import "DemoGridController.h"

/*--------------------------------------------------*/

@implementation DemoGridController

- (void)setup {
    [super setup];
    
    self.title = @"Grid";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataGrid = [MobilyDataContainerItemsGrid new];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem addLeftBarFixedSpace:-16.0f animated:NO];
    [self.navigationItem addLeftBarButtonNormalImage:[UIImage imageNamed:@"menu-back.png"] target:self action:@selector(pressedBack) animated:NO];
    
    // [_dataGrid insertCell:[MobilyDataItem dataI] atColumn:<#(NSUInteger)#>];
    
    [_dataView registerIdentifier:DemoGridColumnIdentifier withViewClass:DemoGridColumnCell.class];
    [_dataView registerIdentifier:DemoGridRowIdentifier withViewClass:DemoGridRowCell.class];
    [_dataView registerIdentifier:DemoGridIdentifier withViewClass:DemoGridCell.class];

    [_dataView setContainer:_dataGrid];
}

#pragma mark Action

- (IBAction)pressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoGridColumnCell

- (void)prepareForUse {
    [super prepareForUse];
}

- (void)prepareForUnuse {
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/

NSString* DemoGridColumnIdentifier = @"DemoGridColumnIdentifier";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoGridRowCell

- (void)prepareForUse {
    [super prepareForUse];
}

- (void)prepareForUnuse {
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/

NSString* DemoGridRowIdentifier = @"DemoGridRowIdentifier";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoGridCell

- (void)prepareForUse {
    [super prepareForUse];
}

- (void)prepareForUnuse {
    [super prepareForUnuse];
}

@end

/*--------------------------------------------------*/

NSString* DemoGridIdentifier = @"DemoGridIdentifier";

/*--------------------------------------------------*/
