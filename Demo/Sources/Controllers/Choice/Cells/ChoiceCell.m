/*--------------------------------------------------*/

#import "ChoiceCell.h"

/*--------------------------------------------------*/

@interface ChoiceCell ()

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceCell

#pragma mark Static

+ (CGSize)sizeForItem:(MobilyDataItem*)item availableSize:(CGSize)size {
    return size;
}

#pragma mark MobilyDataCell

- (void)prepareForUse {
    [super prepareForUse];
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