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

typedef void(^MobilyAudioPlayerBlock)();
typedef void(^MobilyAudioPlayerErrorBlock)(NSError* error);

/*--------------------------------------------------*/

@protocol MobilyAudioPlayerDelegate;

/*--------------------------------------------------*/

@interface MobilyAudioPlayer : NSObject < MobilyObject >

@property(nonatomic, readonly, strong) NSURL* url;
@property(nonatomic, readonly, assign) NSUInteger numberOfChannels;
@property(nonatomic, readwrite, assign) NSTimeInterval currentTime;
@property(nonatomic, readonly, assign) NSTimeInterval duration;
@property(nonatomic, readwrite, assign) CGFloat volume;
@property(nonatomic, readwrite, assign) CGFloat pan;
@property(nonatomic, readwrite, assign) BOOL enableRate;
@property(nonatomic, readwrite, assign) CGFloat rate;
@property(nonatomic, readwrite, assign) NSInteger numberOfLoops;
@property(nonatomic, readwrite, assign, getter=isMeteringEnabled) BOOL meteringEnabled;
@property(nonatomic, readonly, assign) CGFloat peakPower;
@property(nonatomic, readonly, assign) CGFloat averagePower;

@property(nonatomic, readonly, assign, getter=isPrepared) BOOL prepared;
@property(nonatomic, readonly, assign, getter=isPlaying) BOOL playing;
@property(nonatomic, readonly, assign, getter=isPaused) BOOL paused;

@property(nonatomic, readwrite, weak) id< MobilyAudioPlayerDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock preparedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock cleanedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock playingBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock stopedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock finishedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock resumedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerBlock pausedBlock;
@property(nonatomic, readwrite, copy) MobilyAudioPlayerErrorBlock decodeErrorBlock;

- (BOOL)prepareWithName:(NSString*)name;
- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name;
- (BOOL)prepareWithUrl:(NSURL*)url;
- (void)prepareWithUrl:(NSURL*)url success:(MobilyAudioPlayerBlock)success failure:(MobilyAudioPlayerBlock)failure;
- (void)clean;

- (BOOL)play;
- (void)stop;

- (void)resume;
- (void)pause;

- (void)updateMeters;

- (CGFloat)peakPowerForChannel:(NSUInteger)channelNumber;
- (CGFloat)averagePowerForChannel:(NSUInteger)channelNumber;

@end

/*--------------------------------------------------*/

@protocol MobilyAudioPlayerDelegate < NSObject >

@optional
-(void)audioPlayerDidPrepared:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidCleaned:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidPlaying:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidStoped:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidFinished:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidPaused:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayerDidResumed:(MobilyAudioPlayer*)audioPlayer;
-(void)audioPlayer:(MobilyAudioPlayer*)audioPlayer didDecodeError:(NSError*)encodeError;

@end

/*--------------------------------------------------*/
