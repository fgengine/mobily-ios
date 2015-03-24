/*--------------------------------------------------*/

#import "___FILEBASENAME___.h"

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark MobilyModel

+ (NSArray*)serializeMap {
    return @[
    ];
}

#pragma mark Singleton

+ (instancetype)shared {
    static id result = nil;
    if(result == nil) {
        result = [[self alloc] initWithUserDefaultsKey:@"___FILEBASENAMEASIDENTIFIER___"];
    }
    return result;
}

#pragma mark Setup

- (void)setup {
    [super setup];
}

@end

/*--------------------------------------------------*/