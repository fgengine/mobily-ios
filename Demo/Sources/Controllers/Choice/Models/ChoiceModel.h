/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, ChoiceType) {
    ChoiceDataViewList,
    ChoiceDataViewFlow,
    ChoiceDataViewCalendar,
    ChoiceScrollView,
};

/*--------------------------------------------------*/

@interface ChoiceModel : MobilyModel

@property(nonatomic, readonly, strong) NSString* title;
@property(nonatomic, readonly, assign) ChoiceType type;

+ (instancetype)choiceWithTitle:(NSString*)title type:(ChoiceType)type;
- (instancetype)initWithTitle:(NSString*)title type:(ChoiceType)type;

@end

/*--------------------------------------------------*/