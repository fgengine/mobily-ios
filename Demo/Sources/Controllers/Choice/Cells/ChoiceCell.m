/*--------------------------------------------------*/

#import "ChoiceCell.h"
#import "ChoiceModel.h"

/*--------------------------------------------------*/

@interface ChoiceCell ()

@property(nonatomic, readwrite, weak) IBOutlet UILabel* titleLabel;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceCell

#pragma mark MobilyDataCell

- (void)prepareForUse {
    [super prepareForUse];
    
    ChoiceModel* model = self.item.data;
    _titleLabel.text = model.title;
}

- (void)prepareForUnuse {
	[super prepareForUnuse];
}

#pragma mark Action

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

NSString* ChoiceCellIdentifier = @"ChoiceCellIdentifier";

/*--------------------------------------------------*/