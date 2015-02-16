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

#import "MobilyAudioRecorder.h"

/*--------------------------------------------------*/

@interface MobilyAudioRecorder () < AVAudioRecorderDelegate >

@property(nonatomic, readwrite, assign) NSTimeInterval duration;

@property(nonatomic, readwrite, assign, getter=isPrepared) BOOL prepared;
@property(nonatomic, readwrite, assign, getter=isStarted) BOOL started;
@property(nonatomic, readwrite, assign, getter=isWaitFinished) BOOL waitFinished;
@property(nonatomic, readwrite, assign, getter=isPaused) BOOL paused;

@property(nonatomic, readwrite, strong) AVAudioRecorder* recorder;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyAudioRecorder

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setFormat:kAudioFormatAppleIMA4];
    [self setQuality:AVAudioQualityMin];
    [self setBitRate:16];
    [self setNumberOfChannels:1];
    [self setSampleRate:44100.0f];
}

- (void)dealloc {
    [self setRecorder:nil];
    [self setPreparedBlock:nil];
    [self setCleanedBlock:nil];
    [self setStartedBlock:nil];
    [self setStopedBlock:nil];
    [self setFinishedBlock:nil];
    [self setResumedBlock:nil];
    [self setPausedBlock:nil];
    [self setEncodeErrorBlock:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setRecorder:(AVAudioRecorder*)recorder {
    if(_recorder != recorder) {
        if(_recorder != nil) {
            [_recorder setDelegate:nil];
        }
        MOBILY_SAFE_SETTER(_recorder, recorder);
        if(_recorder != nil) {
            [_recorder setDelegate:self];
        }
    }
}

- (BOOL)isRecording {
    return [_recorder isRecording];
}

- (NSURL*)url {
    return [_recorder url];
}

- (NSTimeInterval)duration {
    if([_recorder isRecording] == YES) {
        [self setDuration:[_recorder currentTime]];
    }
    return _duration;
}

#pragma mark Public

- (BOOL)prepareWithName:(NSString*)name {
    return [self prepareWithPath:[NSFileManager documentDirectory] name:name];
}

- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name {
    return [self prepareWithUrl:[NSURL URLWithString:[path stringByAppendingPathComponent:name]]];
}

- (BOOL)prepareWithUrl:(NSURL*)url {
    if(_prepared == NO) {
        NSError* error = nil;
        [self setRecorder:[[AVAudioRecorder alloc] initWithURL:url settings:[self recorderSettings] error:&error]];
        if(_recorder != nil) {
            if([_recorder prepareToRecord] == YES) {
                [self setPrepared:YES];
                if([_delegate respondsToSelector:@selector(audioRecorderDidPrepared:)] == YES) {
                    [_delegate audioRecorderDidPrepared:self];
                } else if(_preparedBlock != nil) {
                    _preparedBlock();
                }
            }
        } else if(error != nil) {
            NSLog(@"MobilyAudioRecorder::prepareWithUrl:%@ Error=%@", url, [error localizedDescription]);
        }
    }
    return _prepared;
}

- (void)clean {
    if(_prepared == YES) {
        [self stop];
        [self setPrepared:NO];
        [self setRecorder:nil];
        if([_delegate respondsToSelector:@selector(audioRecorderDidCleaned:)] == YES) {
            [_delegate audioRecorderDidCleaned:self];
        } else if(_cleanedBlock != nil) {
            _cleanedBlock();
        }
    }
}

- (BOOL)start {
    if((_prepared == YES) && (_started == NO)) {
        if([_recorder record] == YES) {
            [self setStarted:YES];
            if([_delegate respondsToSelector:@selector(audioRecorderDidStarted:)] == YES) {
                [_delegate audioRecorderDidStarted:self];
            } else if(_startedBlock != nil) {
                _startedBlock();
            }
        }
    }
    return _started;
}

- (void)stop {
    if((_prepared == YES) && (_started == YES) && (_waitFinished == NO)) {
        [self setDuration:[_recorder currentTime]];
        [self setWaitFinished:YES];
        [_recorder stop];
        if([_delegate respondsToSelector:@selector(audioRecorderDidStoped:)] == YES) {
            [_delegate audioRecorderDidStoped:self];
        } else if(_stopedBlock != nil) {
            _stopedBlock();
        }
    }
}

- (void)pause {
    if((_prepared == YES) && (_started == YES) && (_paused == NO)) {
        [self setPaused:YES];
        [self setDuration:[_recorder currentTime]];
        [_recorder pause];
        if([_delegate respondsToSelector:@selector(audioRecorderDidPaused:)] == YES) {
            [_delegate audioRecorderDidPaused:self];
        } else if(_pausedBlock != nil) {
            _pausedBlock();
        }
    }
}

- (void)resume {
    if((_prepared == YES) && (_started == YES) && (_paused == YES)) {
        [self setPaused:NO];
        [_recorder record];
        if([_delegate respondsToSelector:@selector(audioRecorderDidResumed:)] == YES) {
            [_delegate audioRecorderDidResumed:self];
        } else if(_resumedBlock != nil) {
            _resumedBlock();
        }
    }
}

#pragma mark Private

- (NSDictionary*)recorderSettings {
    return @{
        AVFormatIDKey: @(_format),
        AVEncoderAudioQualityKey : @(_quality),
        AVEncoderBitRateKey : @(_bitRate),
        AVNumberOfChannelsKey : @(_numberOfChannels),
        AVSampleRateKey : @(_sampleRate)
    };
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)successfully {
    [self setWaitFinished:NO];
    [self setStarted:NO];
    if([_delegate respondsToSelector:@selector(audioRecorderDidFinished:)] == YES) {
        [_delegate audioRecorderDidFinished:self];
    } else if(_finishedBlock != nil) {
        _finishedBlock();
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder*)recorder error:(NSError*)error {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    NSLog(@"MobilyAudioRecorder::EncodeErrorDidOccur:%@", error);
#endif
    if([_delegate respondsToSelector:@selector(audioRecorder:didEncodeError:)] == YES) {
        [_delegate audioRecorder:self didEncodeError:error];
    } else if(_encodeErrorBlock != nil) {
        _encodeErrorBlock(error);
    }
}

@end

/*--------------------------------------------------*/
