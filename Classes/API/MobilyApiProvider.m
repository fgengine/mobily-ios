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

#import "MobilyApiProvider.h"
#import "MobilyApiRequest.h"
#import "MobilyApiResponse.h"
#import "MobilyHttpQuery.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyApiProvider ()

@property(nonatomic, readwrite, strong) NSString* name;
@property(nonatomic, readwrite, strong) NSURL* url;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyApiProviderTask : MobilyTaskHttpQuery

@property(nonatomic, readwrite, weak) MobilyApiProvider* provider;
@property(nonatomic, readwrite, strong) MobilyApiRequest* request;
@property(nonatomic, readwrite, strong) MobilyApiResponse* response;
@property(nonatomic, readwrite, strong) id target;
@property(nonatomic, readwrite, strong) id< MobilyEvent > completeEvent;
@property(nonatomic, readwrite, assign) NSUInteger numberOfErrors;

- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target;
- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target completeSelector:(SEL)completeSelector;
- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target completeBlock:(MobilyApiProviderCompleteBlock)completeBlock;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiProvider

#pragma mark Init

- (id)initWithName:(NSString*)name url:(NSURL*)url {
    self = [super init];
    if(self != nil) {
        [self setName:name];
        [self setUrl:url];
    }
    return self;
}

- (void)dealloc {
    [self setManager:nil];
    [self setTaskManager:nil];
    [self setCache:nil];
    [self setName:nil];
    [self setUrl:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setManager:(MobilyApiManager*)manager {
    if(_manager != manager) {
        if(_manager != nil) {
            [_manager unregisterProvider:self];
        }
        MOBILY_SAFE_SETTER(_manager, manager);
        if(_manager != nil) {
            [_manager registerProvider:self];
        }
    }
}

- (MobilyTaskManager*)taskManager {
    if((_manager != nil) && (_taskManager == nil)) {
        [self setTaskManager:[_manager taskManager]];
    }
    return _taskManager;
}

- (MobilyCache*)cache {
    if((_manager != nil) && (_cache == nil)) {
        [self setCache:[_manager cache]];
    }
    return _cache;
}

#pragma mark Public

- (void)sendRequest:(MobilyApiRequest*)request byTarget:(id)target completeSelector:(SEL)completeSelector {
    [[self taskManager] addTask:[[MobilyApiProviderTask alloc] initWithProvider:self request:request target:target completeSelector:completeSelector]];
}

- (void)sendRequest:(MobilyApiRequest*)request byTarget:(id)target completeBlock:(MobilyApiProviderCompleteBlock)completeBlock {
    [[self taskManager] addTask:[[MobilyApiProviderTask alloc] initWithProvider:self request:request target:target completeBlock:completeBlock]];
}

- (void)cancelByRequest:(MobilyApiRequest*)request {
    [[self taskManager] enumirateTasksUsingBlock:^(MobilyApiProviderTask* task, BOOL* stop) {
        if([[task request] isEqual:request] == YES) {
            [task cancel];
        }
    }];
}

- (void)cancelByTarget:(id)target {
    [[self taskManager] enumirateTasksUsingBlock:^(MobilyApiProviderTask* task, BOOL* stop) {
        if([task target] == target) {
            [task cancel];
        }
    }];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyApiProviderTask

#pragma mark Init

- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target {
    self = [super init];
    if(self != nil) {
        [self setProvider:provider];
        [self setRequest:request];
        [self setTarget:target];
    }
    return self;
}

- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target completeSelector:(SEL)completeSelector {
    self = [self initWithProvider:provider request:request target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventSelector callbackWithTarget:target action:completeSelector inMainThread:YES]];
    }
    return self;
}

- (id)initWithProvider:(MobilyApiProvider*)provider request:(MobilyApiRequest*)request target:(id)target completeBlock:(MobilyApiProviderCompleteBlock)completeBlock {
    self = [self initWithProvider:provider request:request target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(completeBlock != nil) {
                completeBlock(_request, _response);
            }
            return nil;
        } inMainQueue:YES]];
    }
    return self;
}

- (void)dealloc {
    [self setTarget:nil];
    [self setCompleteEvent:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyTask

- (BOOL)willStart {
    MobilyHttpQuery* httpQuery = [_request httpQueryByBaseUrl:[_provider url]];
    if(httpQuery != nil) {
        [self setHttpQuery:httpQuery];
    }
    return [super willStart];
}

- (void)working {
    [super working];
    
    [self setResponse:[_request responseByHttpQuery:[self httpQuery]]];
    if([_response isValid] == NO) {
        if([_request numberOfRetries] == NSNotFound) {
            [self setNeedRework:YES];
        } else {
            if(_numberOfErrors != [_request numberOfRetries]) {
                [self setNumberOfErrors:_numberOfErrors + 1];
                [self setNeedRework:YES];
            }
        }
    }
}

- (void)didComplete {
    [super didComplete];
    
    [_completeEvent fireSender:_request object:_response];
}

@end

/*--------------------------------------------------*/
