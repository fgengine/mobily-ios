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

#import "MobilyAV.h"

/*--------------------------------------------------*/

typedef void(^MobilyAudioRecorderBlock)();
typedef void(^MobilyAudioRecorderErrorBlock)(NSError* error);

/*--------------------------------------------------*/

@interface MobilyAudioRecorder : NSObject

@property(nonatomic, readwrite, assign) AudioFormatID format;
@property(nonatomic, readwrite, assign) AVAudioQuality quality;
@property(nonatomic, readwrite, assign) NSUInteger bitRate;
@property(nonatomic, readwrite, assign) NSUInteger numberOfChannels;
@property(nonatomic, readwrite, assign) CGFloat sampleRate;
@property(nonatomic, readonly, strong) NSURL* url;
@property(nonatomic, readonly, assign) NSTimeInterval duration;

@property(nonatomic, readonly, assign, getter=isPrepared) BOOL prepared;
@property(nonatomic, readonly, assign, getter=isStarted) BOOL started;
@property(nonatomic, readonly, assign, getter=isRecording) BOOL recording;

@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock startBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock stopBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock finishBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock resumeBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock pauseBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderErrorBlock encodeErrorBlock;

- (void)setup;

- (BOOL)prepareWithName:(NSString*)name;
- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name;
- (BOOL)prepareWithUrl:(NSURL*)url;
- (void)clean;

- (BOOL)start;
- (void)stop;

- (void)resume;
- (void)pause;

@end

/*--------------------------------------------------*/
