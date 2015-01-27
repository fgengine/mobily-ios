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

#import "MobilyDownloader.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

typedef void (^MobilyDownloaderBlock)();

/*--------------------------------------------------*/

@interface MobilyDownloader ()

@property(nonatomic, readwrite, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readwrite, strong) MobilyCache* cache;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDownloaderTask : MobilyTask

@property(nonatomic, readwrite, weak) MobilyDownloader* downloader;
@property(nonatomic, readwrite, weak) id< MobilyDownloaderDelegate > downloaderDelegate;
@property(nonatomic, readwrite, weak) MobilyCache* downloaderCache;
@property(nonatomic, readwrite, strong) id target;
@property(nonatomic, readwrite, strong) NSURL* url;
@property(nonatomic, readwrite, strong) id entry;
@property(nonatomic, readwrite, assign) NSUInteger countErrors;
@property(nonatomic, readwrite, strong) id< MobilyEvent > completeEvent;
@property(nonatomic, readwrite, strong) id< MobilyEvent > failureEvent;

- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target;
- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#define MOBILY_LOADER_MAX_CONCURRENT_TASK           5

/*--------------------------------------------------*/

@implementation MobilyDownloader

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [[self alloc] init];
            }
        }
    }
    return shared;
}

#pragma mark Standart

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id< MobilyDownloaderDelegate >)delegate {
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

- (BOOL)isExistEntryByUrl:(NSURL*)url {
    return ([_cache cacheDataForKey:[url absoluteString]] != nil);
}

- (BOOL)setEntry:(id)entry byUrl:(NSURL*)url {
    NSData* data = nil;
    if(entry != nil) {
        if([_delegate respondsToSelector:@selector(downloader:entryToData:)] == YES) {
            data = [_delegate downloader:self entryToData:entry];
        } else if([entry isKindOfClass:[NSData class]] == YES) {
            data = entry;
        }
        if(data != nil) {
            [_cache setCacheData:data forKey:[url absoluteString]];
        }
    }
    return (data != nil);
}

- (void)removeEntryByUrl:(NSURL*)url {
    [_cache removeCacheDataForKey:[url absoluteString]];
}

- (id)entryByUrl:(NSURL*)url {
    id entry = nil;
    id data = [_cache cacheDataForKey:[url absoluteString]];
    if(data != nil) {
        if([_delegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
            entry = [_delegate downloader:self entryFromData:data];
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
- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    if([[url absoluteString] length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:[url absoluteString]];
        if(data != nil) {
            if([_delegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
                entry = [_delegate downloader:self entryFromData:data];
            } else {
                entry = data;
            }
        }
        if(entry == nil) {
            MobilyDownloaderTask* task = [[MobilyDownloaderTask alloc] initWithDownloader:self url:url target:target completeSelector:completeSelector failureSelector:failureSelector];
            if(task != nil) {
                [_taskManager updating];
                [_taskManager addTask:task];
                [_taskManager updated];
            } else {
                if([target respondsToSelector:failureSelector] == YES) {
                    [target performSelector:failureSelector withObject:url];
                }
            }
        } else {
            if([target respondsToSelector:completeSelector] == YES) {
                [target performSelector:completeSelector withObject:entry withObject:url];
            }
        }
    } else {
        if([target respondsToSelector:failureSelector] == YES) {
            [target performSelector:failureSelector withObject:url];
        }
    }
}
#pragma clang diagnostic pop

- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock {
    if([[url absoluteString] length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:[url absoluteString]];
        if(data != nil) {
            if([_delegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
                entry = [_delegate downloader:self entryFromData:data];
            } else {
                entry = data;
            }
        }
        if(entry == nil) {
            MobilyDownloaderTask* task = [[MobilyDownloaderTask alloc] initWithDownloader:self url:url target:target completeBlock:completeBlock failureBlock:failureBlock];
            if(task != nil) {
                [_taskManager updating];
                [_taskManager addTask:task];
                [_taskManager updated];
            } else {
                if(failureBlock != nil) {
                    failureBlock(url);
                }
            }
        } else {
            if(completeBlock != nil) {
                completeBlock(entry, url);
            }
        }
    } else {
        if(failureBlock != nil) {
            failureBlock(url);
        }
    }
}

- (void)cancelByUrl:(NSURL*)url {
    [_taskManager enumirateTasksUsingBlock:^(MobilyDownloaderTask* task, BOOL* stop) {
        if([[task url] isEqual:url] == YES) {
            [task cancel];
        }
    }];
}

- (void)cancelByTarget:(id)target {
    [_taskManager enumirateTasksUsingBlock:^(MobilyDownloaderTask* task, BOOL* stop) {
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

@implementation MobilyDownloaderTask

#pragma mark Standart

- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target {
    self = [super init];
    if(self != nil) {
        [self setDownloader:downloader];
        [self setDownloaderDelegate:[_downloader delegate]];
        [self setDownloaderCache:[_downloader cache]];
        [self setTarget:target];
        [self setUrl:url];
    }
    return self;
}

- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    self = [self initWithDownloader:downloader url:url target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventSelector callbackWithTarget:target action:completeSelector inMainThread:YES]];
        [self setFailureEvent:[MobilyEventSelector callbackWithTarget:target action:failureSelector inMainThread:YES]];
    }
    return self;
}

- (id)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock {
    self = [self initWithDownloader:downloader url:url target:target];
    if(self != nil) {
        [self setCompleteEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(completeBlock != nil) {
                completeBlock(_entry, _url);
            }
            return nil;
        } inMainQueue:YES]];
        [self setFailureEvent:[MobilyEventBlock callbackWithBlock:^id(id sender, id object) {
            if(failureBlock != nil) {
                failureBlock(_url);
            }
            return nil;
        } inMainQueue:YES]];
    }
    return self;
}

- (void)dealloc {
    [self setDownloader:nil];
    [self setDownloaderDelegate:nil];
    [self setDownloaderCache:nil];
    [self setTarget:nil];
    [self setUrl:nil];
    [self setEntry:nil];
    [self setCompleteEvent:nil];
    [self setFailureEvent:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyTask

- (void)working {
    id entry = nil;
    NSData* data = [_downloaderCache cacheDataForKey:[_url absoluteString]];
    if(data != nil) {
        if([_downloaderDelegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
            entry = [_downloaderDelegate downloader:_downloader entryFromData:data];
        } else {
            entry = data;
        }
    }
    if(entry == nil) {
        if([_downloaderDelegate respondsToSelector:@selector(downloader:dataForUrl:)] == YES) {
            entry = [_downloaderDelegate downloader:_downloader dataForUrl:_url];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            data = [NSData dataWithContentsOfURL:_url];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        if(data != nil) {
            if([_downloaderDelegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
                entry = [_downloaderDelegate downloader:_downloader entryFromData:data];
            } else {
                entry = data;
            }
            if(entry != nil) {
                [_downloaderCache setCacheData:data forKey:[_url absoluteString]];
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
            NSLog(@"Failure load:%@", _url);
#endif
            [NSThread sleepForTimeInterval:MOBILY_LOADER_TASK_IMAGE_DELAY];
        }
    } else {
        [self setEntry:entry];
    }
}

- (void)didComplete {
    if(_entry != nil) {
        [_completeEvent fireSender:_entry object:_url];
    } else {
        [_failureEvent fireSender:_url object:nil];
    }
}

- (void)cancel {
    [self setCompleteEvent:nil];
    [self setFailureEvent:nil];
    [super cancel];
}

@end

/*--------------------------------------------------*/
