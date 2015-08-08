/*--------------------------------------------------*/

@interface ChoiceGroupModel : MobilyModel

@property(nonatomic, readonly, strong) NSString* title;
@property(nonatomic, readonly, strong) NSArray* items;

+ (instancetype)choiceWithTitle:(NSString*)title items:(NSArray*)items;
- (instancetype)initWithTitle:(NSString*)title items:(NSArray*)items;

@end

/*--------------------------------------------------*/