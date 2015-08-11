/*--------------------------------------------------*/

#import "ChoiceHeaderCell.h"
#import "ChoiceGroupModel.h"

/*--------------------------------------------------*/

@interface ChoiceHeaderCell ()

@property(nonatomic, readwrite, weak) IBOutlet UILabel* titleLabel;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceHeaderCell

#pragma mark MobilyDataCell

- (void)prepareForUse {
    [super prepareForUse];
    
    ChoiceGroupModel* model = self.item.data;
    _titleLabel.text = model.title;
}

- (void)prepareForUnuse {
	[super prepareForUnuse];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

NSString* ChoiceHeaderCellIdentifier = @"ChoiceHeaderCellIdentifier";

/*--------------------------------------------------*/