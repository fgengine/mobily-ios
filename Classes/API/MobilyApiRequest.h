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

#import "MobilyApiManager.h"
#import "MobilyModel.h"

/*--------------------------------------------------*/

@class MobilyApiResponse;
@class MobilyHttpQuery;

/*--------------------------------------------------*/

@interface MobilyApiRequest : MobilyModel

@property(nonatomic, readonly, strong) NSString* method;
@property(nonatomic, readonly, strong) NSString* relativeUrl;
@property(nonatomic, readonly, strong) NSDictionary* urlParams;
@property(nonatomic, readonly, strong) NSDictionary* bodyParams;
@property(nonatomic, readonly, strong) NSArray* attachments;
@property(nonatomic, readonly, assign) NSUInteger numberOfRetries;

- (id)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams;
- (id)initWithGetRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams numberOfRetries:(NSUInteger)numberOfRetries;
- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams;
- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams numberOfRetries:(NSUInteger)numberOfRetries;
- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments;
- (id)initWithPostRelativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries;
- (id)initWithMethod:(NSString*)method relativeUrl:(NSString*)relativeUrl urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams attachments:(NSArray*)attachments numberOfRetries:(NSUInteger)numberOfRetries;

- (MobilyHttpQuery*)httpQueryByBaseUrl:(NSURL*)baseUrl;
- (MobilyApiResponse*)responseByHttpQuery:(MobilyHttpQuery*)httpQuery;

@end

/*--------------------------------------------------*/
