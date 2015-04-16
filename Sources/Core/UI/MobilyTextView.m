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

#import <MobilyTextView.h>
#import <MobilyFieldValidation.h>

/*--------------------------------------------------*/

#define MOBILY_DURATION                             0.2f
#define MOBILY_TOOLBAR_HEIGHT                       44.0f

/*--------------------------------------------------*/

@interface MobilyTextView ()

@property(nonatomic, readwrite, weak) UIResponder* prevInputResponder;
@property(nonatomic, readwrite, weak) UIResponder* nextInputResponder;

- (void)pressedPrev;
- (void)pressedNext;
- (void)pressedDone;
 
@end

/*--------------------------------------------------*/

@implementation MobilyTextView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;
@synthesize validator = _validator;
@synthesize form = _form;

#pragma mark NSKeyValueCoding

#pragma mark Init / Free

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
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
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didBeginEditing) name:UITextViewTextDidBeginEditingNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didEndEditing) name:UITextViewTextDidEndEditingNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didValueChanged) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds unionWithArrays:self.subviews, nil];
    }
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild];
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

#pragma mark Property

- (void)setHiddenToolbar:(BOOL)hiddenToolbar {
    [self setHiddenToolbar:hiddenToolbar animated:NO];
}

#pragma mark Public

- (void)setHiddenToolbar:(BOOL)hiddenToolbar animated:(BOOL)animated {
    if(_hiddenToolbar != hiddenToolbar) {
        _hiddenToolbar = hiddenToolbar;
        
        if([self isEditing] == YES) {
            CGFloat toolbarHeight = (_hiddenToolbar == NO) ? MOBILY_TOOLBAR_HEIGHT : 0.0f;
            if(animated == YES) {
                [UIView animateWithDuration:MOBILY_DURATION
                                 animations:^{
                                     _toolbar.frameHeight = toolbarHeight;
                                 }];
            } else {
                _toolbar.frameHeight = toolbarHeight;
            }
        }
    }
}

- (void)didBeginEditing {
    if(_toolbar == nil) {
        CGRect windowBounds = self.window.bounds;
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(windowBounds.origin.x, windowBounds.origin.y, windowBounds.size.width, MOBILY_TOOLBAR_HEIGHT)];
        if(_toolbar != nil) {
            self.prevButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedPrev)];
            self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedNext)];
            self.flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressedDone)];
            
            _toolbar.items = @[_prevButton, _nextButton, _flexButton, _doneButton];
            _toolbar.barStyle = UIBarStyleDefault;
            _toolbar.clipsToBounds = YES;
        }
    }
    if(_toolbar != nil) {
        _prevInputResponder = [UIResponder prevResponderFromView:self];
        _nextInputResponder = [UIResponder nextResponderFromView:self];
        _prevButton.enabled = (_prevInputResponder != nil);
        _nextButton.enabled = (_nextInputResponder != nil);
        _toolbar.frameHeight = (_hiddenToolbar == NO) ? MOBILY_TOOLBAR_HEIGHT : 0.0f;
        self.inputAccessoryView = _toolbar;
        [self reloadInputViews];
    }
}

- (void)didEndEditing {
    _prevInputResponder = nil;
    _nextInputResponder = nil;
}

- (void)validate {
    if(_validator != nil) {
        if([_validator validate:self.text] == YES) {
            [_form validatedSuccess:self andValue:self.text];
        } else {
            [_form validatedFail:self andValue:self.text];
        }
    }
}

- (void)didValueChanged {
    [self validate];
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
    [self endEditing:NO];
}

@end

/*--------------------------------------------------*/
