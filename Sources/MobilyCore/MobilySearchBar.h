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

#import <MobilyCore/MobilyBlurView.h>
#import <MobilyCore/MobilyTextField.h>
#import <MobilyCore/MobilyButton.h>

/*--------------------------------------------------*/

@protocol MobilySearchBarDelegate;

/*--------------------------------------------------*/

@interface MobilySearchBar : MobilyBlurView

@property(nonatomic, readwrite, weak) IBOutlet id< MobilySearchBarDelegate > delegate;
@property(nonatomic, readwrite, assign, getter=isSearching) IBInspectable BOOL searching;
@property(nonatomic, readonly, assign, getter=isEditing) BOOL editing;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat minimalHeight;
@property(nonatomic, readwrite, assign) IBInspectable UIEdgeInsets margin;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat spacing;
@property(nonatomic, readonly, strong) IBInspectable UIColor* separatorColor;
@property(nonatomic, readonly, weak) UIView* separatorView;
@property(nonatomic, readonly, weak) IBOutlet MobilyTextField* searchField;
@property(nonatomic, readwrite, assign) BOOL showCancelButton;
@property(nonatomic, readonly, weak) IBOutlet MobilyButton* cancelButton;

- (void)setSearching:(BOOL)searching animated:(BOOL)animated complete:(MobilySimpleBlock)complete;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated complete:(MobilySimpleBlock)complete;

@end

/*--------------------------------------------------*/

@protocol MobilySearchBarDelegate < NSObject >

@optional
- (void)searchBarBeginSearch:(MobilySearchBar*)searchBar;
- (void)searchBarEndSearch:(MobilySearchBar*)searchBar;

- (void)searchBarBeginEditing:(MobilySearchBar*)searchBar;
- (void)searchBar:(MobilySearchBar*)searchBar textChanged:(NSString*)textChanged;
- (void)searchBarEndEditing:(MobilySearchBar*)searchBar;

- (void)searchBarPressedClear:(MobilySearchBar*)searchBar;
- (void)searchBarPressedReturn:(MobilySearchBar*)searchBar;
- (void)searchBarPressedCancel:(MobilySearchBar*)searchBar;

@end

/*--------------------------------------------------*/
