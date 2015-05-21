/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to demal in the Software        */
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

#import <MobilyCore/MobilyFieldValidation+Private.h>

/*--------------------------------------------------*/

@implementation MobilyFieldForm

#pragma mark Property

- (void)setControls:(NSArray*)controls {
    NSMutableArray* checkedControls = [NSMutableArray array];
    for(id control in controls) {
        if([control conformsToProtocol:@protocol(MobilyValidatedObject)]) {
            [checkedControls addObject:control];
        }
    }
    if([_controls isEqualToArray:checkedControls] == NO) {
        for(id< MobilyValidatedObject > control in _controls) {
            control.form = nil;
        }
        _controls = checkedControls;
        for(id< MobilyValidatedObject > control in _controls) {
            control.form = self;
        }
        _validatedControls = [NSMutableSet set];
    }
}

- (void)setValid:(BOOL)valid {
    if(_valid != valid) {
        _valid = valid;
        [_eventChangeState fireSender:self object:@(_valid)];
    }
}

#pragma mark Public

- (void)addControl:(id< MobilyValidatedObject >)control {
    if(([_controls containsObject:control] == NO) && (control.form == nil)) {
        _controls = [NSArray arrayWithArray:_controls andAddingObject:control];
        [_validatedControls addObject:control];
        control.form = self;
    }
}

- (void)removeControl:(id< MobilyValidatedObject >)control {
    if(([_controls containsObject:control] == YES) && (control.form == self)) {
        _controls = [NSArray arrayWithArray:_controls andRemovingObject:control];
        control.form = nil;
    }
}

- (void)removeAllControls {
    for(id< MobilyValidatedObject > control in _controls) {
        control.form = nil;
    }
    _controls = @[];
}

- (NSArray*)invalidControls {
    return [_controls relativeComplement:[_validatedControls allObjects]];
}

- (NSString*)output {
    __block NSString* output = @"";
    NSArray* results = @[];
    NSArray* invalidControls = [self invalidControls];
    for(id< MobilyValidatedObject > control in invalidControls) {
        results = [results unionWithArray:[control messages]];
    }
    [results eachWithIndex:^(NSString* r, NSUInteger index) {
        output = [output stringByAppendingString:r];
        if(index != results.count-1) {
            output = [output stringByAppendingString:@"\n"];
        }
    }];
    return output;
}

#pragma mark Private

- (void)_validatedSuccess:(id< MobilyValidatedObject >)control andValue:(NSString* __unused)value {
    [_validatedControls addObject:control];
    self.valid = (_controls.count == _validatedControls.count);
}

- (void)_validatedFail:(id< MobilyValidatedObject >)control andValue:(NSString* __unused)value {
    [_validatedControls removeObject:control];
    self.valid = (_controls.count == _validatedControls.count);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldEmptyValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithMessage:(NSString*)message {
    if(self = [super init]) {
        _message = message;
    }
    return self;
}

- (BOOL)validate:(NSString*)value {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString* trimmed = [value stringByTrimmingCharactersInSet:whitespace];
    if([trimmed length] > 0) {
        return YES;
    }
    return NO;
}

- (NSArray*)messages:(NSString*)value {
    if([self validate:value] == NO) {
        return @[(_message == nil) ? @"Заполните все поля" : _message];
    }
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldEmailValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithMessage:(NSString*)message {
    if(self = [super init]) {
        _message = message;
    }
    return self;
}

- (BOOL)validate:(NSString*)value {
    return [value isEmail];
}

- (NSArray*)messages:(NSString*)value {
    if([self validate:value] == NO) {
        return @[(_message == nil) ? @"Заполните все поля" : _message];
    }
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldRegExpValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithRegExp:(NSString*)regExp andMessage:(NSString*)message {
    if(self = [super init]) {
        _regExp = regExp;
        _message = message;
    }
    return self;
}

- (void)setRegExp:(NSString*)regExp {
    if([_regExp isEqualToString:regExp] == NO) {
        _regExp = regExp;
        [_control validate];
    }
}

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regExp];
    if([test evaluateWithObject:value] == YES) {
        return YES;
    }
    return NO;
}

- (NSArray*)messages:(NSString*)value {
    if([self validate:value] == NO) {
        if(_message != nil) {
            return @[_message];
        }
    }
    
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldMinLengthValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithMessage:(NSString*)message minLength:(NSInteger)minLength {
    if(self = [super init]) {
        _message = message;
        _minLength = minLength;
    }
    return self;
}

- (void)setMinLength:(NSInteger)minLength {
    if(_minLength != minLength) {
        _minLength = minLength;
        [_control validate];
    }
}

- (BOOL)validate:(NSString*)value {
    if([value length] >= _minLength) {
        return YES;
    }
    return NO;
}

- (NSArray*)messages:(NSString* __unused)value {
    return @[];
}

@end

/*--------------------------------------------------*/

@implementation MobilyFieldMaxLengthValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithMessage:(NSString*)message maxLength:(NSInteger)maxLength {
    if(self = [super init]) {
        _message = message;
        _maxLength = maxLength;
    }
    return self;
}

- (void)setMaxLength:(NSInteger)maxLength {
    if(_maxLength != maxLength) {
        _maxLength = maxLength;
        [_control validate];
    }
}

- (BOOL)validate:(NSString*)value {
    if([value length] <= _maxLength) {
        return YES;
    }
    return NO;
}

- (NSArray*)messages:(NSString* __unused)value {
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldDigitValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithMessage:(NSString*)message {
    if(self = [super init]) {
        _message = message;
    }
    return self;
}

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]+"];
    if([test evaluateWithObject:value] == YES) {
        return YES;
    }
    return NO;
}

- (NSArray*)messages:(NSString* __unused)value {
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldANDValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithValidators:(NSArray*)validators andMessage:(NSString*)message {
    if(self = [super init]) {
        _validators = validators;
        _message = message;
    }
    return self;
}

- (BOOL)validate:(NSString*)value {
    BOOL result = YES;
    for(id<MobilyFieldValidator> val in _validators) {
        if([val validate:value] == NO) {
            result = NO;
            break;
        }
    }
    return result;
}

- (NSArray*)messages:(NSString*)value {
    NSArray* results = @[];
    for(id<MobilyFieldValidator> val in _validators) {
        results = [results unionWithArray:[val messages:value]];
    }
    return results;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldORValidator

@synthesize message = _message;
@synthesize control = _control;

- (instancetype)initWithValidators:(NSArray*)validators andMessage:(NSString*)message {
    if(self = [super init]) {
        _validators = validators;
        _message = message;
    }
    return self;
}

- (BOOL)validate:(NSString*)value {
    BOOL result = NO;
    for(id<MobilyFieldValidator> val in _validators) {
        if([val validate:value] == YES) {
            result = YES;
            break;
        }
    }
    return result;
}

- (NSArray*)messages:(NSString* __unused)value {
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/