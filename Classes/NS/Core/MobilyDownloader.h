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

#import "MobilyTaskManager.h"
#import "MobilyCache.h"

/*--------------------------------------------------*/

typedef void (^MobilyDownloaderCompleteBlock)(id entry, NSURL* url);
typedef void (^MobilyDownloaderFailureBlock)(NSURL* url);

/*--------------------------------------------------*/

@protocol MobilyDownloaderDelegate;

/*--------------------------------------------------*/

@interface MobilyDownloader : NSObject< MobilyObject >

@property(nonatomic, readwrite, weak) id< MobilyDownloaderDelegate > delegate;
@property(nonatomic, readonly, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readonly, strong) MobilyCache* cache;

+ (instancetype)shared;

- (instancetype)initWithDelegate:(id< MobilyDownloaderDelegate >)delegate;

- (BOOL)isExistEntryByUrl:(NSURL*)url;
- (BOOL)setEntry:(id)entry byUrl:(NSURL*)url;
- (void)removeEntryByUrl:(NSURL*)url;
- (id)entryByUrl:(NSURL*)url;

- (void)cleanup;

- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (void)downloadWithUrl:(NSURL*)url byTarget:(id)target completeBlock:(MobilyDownloaderCompleteBlock)completeBlock failureBlock:(MobilyDownloaderFailureBlock)failureBlock;
- (void)cancelByUrl:(NSURL*)url;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/

@protocol MobilyDownloaderDelegate < NSObject >

@optional
- (NSData*)downloader:(MobilyDownloader*)downloader dataForUrl:(NSURL*)url;
- (id)downloader:(MobilyDownloader*)downloader entryFromData:(NSData*)data;
- (NSData*)downloader:(MobilyDownloader*)downloader entryToData:(id)entry;

@end

/*--------------------------------------------------*/
