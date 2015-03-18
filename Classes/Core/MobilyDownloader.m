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

- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target;
- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock;

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
                shared = [self new];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id< MobilyDownloaderDelegate >)delegate {
    self = [super init];
    if(self != nil) {
        self.delegate = delegate;
        self.taskManager = [MobilyTaskManager new];
        if(_taskManager != nil) {
            _taskManager.maxConcurrentTask = MOBILY_LOADER_MAX_CONCURRENT_TASK;
        }
        self.cache = [MobilyCache shared];
        
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.taskManager = nil;
    self.cache = nil;
}

#pragma mark Public

- (BOOL)isExistEntryByUrl:(NSURL*)url {
    return ([_cache cacheDataForKey:url.absoluteString] != nil);
}

- (BOOL)setEntry:(id)entry byUrl:(NSURL*)url {
    NSData* data = nil;
    if(entry != nil) {
        if([_delegate respondsToSelector:@selector(downloader:entryToData:)] == YES) {
            data = [_delegate downloader:self entryToData:entry];
        } else if([entry isKindOfClass:NSData.class] == YES) {
            data = entry;
        }
        if(data != nil) {
            [_cache setCacheData:data forKey:url.absoluteString];
        }
    }
    return (data != nil);
}

- (void)removeEntryByUrl:(NSURL*)url {
    [_cache removeCacheDataForKey:url.absoluteString];
}

- (id)entryByUrl:(NSURL*)url {
    id entry = nil;
    id data = [_cache cacheDataForKey:url.absoluteString];
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
    if([url.absoluteString length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:url.absoluteString];
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
    if([url.absoluteString length] > 0) {
        id entry = nil;
        NSData* data = [_cache cacheDataForKey:url.absoluteString];
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
    [_taskManager enumirateTasksUsingBlock:^(MobilyDownloaderTask* task, BOOL* stop __unused) {
        if([[task url] isEqual:url] == YES) {
            [task cancel];
        }
    }];
}

- (void)cancelByTarget:(id)target {
    [_taskManager enumirateTasksUsingBlock:^(MobilyDownloaderTask* task, BOOL* stop __unused) {
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

#pragma mark Init / Free

- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target {
    self = [super init];
    if(self != nil) {
        self.downloader = downloader;
        self.downloaderDelegate = _downloader.delegate;
        self.downloaderCache = _downloader.cache;
        self.target = target;
        self.url = url;
    }
    return self;
}

- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector {
    self = [self initWithDownloader:downloader url:url target:target];
    if(self != nil) {
        self.completeEvent = [MobilyEventSelector eventWithTarget:target action:completeSelector inMainThread:YES];
        self.failureEvent = [MobilyEventSelector eventWithTarget:target action:failureSelector inMainThread:YES];
    }
    return self;
}

- (instancetype)initWithDownloader:(MobilyDownloader*)downloader url:(NSURL*)url target:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock {
    self = [self initWithDownloader:downloader url:url target:target];
    if(self != nil) {
        self.completeEvent = [MobilyEventBlock eventWithBlock:^id(id entry, NSURL* url) {
            if(completeBlock != nil) {
                completeBlock(entry, url);
            }
            return nil;
        } inMainQueue:YES];
        self.failureEvent = [MobilyEventBlock eventWithBlock:^id(id sender __unused, NSURL* url) {
            if(failureBlock != nil) {
                failureBlock(url);
            }
            return nil;
        } inMainQueue:YES];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.downloader = nil;
    self.downloaderDelegate = nil;
    self.downloaderCache = nil;
    self.target = nil;
    self.url = nil;
    self.entry = nil;
    self.completeEvent = nil;
    self.failureEvent = nil;
}

#pragma mark MobilyTask

- (void)working {
    id entry = nil;
    NSData* data = [_downloaderCache cacheDataForKey:_url.absoluteString];
    if(data != nil) {
        if([_downloaderDelegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
            entry = [_downloaderDelegate downloader:_downloader entryFromData:data];
        } else {
            entry = data;
        }
    }
    if(entry == nil) {
        if([_downloaderDelegate respondsToSelector:@selector(downloader:dataForUrl:)] == YES) {
            data = [_downloaderDelegate downloader:_downloader dataForUrl:_url];
        } else {
            UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
            data = [NSData dataWithContentsOfURL:_url];
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
        }
        if(data != nil) {
            if([_downloaderDelegate respondsToSelector:@selector(downloader:entryFromData:)] == YES) {
                entry = [_downloaderDelegate downloader:_downloader entryFromData:data];
            } else {
                entry = data;
            }
            if(entry != nil) {
                [_downloaderCache setCacheData:data forKey:_url.absoluteString];
                self.entry = entry;
                self.needRework = NO;
            }
        } else {
            if(_countErrors < MOBILY_LOADER_TASK_ERROR_LIMITS) {
                self.countErrors = _countErrors + 1;
                self.needRework = YES;
            } else {
                self.needRework = NO;
            }
#if defined(MOBILY_DEBUG)
            NSLog(@"Failure load:%@", _url);
#endif
            [NSThread sleepForTimeInterval:MOBILY_LOADER_TASK_IMAGE_DELAY];
        }
    } else {
        self.entry = entry;
    }
}

- (void)didComplete {
    if(_entry != nil) {
        [_completeEvent fireSender:_entry object:_url];
    } else {
        [_failureEvent fireSender:self object:_url];
    }
}

- (void)cancel {
    self.completeEvent = nil;
    self.failureEvent = nil;
    [super cancel];
}

@end

/*--------------------------------------------------*/
