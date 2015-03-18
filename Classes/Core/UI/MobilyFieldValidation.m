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

#import "MobilyFieldValidation.h"
#import "MobilyValidatedObject.h"
#import "MobilyNS.h"

/*--------------------------------------------------*/

@interface MobilyFieldForm ()

@property(nonatomic, readwrite, assign) BOOL valid;

@property(nonatomic, readwrite, strong) NSMutableSet* validatedControls;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldForm

- (void)setControls:(NSArray*)controls {
    if([_controls isEqualToArray:controls] == NO) {
        NSMutableArray* checkedControls = [NSMutableArray array];
        for(id control in controls) {
            if([control conformsToProtocol:@protocol(MobilyValidatedObject)]) {
                [checkedControls addObject:control];
            }
        }
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

- (void)addControl:(id<MobilyValidatedObject>)control {
    if([_controls indexOfObjectIdenticalTo:control] == NSNotFound) {
        control.form = self;
        NSMutableArray* updatedControls = [NSMutableArray arrayWithArray:_controls];
        [updatedControls addObject:control];
        _controls = updatedControls;
    }
}

- (void)removeControl:(id<MobilyValidatedObject>)control {
    NSUInteger index = [_controls indexOfObjectIdenticalTo:control];
    if(index != NSNotFound) {
        control.form = nil;
        NSMutableArray* updatedControls = [NSMutableArray arrayWithArray:_controls];
        [updatedControls removeObjectAtIndex:index];
        _controls = updatedControls;
    }
}

- (void)removeAllControls {
    for(id< MobilyValidatedObject > control in _controls) {
        control.form = nil;
    }
    _controls = [NSArray array];
}

- (NSArray*)getInvalidControls {
    return [_controls relativeComplement:[_validatedControls allObjects]];
}

- (NSString*)output {
    __block NSString* output = @"";
    NSArray* results = @[];
    NSArray* invalidControls = [self getInvalidControls];
    for(id<MobilyValidatedObject> control in invalidControls) {
        results = [results unionWithArray:[control.validator messages:control.text]];
    }
    [results eachWithIndex:^(NSString* r, NSUInteger index) {
        output = [output stringByAppendingString:r];
        if(index != results.count-1) {
            output = [output stringByAppendingString:@"\n"];
        }
    }];
    return output;
}

- (void)validatedSuccess:(id<MobilyValidatedObject>)control andValue:(NSString* __unused)value {
    [_validatedControls addObject:control];
}

- (void)validatedFail:(id<MobilyValidatedObject>)control andValue:(NSString* __unused)value {
    [_validatedControls removeObject:control];
}

- (BOOL)isValid {
    NSInteger countControlsWithValidator = 0;
    for(id<MobilyValidatedObject> control in _controls) {
        if(control.validator != nil) {
            countControlsWithValidator++;
        }
    }
    return (countControlsWithValidator == _validatedControls.count);
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldEmptyValidator

@synthesize msg = _msg;

- (instancetype)initWithMessage:(NSString*)msg {
    if(self = [super init]) {
        self.msg = msg;
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
        return @[(_msg == nil) ? @"Заполните все поля" : _msg];
    }
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldRegExpValidator

@synthesize msg = _msg;

- (instancetype)initWithRegExp:(NSString*)regExp andMessage:(NSString*)msg {
    if(self = [super init]) {
        self.regExp = regExp;
        self.msg = msg;
    }
    return self;
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
        if(_msg != nil) {
            return @[_msg];
        }
    }
    
    return @[];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldMinLengthValidator

@synthesize msg = _msg;

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

@synthesize msg = _msg;

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

@synthesize msg = _msg;

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

@synthesize msg = _msg;

- (instancetype)initWithValidators:(NSArray*)validators andMessage:(NSString*)msg {
    if(self = [super init]) {
        self.validators = validators;
        self.msg = msg;
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

@synthesize msg = _msg;

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