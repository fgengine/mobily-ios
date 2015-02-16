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

#import "MobilyTransitionController.h"

/*--------------------------------------------------*/

#define MOBILY_TRANSITION_CONTROLLER_CLASS          @"MobilyTransitionController%@"

/*--------------------------------------------------*/

@implementation NSString (MobilyTransitionController)

- (MobilyTransitionController*)convertToTransitionController {
    static NSCharacterSet* characterSet = nil;
    if(characterSet == nil) {
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@":-"];
    }
    
    __block NSString* validKey = [NSString string];;
    NSArray* components = [self componentsSeparatedByCharactersInSet:characterSet];
    if([components count] > 1) {
        [components enumerateObjectsUsingBlock:^(NSString* component, NSUInteger index, BOOL* stop) {
            validKey = [validKey stringByAppendingString:[component stringByUppercaseFirstCharacterString]];
        }];
    } else {
        validKey = [self stringByUppercaseFirstCharacterString];
    }
    
    Class resultClass = nil;
    if([validKey length] > 0) {
        Class defaultClass = NSClassFromString([NSString stringWithFormat:MOBILY_TRANSITION_CONTROLLER_CLASS, validKey]);
        if([defaultClass isSubclassOfClass:[MobilyTransitionController class]] == YES) {
            resultClass = defaultClass;
        } else {
            Class customClass = NSClassFromString(self);
            if([customClass isSubclassOfClass:[MobilyTransitionController class]] == YES) {
                resultClass = customClass;
            }
        }
    }
    
    MobilyTransitionController* result = nil;
    if(resultClass != nil) {
        result = [[resultClass alloc] init];
    }
    return result;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTransitionController

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setDuration:1.0f];
}

- (void)dealloc {
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)animateTransition:(id< UIViewControllerContextTransitioning >)transitionContext fromVC:(UIViewController*)fromVC toVC:(UIViewController*)toVC fromView:(UIView*)fromView toView:(UIView*)toView {
}

#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id< UIViewControllerContextTransitioning >)transitionContext {
    return _duration;
}

- (void)animateTransition:(id< UIViewControllerContextTransitioning >)transitionContext {
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:[fromVC view] toView:[toVC view]];
}

@end

/*--------------------------------------------------*/
