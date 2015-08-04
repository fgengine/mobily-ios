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

#import <MobilyCore/MobilyWindow.h>
#import <MobilyCore/MobilyApplication.h>
#import <MobilyCore/MobilyEvent.h>

/*--------------------------------------------------*/

#import <MobilyCore/MobilyViewController.h>
#import <MobilyCore/MobilyDataCell.h>

/*--------------------------------------------------*/

@interface MobilyWindow () {
@protected
    UIView* _emptyView;
    UITapGestureRecognizer* _emptyTabGesture;
    UIPanGestureRecognizer* _emptyPanGesture;
    MobilyActivityView* _activity;
}

- (void)willShowKeyboard:(NSNotification*)notification;
- (void)didHideKeyboard:(NSNotification*)notification;

- (void)resignCurrentFirstResponder;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyWindow

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_EVENT(EventDidLoad)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidUnload)

#pragma mark Init / Free

- (instancetype)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.automaticallyHideKeyboard = YES;
}

- (void)dealloc {
    [_eventDidUnload fireSender:self object:nil];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds moUnionWithArrays:@[ self.rootViewController ], nil];
    }
    return @[ self.rootViewController ];
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andAddingObject:objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIViewController.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andRemovingObject:objectChild];
    }
}

- (void)willLoadObjectChilds {
}

- (void)didLoadObjectChilds {
}

- (id< MobilyBuilderObject >)objectForName:(NSString*)name {
    return [MobilyBuilderForm object:self forName:name];
}

- (id< MobilyBuilderObject >)objectForSelector:(SEL)selector {
    return [MobilyBuilderForm object:self forSelector:selector];
}

#pragma mark UIWindow

- (void)becomeKeyWindow {
    [super becomeKeyWindow];
    
    if(_emptyView == nil) {
        _emptyView = [[UIView alloc] initWithFrame:self.bounds];
        if(_emptyView != nil) {
            _emptyView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            _emptyView.backgroundColor = [UIColor clearColor];
            _emptyView.hidden = YES;
            [self addSubview:_emptyView];
            
            _emptyTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
            [_emptyView addGestureRecognizer:_emptyTabGesture];
            
            _emptyPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
            [_emptyView addGestureRecognizer:_emptyPanGesture];
        }
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
    if(self.rootViewController == nil) {
        UIViewController* controller = [_eventDidLoad fireSender:self object:nil];
        if(self.rootViewController == nil) {
            if(controller != nil) {
                self.rootViewController = controller;
            } else if(_objectChilds.count > 0) {
                self.rootViewController = _objectChilds.firstObject;
            }
        }
    }
}

- (void)resignKeyWindow {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    if(_emptyView != nil) {
        _emptyView.hidden = YES;
    }
    [super resignKeyWindow];
}

- (void)didAddSubview:(UIView*)subview {
    [super didAddSubview:subview];
    if(_activity != nil) {
        [self bringSubviewToFront:_activity];
    }
    [self bringSubviewToFront:_emptyView];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    if(_emptyView.isHidden == NO) {
        UIViewController* currentController = self.moCurrentController;
        UIViewController* parentController = [currentController parentViewController];
        if(parentController == nil) {
            parentController = currentController;
        }
        if(_automaticallyHideKeyboard == YES) {
            UIView* view = nil;
            if([currentController isKindOfClass:MobilyViewController.class] == YES) {
                MobilyViewController* mobilyViewController = (MobilyViewController*)currentController;
                if(mobilyViewController.isAutomaticallyHideKeyboard == NO) {
                    _emptyView.hidden = YES;
                    view = [super hitTest:point withEvent:event];
                    _emptyView.hidden = NO;
                }
            }
            if(view == nil) {
                view = [parentController.view hitTest:point withEvent:event];
                if(view.canBecomeFirstResponder == NO) {
                    if([view isKindOfClass:UIControl.class] == YES) {
                        UIControl* control = (UIControl*)view;
                        if([control isEnabled] == NO) {
                            view = _emptyView;
                        }
                    } else {
                        UIView* superview = view.superview;
                        if([superview isKindOfClass:[MobilyDataCell class]] == NO) {
                            view = _emptyView;
                        }
                    }
                }
            }
            return view;
        } else {
            _emptyView.hidden = YES;
            UIView* view = [super hitTest:point withEvent:event];
            _emptyView.hidden = NO;
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark Property

- (MobilyActivityView*)activity {
    if(_activity == nil) {
        _activity = [self makeActivity];
    }
    return _activity;
}

#pragma mark Public

- (MobilyActivityView*)makeActivity {
    return [MobilyActivityView activityViewInView:self style:MobilyActivityViewStyleCircle];
}

#pragma mark Private

- (void)willShowKeyboard:(NSNotification* __unused)notification {
    _emptyView.hidden = NO;
}

- (void)didHideKeyboard:(NSNotification* __unused)notification {
    _emptyView.hidden = YES;
}

- (void)resignCurrentFirstResponder {
    UIResponder* responder = UIResponder.moCurrentFirstResponder;
    if(responder != nil) {
        [responder resignFirstResponder];
    }
}

@end

/*--------------------------------------------------*/
