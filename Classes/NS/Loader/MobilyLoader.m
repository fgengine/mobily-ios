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

#import "MobilyLoader.h"

/*--------------------------------------------------*/

typedef void (^MobilyLoaderBlock)();

/*--------------------------------------------------*/

@interface MobilyLoader ()

@property(nonatomic, readwrite, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, strong) MobilyCache* cache;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyLoaderTask : MobilyTask

@property(nonatomic, readwrite, weak) MobilyLoader* loader;
@property(nonatomic, readwrite, weak) id< MobilyLoaderDelegate > loaderDelegate;
@property(nonatomic, readwrite, weak) MobilyCache* loaderCache;
@property(nonatomic, readwrite, strong) id target;
@property(nonatomic, readwrite, strong) NSString* path;
@property(nonatomic, readwrite, strong) id entry;
@property(nonatomic, readwrite, assign) NSUInteger countErrors;
@property(nonatomic, readwrite, strong) id< MobilyEvent > completeEvent;
@property(nonatomic, readwrite, strong) id< MobilyEvent > failureEvent;

- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target;
- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target completeBlock:(MobilyLoaderCompleteBlock)completeBlock failureBlock:(MobilyLoaderFailureBlock)failureBlock;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_LOADER_MAX_CONCURRENT_TASK           5

/*--------------------------------------------------*/

@implementation MobilyLoader

#pragma mark Standart

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id< MobilyLoaderDelegate >)delegate {
    self = [super init];
    if(self != nil) {
        [self setDelegate:delegate];
        [self setTaskManager:[[MobilyTaskManager alloc] init]];
        if(_taskManager != nil) {
            [_taskManager setMaxConcurrentTask:MOBILY_LOADER_MAX_CONCURRENT_TASK];
        }
        [self setCache:[MobilyCache shared]];
    }
    return self;
}

- (void)dealloc {
    [self setTaskManager:nil];
    [self setCache:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (BOOL)isExistEntryByPath:(NSString*)path {
    return ([_cache cacheDataForKey:path] != nil);
}

- (BOOL)setEntry:(id)entry byPath:(NSString*)path {
    NSData* data = nil;
    if(entry != nil) {
        if([_delegate respondsToSelector:@selector(loader:entryToData:)] == YES) {
            data = [_delegate loader:self entryToData:entry];
        } else if([entry isKindOfClass:[NSData class]] == YES) {
            data = entry;
        }
        if(data != nil) {
            [_cache setCacheData:data forKey:path];
        }
    }
    return (data != nil);
}

- (void)removeEntryByPath:(NSString*)path {
    [_cache removeCacheDataForKey:path];
}

- (id)entryByPath:(NSString*)path {
    id entry = nil;
    id data = [_cache cacheDataForKey:path];
    if(data != nil) {
        if([_delegate respondsToSelector:@selector(loader:entryFromData:)] == YES) {
            entry = [_delegate loader:self entryFromData:data];
        } else {
            entry = data;
        }
    }
    return entry;
}

- (void)cleanup {
    [_taskManager cancelAllTasks];
    [_cache removeAllCachedData];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)loadWithPath:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    if([path length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:path];
        if(data != nil) {
            if([_delegate respondsToSelector:@selector(loader:entryFromData:)] == YES) {
                entry = [_delegate loader:self entryFromData:data];
            } else {
                entry = data;
            }
        }
        if(entry == nil) {
            MobilyLoaderTask* task = [[MobilyLoaderTask alloc] initWithLoader:self path:path target:target completeSelector:completeSelector failureSelector:failureSelector];
            if(task != nil) {
                [_taskManager updating];
                [_taskManager addTask:task];
                [_taskManager updated];
            } else {
                if([target respondsToSelector:failureSelector] == YES) {
                    [target performSelector:failureSelector withObject:path];
                }
            }
        } else {
            if([target respondsToSelector:completeSelector] == YES) {
                [target performSelector:completeSelector withObject:entry withObject:path];
            }
        }
    } else {
        if([target respondsToSelector:failureSelector] == YES) {
            [target performSelector:failureSelector withObject:path];
        }
    }
}
#pragma clang diagnostic pop

- (void)loadWithPath:(NSString*)path target:(id)target completeBlock:(MobilyLoaderCompleteBlock)completeBlock failureBlock:(MobilyLoaderFailureBlock)failureBlock {
    if([path length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:path];
        if(data != nil) {
            if([_delegate respondsToSelector:@selector(loader:entryFromData:)] == YES) {
                entry = [_delegate loader:self entryFromData:data];
            } else {
                entry = data;
            }
        }
        if(entry == nil) {
            MobilyLoaderTask* task = [[MobilyLoaderTask alloc] initWithLoader:self path:path target:target completeBlock:completeBlock failureBlock:failureBlock];
            if(task != nil) {
                [_taskManager updating];
                [_taskManager addTask:task];
                [_taskManager updated];
            } else {
                if(failureBlock != nil) {
                    failureBlock(path);
                }
            }
        } else {
            if(completeBlock != nil) {
                completeBlock(entry, path);
            }
        }
    } else {
        if(failureBlock != nil) {
            failureBlock(path);
        }
    }
}

- (void)cancelByPath:(NSString*)path {
    [_taskManager enumirateTasksUsingBlock:^(MobilyLoaderTask* task, BOOL* stop) {
        if([[task path] isEqualToString:path] == YES) {
            [task cancel];
        }
    }];
}

- (void)cancelByTarget:(id)target {
    [_taskManager enumirateTasksUsingBlock:^(MobilyLoaderTask* task, BOOL* stop) {
        if([task target] == target) {
            [task cancel];
        }
    }];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_LOADER_TASK_ERROR_LIMITS             5
#define MOBILY_LOADER_TASK_IMAGE_DELAY              1.0f

/*--------------------------------------------------*/

@implementation MobilyLoaderTask

#pragma mark Standart

- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target {
    self = [super init];
    if(self != nil) {
        [self setLoader:loader];
        [self setLoaderDelegate:[_loader delegate]];
        [self setLoaderCache:[_loader cache]];
        [self setTarget:target];
        [self setPath:path];
    }
    return self;
}

- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    self = [self initWithLoader:loader path:path target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventSelector callbackWithTarget:target action:completeSelector inMainThread:YES]];
        [self setFailureEvent:[MobilyEventSelector callbackWithTarget:target action:failureSelector inMainThread:YES]];
    }
    return self;
}

- (id)initWithLoader:(MobilyLoader*)loader path:(NSString*)path target:(id)target completeBlock:(MobilyLoaderCompleteBlock)completeBlock failureBlock:(MobilyLoaderFailureBlock)failureBlock {
    self = [self initWithLoader:loader path:path target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(completeBlock != nil) {
                completeBlock(_entry, _path);
            }
            return nil;
        } inMainQueue:YES]];
        [self setFailureEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(failureBlock != nil) {
                failureBlock(_path);
            }
            return nil;
        } inMainQueue:YES]];
    }
    return self;
}

- (void)dealloc {
    [self setLoader:nil];
    [self setLoaderDelegate:nil];
    [self setLoaderCache:nil];
    [self setTarget:nil];
    [self setPath:nil];
    [self setEntry:nil];
    [self setCompleteEvent:nil];
    [self setFailureEvent:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyTask

- (void)working {
    id entry = nil;
    NSData* data = [_loaderCache cacheDataForKey:_path];
    if(data != nil) {
        if([_loaderDelegate respondsToSelector:@selector(loader:entryFromData:)] == YES) {
            entry = [_loaderDelegate loader:_loader entryFromData:data];
        } else {
            entry = data;
        }
    }
    if(entry == nil) {
        if([_loaderDelegate respondsToSelector:@selector(loader:dataForPath:)] == YES) {
            entry = [_loaderDelegate loader:_loader dataForPath:_path];
        } else {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_path]];
        }
        if(data != nil) {
            if([_loaderDelegate respondsToSelector:@selector(loader:entryFromData:)] == YES) {
                entry = [_loaderDelegate loader:_loader entryFromData:data];
            } else {
                entry = data;
            }
            if(entry != nil) {
                [_loaderCache setCacheData:data forKey:_path];
                [self setEntry:entry];
                [self setNeedRework:NO];
            }
        } else {
            if(_countErrors < MOBILY_LOADER_TASK_ERROR_LIMITS) {
                [self setCountErrors:_countErrors + 1];
                [self setNeedRework:YES];
            } else {
                [self setNeedRework:NO];
            }
#if defined(MOBILY_DEBUG)
            NSLog(@"Failure load:%@", _path);
#endif
            [NSThread sleepForTimeInterval:MOBILY_LOADER_TASK_IMAGE_DELAY];
        }
    } else {
        [self setEntry:entry];
    }
}

- (void)didComplete {
    if(_entry != nil) {
        [_completeEvent fireSender:_entry object:_path];
    } else {
        [_failureEvent fireSender:_path object:nil];
    }
}

- (void)cancel {
    [self setCompleteEvent:nil];
    [self setFailureEvent:nil];
    [super cancel];
}

@end

/*--------------------------------------------------*/
