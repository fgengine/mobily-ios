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

#import <Mobily/MobilyAV.h>

/*--------------------------------------------------*/

typedef void(^MobilyAudioRecorderBlock)();
typedef void(^MobilyAudioRecorderErrorBlock)(NSError* error);

/*--------------------------------------------------*/

@protocol MobilyAudioRecorderDelegate;

/*--------------------------------------------------*/

@interface MobilyAudioRecorder : NSObject < MobilyObject >

@property(nonatomic, readwrite, assign) AudioFormatID format;
@property(nonatomic, readwrite, assign) AVAudioQuality quality;
@property(nonatomic, readwrite, assign) NSUInteger bitRate;
@property(nonatomic, readwrite, assign) NSUInteger numberOfChannels;
@property(nonatomic, readwrite, assign) CGFloat sampleRate;
@property(nonatomic, readonly, strong) NSURL* url;
@property(nonatomic, readonly, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, assign, getter=isMeteringEnabled) BOOL meteringEnabled;
@property(nonatomic, readonly, assign) CGFloat peakPower;
@property(nonatomic, readonly, assign) CGFloat averagePower;

@property(nonatomic, readonly, assign, getter=isPrepared) BOOL prepared;
@property(nonatomic, readonly, assign, getter=isStarted) BOOL started;
@property(nonatomic, readonly, assign, getter=isRecording) BOOL recording;
@property(nonatomic, readonly, assign, getter=isPaused) BOOL paused;

@property(nonatomic, readwrite, weak) id< MobilyAudioRecorderDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock preparedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock cleanedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock startedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock stopedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock finishedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock resumedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderBlock pausedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioRecorderErrorBlock encodeErrorBlock;

- (void)setup NS_REQUIRES_SUPER;

- (BOOL)prepareWithName:(NSString*)name;
- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name;
- (BOOL)prepareWithUrl:(NSURL*)url;
- (void)clean;

- (BOOL)start;
- (void)stop;

- (void)resume;
- (void)pause;

- (void)updateMeters;

- (CGFloat)peakPowerForChannel:(NSUInteger)channelNumber;
- (CGFloat)averagePowerForChannel:(NSUInteger)channelNumber;

@end

/*--------------------------------------------------*/

@protocol MobilyAudioRecorderDelegate < NSObject >

@optional
-(void)audioRecorderDidPrepared:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidCleaned:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidStarted:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidStoped:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidFinished:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidPaused:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorderDidResumed:(MobilyAudioRecorder*)audioRecorder;
-(void)audioRecorder:(MobilyAudioRecorder*)audioRecorder didEncodeError:(NSError*)encodeError;

@end

/*--------------------------------------------------*/
