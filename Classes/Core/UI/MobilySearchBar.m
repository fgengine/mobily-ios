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

#import "MobilySearchBar.h"

/*--------------------------------------------------*/

@interface MobilySearchBar () < UITextFieldDelegate > {
@protected
    BOOL _searching;
    BOOL _editing;
    UIEdgeInsets _margin;
    CGFloat _spacing;
    __weak id< MobilySearchBarDelegate > _delegate;
    __weak MobilyTextField* _searchField;
    BOOL _showCancelButton;
    __weak MobilyButton* _cancelButton;
    NSMutableArray* _contentConstraints;
}

@property(nonatomic, readwrite, weak) MobilyTextField* searchField;
@property(nonatomic, readwrite, weak) MobilyButton* cancelButton;

- (void)updateAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static CGFloat MobilySearchBarContentHeight = 34.0f;

/*--------------------------------------------------*/

@implementation MobilySearchBar

#pragma mark Synthesize

@synthesize searching = _searching;
@synthesize editing = _editing;
@synthesize margin = _margin;
@synthesize spacing = _spacing;
@synthesize delegate = _delegate;
@synthesize searchField = _searchField;
@synthesize showCancelButton = _showCancelButton;
@synthesize cancelButton = _cancelButton;

#pragma mark Init / Free

- (void)setup {
    _margin = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
    _spacing = 8.0f;
    _showCancelButton = YES;
    _contentConstraints = NSMutableArray.array;
}

- (void)dealloc {
}

#pragma mark InterfaceBuilder

#if TARGET_INTERFACE_BUILDER
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    if(self.searchField != nil) {
    }
    if(self.cancelButton != nil) {
    }
}
#endif

#pragma mark Property

- (void)setSearching:(BOOL)searching {
    [self setSearching:searching animated:NO complete:nil];
}

- (void)setSearching:(BOOL)searching animated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if(_searching != searching) {
        _searching = searching;
        if(_searching == NO) {
            _editing = NO;
        }
        [self updateAnimated:animated complete:complete];
    }
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO complete:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if(_editing != editing) {
        _editing = editing;
        if((_editing == YES) && (self.searchField.isFirstResponder == NO)) {
            [self.searchField becomeFirstResponder];
        }
        [self updateAnimated:animated complete:complete];
    }
}

- (void)setSearchField:(MobilyTextField*)searchField {
    if(_searchField != searchField) {
        if(_searchField != nil) {
            [_searchField removeFromSuperview];
        }
        _searchField = searchField;
        if(_searchField != nil) {
            [_searchField addTarget:self action:@selector(changeTextField) forControlEvents:UIControlEventEditingChanged];
            _searchField.translatesAutoresizingMaskIntoConstraints = NO;
            _searchField.delegate = self;
            if(_searchField.superview == nil) {
                [self addSubview:_searchField];
            }
            [self setNeedsUpdateConstraints];
        }
    }
}

- (MobilyTextField*)searchField {
    if(_searchField == nil) {
        MobilyTextField* textField = [[MobilyTextField alloc] initWithFrame:CGRectZero];
        textField.placeholder = NSLocalizedString(@"Search", @"MobilySearchBar search placeholder");
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor darkGrayColor];
        textField.cornerRadius = 4.0f;
        textField.hiddenToolbar = YES;
        self.searchField = textField;
    }
    return _searchField;
}

- (void)setCancelButton:(MobilyButton*)cancelButton {
    if(_cancelButton != cancelButton) {
        if(_cancelButton != nil) {
            [_cancelButton removeFromSuperview];
        }
        _cancelButton = cancelButton;
        if(_cancelButton != nil) {
            [_cancelButton addTarget:self action:@selector(pressedCancel) forControlEvents:UIControlEventTouchUpInside];
            _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
            if(((_searching == YES) || (_editing == YES)) && (_showCancelButton == YES)) {
                _cancelButton.hidden = NO;
            } else {
                _cancelButton.hidden = YES;
            }
            if(_cancelButton.superview == nil) {
                [self addSubview:_cancelButton];
            }
            [self setNeedsUpdateConstraints];
        }
    }
}

- (MobilyButton*)cancelButton {
    if(_cancelButton == nil) {
        MobilyButton* button = [[MobilyButton alloc] initWithFrame:CGRectZero];
        button.normalTitle = NSLocalizedString(@"Cancel", @"MobilySearchBar cancel title");
        button.normalTitleColor = [UIColor whiteColor];
        self.cancelButton = button;
    }
    return _cancelButton;
}

#pragma mark Public override

- (void)updateConstraints {
    NSDictionary* metrics = @{
        @"height": @(MobilySearchBarContentHeight),
        @"marginTop": @(_margin.top),
        @"marginBottom": @(_margin.bottom),
        @"marginLeft": @(_margin.left),
        @"marginRight": @(_margin.right),
        @"spacing": @(_spacing),
    };
    NSDictionary* views = @{
        @"searchField": self.searchField,
        @"cancelButton": self.cancelButton,
    };
    [self removeConstraints:_contentConstraints];
    [_contentConstraints removeAllObjects];
    if(((_searching == YES) || (_editing == YES)) && (_showCancelButton == YES)) {
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginLeft)-[searchField]-(spacing)-[cancelButton]-(marginRight)-|" options:0 metrics:metrics views:views]];
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=marginTop)-[searchField(>=height)]-(marginBottom)-|" options:0 metrics:metrics views:views]];
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=marginTop)-[cancelButton(>=height)]-(marginBottom)-|" options:0 metrics:metrics views:views]];
    } else {
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(marginLeft)-[searchField]-(marginRight)-|" options:0 metrics:metrics views:views]];
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[searchField]-(marginRight)-[cancelButton]" options:0 metrics:metrics views:views]];
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=marginTop)-[searchField(>=height)]-(marginBottom)-|" options:0 metrics:metrics views:views]];
        [_contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=marginTop)-[cancelButton(>=height)]-(marginBottom)-|" options:0 metrics:metrics views:views]];
    }
    [self addConstraints:_contentConstraints];
    [super updateConstraints];
}

#pragma mark Public

#pragma mark Private

- (void)updateAnimated:(BOOL)animated complete:(MobilySimpleBlock)complete {
    if(_searching == _editing) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    if(animated == YES) {
        if(((_searching == YES) || (_editing == YES)) && (_showCancelButton == YES)) {
            self.cancelButton.hidden = NO;
        }
        [UIView animateWithDuration:0.2f animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if((_searching == NO) && (_editing == NO)) {
                self.cancelButton.hidden = YES;
            }
            if(complete != nil) {
                complete();
            }
        }];
    } else {
        if(((_searching == YES) || (_editing == YES)) && (_showCancelButton == YES)) {
            self.cancelButton.hidden = NO;
        } else {
            self.cancelButton.hidden = YES;
        }
        if(complete != nil) {
            complete();
        }
    }
}

#pragma mark Action

- (void)changeTextField {
    if((_searching == NO) && (self.searchField.text.length > 0)) {
        if([_delegate respondsToSelector:@selector(searchBarBeginSearch:)]) {
            [_delegate searchBarBeginSearch:self];
        }
        [self setSearching:YES animated:YES complete:nil];
    }
    if(self.searchField.text.length > 0) {
        _searchField.clearButtonMode = UITextFieldViewModeAlways;
    } else {
        _searchField.clearButtonMode = UITextFieldViewModeNever;
    }
    if([_delegate respondsToSelector:@selector(searchBar:textChanged:)]) {
        [_delegate searchBar:self textChanged:self.searchField.text];
    }
}

- (void)pressedCancel {
    if([_delegate respondsToSelector:@selector(searchBarEndEditing:)]) {
        [_delegate searchBarPressedCancel:self];
    } else {
        __weak typeof(self) wealSelf = self;
        [self setSearching:NO animated:YES complete:^{
            [wealSelf.searchField endEditing:NO];
            wealSelf.searchField.clearButtonMode = UITextFieldViewModeNever;
            wealSelf.searchField.text = @"";
        }];
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    if([_delegate respondsToSelector:@selector(searchBarBeginEditing:)]) {
        [_delegate searchBarBeginEditing:self];
    }
    [self setEditing:YES animated:YES complete:nil];
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
    if([_delegate respondsToSelector:@selector(searchBarEndEditing:)]) {
        [_delegate searchBarEndEditing:self];
    }
    if(self.searchField.text.length < 1) {
        if([_delegate respondsToSelector:@selector(searchBarEndSearch:)]) {
            [_delegate searchBarEndSearch:self];
        }
        [self setSearching:NO animated:YES complete:nil];
    }
    [self setEditing:NO animated:YES complete:nil];
}

- (BOOL)textFieldShouldClear:(UITextField*)textField {
    if([_delegate respondsToSelector:@selector(searchBarPressedClear:)]) {
        [_delegate searchBarPressedClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if([_delegate respondsToSelector:@selector(searchBarPressedReturn:)]) {
        [_delegate searchBarPressedReturn:self];
    }
    return YES;
}

@end

/*--------------------------------------------------*/
