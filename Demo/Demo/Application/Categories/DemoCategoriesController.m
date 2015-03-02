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
#import "DemoCalendarController.h"
#import "DemoAudioRecorderController.h"
#import "DemoAudioPlayerController.h"

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, DemoCategoriesType) {
    DemoCategoriesTypeButtons,
    DemoCategoriesTypeFields,
    DemoCategoriesTypeTables,
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
    
    self.commonItems = MobilyDataContainerItemsList.new;
    self.commonItems.header = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"COMMON"];
    [self.commonItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeButtons title:@"Buttons"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeFields title:@"Fields"],
    ]]];
    self.commonItems.footer = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"common"];
    [self.sections appendSection:self.commonItems];
    
    self.collectionItems = MobilyDataContainerItemsList.new;
    self.collectionItems.header = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"COLLECTION"];
    [self.collectionItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeCalendar title:@"Calendar"],
        ]]];
    self.collectionItems.footer = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"collection"];
    [self.sections appendSection:self.collectionItems];
    
    self.audioVideoItems = MobilyDataContainerItemsList.new;
    self.audioVideoItems.header = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"AUDIO / VIDEO"];
    [self.audioVideoItems appendItems:[MobilyDataItem dataItemsWithIdentifier:DemoCategoriesIdentifier dataArray:@[
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioRecorder title:@"AudioRecorder"],
        [[DemoCategoriesModel alloc] initWithType:DemoCategoriesTypeAudioPlayer title:@"AudioPlayer"],
        ]]];
    self.audioVideoItems.footer = [MobilyDataItem dataItemWithIdentifier:DemoCategoriesHeaderIdentifier data:@"audio / video"];
    [self.sections appendSection:self.audioVideoItems];
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataView registerIdentifier:DemoCategoriesHeaderIdentifier withViewClass:DemoCategoriesHeaderCell.class];
    [self.dataView registerIdentifier:DemoCategoriesIdentifier withViewClass:DemoCategoriesCell.class];
    [self.dataView registerEventWithTarget:self action:@selector(pressedDataCell:dataItem:) forKey:MobilyDataCellPressed];
    self.dataView.container = self.sections;
}

- (IBAction)pressedDataCell:(MobilyDataCell*)dataCell dataItem:(MobilyDataItem*)dataItem {
    DemoCategoriesModel* model = dataItem.data;
    switch(model.type) {
        case DemoCategoriesTypeButtons: [self.app.slideCenterController pushViewController:DemoButtonsController.new animated:YES]; break;
        case DemoCategoriesTypeFields: [self.app.slideCenterController pushViewController:DemoFieldsController.new animated:YES]; break;
        case DemoCategoriesTypeTables: [self.app.slideCenterController pushViewController:DemoTablesController.new animated:YES]; break;
        case DemoCategoriesTypeCalendar: [self.app.slideCenterController pushViewController:DemoCalendarController.new animated:YES]; break;
        case DemoCategoriesTypeAudioRecorder: [self.app.slideCenterController pushViewController:DemoAudioRecorderController.new animated:YES]; break;
        case DemoCategoriesTypeAudioPlayer: [self.app.slideCenterController pushViewController:DemoAudioPlayerController.new animated:YES]; break;
    }
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoCategoriesHeaderCell

+ (CGSize)sizeForItem:(MobilyDataItem*)item availableSize:(CGSize)size {
    return CGSizeMake(size.width, 44.0f);
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
