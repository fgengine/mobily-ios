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

#import "MobilyDialogController.h"
#import "MobilyApplication.h"
#import "MobilyWindow.h"

/*--------------------------------------------------*/

@interface MobilyDialog ()


@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDialogWindow : MobilyWindow

@property(nonatomic, readwrite, strong) NSMutableArray* dialogControllers;
@property(nonatomic, readwrite, assign, getter=isActive) BOOL active;
@property(nonatomic, readwrite, strong) UIWindow* lastWindow;

+ (instancetype)shared;

- (void)showDialogController:(UIViewController*)viewController animated:(BOOL)animated;
- (UIViewController*)dismissDialogControllerAnimated:(BOOL)animated;
- (NSArray*)dismissAllDialogControllerAnimated:(BOOL)animated;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialog

+ (void)showDialogController:(UIViewController*)viewController animated:(BOOL)animated {
    [[MobilyDialogWindow shared] showDialogController:viewController animated:animated];
}

+ (UIViewController*)dismissDialogControllerAnimated:(BOOL)animated {
    return [[MobilyDialogWindow shared] dismissDialogControllerAnimated:animated];
}

+ (NSArray*)dismissAllDialogControllerAnimated:(BOOL)animated {
    return [[MobilyDialogWindow shared] dismissAllDialogControllerAnimated:animated];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDialogWindow

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.dialogControllers = NSMutableArray.array;
}

- (void)dealloc {
    self.dialogControllers = nil;
}

#pragma mark Private

+ (instancetype)shared {
    static id result = nil;
    if(result == nil) {
        result = [self new];
    }
    return result;
}

- (void)showDialogController:(UIViewController* __unused)viewController animated:(BOOL __unused)animated {
}

- (UIViewController*)dismissDialogControllerAnimated:(BOOL __unused)animated {
    return nil;
}

- (NSArray*)dismissAllDialogControllerAnimated:(BOOL __unused)animated {
    return nil;
}

- (void)setActive:(BOOL)active {
    if(_active != active) {
        if(_active == YES) {
            if(_lastWindow != nil) {
                [_lastWindow makeKeyWindow];
                self.lastWindow = nil;
            }
            [self endEditing:YES];
        }
        _active = active;
        if(_active == YES) {
            self.lastWindow = UIApplication.sharedApplication.keyWindow;
            if(_lastWindow != nil) {
                [_lastWindow endEditing:YES];
            }
            [self makeKeyWindow];
        }
    }
}

@end

/*--------------------------------------------------*/
