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
    
    [self setTitle:@"500px"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [PXRequest setConsumerKey:PXConsumerKey consumerSecret:PXConsumerSecret];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                                 [self setDataSource:[results valueForKey:@"photos"]];
                                 [_tableView reloadData];
                             }
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         }];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Demo500pxCell* cell = [_tableView dequeueReusableCellWithClass:[Demo500pxCell class]];
    if(cell != nil) {
        [cell setModel:[_dataSource objectAtIndex:[indexPath row]]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [Demo500pxCell heightForModel:[_dataSource objectAtIndex:[indexPath row]] tableView:_tableView];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation Demo500pxCell

+ (CGFloat)heightForModel:(NSDictionary*)model tableView:(UITableView*)tableView {
    CGFloat width = [[model objectForKey:@"width"] floatValue];
    CGFloat height = [[model objectForKey:@"height"] floatValue];
    CGRect rect = CGRectAspectFillFromBoundsAndSize([tableView bounds], CGSizeMake(width, height));
    return rect.size.height;
}

- (void)setup {
    [super setup];
}

- (void)setModel:(NSDictionary*)model {
    [super setModel:model];
    
    [_activityView startAnimating];
    [_photoView setImageUrl:[NSURL URLWithString:[[[model objectForKey:@"images"] lastObject] valueForKey:@"url"]] complete:^(UIImage *image, NSURL *url) {
        [_activityView stopAnimating];
    } failure:^(NSURL* url) {
        [_activityView stopAnimating];
    }];
}

@end

/*--------------------------------------------------*/
