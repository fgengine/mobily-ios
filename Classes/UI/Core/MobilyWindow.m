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

#import "MobilyWindow.h"
#import "MobilyApplication.h"
#import "MobilyEvent.h"

/*--------------------------------------------------*/

@interface MobilyWindow ()

@property(nonatomic, readwrite, assign) BOOL isNeedLoad;

@property(nonatomic, readwrite, strong) UIView* emptyView;
@property(nonatomic, readwrite, strong) UITapGestureRecognizer* emptyTabGesture;
@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* emptyPanGesture;

- (void)willShowKeyboard:(NSNotification*)notification;
- (void)didHideKeyboard:(NSNotification*)notification;

- (void)resignCurrentFirstResponder;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyWindow

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

MOBILY_DEFINE_VALIDATE_EVENT(EventDidLoad)
MOBILY_DEFINE_VALIDATE_EVENT(EventDidUnload)

#pragma mark Standart

- (id)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self != nil) {
        [self setupWindow];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupWindow];
    }
    return self;
}

- (void)dealloc {
    [_eventDidUnload fireSender:self object:nil];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    [self setEmptyView:nil];
    [self setEmptyTabGesture:nil];
    [self setEmptyPanGesture:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIViewController class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIViewController class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovedObject:objectChild]];
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
        [self setEmptyView:[[UIView alloc] initWithFrame:[self bounds]]];
        if(_emptyView != nil) {
            [_emptyView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            [_emptyView setBackgroundColor:[UIColor clearColor]];
            [_emptyView setHidden:YES];
            [self addSubview:_emptyView];
            
            [self setEmptyTabGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)]];
            if(_emptyTabGesture != nil) {
                [_emptyView addGestureRecognizer:_emptyTabGesture];
            }
            
            [self setEmptyPanGesture:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)]];
            if(_emptyPanGesture != nil) {
                [_emptyView addGestureRecognizer:_emptyPanGesture];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
    if([self rootViewController] == nil) {
        UIViewController* controller = [_eventDidLoad fireSender:self object:nil];
        if(controller != nil) {
            [self setRootViewController:controller];
        } else if([_objectChilds count] > 0) {
            [self setRootViewController:[_objectChilds firstObject]];
        }
    }
}

- (void)resignKeyWindow {
    [super resignKeyWindow];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didAddSubview:(UIView*)subview {
    [super didAddSubview:subview];
    [self bringSubviewToFront:_emptyView];
}

- (void)willRemoveSubview:(UIView*)subview {
    [super willRemoveSubview:subview];
    [self bringSubviewToFront:_emptyView];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView* result = nil;
    if([_emptyView isHidden] == NO) {
        UIViewController* rootController = [self rootViewController];
        if([rootController presentedViewController] != nil) {
            rootController = [rootController presentedViewController];
        }
        result = [[rootController view] hitTest:point withEvent:event];
        if([result canBecomeFirstResponder] == NO) {
            if([result isKindOfClass:[UIControl class]] == YES) {
                UIControl* control = (UIControl*)result;
                if([control isEnabled] == NO) {
                    result = _emptyView;
                }
            } else {
                result = _emptyView;
            }
        }
    } else {
        result = [super hitTest:point withEvent:event];
    }
    return result;
}

#pragma mark Public

- (void)setupWindow {
}

#pragma mark Private

- (void)willShowKeyboard:(NSNotification*)notification {
    [_emptyView setHidden:NO];
}

- (void)didHideKeyboard:(NSNotification*)notification {
    [_emptyView setHidden:YES];
}

- (void)resignCurrentFirstResponder {
    UIResponder* firstResponder = [UIResponder currentFirstResponder];
    if(firstResponder != nil) {
        [firstResponder resignFirstResponder];
    }
}

@end

/*--------------------------------------------------*/
