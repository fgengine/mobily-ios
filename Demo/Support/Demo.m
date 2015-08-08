/*--------------------------------------------------*/

#import "App.h"

/*--------------------------------------------------*/

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [MobilyContext setArgCount:argc argValue:argv];
        [MobilyContext setApplicationClass:App.class];
        return [MobilyContext run];
    }
}

/*--------------------------------------------------*/
