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

#import "DemoCategoriesController.h"

/*--------------------------------------------------*/

#import "DemoButtonsController.h"
#import "DemoFieldsController.h"
#import "DemoAudioRecorderController.h"

/*--------------------------------------------------*/

@implementation DemoCategoriesController

- (void)setup {
    [super setup];
    
    [self setTitle:@"Categories"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setDataSource:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeButtons title:@"Buttons"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeFields title:@"Fields"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioRecorder title:@"AudioRecorder"],
    ]];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerCellClass:[DemoCategoriesCell class]];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    DemoCategoriesCell* cell = [_tableView dequeueReusableCellWithClass:[DemoCategoriesCell class]];
    if(cell != nil) {
        [cell setModel:[_dataSource objectAtIndex:[indexPath row]]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [DemoCategoriesCell heightForModel:[_dataSource objectAtIndex:[indexPath row]] tableView:_tableView];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    DemoCategoriesModel* model = [_dataSource objectAtIndex:[indexPath row]];
    if(model != nil) {
        switch([model type]) {
            case DemoCategoriesTypeButtons: {
                [[self navigationController] pushViewController:[DemoButtonsController new] animated:YES];
                break;
            }
            case DemoCategoriesTypeFields: {
                [[self navigationController] pushViewController:[DemoFieldsController new] animated:YES];
                break;
            }
            case DemoCategoriesTypeAudioRecorder: {
                [[self navigationController] pushViewController:[DemoAudioRecorderController new] animated:YES];
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

@implementation DemoCategoriesCell

+ (CGFloat)heightForModel:(DemoCategoriesModel*)model tableView:(UITableView*)tableView {
    return 44.0f;
}

- (void)setup {
    [super setup];
}

- (void)setModel:(DemoCategoriesModel*)model {
    [super setModel:model];
    
    [_textView setText:[model title]];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesModel

- (id)initWithType:(DemoCategoriesType)type title:(NSString*)title {
    self = [super init];
    if(self != nil) {
        [self setType:type];
        [self setTitle:title];
    }
    return self;
}

@end

/*--------------------------------------------------*/
