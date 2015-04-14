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

@property(nonatomic, readwrite, assign) NSInteger prevPhoneDigitsCount;
@property(nonatomic, readwrite, assign) NSInteger formatDigitsCount;
@property(nonatomic, readwrite, strong) NSString* phonePrefixWithoutSpaces;

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

- (void)setPhonePrefix:(NSString *)phonePrefix {
    if([_phonePrefix isEqualToString:phonePrefix] == NO) {
        _phonePrefix = phonePrefix;
        self.phonePrefixWithoutSpaces = [[_phonePrefix componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet] componentsJoinedByString:@""];
    }
}

- (void)setPhoneFormat:(NSString *)phoneFormat {
    if([phoneFormat isEqualToString:_phoneFormat] == NO) {
        _phoneFormat = phoneFormat;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:(NSString*)kPhoneEmptySymbol options:NSRegularExpressionCaseInsensitive error:nil];
        self.formatDigitsCount = [regex numberOfMatchesInString:_phoneFormat options:0 range:NSMakeRange(0, _phoneFormat.length)];
    }
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

- (void)setPhoneFormat:(NSString *)phoneFormat withPrefix:(NSString*)phonePrefix {
    self.phonePrefix = phonePrefix;
    self.phoneFormat = phoneFormat;
}

- (void)didBeginEditing {
    if(_phoneFormat != nil) {
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
        NSArray* digits = [self getDigits];
        if(digits.count == 0) {
            self.text = @"";
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
        [self updateTextWithPhoneFormat];
    }
    
    [self validate];
}

#pragma mark Private

- (void)updateTextWithPhoneFormat {
    __block NSString* newValue = [NSString stringWithFormat:@"%@%@",(_phonePrefix != nil) ? _phonePrefix : @"", _phoneFormat];
    NSMutableArray* digits = [self getDigits];
    if(digits.count > 0) {
        if(self.text.length < newValue.length) {
            if(_prevPhoneDigitsCount == digits.count) {
                [digits removeLastObject];
            }
        }
        [digits each:^(NSString* digit) {
            NSRange range = [newValue rangeOfString:(NSString*)kPhoneEmptySymbol];
            if(range.location != NSNotFound) {
                newValue = [newValue stringByReplacingCharactersInRange:range withString:digit];
            }
        }];
    }
    
    self.text = newValue;
    self.prevPhoneDigitsCount = digits.count;
    
    NSRange range = [self.text rangeOfString:(NSString*)kPhoneEmptySymbol];
    if(range.location != NSNotFound) {
        [self selectTextAtIndex:range.location];
    }
}

- (NSMutableArray*)getDigits {
    NSString* text = self.text;
    
    if(_phonePrefix != nil) {
        NSRange range = [text rangeOfString:_phonePrefix];
        if(range.location != NSNotFound) {
            text = [text stringByReplacingCharactersInRange:range withString:@""];
        }
        
        range = [text rangeOfString:_phonePrefixWithoutSpaces];
        if(range.location != NSNotFound) {
            text = [text stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    
    NSArray* digits = [[[text componentsSeparatedByCharactersInSet:NSCharacterSet.decimalDigitCharacterSet.invertedSet] componentsJoinedByString:@""] charactersArray];
    if(_prevPhoneDigitsCount < 1) {
        if(digits.count > _formatDigitsCount) {
            digits = [digits subarrayWithRange:NSMakeRange((digits.count - _formatDigitsCount), _formatDigitsCount)];
        }
    }
    return [digits mutableCopy];
}

- (void)selectTextAtIndex:(NSInteger)index {
    NSRange range = NSMakeRange(index, 0);
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument] offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
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
