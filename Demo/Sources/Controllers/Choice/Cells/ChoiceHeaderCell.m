/*--------------------------------------------------*/

#import "ChoiceHeaderCell.h"

/*--------------------------------------------------*/

@interface ChoiceHeaderCell ()

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceHeaderCell

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

NSString* ChoiceHeaderCellIdentifier = @"ChoiceHeaderCellIdentifier";

/*--------------------------------------------------*/