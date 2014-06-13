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

#import "MobilyViewFieldText.h"

/*--------------------------------------------------*/

#define MOBILY_TOOLBAR_HEIGHT                       44.0f

/*--------------------------------------------------*/

@interface MobilyViewFieldText ()

@property(nonatomic, readwrite, weak) UIResponder* prevInputResponder;
@property(nonatomic, readwrite, weak) UIResponder* nextInputResponder;

- (void)pressedPrev;
- (void)pressedNext;
- (void)pressedDone;
 
@end

/*--------------------------------------------------*/

@implementation MobilyViewFieldText

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark NSKeyValueCoding

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    [self setToolbar:nil];
    [self setPrevButton:nil];
    [self setNextButton:nil];
    [self setFlexButton:nil];
    [self setDoneButton:nil];
    
    [self setPrevInputResponder:nil];
    [self setNextInputResponder:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild]];
        [self removeSubview:(UIView*)objectChild];
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

#pragma mark Public

- (void)setupView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)didBeginEditing {
    if(_toolbar == nil) {
        CGRect windowBounds = [[self window] bounds];
        [self setToolbar:[[UIToolbar alloc] initWithFrame:CGRectMake(windowBounds.origin.x, windowBounds.origin.y, windowBounds.size.width, MOBILY_TOOLBAR_HEIGHT)]];
        if(_toolbar != nil) {
            [self setPrevButton:[[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedPrev)]];
            [self setNextButton:[[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedNext)]];
            [self setFlexButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
            [self setDoneButton:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressedDone)]];
            
            [_toolbar setItems:@[_prevButton, _nextButton, _flexButton, _doneButton]];
            [_toolbar setBarStyle:UIBarStyleDefault];
        }
    }
    if(_toolbar != nil) {
        _prevInputResponder = [UIResponder prevResponderFromView:self withSuperview:[self superview]];
        _nextInputResponder = [UIResponder nextResponderFromView:self withSuperview:[self superview]];
        [_prevButton setEnabled:(_prevInputResponder != nil)];
        [_nextButton setEnabled:(_nextInputResponder != nil)];
        
        [self setInputAccessoryView:_toolbar];
    }
}

- (void)didEndEditing {
    _prevInputResponder = nil;
    _nextInputResponder = nil;
}

#pragma mark Private

- (void)pressedPrev {
    if(_prevInputResponder != nil) {
        [_prevInputResponder becomeFirstResponder];
    }
}

- (void)pressedNext {
    if(_nextInputResponder != nil) {
        [_nextInputResponder becomeFirstResponder];
    }
}

- (void)pressedDone {
    [self resignFirstResponder];
}


@end

/*--------------------------------------------------*/
