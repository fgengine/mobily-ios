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

typedef void (^MobilyLoaderCompleteBlock)(id entry, NSString* path);
typedef void (^MobilyLoaderFailureBlock)(NSString* path);

/*--------------------------------------------------*/

@protocol MobilyLoaderDelegate;

/*--------------------------------------------------*/

@interface MobilyLoader : NSObject

@property(nonatomic, readwrite, weak) id< MobilyLoaderDelegate > delegate;
@property(nonatomic, readonly, strong) MobilyTaskManager* taskManager;
@property(nonatomic, readonly, strong) MobilyCache* cache;

- (id)initWithDelegate:(id< MobilyLoaderDelegate >)delegate;

- (BOOL)isExistEntryByPath:(NSString*)path;
- (BOOL)setEntry:(id)entry byPath:(NSString*)path;
- (void)removeEntryByPath:(NSString*)path;
- (id)entryByPath:(NSString*)path;

- (void)cleanup;

- (void)loadWithPath:(NSString*)path target:(id)target completeSelector:(SEL)completeSelector failureSelector:(SEL)failureSelector;
- (void)loadWithPath:(NSString*)path target:(id)target completeBlock:(MobilyLoaderCompleteBlock)completeBlock failureBlock:(MobilyLoaderFailureBlock)failureBlock;
- (void)cancelByPath:(NSString*)path;
- (void)cancelByTarget:(id)target;

@end

/*--------------------------------------------------*/

@protocol MobilyLoaderDelegate < NSObject >

@optional
- (NSData*)loader:(MobilyLoader*)mobilyLoader dataForPath:(NSString*)path;
- (id)loader:(MobilyLoader*)mobilyLoader entryFromData:(NSData*)data;
- (NSData*)loader:(MobilyLoader*)mobilyLoader entryToData:(id)entry;

@end

/*--------------------------------------------------*/
