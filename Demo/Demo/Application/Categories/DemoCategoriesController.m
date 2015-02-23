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
#import "DemoApplication.h"

/*--------------------------------------------------*/

#import "DemoButtonsController.h"
#import "DemoFieldsController.h"
#import "DemoTablesController.h"
#import "DemoDataScrollViewController.h"
#import "DemoAudioRecorderController.h"
#import "DemoAudioPlayerController.h"

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, DemoCategoriesType) {
    DemoCategoriesTypeButtons,
    DemoCategoriesTypeFields,
    DemoCategoriesTypeTables,
    DemoCategoriesTypeDataScrollView,
    DemoCategoriesTypeAudioRecorder,
    DemoCategoriesTypeAudioPlayer
};

/*--------------------------------------------------*/

@interface DemoCategoriesModel : MobilyModel

@property(nonatomic, readwrite, assign) DemoCategoriesType type;
@property(nonatomic, readwrite, strong) NSString* title;

- (instancetype)initWithType:(DemoCategoriesType)type title:(NSString*)title;

@end

/*--------------------------------------------------*/

@implementation DemoCategoriesController

- (void)setup {
    [super setup];
    
    self.title = @"Categories";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.dataListContainer = MobilyDataVerticalListContainer.new;
    [_dataListContainer appendItems:@[
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeButtons title:@"Buttons"]],
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeFields title:@"Fields"]],
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeTables title:@"Tables"]],
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeDataScrollView title:@"DataScrollView"]],
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioRecorder title:@"AudioRecorder"]],
        [MobilyDataItem dataItemWithIdentifier:DemoCategoriesCell.className data:[[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioPlayer title:@"AudioPlayer"]],
    ]];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_dataScrollView registerIdentifier:DemoCategoriesCell.className withViewClass:DemoCategoriesCell.class];
    [_dataScrollView registerEventWithTarget:self action:@selector(pressedDataItemView:dataItem:) forKey:MobilyDataItemViewPressed];
    _dataScrollView.container = _dataListContainer;
}

- (IBAction)pressedDataItemView:(MobilyDataItemView*)dataItemView dataItem:(MobilyDataItem*)dataItem {
    DemoCategoriesModel* model = dataItem.data;
    switch(model.type) {
        case DemoCategoriesTypeButtons: [self.app.slideCenterController pushViewController:DemoButtonsController.new animated:YES]; break;
        case DemoCategoriesTypeFields: [self.app.slideCenterController pushViewController:DemoFieldsController.new animated:YES]; break;
        case DemoCategoriesTypeTables: [self.app.slideCenterController pushViewController:DemoTablesController.new animated:YES]; break;
        case DemoCategoriesTypeDataScrollView: [self.app.slideCenterController pushViewController:DemoDataScrollViewController.new animated:YES]; break;
        case DemoCategoriesTypeAudioRecorder: [self.app.slideCenterController pushViewController:DemoAudioRecorderController.new animated:YES]; break;
        case DemoCategoriesTypeAudioPlayer: [self.app.slideCenterController pushViewController:DemoAudioPlayerController.new animated:YES]; break;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesCell

+ (CGSize)sizeForItem:(id< MobilyDataItem >)item availableSize:(CGSize)size {
    return CGSizeMake(size.width, 44.0f);
}

- (void)prepareForUse {
    [super prepareForUse];
    
    DemoCategoriesModel* model = self.item.data;
    _textView.text = model.title;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesModel

- (instancetype)initWithType:(DemoCategoriesType)type title:(NSString*)title {
    self = [super init];
    if(self != nil) {
        self.type = type;
        self.title = title;
    }
    return self;
}

@end

/*--------------------------------------------------*/
