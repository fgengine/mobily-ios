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

#import "MobilyTextField.h"
#import "MobilyFieldValidation.h"

/*--------------------------------------------------*/

#define MOBILY_DURATION                             0.2f
#define MOBILY_TOOLBAR_HEIGHT                       44.0f

/*--------------------------------------------------*/

const NSString* kPhoneEmptySymbol = @"_";

/*--------------------------------------------------*/

@interface MobilyTextField ()

@property(nonatomic, readwrite, weak) UIResponder* prevInputResponder;
@property(nonatomic, readwrite, weak) UIResponder* nextInputResponder;

@property(nonatomic, readwrite, strong) NSMutableArray* phoneFormatSymbols;

- (void)pressedPrev;
- (void)pressedNext;
- (void)pressedDone;
 
@end

/*--------------------------------------------------*/

@implementation MobilyTextField

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
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didEndEditing) name:UITextFieldTextDidEndEditingNotification object:self];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didValueChanged) name:UITextFieldTextDidChangeNotification object:self];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
    
    self.toolbar = nil;
    self.prevButton = nil;
    self.nextButton = nil;
    self.flexButton = nil;
    self.doneButton = nil;
    
    self.prevInputResponder = nil;
    self.nextInputResponder = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    return [_objectChilds unionWithArray:self.subviews];
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

- (void)setPhoneFormat:(NSString *)phoneFormat {
    if([phoneFormat isEqualToString:_phoneFormat] == NO) {
        _phoneFormat = phoneFormat;
        
        self.phoneFormatSymbols = NSMutableArray.array;
        
        /*
        [[_phoneFormat charactersArray] each:^(NSString* ichar) {
            if([ichar isEqualToString:@"#"]) {
                [_phoneFormatSymbols addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"digit": @(YES), @"value": kPhoneEmptySymbol}]];
            } else {
                [_phoneFormatSymbols addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"digit": @(NO), @"value": ichar}]];
            }
        }];
         */
    }
}

#pragma mark Public

- (NSString*)getDigitsOnly {
    __block NSString* result = @"";
    if(_phoneFormatSymbols.count > 0) {
        [_phoneFormatSymbols each:^(NSMutableDictionary* object) {
            if([object[@"digit"] boolValue] == YES) {
                if([object[@"value"] isEqualToString:(NSString*)kPhoneEmptySymbol] == NO) {
                    result = [result stringByAppendingString:object[@"value"]];
                }
            }
        }];
    }
    if(result.length == 0) {
        result = self.text;
    }
    return result;
}

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
    if(_phoneFormat != nil) {
        if(_phoneFormatSymbols.count == 0) {
            self.phoneFormatSymbols = NSMutableArray.array;
            if(self.text.length > 0) {
                for(int i = 0; i < self.text.length; i ++) {
                    NSString* phoneFormatChar = [NSString stringWithFormat:@"%c", [_phoneFormat characterAtIndex:i]];
                    [_phoneFormatSymbols addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                   @"digit": @([phoneFormatChar isEqualToString:@"#"]),
                                                                                                   @"value": [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]]
                                                                                                   }]];
                }
            } else {
                [[_phoneFormat charactersArray] each:^(NSString* ichar) {
                    if([ichar isEqualToString:@"#"]) {
                        [_phoneFormatSymbols addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"digit": @(YES), @"value": kPhoneEmptySymbol}]];
                    } else {
                        [_phoneFormatSymbols addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"digit": @(NO), @"value": ichar}]];
                    }
                }];
            }
        }
        [self updateTextWithPhoneFormat];
    }
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
    }
}

- (void)didEndEditing {
    if(_phoneFormat != nil) {
        if([self allDigitsEntered] == NO) {
            self.text = @"";
            [_phoneFormatSymbols each:^(NSMutableDictionary* object) {
                if([object[@"digit"] boolValue] == YES) {
                    object[@"value"] = kPhoneEmptySymbol;
                }
            }];
        }
    }
    
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
    if(_phoneFormat != nil) {
        if(self.text.length < _phoneFormatSymbols.count) {
            for(unsigned long i=_phoneFormatSymbols.count-1; i > 0; i--) {
                if([_phoneFormatSymbols[i][@"digit"] boolValue] == YES) {
                    if([_phoneFormatSymbols[i][@"value"] isEqualToString:(NSString*)kPhoneEmptySymbol] == NO) {
                        _phoneFormatSymbols[i][@"value"] = kPhoneEmptySymbol;
                        break;
                    }
                }
            }
        } else {
            for(int i=0; i < self.text.length; i++) {
                NSString* ichar  = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
                if(i < _phoneFormatSymbols.count) {
                     if([_phoneFormatSymbols[i][@"digit"] boolValue] == YES) {
                         if([_phoneFormatSymbols[i][@"value"] isEqualToString:ichar] == NO) {
                                _phoneFormatSymbols[i][@"value"] = ichar;
                                break;
                         }
                     }
                     
                }
            }
        }
        [self updateTextWithPhoneFormat];
    }
    
    [self validate];
}

#pragma mark Private

- (void)updateTextWithPhoneFormat {
    self.text = [self getPhoneFormattedText];
    NSInteger index = [_phoneFormatSymbols indexOfObjectPassingTest:^BOOL(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        return ([obj[@"value"] isEqualToString:(NSString*)kPhoneEmptySymbol]);
    }];
    if(index != NSNotFound) {
        [self selectTextAtIndex:index];
    }
}

- (NSString*)getPhoneFormattedText {
    __block NSString* result = @"";
    [_phoneFormatSymbols each:^(NSDictionary* object) {
        result = [result stringByAppendingString:object[@"value"]];
    }];
    return result;
}

- (void)selectTextAtIndex:(NSInteger)index {
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument] offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

- (BOOL)allDigitsEntered {
    __block BOOL result = YES;
    [_phoneFormatSymbols each:^(NSDictionary* object) {
        if([object[@"digit"] boolValue] == YES) {
            if([object[@"value"] isEqualToString:(NSString*)kPhoneEmptySymbol]) {
                result = NO;
            }
        }
    }];
    
    return result;
}

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
