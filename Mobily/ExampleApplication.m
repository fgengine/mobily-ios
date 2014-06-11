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

#import "ExampleApplication.h"

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ExampleApplication

- (void)setupApplication {
    [super setupApplication];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (BOOL)launchingWithOptions:(NSDictionary *)options {
    BOOL result = [super launchingWithOptions:options];
    if(result == YES) {
        [_mainSlide setLeftDrawerViewController:_mainMenuLeft];
        [_mainSlide setRightDrawerViewController:_mainMenuRight];
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation ExampleControllerMain

- (void)setupController {
    [super setupController];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"MENU" style:UIBarButtonItemStylePlain target:self action:@selector(pressedMenu)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"PUSH" style:UIBarButtonItemStylePlain target:self action:@selector(pressedPush)]];
    
    [[self view] setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5f]];
}

- (void)pressedMenu {
    [[[MobilyContext application] mainSlide] showLeftDrawerAnimated:YES completion:nil];
}

- (void)pressedPush {
    ExampleControllerMain* controller = [[ExampleControllerMain alloc] init];
    [[self navigationController] pushViewController:controller animated:YES];
}

@end

/*--------------------------------------------------*/
