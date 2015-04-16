/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyApiRequest.h>
#import <MobilyApiResponse.h>
#import <MobilyHttpQuery.h>

/*--------------------------------------------------*/

@interface MobilyApiRequest () {
    NSString* _method;
    NSString* _relativeUrl;
    NSDictionary* _urlParams;
    NSDictionary* _headers;
    NSDictionary* _bodyParams;
    NSArray* _attachments;
    NSUInteger _numberOfRetries;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiRequest

#pragma mark MobilyModel

@synthesize method = _method;
@synthesize relativeUrl = _relativeUrl;
@synthesize urlParams = _urlParams;
@synthesize headers = _headers;
@synthesize bodyParams = _bodyParams;
@synthesize attachments = _attachments;
@synthesize numberOfRetries = _numberOfRetries;

#pragma mark MobilyModel

+ (NSArray*)compareMap {
    return @[
        @"method",
        @"relativeUrl",
        @"urlParams",
        @"headers",
        @"bodyParams",
        @"attachments"
    ];
}

+ (NSArray*)serializeMap {
    return @[
        @"method",
        @"relativeUrl",
        @"urlParams",
        @"headers",
        @"bodyParams",
        @"attachments",
        @"numberOfRetries"
    ];
}

#pragma mark Init / Free

- (instancetype)initWithGetRelativeUrl:(NSString*)relativeUrl {
    return [self initWithMethod:@"GET" relativeUrl:relativeUrl urlParams:nil headers:nil bodyParams:nil attachments:nil numberOfRetries:0];
}

- (instancetype)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams {
    return [self initWithMethod:@"GET" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:nil attachments:nil numberOfRetries:0];
}

- (instancetype)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"GET" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:nil attachments:nil numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl bodyParams:(NSDictionary*)bodyParams {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:nil bodyParams:bodyParams attachments:nil numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:nil bodyParams:bodyParams attachments:nil numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:nil bodyParams:bodyParams attachments:attachments numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:nil bodyParams:bodyParams attachments:attachments numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:headers bodyParams:bodyParams attachments:nil numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:headers bodyParams:bodyParams attachments:nil numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:headers bodyParams:bodyParams attachments:attachments numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:nil headers:headers bodyParams:bodyParams attachments:attachments numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:bodyParams attachments:nil numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:bodyParams attachments:nil numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:bodyParams attachments:attachments numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:nil bodyParams:bodyParams attachments:attachments numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:headers bodyParams:bodyParams attachments:nil numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:headers bodyParams:bodyParams attachments:nil numberOfRetries:numberOfRetries];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:headers bodyParams:bodyParams attachments:attachments numberOfRetries:0];
}

- (instancetype)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams headers:headers bodyParams:bodyParams attachments:attachments numberOfRetries:numberOfRetries];
}

- (instancetype)initWithMethod:(NSString*)method relativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams headers:(NSDictionary*)headers bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    self = [super init];
    if(self != nil) {
        _method = method;
        _relativeUrl = relativeUrl;
        _urlParams = urlParams;
        _headers = headers;
        _bodyParams = bodyParams;
        _attachments = attachments;
        _numberOfRetries = numberOfRetries;
        [self setup];
    }
    return self;
}

#pragma mark Debug

- (NSString*)description {
    NSMutableArray* result = NSMutableArray.array;
    [result addObject:[NSMutableString stringWithFormat:@"Method = \"%@\";", _method]];
    if(_relativeUrl.length > 0) {
        [result addObject:[NSMutableString stringWithFormat:@"RelativeURL = \"%@\";", _relativeUrl]];
    }
    if(_urlParams.count > 0) {
        NSMutableArray* temp = NSMutableArray.array;
        [_urlParams each:^(id key, id value) {
            [temp addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\";", [key description], [value description]]];
        }];
        [result addObject:[NSString stringWithFormat:@"UrlParams [%@]", [temp componentsJoinedByString:@", "]]];
    }
    if(_headers.count > 0) {
        NSMutableArray* temp = NSMutableArray.array;
        [_headers each:^(id key, id value) {
            [temp addObject:[NSString stringWithFormat:@"\t\"%@\" = \"%@\";", [key description], [value description]]];
        }];
        [result addObject:[NSString stringWithFormat:@"Headers [%@];", [temp componentsJoinedByString:@", "]]];
    }
    if(_bodyParams.count > 0) {
        NSMutableArray* temp = NSMutableArray.array;
        [_bodyParams each:^(id key, id value) {
            [temp addObject:[NSString stringWithFormat:@"\t\"%@\" = \"%@\";", [key description], [value description]]];
        }];
        [result addObject:[NSString stringWithFormat:@"BodyParams [%@];", [temp componentsJoinedByString:@", "]]];
    }
    if(_attachments.count > 0) {
        NSMutableArray* temp = NSMutableArray.array;
        for(MobilyHttpAttachment* attachment in _attachments) {
            [temp addObject:[attachment description]];
        }
        [result addObject:[NSString stringWithFormat:@"Attachments [%@];", [temp componentsJoinedByString:@", "]]];
    }
    return [result componentsJoinedByString:@", "];
}

#pragma mark Public

- (MobilyHttpQuery*)httpQueryByBaseUrl:(NSURL*)baseUrl {
    MobilyHttpQuery* httpQuery = [MobilyHttpQuery new];
    if(_method.length > 0) {
        httpQuery.requestMethod = _method;
    }
    if(_relativeUrl.length > 0) {
        NSMutableString* mutableBaseUrl = [NSMutableString stringWithString:baseUrl.absoluteString];
        if([mutableBaseUrl characterAtIndex:mutableBaseUrl.length - 1] != '/') {
            [mutableBaseUrl appendFormat:@"/%@", _relativeUrl];
        } else {
            [mutableBaseUrl appendString:_relativeUrl];
        }
        httpQuery.requestUrl = [NSURL URLWithString:mutableBaseUrl];
    } else {
        httpQuery.requestUrl = baseUrl;
    }
    if(_urlParams.count > 0) {
        httpQuery.requestUrlParams = _urlParams;
    }
    if(_attachments.count > 0) {
        [httpQuery setRequestBodyParams:_bodyParams boundary:@"MobilyBoundary" attachments:_attachments];
    } else {
        [httpQuery setRequestBodyParams:_bodyParams];
    }
    return httpQuery;
}

- (MobilyApiResponse*)responseByHttpQuery:(MobilyHttpQuery*)httpQuery {
    return [[MobilyApiResponse alloc] initWithHttpQuery:httpQuery];
}

@end

/*--------------------------------------------------*/
