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

@protocol MobilyValidatedObject;
@class MobilyFieldForm;

/*--------------------------------------------------*/

@protocol MobilyFieldValidator <NSObject>

@property(nonatomic, readwrite, strong) NSString* msg;

@required
- (BOOL)validate:(NSString*)value;
- (NSArray*)messages:(NSString*)value;

@end

/*--------------------------------------------------*/

@interface MobilyFieldForm : NSObject

@property(nonatomic, readonly, assign, getter=isValid) BOOL valid;
@property(nonatomic, readwrite, strong) IBOutletCollection(NSObject) NSArray* controls;

- (void)addControl:(id<MobilyValidatedObject>)control;
- (void)removeControl:(id<MobilyValidatedObject>)control;
- (void)removeAllControls;

- (NSArray*)getInvalidControls;
- (NSString*)output;

- (void)validatedSuccess:(id<MobilyValidatedObject>)control andValue:(NSString*)value;
- (void)validatedFail:(id<MobilyValidatedObject>)control andValue:(NSString*)value;

@end

/*--------------------------------------------------*/

@interface MobilyFieldEmptyValidator : NSObject < MobilyFieldValidator >

- (instancetype)initWithMessage:(NSString*)msg;

@end

/*--------------------------------------------------*/

@interface MobilyFieldRegExpValidator : NSObject < MobilyFieldValidator >

@property(nonatomic, readwrite, strong) NSString* regExp;

- (instancetype)initWithRegExp:(NSString*)regExp andMessage:(NSString*)msg;

@end

/*--------------------------------------------------*/

@interface MobilyFieldMinLengthValidator : NSObject < MobilyFieldValidator >

@property(nonatomic, readwrite, assign) NSInteger minLength;

@end

/*--------------------------------------------------*/

@interface MobilyFieldMaxLengthValidator : NSObject < MobilyFieldValidator >

@property(nonatomic, readwrite, assign) NSInteger maxLength;

@end

/*--------------------------------------------------*/

@interface MobilyFieldDigitValidator : NSObject < MobilyFieldValidator >

@end

/*--------------------------------------------------*/

@interface MobilyFieldANDValidator : NSObject < MobilyFieldValidator >

@property(nonatomic, readwrite, strong) NSArray* validators;

- (instancetype)initWithValidators:(NSArray*)validators andMessage:(NSString*)msg;

@end

/*--------------------------------------------------*/

@interface MobilyFieldORValidator : NSObject < MobilyFieldValidator >

@property(nonatomic, readwrite, strong) NSArray* validators;

@end

/*--------------------------------------------------*/