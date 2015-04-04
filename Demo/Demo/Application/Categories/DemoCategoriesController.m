/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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
#import "DemoGridController.h"
#import "DemoCalendarController.h"
#import "DemoAudioRecorderController.h"
#import "DemoAudioPlayerController.h"

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, DemoCategoriesType) {
    DemoCategoriesTypeButtons,
    DemoCategoriesTypeFields,
    DemoCategoriesTypeTables,
    DemoCategoriesTypeGrid,
    DemoCategoriesTypeCalendar,
    DemoCategoriesTypeAudioRecorder,
    DemoCategoriesTypeAudioPlayer
};

/*--------------------------------------------------*/

@interface DemoCategoriesModel : MobilyModel

@property(nonatomic, readwrite, assign) DemoCategoriesType type;
@property(nonatomic, readwrite, strong) NSString* title;

- (instancetype)initWithTitle:(NSString*)title;
- (instancetype)initWithType:(DemoCategoriesType)type title:(NSString*)title;

@end

/*--------------------------------------------------*/

@implementation DemoCategoriesController

- (void)setup {
    [super setup];
    
    self.title = @"Categories";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.sections = MobilyDataContainerSectionsList.new;
    
    MobilyDataContainerItemsList* commonItems = MobilyDataContainerItemsList.new;
    commonItems.header = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"COMMON"];
    [commonItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier order:1 dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeButtons title:@"Buttons"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeFields title:@"Fields"],
    ]]];
    commonItems.footer = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"common"];
    [self.sections appendSection:commonItems];
    
    MobilyDataContainerItemsList* tableItems = MobilyDataContainerItemsList.new;
    tableItems.header = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"TABLES"];
    [tableItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier order:1 dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeTables title:@"Tables"],
    ]]];
    tableItems.footer = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"tables"];
    [self.sections appendSection:tableItems];
    
    MobilyDataContainerItemsList* collectionItems = MobilyDataContainerItemsList.new;
    collectionItems.header = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"COLLECTION"];
    [collectionItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier order:1 dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeGrid title:@"Grid"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeCalendar title:@"Calendar"],
    ]]];
    collectionItems.footer = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"collection"];
    [self.sections appendSection:collectionItems];
    
    MobilyDataContainerItemsList* audioVideoItems = MobilyDataContainerItemsList.new;
    audioVideoItems.header = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"AUDIO / VIDEO"];
    [audioVideoItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier order:1 dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioRecorder title:@"AudioRecorder"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioPlayer title:@"AudioPlayer"],
    ]]];
    audioVideoItems.footer = [MobilyDataItem itemWithIdentifier:DemoCategoriesHeaderIdentifier order:2 data:@"audio / video"];
    [self.sections appendSection:audioVideoItems];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataView registerIdentifier:DemoCategoriesHeaderIdentifier withViewClass:DemoCategoriesHeaderCell.class];
    [self.dataView registerIdentifier:DemoCategoriesIdentifier withViewClass:DemoCategoriesCell.class];
    [self.dataView registerEventWithTarget:self action:@selector(pressedDataCell:dataItem:) forIdentifier:DemoCategoriesIdentifier forKey:MobilyDataCellPressed];
    self.dataView.container = self.sections;
}

- (IBAction)pressedDataCell:(MobilyDataCell*)dataCell dataItem:(MobilyDataItem*)dataItem {
    DemoCategoriesModel* model = dataItem.data;
    switch(model.type) {
        case DemoCategoriesTypeButtons: [self.app.mainSlideCenterController pushViewController:DemoButtonsController.new animated:YES]; break;
        case DemoCategoriesTypeFields: [self.app.mainSlideCenterController pushViewController:DemoFieldsController.new animated:YES]; break;
        case DemoCategoriesTypeTables: [self.app.mainSlideCenterController pushViewController:DemoTablesController.new animated:YES]; break;
        case DemoCategoriesTypeGrid: [self.app.mainSlideCenterController pushViewController:DemoGridController.new animated:YES]; break;
        case DemoCategoriesTypeCalendar: [self.app.mainSlideCenterController pushViewController:DemoCalendarController.new animated:YES]; break;
        case DemoCategoriesTypeAudioRecorder: [self.app.mainSlideCenterController pushViewController:DemoAudioRecorderController.new animated:YES]; break;
        case DemoCategoriesTypeAudioPlayer: [self.app.mainSlideCenterController pushViewController:DemoAudioPlayerController.new animated:YES]; break;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesHeaderCell

+ (CGSize)sizeForItem:(MobilyDataItem*)item availableSize:(CGSize)size {
    return CGSizeMake(size.width, 21.0f);
}

- (void)prepareForUse {
    [super prepareForUse];
    
    self.textView.text = self.item.data;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesCell

+ (CGSize)sizeForItem:(MobilyDataItem*)item availableSize:(CGSize)size {
    return CGSizeMake(size.width, 88.0f);
}

- (void)prepareForUse {
    [super prepareForUse];
    
    DemoCategoriesModel* model = self.item.data;
    self.textView.text = model.title;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesModel


- (instancetype)initWithTitle:(NSString*)title {
    self = [super init];
    if(self != nil) {
        self.title = title;
    }
    return self;
}

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

NSString* DemoCategoriesHeaderIdentifier = @"DemoCategoriesHeaderIdentifier";
NSString* DemoCategoriesIdentifier = @"DemoCategoriesIdentifier";

/*--------------------------------------------------*/
