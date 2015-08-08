/*--------------------------------------------------*/

#import "ChoiceModel.h"

/*--------------------------------------------------*/

@interface ChoiceModel ()

@property(nonatomic, readwrite, strong) NSString* title;
@property(nonatomic, readwrite, assign) ChoiceType type;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ChoiceModel

+ (instancetype)choiceWithTitle:(NSString*)title type:(ChoiceType)type {
    return [[self alloc] initWithTitle:title type:type];
}

- (instancetype)initWithTitle:(NSString*)title type:(ChoiceType)type {
    self = [super init];
    if(self != nil) {
        self.title = title;
        self.type = type;
    }
    return self;
}

@end

/*--------------------------------------------------*/