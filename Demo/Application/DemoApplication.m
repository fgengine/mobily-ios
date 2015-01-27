/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import "DemoApplication.h"

/*--------------------------------------------------*/

@interface DemoApplication ()

@property(nonatomic, readwrite, strong) MobilyApiProvider* testProvider;

@end

/*
 http://144.76.71.48/api/v1
 http://144.76.71.48/api/v1?m=user.checktoken.ya
 http://144.76.71.48/api/v1?m=user.checktoken
 http://144.76.71.48/api/v1?m=user.checktoken&token=0001.000001.uyetr56w
 http://144.76.71.48/api/v1?m=user.checktoken&token=00001.000001.uyetr56whgd67sghd6e8g
 http://144.76.71.48/api/v1?m=user.checktoken&token=00001.000001.uyetr56whgd67sghd6e8e
*/

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation DemoApplication

- (void)setup {
    [super setup];
    
    [self setTestProvider:[[MobilyApiProvider alloc] initWithName:@"test" url:[NSURL URLWithString:@"http://144.76.71.48/api/v1"]]];
    [[MobilyApiManager shared] registerProvider:_testProvider];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (BOOL)launchingWithOptions:(NSDictionary *)options {
    BOOL result = [super launchingWithOptions:options];
    if(result == YES) {
        MobilyApiRequest* request = [[MobilyApiRequest alloc] initWithMethodType:MobilyApiRequestHttpMethodTypeGet
                                                                     relativeUrl:nil
                                                                      paramsType:MobilyApiRequestParamsTypeUrl
                                                                          params:@{
                                                                                   @"m": @"user.checktoken",
                                                                                   @"token" : @"00001.000001.uyetr56whgd67sghd6e8g"
                                                                                   }
                                                                     attachments:nil
                                                                 numberOfRetries:0];
        [_testProvider sendRequest:request byTarget:self successBlock:^(MobilyApiRequest* request, MobilyApiResponse* response) {
            NSLog(@"%@ - %@", request, response);
        } failureBlock:^(MobilyApiRequest* request, MobilyApiResponse* response) {
            NSLog(@"%@ - %@", request, response);
        }];
    }
    return result;
}

@end

/*--------------------------------------------------*/
