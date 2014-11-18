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

#import "ExampleApplication.h"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ExampleApplication

- (void)setupApplication {
    [super setupApplication];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (BOOL)launchingWithOptions:(NSDictionary *)options {
    BOOL result = [super launchingWithOptions:options];
    if(result == YES) {
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ExampleControllerMain

- (void)setupController {
    [super setupController];
    
    [self setTitle:@"TITLE"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setDataSource:@[ @"Data #1", @"Data #2", @"Data #3", @"Data #4", @"Data #5" ]];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_viewTable registerCellClass:[ExampleControllerMainCell class]];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    ExampleControllerMainCell* cell = [_viewTable dequeueReusableCellWithClass:[ExampleControllerMainCell class]];
    if(cell != nil) {
        [cell setModel:[_dataSource objectAtIndex:[indexPath row]]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [ExampleControllerMainCell heightForModel:[_dataSource objectAtIndex:[indexPath row]] tableView:tableView];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ExampleControllerMainCell

- (void)setupView {
    [super setupView];
}

- (void)setModel:(id)model {
    [super setModel:model];
    
    [_viewTitle setText:model];
}

@end

/*--------------------------------------------------*/
