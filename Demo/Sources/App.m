/*--------------------------------------------------*/

#import "App.h"

/*--------------------------------------------------*/

#import "RootController.h"

/*--------------------------------------------------*/

@interface App ()

@end

/*--------------------------------------------------*/

@implementation App

#pragma mark Public

@synthesize window = _window;
@synthesize rootController = _rootController;

#pragma mark Public

- (BOOL)launchingWithOptions:(NSDictionary*)options {
    BOOL result = [super launchingWithOptions:options];
    if(result == YES) {
        self.window.rootViewController = self.rootController;
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

- (RootController*)rootController {
    if(_rootController == nil) {
        _rootController = [RootController new];
    }
    return _rootController;
}

@end

/*--------------------------------------------------*/
