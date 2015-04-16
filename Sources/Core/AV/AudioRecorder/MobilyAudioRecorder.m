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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyAudioRecorder.h>

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

- (instancetype)initWithCoder:(NSCoder* __unused)coder {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.format = kAudioFormatAppleIMA4;
    self.quality = AVAudioQualityMin;
    self.bitRate = 16;
    self.numberOfChannels = 1;
    self.sampleRate = 44100.0f;
}

- (void)dealloc {
    self.recorder = nil;
    self.preparedBlock = nil;
    self.cleanedBlock = nil;
    self.startedBlock = nil;
    self.stopedBlock = nil;
    self.finishedBlock = nil;
    self.resumedBlock = nil;
    self.pausedBlock = nil;
    self.encodeErrorBlock = nil;
}

#pragma mark Property

- (void)setRecorder:(AVAudioRecorder*)recorder {
    if(_recorder != recorder) {
        if(_recorder != nil) {
            _recorder.delegate = nil;
        }
        _recorder = recorder;
        if(_recorder != nil) {
            _recorder.delegate = self;
        }
    }
}

- (BOOL)isRecording {
    return _recorder.isRecording;
}

- (NSURL*)url {
    return _recorder.url;
}

- (NSTimeInterval)duration {
    if(_recorder.isRecording == YES) {
        self.duration = _recorder.currentTime;
    }
    return _duration;
}

- (BOOL)isMeteringEnabled {
    return _recorder.isMeteringEnabled;
}

- (CGFloat)peakPower {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        for(NSUInteger channel = 0; channel < _numberOfChannels; channel++) {
            result += [_recorder peakPowerForChannel:channel];
        }
        result /= _numberOfChannels;
    }
    return result;
}

- (CGFloat)averagePower {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        for(NSUInteger channel = 0; channel < _numberOfChannels; channel++) {
            result += [_recorder averagePowerForChannel:channel];
        }
        result /= _numberOfChannels;
    }
    return result;
}

#pragma mark Public

- (BOOL)prepareWithName:(NSString*)name {
    return [self prepareWithPath:NSFileManager.documentDirectory name:name];
}

- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name {
    return [self prepareWithUrl:[NSURL URLWithString:[path stringByAppendingPathComponent:name]]];
}

- (BOOL)prepareWithUrl:(NSURL*)url {
    if(_prepared == NO) {
        NSError* error = nil;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self recorderSettings] error:&error];
        if(_recorder != nil) {
            if([_recorder prepareToRecord] == YES) {
                self.prepared = YES;
                if([_delegate respondsToSelector:@selector(audioRecorderDidPrepared:)] == YES) {
                    [_delegate audioRecorderDidPrepared:self];
                } else if(_preparedBlock != nil) {
                    _preparedBlock();
                }
            }
        } else if(error != nil) {
            NSLog(@"MobilyAudioRecorder::prepareWithUrl:%@ Error=%@", url, error.localizedDescription);
        }
    }
    return _prepared;
}

- (void)clean {
    if(_prepared == YES) {
        [self stop];
        self.prepared = NO;
        self.recorder = nil;
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
            self.started = YES;
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
        self.duration = _recorder.currentTime;
        self.waitFinished = YES;
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
        self.paused = YES;
        self.duration = _recorder.currentTime;
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
        self.paused = NO;
        [_recorder record];
        if([_delegate respondsToSelector:@selector(audioRecorderDidResumed:)] == YES) {
            [_delegate audioRecorderDidResumed:self];
        } else if(_resumedBlock != nil) {
            _resumedBlock();
        }
    }
}

- (void)updateMeters {
    if(_prepared == YES) {
        [_recorder updateMeters];
    }
}

- (CGFloat)peakPowerForChannel:(NSUInteger)channelNumber {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        result = [_recorder peakPowerForChannel:channelNumber];
    }
    return result;
}

- (CGFloat)averagePowerForChannel:(NSUInteger)channelNumber {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        result = [_recorder averagePowerForChannel:channelNumber];
    }
    return result;
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

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder* __unused)recorder successfully:(BOOL __unused)successfully {
    self.waitFinished = NO;
    self.started = NO;
    if([_delegate respondsToSelector:@selector(audioRecorderDidFinished:)] == YES) {
        [_delegate audioRecorderDidFinished:self];
    } else if(_finishedBlock != nil) {
        _finishedBlock();
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder* __unused)recorder error:(NSError* __unused)error {
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
