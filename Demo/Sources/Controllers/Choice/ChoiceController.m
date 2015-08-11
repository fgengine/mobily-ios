/*--------------------------------------------------*/

#import "ChoiceController.h"
#import "ChoiceHeaderCell.h"
#import "ChoiceCell.h"

/*--------------------------------------------------*/

#import "ChoiceGroupModel.h"
#import "ChoiceModel.h"

/*--------------------------------------------------*/

@interface ChoiceController ()

@property(nonatomic, readwrite, weak) IBOutlet MobilyDataView* dataView;

@property(nonatomic, readwrite, strong) MobilyDataContainerSectionsList* dataContainer;

@end

/*--------------------------------------------------*/

@implementation ChoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataContainer = [MobilyDataContainerSectionsList containerWithOrientation:MobilyDataContainerOrientationVertical];
    
    self.dataView.allowsSelection = NO;
    self.dataView.allowsEditing = NO;
    [self.dataView registerIdentifier:ChoiceHeaderCellIdentifier withViewClass:ChoiceHeaderCell.class];
    [self.dataView registerIdentifier:ChoiceCellIdentifier withViewClass:ChoiceCell.class];
    [self.dataView registerEventWithTarget:self action:@selector(pressedChoiceCell:forItem:) forIdentifier:ChoiceCellIdentifier forKey:MobilyDataCellPressed];
    self.dataView.container = self.dataContainer;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)update {
    [super update];
    
    NSArray* groups = @[
        [ChoiceGroupModel choiceGroupWithTitle:@"DataView" items:@[
            [ChoiceModel choiceWithTitle:@"List" type:ChoiceTypeDataViewList],
            [ChoiceModel choiceWithTitle:@"Flow" type:ChoiceTypeDataViewFlow],
            [ChoiceModel choiceWithTitle:@"Calendar" type:ChoiceTypeDataViewCalendar],
        ]],
        [ChoiceGroupModel choiceGroupWithTitle:@"ScrollView" items:@[
            [ChoiceModel choiceWithTitle:@"Form" type:ChoiceTypeScrollViewForm],
        ]],
    ];
    [self.dataView batchUpdate:^{
        [groups moEach:^(ChoiceGroupModel* group) {
            MobilyDataContainerItemsList* container = [MobilyDataContainerItemsList containerWithOrientation:MobilyDataContainerOrientationVertical];
            container.header = [MobilyDataItem itemWithIdentifier:ChoiceHeaderCellIdentifier order:1 data:group];
            [group.items moEach:^(ChoiceModel* item) {
                [container appendIdentifier:ChoiceCellIdentifier byData:item];
            }];
            [self.dataContainer appendSection:container];
        }];
    }];
}

- (void)clear {
    [super clear];
}

#pragma mark Actions

- (IBAction)pressedChoiceCell:(MobilyDataCell*)cell forItem:(MobilyDataItem*)item {
    ChoiceModel* choice = item.data;
    switch(choice.type) {
        case ChoiceTypeDataViewList:
            break;
        case ChoiceTypeDataViewFlow:
            break;
        case ChoiceTypeDataViewCalendar:
            break;
        case ChoiceTypeScrollViewForm:
            break;
    }
}

@end

/*--------------------------------------------------*/
