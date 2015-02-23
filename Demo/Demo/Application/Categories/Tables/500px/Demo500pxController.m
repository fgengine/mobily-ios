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

#import "Demo500pxController.h"

/*--------------------------------------------------*/

#import "DemoButtonsController.h"
#import "DemoFieldsController.h"
#import "DemoAudioRecorderController.h"
#import "DemoAudioPlayerController.h"

/*--------------------------------------------------*/

static NSString* PXConsumerKey = @"81gxei623475kKd1k4cIOT0AMUDO9C8LNmRlZa4p";
static NSString* PXConsumerSecret = @"wMDdVbq28mvbkb0GxbLxBW9UdO8v4NZkMIVFqZWl";

/*--------------------------------------------------*/

@implementation Demo500pxController

- (void)setup {
    [super setup];
    
    self.title = @"500px";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [PXRequest setConsumerKey:PXConsumerKey consumerSecret:PXConsumerSecret];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem addLeftBarFixedSpace:-16.0f animated:NO];
    [self.navigationItem addLeftBarButtonNormalImage:[UIImage imageNamed:@"menu-back.png"] target:self action:@selector(pressedBack) animated:NO];
    
    [_tableView registerCellClass:[Demo500pxCell class]];
}

- (void)update {
    [super update];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [PXRequest requestForSearchTerm:@"Comics"
                               page:1
                     resultsPerPage:500
                         photoSizes:PXPhotoModelSizeLarge
                             except:PXPhotoModelCategoryUncategorized
                         completion:^(NSDictionary* results, NSError* error) {
                             if(results != nil) {
                                 self.dataSource = [results valueForKey:@"photos"];
                                 [_tableView reloadData];
                             }
                             UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
                         }];
}

#pragma mark Action

- (IBAction)pressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Demo500pxCell* cell = [_tableView dequeueReusableCellWithClass:[Demo500pxCell class]];
    if(cell != nil) {
        cell.model = _dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [Demo500pxCell heightForModel:_dataSource[indexPath.row] tableView:_tableView];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation Demo500pxCell

+ (CGFloat)heightForModel:(NSDictionary*)model tableView:(UITableView*)tableView {
    CGFloat width = [model[@"width"] floatValue];
    CGFloat height = [model[@"height"] floatValue];
    CGRect rect = CGRectAspectFillFromBoundsAndSize([tableView bounds], CGSizeMake(width, height));
    return rect.size.height;
}

- (void)setup {
    [super setup];
}

- (void)setModel:(NSDictionary*)model {
    [super setModel:model];
    
    [_activityView startAnimating];
    [_photoView setImageUrl:[NSURL URLWithString:[[model[@"images"] lastObject] valueForKey:@"url"]] complete:^() {
        [_activityView stopAnimating];
    } failure:^(NSURL* url) {
        [_activityView stopAnimating];
    }];
}

@end

/*--------------------------------------------------*/
