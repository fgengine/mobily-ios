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

@property(nonatomic, readwrite, strong) NSString* method;
@property(nonatomic, readwrite, strong) NSString* relativeUrl;
@property(nonatomic, readwrite, strong) NSDictionary* urlParams;
@property(nonatomic, readwrite, strong) NSDictionary* bodyParams;
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
        @"method",
        @"relativeUrl",
        @"urlParams",
        @"bodyParams",
        @"attachments"
    ];
}

+ (NSArray*)serializeMap {
    return @[
        @"method",
        @"relativeUrl",
        @"urlParams",
        @"bodyParams",
        @"attachments",
        @"numberOfRetries"
    ];
}

#pragma mark Init

- (id)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams {
    return [self initWithMethod:@"GET" relativeUrl:relativeUrl urlParams:urlParams bodyParams:nil attachments:nil numberOfRetries:0];
}

- (id)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"GET" relativeUrl:relativeUrl urlParams:urlParams bodyParams:nil attachments:nil numberOfRetries:numberOfRetries];
}

- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams bodyParams:bodyParams attachments:nil numberOfRetries:0];
}

- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams bodyParams:bodyParams attachments:nil numberOfRetries:numberOfRetries];
}

- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams bodyParams:bodyParams attachments:attachments numberOfRetries:0];
}

- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    return [self initWithMethod:@"POST" relativeUrl:relativeUrl urlParams:urlParams bodyParams:bodyParams attachments:attachments numberOfRetries:numberOfRetries];
}

- (id)initWithMethod:(NSString*)method relativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries {
    self = [super init];
    if(self != nil) {
        [self setMethod:method];
        [self setRelativeUrl:relativeUrl];
        [self setUrlParams:urlParams];
        [self setBodyParams:bodyParams];
        [self setAttachments:attachments];
        [self setNumberOfRetries:numberOfRetries];
    }
    return self;
}

- (void)dealloc {
    [self setMethod:nil];
    [self setRelativeUrl:nil];
    [self setUrlParams:nil];
    [self setBodyParams:nil];
    [self setAttachments:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (MobilyHttpQuery*)httpQueryByBaseUrl:(NSURL*)baseUrl {
    MobilyHttpQuery* httpQuery = [[MobilyHttpQuery alloc] init];
    if([_method length] > 0) {
        [httpQuery setRequestMethod:_method];
    }
    if([_relativeUrl length] > 0) {
        [httpQuery setRequestUrl:[NSURL URLWithString:[[baseUrl absoluteString] stringByAppendingPathComponent:_relativeUrl]]];
    } else {
        [httpQuery setRequestUrl:baseUrl];
    }
    if([_urlParams count] > 0) {
        [httpQuery setRequestUrlParams:_urlParams];
    }
    if([_attachments count] > 0) {
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
