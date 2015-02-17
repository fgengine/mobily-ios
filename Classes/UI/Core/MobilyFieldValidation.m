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

@end

/*--------------------------------------------------*/

@implementation MobilyFieldForm

- (void)setControls:(NSArray *)controls {
    if([_controls isEqualToArray:controls] == NO) {
        for(id<MobilyValidatedObject> control in _controls) {
            control.form = nil;
        }
        _controls = controls;
        for(id<MobilyValidatedObject> control in _controls) {
            control.form = self;
        }
    }
}

- (void)validatedSuccess:(id<MobilyValidatedObject>)control {
    
}

- (void)validatedFail:(id<MobilyValidatedObject>)control {
    
}

@end

/*--------------------------------------------------*/

@implementation MobilyFieldEmptyValidator

- (BOOL)validate:(NSString *)value {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString* trimmed = [value stringByTrimmingCharactersInSet:whitespace];
    if([trimmed length] == 0) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/

@implementation MobilyFieldRegExpValidator

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regExp];
    if([test evaluateWithObject:value]) {
        return YES;
    }
    return NO;
}

@end

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

@implementation MobilyFieldDigitValidator

- (BOOL)validate:(NSString*)value {
    NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]+"];
    if([test evaluateWithObject:value]) {
        return YES;
    }
    return NO;
}

@end

/*--------------------------------------------------*/