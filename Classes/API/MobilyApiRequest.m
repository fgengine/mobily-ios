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

#import "MobilyApiRequest.h"
#import "MobilyApiResponse.h"
#import "MobilyHttpQuery.h"

/*--------------------------------------------------*/

@interface MobilyApiRequest ()

@property(nonatomic, readwrite, assign) MobilyApiRequestHttpMethodType methodType;
@property(nonatomic, readwrite, strong) NSString* relativeUrl;
@property(nonatomic, readwrite, assign) MobilyApiRequestParamsType paramsType;
@property(nonatomic, readwrite, strong) NSDictionary* params;
@property(nonatomic, readwrite, strong) NSArray* attachments;
@property(nonatomic, readwrite, assign) NSUInteger numberOfRetries;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiRequest

#pragma mark MobilyModel

+ (NSArray*)compareMap {
    return @[
        @"methodType",
        @"relativeUrl",
        @"paramsType",
        @"params",
        @"attachments"
    ];
}

+ (NSArray*)serializeMap {
    return @[
        @"methodType",
        @"relativeUrl",
        @"paramsType",
        @"params",
        @"attachments",
        @"numberOfRetries"
    ];
}

#pragma mark Init

- (id)initWithMethodType:(MobilyApiRequestHttpMethodType)methodType relativeUrl:(NSString*)relativeUrl paramsType:(MobilyApiRequestParamsType)paramsType params:(NSDictionary*)params attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    self = [super init];
    if(self != nil) {
        [self setMethodType:methodType];
        [self setRelativeUrl:relativeUrl];
        [self setParamsType:paramsType];
        [self setParams:params];
        [self setAttachments:attachments];
        [self setNumberOfRetries:numberOfRetries];
    }
    return self;
}

- (void)dealloc {
    [self setParams:nil];
    [self setAttachments:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (MobilyHttpQuery*)httpQueryByBaseUrl:(NSURL*)baseUrl {
    MobilyHttpQuery* httpQuery = [[MobilyHttpQuery alloc] init];
    switch(_methodType) {
        case MobilyApiRequestHttpMethodTypeGet:
            [httpQuery setRequestMethod:@"GET"];
            break;
        case MobilyApiRequestHttpMethodTypePost:
            [httpQuery setRequestMethod:@"POST"];
            break;
    }
    if([_relativeUrl length] > 0) {
        [httpQuery setRequestUrl:[NSURL URLWithString:[[baseUrl absoluteString] stringByAppendingPathComponent:_relativeUrl]]];
    } else {
        [httpQuery setRequestUrl:baseUrl];
    }
    switch(_paramsType) {
        case MobilyApiRequestParamsTypeUrl:
            [httpQuery setRequestUrlParams:_params];
            break;
        case MobilyApiRequestParamsTypeFormData:
            if([_attachments count] > 0) {
                [httpQuery setRequestBodyParams:_params boundary:@"boundary" attachments:_attachments];
            } else {
                [httpQuery setRequestBodyParams:_params];
            }
            break;
    }
    return httpQuery;
}

- (MobilyApiResponse*)responseByHttpQuery:(MobilyHttpQuery*)httpQuery {
    return [[MobilyApiResponse alloc] initWithHttpQuery:httpQuery];
}

@end

/*--------------------------------------------------*/
