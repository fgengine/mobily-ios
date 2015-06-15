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

#import <MobilyCore/MobilyPopoverController.h>

/*--------------------------------------------------*/

@interface MobilyPopoverController () < UIPopoverControllerDelegate >

@property(nonatomic, readwrite, strong) UIPopoverController* popover;
@property(nonatomic, readwrite, strong) UIView* view;
@property(nonatomic, readwrite, strong) UIView* arrowTargetView;
@property(nonatomic, readwrite, assign) UIPopoverArrowDirection arrowDirection;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyPopoverController

#pragma mark Init/Free

- (instancetype)initWithContentViewController:(UIViewController *)viewController fromView:(UIView*)view arrowTargetView:(UIView*)arrowTargetView arrowDirection:(UIPopoverArrowDirection)arrowDirection {
    self = [super init];
    if(self != nil) {
        viewController.popoverController = self;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:viewController];
        self.popover.delegate = self;
        self.view = view;
        self.arrowTargetView = arrowTargetView;
        self.arrowDirection = arrowDirection;
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Public static

+ (instancetype)presentController:(UIViewController*)controller fromView:(UIView*)view arrowTargetView:(UIView*)arrowTargetView arrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated {
    MobilyPopoverController* popoverController = [[MobilyPopoverController alloc] initWithContentViewController:controller fromView:view arrowTargetView:arrowTargetView arrowDirection:arrowDirection];
    [popoverController presentAnimated:animated];
    return popoverController;
}

#pragma mark Public

- (void)presentAnimated:(BOOL)animated {
    [self.popover presentPopoverFromRect:[_arrowTargetView convertRect:[_arrowTargetView bounds] toView:_view] inView:_view permittedArrowDirections:_arrowDirection animated:animated];
}

- (void)dismissAnimated:(BOOL)animated {
    [_popover dismissPopoverAnimated:animated];
}

#pragma mark UIPopoverControllerDelegate

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view {
    *rect = [_arrowTargetView convertRect:[_arrowTargetView bounds] toView:*view];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

#import <objc/runtime.h>

/*--------------------------------------------------*/

static char const* const MobilyPopoverControllerKey = "popoverControllerKey";

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation UIViewController (MobilyPopoverController)

- (void)setPopoverController:(MobilyPopoverController*)popoverController {
    objc_setAssociatedObject(self, MobilyPopoverControllerKey, popoverController, OBJC_ASSOCIATION_ASSIGN);
}

- (MobilyPopoverController*)popoverController {
    MobilyPopoverController* popoverController = objc_getAssociatedObject(self, MobilyPopoverControllerKey);
    if(popoverController == nil) {
        popoverController = self.parentViewController.popoverController;
    }
    return popoverController;
}

@end

/*--------------------------------------------------*/
