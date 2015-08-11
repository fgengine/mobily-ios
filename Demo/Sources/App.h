/*--------------------------------------------------*/

@class ChoiceController;

/*--------------------------------------------------*/

@interface App : MobilyApplication

@property(nonatomic, readonly, strong) MobilyWindow* window;
@property(nonatomic, readonly, strong) MobilyNavigationController* choiceNavigation;
@property(nonatomic, readonly, strong) ChoiceController* choiceController;

@end

/*--------------------------------------------------*/
