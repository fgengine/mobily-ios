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

#import "DemoAudioRecorderController.h"

/*--------------------------------------------------*/

#define UPDATE_INTERVAL 0.25f
#define MAXIMUM_DURATION 60.0f

/*--------------------------------------------------*/

@implementation DemoAudioRecorderController

- (void)setup {
    [super setup];
    
    [self setTitle:@"AudioRecorder"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak id selfWeak = self;
    
    [self setAudioRecorder:[[MobilyAudioRecorder alloc] init]];
    if(_audioRecorder != nil) {
#if defined(MOBILY_SIMULATOR)
        [_audioRecorder setFormat:kAudioFormatAppleIMA4];
        [_audioRecorder prepareWithName:@"Test.caf"];
#elif defined(MOBILY_DEVICE)
        [_audioRecorder setFormat:kAudioFormatMPEG4AAC];
        [_audioRecorder prepareWithName:@"Test.m4a"];
#endif
        [_audioRecorder setStartBlock:^{
            [[selfWeak timer] start];
            [selfWeak updateButtonState];
        }];
        [_audioRecorder setStopBlock:^{
            [selfWeak updateButtonState];
        }];
        [_audioRecorder setPauseBlock:^{
            [selfWeak updateButtonState];
        }];
        [_audioRecorder setResumeBlock:^{
            [selfWeak updateButtonState];
        }];
        [_audioRecorder setFinishBlock:^{
            [selfWeak updateButtonState];
        }];
    }
    [self setTimer:[MobilyTimer timerWithInterval:UPDATE_INTERVAL repeat:MAXIMUM_DURATION / UPDATE_INTERVAL]];
    if(_timer != nil) {
        [_timer setRepeatBlock:^{
            [selfWeak updateLabelState];
        }];
    }
    [self updateButtonState];
}

#pragma mark Private

- (void)updateLabelState {
    NSDictionary* attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[[_audioRecorder url] absoluteString] error:nil];
    
    [_elapsedTimeLabel setText:[NSString stringWithFormat:@"%d s", (int)[_audioRecorder duration]]];
    [_fileSizeLabel setText:[NSString stringWithFormat:@"%d kb", (int)([attrs fileSize] / 1024)]];
}

- (void)updateButtonState {
    [_startButton setEnabled:([_audioRecorder isPrepared] == YES) && ([_audioRecorder isStarted] == NO)];
    [_stopButton setEnabled:([_audioRecorder isPrepared] == YES) && ([_audioRecorder isStarted] == YES)];
    [_pauseButton setEnabled:([_audioRecorder isPrepared] == YES) && ([_audioRecorder isStarted] == YES) && ([_audioRecorder isRecording] == YES)];
    [_resumeButton setEnabled:([_audioRecorder isPrepared] == YES) && ([_audioRecorder isStarted] == YES) && ([_audioRecorder isRecording] == NO)];
}

#pragma mark Action

- (IBAction)pressedStartButton:(id)sender {
    [_audioRecorder start];
}

- (IBAction)pressedStopButton:(id)sender {
    [_audioRecorder stop];
}

- (IBAction)pressedPauseButton:(id)sender {
    [_audioRecorder pause];
    [self updateButtonState];
}

- (IBAction)pressedResumeButton:(id)sender {
    [_audioRecorder resume];
    [self updateButtonState];
}

@end

/*--------------------------------------------------*/
