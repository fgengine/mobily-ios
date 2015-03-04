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

#import "MobilyAudioPlayer.h"
#import "MobilyDownloader.h"

/*--------------------------------------------------*/

@interface MobilyAudioPlayer () < AVAudioPlayerDelegate >

@property(nonatomic, readwrite, strong) NSURL* url;
@property(nonatomic, readwrite, assign, getter=isPrepared) BOOL prepared;
@property(nonatomic, readwrite, assign, getter=isPlaying) BOOL playing;
@property(nonatomic, readwrite, assign, getter=isPaused) BOOL paused;

@property(nonatomic, readwrite, strong) AVAudioPlayer* player;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyAudioPlayer

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
}

- (void)dealloc {
    self.url = nil;
    self.player = nil;
    self.preparedBlock = nil;
    self.cleanedBlock = nil;
    self.playingBlock = nil;
    self.stopedBlock = nil;
    self.finishedBlock = nil;
    self.resumedBlock = nil;
    self.pausedBlock = nil;
    self.decodeErrorBlock = nil;
}

#pragma mark Property

- (void)setPlayer:(AVAudioPlayer*)player {
    if(_player != player) {
        if(_player != nil) {
            _player.delegate = nil;
        }
        _player = player;
        if(_player != nil) {
            _player.delegate = self;
        }
    }
}

- (NSUInteger)numberOfChannels {
    return _player.numberOfChannels;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _player.currentTime = currentTime;
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSTimeInterval)duration {
    return _player.duration;
}

- (void)setVolume:(CGFloat)volume {
    _player.volume = volume;
}

- (CGFloat)volume {
    return _player.volume;
}

- (void)setPan:(CGFloat)pan {
    _player.pan = pan;
}

- (CGFloat)pan {
    return _player.pan;
}

- (void)setEnableRate:(BOOL)enableRate {
    _player.enableRate = enableRate;
}

- (BOOL)enableRate {
    return _player.enableRate;
}

- (void)setRate:(CGFloat)rate {
    _player.rate = rate;
}

- (CGFloat)rate {
    return _player.rate;
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops {
    _player.numberOfLoops = numberOfLoops;
}

- (NSInteger)numberOfLoops {
    return _player.numberOfLoops;
}

- (void)setMeteringEnabled:(BOOL)meteringEnabled {
    _player.meteringEnabled = meteringEnabled;
}

- (BOOL)isMeteringEnabled {
    return _player.isMeteringEnabled;
}

- (CGFloat)peakPower {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        for(NSUInteger channel = 0; channel < _player.numberOfChannels; channel++) {
            result += [_player peakPowerForChannel:channel];
        }
        result /= _player.numberOfChannels;
    }
    return result;
}

- (CGFloat)averagePower {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        for(NSUInteger channel = 0; channel < _player.numberOfChannels; channel++) {
            result += [_player averagePowerForChannel:channel];
        }
        result /= _player.numberOfChannels;
    }
    return result;
}

#pragma mark Public

- (BOOL)prepareWithName:(NSString*)name {
    return [self prepareWithPath:NSBundle.mainBundle.resourcePath name:name];
}

- (BOOL)prepareWithPath:(NSString*)path name:(NSString*)name {
    return [self prepareWithUrl:[NSURL URLWithString:[path stringByAppendingPathComponent:name]]];
}

- (BOOL)prepareWithUrl:(NSURL*)url {
    if(_prepared == NO) {
        NSError* error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(_player != nil) {
            if([_player prepareToPlay] == YES) {
                self.url = url;
                self.prepared = YES;
                if([_delegate respondsToSelector:@selector(audioPlayerDidPrepared:)] == YES) {
                    [_delegate audioPlayerDidPrepared:self];
                } else if(_preparedBlock != nil) {
                    _preparedBlock();
                }
            } else {
                self.player = nil;
            }
        } else if(error != nil) {
            NSLog(@"MobilyAudioPlayer::prepareWithUrl:%@ Error=%@", url, error.localizedDescription);
        }
    }
    return _prepared;
}

- (void)prepareWithUrl:(NSURL*)url success:(MobilyAudioPlayerBlock)success failure:(MobilyAudioPlayerBlock)failure {
    if((_prepared == NO) && ([_url isEqual:url] == NO)) {
        if(_player.url != nil) {
            [[MobilyDownloader shared] cancelByTarget:self];
        }
        [[MobilyDownloader shared] downloadWithUrl:url byTarget:self completeBlock:^(NSData* data, NSURL* url) {
            NSError* error = nil;
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
            if(_player != nil) {
                if([_player prepareToPlay] == YES) {
                    self.url = url;
                    self.prepared = YES;
                    if([_delegate respondsToSelector:@selector(audioPlayerDidPrepared:)] == YES) {
                        [_delegate audioPlayerDidPrepared:self];
                    } else if(_preparedBlock != nil) {
                        _preparedBlock();
                    }
                    if(success != nil) {
                        success();
                    }
                } else {
                    self.player = nil;
                }
            } else if(error != nil) {
                NSLog(@"MobilyAudioPlayer::prepareWithUrl:%@ Error=%@", url, error.localizedDescription);
            }
            if((_prepared == NO) && (failure != nil)) {
                failure();
            }
        } failureBlock:^(NSURL *url) {
            if(failure != nil) {
                failure();
            }
        }];
    }
}

- (void)clean {
    if(_prepared == YES) {
        [self stop];
        self.prepared = NO;
        self.player = nil;
        if([_delegate respondsToSelector:@selector(audioPlayerDidCleaned:)] == YES) {
            [_delegate audioPlayerDidCleaned:self];
        } else if(_cleanedBlock != nil) {
            _cleanedBlock();
        }
    }
}

- (BOOL)play {
    if((_prepared == YES) && (_playing == NO)) {
        if([_player play] == YES) {
            self.playing = YES;
            if([_delegate respondsToSelector:@selector(audioPlayerDidPlaying:)] == YES) {
                [_delegate audioPlayerDidPlaying:self];
            } else if(_playingBlock != nil) {
                _playingBlock();
            }
        }
    }
    return _player.isPlaying;
}

- (void)stop {
    if((_prepared == YES) && (_playing == YES)) {
        self.playing = NO;
        _player.currentTime = 0.0f;
        [_player stop];
        if([_delegate respondsToSelector:@selector(audioPlayerDidStoped:)] == YES) {
            [_delegate audioPlayerDidStoped:self];
        } else if(_stopedBlock != nil) {
            _stopedBlock();
        }
    }
}

- (void)resume {
    if((_prepared == YES) && (_playing == YES) && (_paused == YES)) {
        if([_player play] == YES) {
            self.paused = NO;
            if([_delegate respondsToSelector:@selector(audioPlayerDidResumed:)] == YES) {
                [_delegate audioPlayerDidResumed:self];
            } else if(_resumedBlock != nil) {
                _resumedBlock();
            }
        }
    }
}

- (void)pause {
    if((_prepared == YES) && (_playing == YES) && (_paused == NO)) {
        self.paused = YES;
        [_player pause];
        if([_delegate respondsToSelector:@selector(audioPlayerDidPaused:)] == YES) {
            [_delegate audioPlayerDidPaused:self];
        } else if(_pausedBlock != nil) {
            _pausedBlock();
        }
    }
}

- (void)updateMeters {
    if(_prepared == YES) {
        [_player updateMeters];
    }
}

- (CGFloat)peakPowerForChannel:(NSUInteger)channelNumber {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        result = [_player peakPowerForChannel:channelNumber];
    }
    return result;
}

- (CGFloat)averagePowerForChannel:(NSUInteger)channelNumber {
    CGFloat result = 0.0f;
    if(_prepared == YES) {
        result = [_player averagePowerForChannel:channelNumber];
    }
    return result;
}

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)successfully {
    self.playing = NO;
    if([_delegate respondsToSelector:@selector(audioPlayerDidFinished:)] == YES) {
        [_delegate audioPlayerDidFinished:self];
    } else if(_finishedBlock != nil) {
        _finishedBlock();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError*)error {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    NSLog(@"MobilyAudioPlayer::EncodeErrorDidOccur:%@", error);
#endif
    if([_delegate respondsToSelector:@selector(audioPlayer:didDecodeError:)] == YES) {
        [_delegate audioPlayer:self didDecodeError:error];
    } else if(_decodeErrorBlock != nil) {
        _decodeErrorBlock(error);
    }
}

@end

/*--------------------------------------------------*/
