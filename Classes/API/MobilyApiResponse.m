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

#import "MobilyApiResponse.h"

/*--------------------------------------------------*/

@interface MobilyApiResponse ()


@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiResponse

#pragma mark Init

- (id)initWithHttpQuery:(MobilyHttpQuery*)httpQuery {
    self = [super init];
    if(self != nil) {
        [self setValid:[self fromHttpQuery:httpQuery]];
    }
    return self;
}

- (void)dealloc {
    [self setHttpError:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Init

- (BOOL)fromHttpQuery:(MobilyHttpQuery*)httpQuery {
    if([httpQuery error] == nil) {
        NSString* responseMimeType = [httpQuery responseMimeType];
        if(([responseMimeType isEqualToString:@"application/json"] == YES) || ([responseMimeType isEqualToString:@"text/json"] == YES)) {
            id json = [httpQuery responseJson];
            if(json != nil) {
                [self convertFromJson:json];
                return YES;
            }
        }
    } else {
        [self setHttpError:[httpQuery error]];
    }
    return NO;
}

@end

/*--------------------------------------------------*/
