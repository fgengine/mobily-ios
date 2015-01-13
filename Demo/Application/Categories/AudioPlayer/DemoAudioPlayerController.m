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

#import "DemoAudioPlayerController.h"

/*--------------------------------------------------*/

#define UPDATE_INTERVAL 0.1f

/*--------------------------------------------------*/

@implementation DemoAudioPlayerController

- (void)setup {
    [super setup];
    
    [self setTitle:@"AudioPlayer"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError* error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if(error != nil) {
        NSLog(@"AVAudioSession: %@", [error localizedDescription]);
    }
    
    [self setTimer:[MobilyTimer timerWithInterval:UPDATE_INTERVAL]];
    if(_timer != nil) {
        [_timer setDelegate:self];
    }
    [self setAudioPlayer:[[MobilyAudioPlayer alloc] init]];
    if(_audioPlayer != nil) {
        [_audioPlayer setDelegate:self];
        [_audioPlayer prepareWithName:@"TestMusic.m4a"];
    }
    [self updateButtonState];
}

#pragma mark Private

- (void)updateLabelState {
    [_currentTimeLabel setText:[NSString stringWithFormat:@"%0.2f s", [_audioPlayer currentTime]]];
    [_currentTimeSlider setValue:[_audioPlayer currentTime]];
}

- (void)updateButtonState {
    [_playButton setEnabled:([_audioPlayer isPrepared] == YES) && ([_audioPlayer isPlaying] == NO)];
    [_stopButton setEnabled:([_audioPlayer isPrepared] == YES) && ([_audioPlayer isPlaying] == YES)];
    [_pauseButton setEnabled:([_audioPlayer isPrepared] == YES) && ([_audioPlayer isPlaying] == YES) && ([_audioPlayer isPaused] == NO)];
    [_resumeButton setEnabled:([_audioPlayer isPrepared] == YES) && ([_audioPlayer isPlaying] == YES) && ([_audioPlayer isPaused] == YES)];
}

#pragma mark MobilyTimerDelegate

-(void)timerDidStarted:(MobilyTimer*)timer {
    [self updateLabelState];
}

-(void)timerDidRepeat:(MobilyTimer*)timer {
    [self updateLabelState];
}

-(void)timerDidStoped:(MobilyTimer*)timer {
    [_audioPlayer stop];
    [self updateLabelState];
}

#pragma mark MobilyAudioPlayerDelegate

-(void)audioPlayerDidPrepared:(MobilyAudioPlayer*)audioPlayer {
    [_timer setRepeat:[_audioPlayer duration] / UPDATE_INTERVAL];
    [_currentTimeSlider setMaximumValue:[_audioPlayer duration]];
    [_currentTimeSlider setValue:[_audioPlayer currentTime]];
    [_durationLabel setText:[NSString stringWithFormat:@"%0.2f s", [_audioPlayer duration]]];
    [_volumeSlider setValue:[_audioPlayer volume]];
    [_volumeLabel setText:[NSString stringWithFormat:@"%0.1f s", [_audioPlayer volume]]];
    [_panSlider setValue:[_audioPlayer pan]];
    [_panLabel setText:[NSString stringWithFormat:@"%0.1f s", [_audioPlayer pan]]];
}

-(void)audioPlayerDidCleaned:(MobilyAudioPlayer*)audioPlayer {
}

-(void)audioPlayerDidPlaying:(MobilyAudioPlayer*)audioPlayer {
    [_timer start];
    [self updateButtonState];
}

-(void)audioPlayerDidStoped:(MobilyAudioPlayer*)audioPlayer {
    [_timer stop];
    [self updateButtonState];
}

-(void)audioPlayerDidFinished:(MobilyAudioPlayer*)audioPlayer {
    [_timer stop];
    [self updateButtonState];
}

-(void)audioPlayerDidPaused:(MobilyAudioPlayer*)audioPlayer {
    [_timer pause];
    [self updateButtonState];
}

-(void)audioPlayerDidResumed:(MobilyAudioPlayer*)audioPlayer {
    [_timer resume];
    [self updateButtonState];
}

-(void)audioPlayer:(MobilyAudioPlayer*)audioPlayer didDecodeError:(NSError*)encodeError {
}

#pragma mark Action

- (IBAction)pressedPlayButton:(id)sender {
    [_audioPlayer play];
}

- (IBAction)pressedStopButton:(id)sender {
    [_audioPlayer stop];
}

- (IBAction)pressedPauseButton:(id)sender {
    [_audioPlayer pause];
    [self updateButtonState];
}

- (IBAction)pressedResumeButton:(id)sender {
    [_audioPlayer resume];
    [self updateButtonState];
}

- (IBAction)changedCurrentTimeSlider:(id)sender {
    [_audioPlayer setCurrentTime:[_currentTimeSlider value]];
    [_currentTimeLabel setText:[NSString stringWithFormat:@"%0.2f s", [_audioPlayer currentTime]]];
}

- (IBAction)changedVolumeSlider:(id)sender {
    [_audioPlayer setVolume:[_volumeSlider value]];
    [_volumeLabel setText:[NSString stringWithFormat:@"%0.1f s", [_audioPlayer volume]]];
}

- (IBAction)changedPanSlider:(id)sender {
    [_audioPlayer setPan:[_panSlider value]];
    [_panLabel setText:[NSString stringWithFormat:@"%0.1f s", [_audioPlayer pan]]];
}

@end

/*--------------------------------------------------*/
