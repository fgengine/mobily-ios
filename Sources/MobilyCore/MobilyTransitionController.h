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

#import <MobilyCore/MobilyBuilder.h>

/*--------------------------------------------------*/

@class MobilyTransitionController;

/*--------------------------------------------------*/

@interface NSString (MobilyTransitionController)

- (MobilyTransitionController*)convertToTransitionController;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyTransitionOperation) {
    MobilyTransitionOperationPresent,
    MobilyTransitionOperationDismiss,
    MobilyTransitionOperationPush,
    MobilyTransitionOperationPop
};

/*--------------------------------------------------*/

@interface MobilyTransitionController : NSObject < MobilyObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning >

@property(nonatomic, readwrite, weak) id< UIViewControllerContextTransitioning > transitionContext;
@property(nonatomic, readwrite, assign) MobilyTransitionOperation operation;
@property(nonatomic, readwrite, assign) NSTimeInterval duration;
@property(nonatomic, readonly, assign) CGFloat percentComplete;
@property(nonatomic, readwrite, assign) CGFloat completionSpeed;
@property(nonatomic, readwrite, assign) UIViewAnimationCurve completionCurve;
@property(nonatomic, readonly, assign, getter=isInteractive) BOOL interactive;

- (void)setup NS_REQUIRES_SUPER;

- (BOOL)isAnimated;
- (BOOL)isCancelled;

- (void)beginInteractive;
- (void)updateInteractive:(CGFloat)percentComplete;
- (void)finishInteractive;
- (void)cancelInteractive;
- (void)endInteractive;

@end

/*--------------------------------------------------*/

@interface MobilyTransitionControllerCrossFade : MobilyTransitionController

@end

/*--------------------------------------------------*/

@interface MobilyTransitionControllerCards : MobilyTransitionController

@end

/*--------------------------------------------------*/

@interface MobilyTransitionControllerSlide : MobilyTransitionController

@property(nonatomic, readwrite, assign) CGFloat ratio;

- (instancetype)initWithRatio:(CGFloat)ratio;

@end

/*--------------------------------------------------*/

#define MOBILY_DEFINE_VALIDATE_TRANSITION_CONTROLLER(name) \
- (BOOL)validate##name:(inout id*)value error:(out NSError** __unused)error { \
    if([*value isKindOfClass:NSString.class] == YES) { \
        *value = [*value convertToTransitionController]; \
    } \
    return [*value isKindOfClass:MobilyTransitionController.class]; \
}

/*--------------------------------------------------*/
