/*--------------------------------------------------*/

#import "ChoiceGroupModel.h"

/*--------------------------------------------------*/

@interface ChoiceGroupModel ()

@property(nonatomic, readwrite, strong) NSString* title;
@property(nonatomic, readwrite, strong) NSArray* items;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceGroupModel

+ (instancetype)choiceWithTitle:(NSString*)title items:(NSArray*)items {
    return [[self alloc] initWithTitle:title items:items];
}

- (instancetype)initWithTitle:(NSString*)title items:(NSArray*)items {
    self = [super init];
    if(self != nil) {
        self.title = title;
        self.items = items;
    }
    return self;
}

@end

/*--------------------------------------------------*/