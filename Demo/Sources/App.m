/*--------------------------------------------------*/

#import "App.h"

/*--------------------------------------------------*/

#import "ChoiceController.h"

/*--------------------------------------------------*/

@interface App ()

@end

/*--------------------------------------------------*/

@implementation App

#pragma mark Public

@synthesize window = _window;
@synthesize choiceNavigation = _choiceNavigation;
@synthesize choiceController = _choiceController;

#pragma mark Public

- (BOOL)launchingWithOptions:(NSDictionary*)options {
    BOOL result = [super launchingWithOptions:options];
    if(result == YES) {
        self.window.rootViewController = self.choiceNavigation;
    }
    return result;
}

- (void)terminate {
    [super terminate];
}

#pragma mark Property

- (MobilyWindow*)window {
    if(_window == nil) {
        _window = [MobilyWindow new];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (MobilyNavigationController*)choiceNavigation {
    if(_choiceNavigation == nil) {
        _choiceNavigation = [[MobilyNavigationController alloc] initWithRootViewController:self.choiceController];
    }
    return _choiceNavigation;
}

- (ChoiceController*)choiceController {
    if(_choiceController == nil) {
        _choiceController = [ChoiceController new];
    }
    return _choiceController;
}

@end

/*--------------------------------------------------*/
