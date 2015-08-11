/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, ChoiceType) {
    ChoiceTypeDataViewList,
    ChoiceTypeDataViewFlow,
    ChoiceTypeDataViewCalendar,
    ChoiceTypeScrollViewForm,
};

/*--------------------------------------------------*/

@interface ChoiceModel : MobilyModel

@property(nonatomic, readonly, strong) NSString* title;
@property(nonatomic, readonly, assign) ChoiceType type;

+ (instancetype)choiceWithTitle:(NSString*)title type:(ChoiceType)type;
- (instancetype)initWithTitle:(NSString*)title type:(ChoiceType)type;

@end

/*--------------------------------------------------*/