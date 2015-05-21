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
#import <MobilyFieldValidation+Private.h>

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

#pragma mark Public override

- (void)insertText:(NSString*)string {
    [super insertText:string];
    [self setNeedsDisplay];
}

#pragma mark Property

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setText:(NSString*)string {
    [super setText:string];
    if(self.isEditing == NO) {
        [self validate];
    }
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString*)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString*)string {
    if([string isEqualToString:_attributedPlaceholder.string] == NO) {
        NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
        if(([self isFirstResponder] == YES) && (self.typingAttributes != nil)) {
            [attributes addEntriesFromDictionary:self.typingAttributes];
        } else {
            attributes[NSFontAttributeName] = (_placeholderFont != nil) ? _placeholderFont : self.font;
            attributes[NSForegroundColorAttributeName] = (_placeholderColor != nil) ? _placeholderColor : [UIColor colorWithRed:170.0f/255 green:170.0f/255 blue:170.0f/255 alpha:1.0f];
            if(self.textAlignment != NSTextAlignmentLeft) {
                NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = self.textAlignment;
                attributes[NSParagraphStyleAttributeName] = paragraph;
            }
        }
        _attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:attributes];
        [self setNeedsDisplay];
    }
}

- (NSString*)placeholder {
    return _attributedPlaceholder.string;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    if([_attributedPlaceholder isEqualToAttributedString:attributedPlaceholder] == NO) {
        _attributedPlaceholder = attributedPlaceholder;
        [self setNeedsDisplay];
    }
}

- (void)setForm:(MobilyFieldForm*)form {
    if([_form isEqual:form] == NO) {
        _form = form;
        [self validate];
    }
}

- (void)setValidator:(id< MobilyFieldValidator >)validator {
    if([_validator isEqual:validator] == NO) {
        if(_validator != nil) {
            _validator.control = nil;
        }
        _validator = validator;
        if(_validator != nil) {
            _validator.control = self;
        }
        [self validate];
    }
}

- (void)setHiddenToolbar:(BOOL)hiddenToolbar {
    [self setHiddenToolbar:hiddenToolbar animated:NO];
}

- (void)setHiddenToolbarArrows:(BOOL)hiddenToolbarArrows {
    if(_hiddenToolbarArrows != hiddenToolbarArrows) {
        _hiddenToolbarArrows = hiddenToolbarArrows;
        if([self isEditing] == YES) {
            if(_hiddenToolbarArrows == YES) {
                _toolbar.items = @[ _flexButton, _doneButton ];
            } else {
                _toolbar.items = @[ _prevButton, _nextButton, _flexButton, _doneButton ];
            }
        }
    }
}

#pragma mark Public override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if((_attributedPlaceholder != nil) && (self.text.length < 1)) {
        [_attributedPlaceholder drawInRect:[self placeholderRectForBounds:self.bounds]];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if((_attributedPlaceholder != nil) && (self.text.length < 1)) {
        [self setNeedsDisplay];
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

- (void)didBeginEditing {
    if(_toolbar == nil) {
        CGRect windowBounds = self.window.bounds;
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(windowBounds.origin.x, windowBounds.origin.y, windowBounds.size.width, MOBILY_TOOLBAR_HEIGHT)];
        self.prevButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(pressedPrev)];
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(pressedNext)];
        self.flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressedDone)];
        
        _toolbar.barStyle = UIBarStyleDefault;
        _toolbar.clipsToBounds = YES;
    }
    if(_toolbar != nil) {
        _prevInputResponder = [UIResponder prevResponderFromView:self];
        _nextInputResponder = [UIResponder nextResponderFromView:self];
        if(_hiddenToolbarArrows == YES) {
            _toolbar.items = @[ _flexButton, _doneButton ];
        } else {
            _toolbar.items = @[ _prevButton, _nextButton, _flexButton, _doneButton ];
        }
        _prevButton.enabled = (_prevInputResponder != nil);
        _nextButton.enabled = (_nextInputResponder != nil);
        _toolbar.frameHeight = (_hiddenToolbar == NO) ? MOBILY_TOOLBAR_HEIGHT : 0.0f;
        self.inputAccessoryView = _toolbar;
        [self reloadInputViews];
    }
}

- (void)didValueChanged {
    [self setNeedsDisplay];
    [self validate];
}

- (void)didEndEditing {
    _prevInputResponder = nil;
    _nextInputResponder = nil;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    if([self respondsToSelector:@selector(textContainer)] == YES) {
        rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
        CGFloat padding = self.textContainer.lineFragmentPadding;
        rect.origin.x += padding;
        rect.size.width -= padding * 2.0f;
    } else {
        if(self.contentInset.left == 0.0f) {
            rect.origin.x += 8.0f;
        }
        rect.origin.y += 8.0f;
    }
    return rect;
}

#pragma mark MobilyValidatedObject

- (void)validate {
    if((_form != nil) && (_validator != nil)) {
        if([_validator validate:self.text] == YES) {
            [_form _validatedSuccess:self andValue:self.text];
        } else {
            [_form _validatedFail:self andValue:self.text];
        }
    }
}

- (NSArray*)messages {
    if((_form != nil) && (_validator != nil)) {
        return [_validator messages:self.text];
    }
    return @[];
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
