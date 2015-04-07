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

#import "MobilyApiResponse.h"

/*--------------------------------------------------*/

@interface MobilyApiResponse ()


@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiResponse

#pragma mark Init / Free

- (instancetype)initWithHttpQuery:(MobilyHttpQuery*)httpQuery {
    self = [super init];
    if(self != nil) {
        self.validResponse = [self fromHttpQuery:httpQuery];
    }
    return self;
}

- (void)dealloc {
    self.httpError = nil;
}

#pragma mark Public

- (BOOL)fromHttpQuery:(MobilyHttpQuery*)httpQuery {
    if(httpQuery.error == nil) {
        NSString* responseMimeType = httpQuery.responseMimeType;
        if(([responseMimeType isEqualToString:@"application/json"] == YES) || ([responseMimeType isEqualToString:@"text/json"] == YES)) {
            id json = httpQuery.responseJson;
            if(json != nil) {
                [self fromJson:json];
                return YES;
            }
        }
    } else {
        self.httpError = httpQuery.error;
    }
    return NO;
}

@end

/*--------------------------------------------------*/
