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

#import <MobilyBuilder.h>
#import <MobilyValidatedObject.h>

/*--------------------------------------------------*/

@interface MobilyTextField : UITextField< MobilyBuilderObject, MobilyValidatedObject >

@property(nonatomic, readwrite, strong) IBOutlet id<MobilyFieldValidator> validator;

@property(nonatomic, readwrite, assign) IBInspectable BOOL hiddenToolbar;
@property(nonatomic, readwrite, assign) IBInspectable BOOL hiddenToolbarArrows;
@property(nonatomic, readwrite, strong) UIToolbar* toolbar;
@property(nonatomic, readwrite, strong) UIBarButtonItem* prevButton;
@property(nonatomic, readwrite, strong) UIBarButtonItem* nextButton;
@property(nonatomic, readwrite, strong) UIBarButtonItem* flexButton;
@property(nonatomic, readwrite, strong) UIBarButtonItem* doneButton;

@property(nonatomic, readwrite, strong) NSString* phonePrefix;
@property(nonatomic, readwrite, strong) NSString* phoneFormat;

- (void)setup NS_REQUIRES_SUPER;

- (void)setHiddenToolbar:(BOOL)hiddenToolbar animated:(BOOL)animated;
- (void)setPhoneFormat:(NSString *)phoneFormat withPrefix:(NSString*)phonePrefix;

- (void)didBeginEditing;
- (void)didEndEditing;
- (void)didValueChanged;

- (void)validate;

- (BOOL)isEmptyText;

@end

/*--------------------------------------------------*/
