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

#import "MobilyFieldValidation.h"
#import "MobilyValidatedObject.h"

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

- (void)validatedSuccess:(id<MobilyValidatedObject>)control {
    [_validatedControls addObject:control];
    NSLog(@"success");
}

- (void)validatedFail:(id<MobilyValidatedObject>)control {
    [_validatedControls removeObject:control];
    NSLog(@"fail");
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

- (BOOL)validate:(NSString*)value {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString* trimmed = [value stringByTrimmingCharactersInSet:whitespace];
    if([trimmed length] > 0) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldRegExpValidator

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regExp];
    if([test evaluateWithObject:value] == YES) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldMinLengthValidator

- (BOOL)validate:(NSString*)value {
    if([value length] >= _minLength) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/

@implementation MobilyFieldMaxLengthValidator

- (BOOL)validate:(NSString*)value {
    if([value length] <= _maxLength) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldDigitValidator

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]+"];
    if([test evaluateWithObject:value] == YES) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldANDValidator

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

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyFieldORValidator

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

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/