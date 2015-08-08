/*--------------------------------------------------*/

@class RootController;

/*--------------------------------------------------*/

@interface App : MobilyApplication

@property(nonatomic, readonly, strong) MobilyWindow* window;
@property(nonatomic, readonly, strong) RootController* rootController;

@end

/*--------------------------------------------------*/
