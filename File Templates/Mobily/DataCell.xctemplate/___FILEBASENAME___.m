/*--------------------------------------------------*/

#import "___FILEBASENAME___.h"

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ___FILEBASENAMEASIDENTIFIER___

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

// actions

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

NSString* ___FILEBASENAMEASIDENTIFIER___Identifier = @"___FILEBASENAMEASIDENTIFIER___Identifier";

/*--------------------------------------------------*/