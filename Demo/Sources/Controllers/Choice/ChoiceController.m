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

@property(nonatomic, readwrite, strong) MobilyDataContainerItemsList* dataContainer;

@end

/*--------------------------------------------------*/

@implementation ChoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)update {
    [super update];
    
    [_dataView batchUpdate:^{
        [_dataContainer appendIdentifier:ChoiceCellIdentifier byData:nil];
    }];
}

- (void)clear {
    [super clear];
}

@end

/*--------------------------------------------------*/
