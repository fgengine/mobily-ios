/*--------------------------------------------------*/

#import "___FILEBASENAME___.h"

/*--------------------------------------------------*/

static NSString* ___FILEBASENAMEASIDENTIFIER___ServerUrl = @"http://httpbin.org/";

/*--------------------------------------------------*/

@interface ___FILEBASENAMEASIDENTIFIER___ ()

+ (MobilyApiProvider*)___FILEBASENAMEASIDENTIFIER___Provider;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark Property

+ (MobilyApiProvider*)___FILEBASENAMEASIDENTIFIER___Provider {
    static MobilyApiProvider* ___FILEBASENAMEASIDENTIFIER___Provider = nil;
    if(___FILEBASENAMEASIDENTIFIER___Provider == nil) {
        ___FILEBASENAMEASIDENTIFIER___Provider = [[MobilyApiProvider alloc] initWithName:@"___FILEBASENAMEASIDENTIFIER___Provider" url:[NSURL URLWithString:___FILEBASENAMEASIDENTIFIER___ServerUrl]];
        [[MobilyApiManager shared] registerProvider:___FILEBASENAMEASIDENTIFIER___Provider];
    }
    return ___FILEBASENAMEASIDENTIFIER___Provider;
}

#pragma mark Public

+ (void)exampleRequestSuccess:(ApiSuccess)success failure:(ApiFailure)failure {
    [self.___FILEBASENAMEASIDENTIFIER___Provider sendRequest:[[MobilyApiRequest alloc] initWithGetRelativeUrl:@"/get"]
                                    byTarget:self
                               completeBlock:^(MobilyApiRequest* request, MobilyApiResponse* response) {
                                   if(response.httpError == nil) {
                                       if(success != nil) {
                                           success();
                                       }
                                   } else {
                                       if(failure != nil) {
                                           failure(@"error", response.httpError);
                                       }
                                   }
                               }];
}

@end

/*--------------------------------------------------*/