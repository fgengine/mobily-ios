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

#import "DemoTablesController.h"

/*--------------------------------------------------*/

#import "Demo500pxController.h"

/*--------------------------------------------------*/

@implementation DemoTablesController

- (void)setup {
    [super setup];
    
    self.title = @"Tables";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setDataSource:@[
        [[DemoTablesModel alloc] initWithType:DemoTablesType500px title:@"500 px"],
    ]];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerCellClass:DemoTablesCell.class];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    DemoTablesCell* cell = [_tableView dequeueReusableCellWithClass:[DemoTablesCell class]];
    if(cell != nil) {
        cell.model = _dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [DemoTablesCell heightForModel:_dataSource[indexPath.row] tableView:_tableView];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    DemoTablesModel* model = _dataSource[indexPath.row];
    if(model != nil) {
        switch([model type]) {
            case DemoTablesType500px: {
                [self.navigationController pushViewController:[Demo500pxController new] animated:YES];
                break;
            }
        }
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoTablesCell

+ (CGFloat)heightForModel:(DemoTablesModel*)model tableView:(UITableView*)tableView {
    return 44.0f;
}

- (void)setup {
    [super setup];
}

- (void)setModel:(DemoTablesModel*)model {
    [super setModel:model];
    
    _textView.text = model.title;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoTablesModel

- (instancetype)initWithType:(DemoTablesType)type title:(NSString*)title {
    self = [super init];
    if(self != nil) {
        self.type = type;
        self.title = title;
    }
    return self;
}

@end

/*--------------------------------------------------*/
