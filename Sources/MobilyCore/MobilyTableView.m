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

#import <MobilyCore/MobilyTableView.h>

/*--------------------------------------------------*/

@interface MobilyTableView ()

@property(nonatomic, readwrite, strong) NSMutableDictionary* registeredCellNibs;
@property(nonatomic, readwrite, strong) NSMutableDictionary* registeredHeaderFooterNibs;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyTableCell ()

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintCenterXRootView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintCenterYRootView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintWidthRootView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintHeightRootView;

- (NSArray*)orderedSubviews;

- (void)cleanupConstraint;

- (CGFloat)rootConstantX;
- (CGFloat)rootConstantY;
- (CGFloat)rootConstantWidth;
- (CGFloat)rootConstantHeight;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataCellSwipeDirection) {
    MobilyDataCellSwipeDirectionUnknown,
    MobilyDataCellSwipeDirectionLeft,
    MobilyDataCellSwipeDirectionRight
};

/*--------------------------------------------------*/

@interface MobilyTableSwipeCell () < UIGestureRecognizerDelegate >

@property(nonatomic, readwrite, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readwrite, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGesture;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintOffsetLeftSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintCenterYLeftSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintWidthLeftSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintHeightLeftSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintOffsetRightSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintCenterYRightSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintWidthRightSwipeView;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintHeightRightSwipeView;

@property(nonatomic, readwrite, assign) CGFloat swipeLastOffset;
@property(nonatomic, readwrite, assign) CGFloat swipeLastVelocity;
@property(nonatomic, readwrite, assign) CGFloat swipeProgress;
@property(nonatomic, readwrite, assign) CGFloat swipeLeftWidth;
@property(nonatomic, readwrite, assign) CGFloat swipeRightWidth;
@property(nonatomic, readwrite, assign) MobilyDataCellSwipeDirection swipeDirection;

- (CGFloat)leftConstant;
- (CGFloat)rightConstant;

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe;

- (void)handlerPanGesture;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTableView

#pragma mark Synthesize

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

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
    self.registeredCellNibs = NSMutableDictionary.dictionary;
    self.registeredHeaderFooterNibs = NSMutableDictionary.dictionary;
    
    [self moRegisterAdjustmentResponder];
}

- (void)dealloc {
    [self moUnregisterAdjustmentResponder];
    
    self.objectName = nil;
    self.objectParent = nil;
    self.objectChilds = nil;
    
    self.registeredCellNibs = nil;
    self.registeredHeaderFooterNibs = nil;
}

#pragma mark MobilyBuilderObject

- (NSArray*)relatedObjects {
    if(_objectChilds.count > 0) {
        return [_objectChilds moUnionWithArrays:self.subviews, nil];
    }
    return self.subviews;
}

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andAddingObject:objectChild];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:UIView.class] == YES) {
        self.objectChilds = [NSArray moArrayWithArray:_objectChilds andRemovingObject:objectChild];
        [self moRemoveSubview:(UIView*)objectChild];
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

- (void)setCurrentSwipeCell:(MobilyTableSwipeCell*)currentSwipeCell {
    [self setCurrentSwipeCell:currentSwipeCell animated:NO];
}

#pragma mark Public

- (void)setCurrentSwipeCell:(MobilyTableSwipeCell*)currentSwipeCell animated:(BOOL)animated {
    if(_currentSwipeCell != currentSwipeCell) {
        if(_currentSwipeCell != nil) {
            _currentSwipeCell.hiddenAnySwipeViewAnimated = animated;
        }
        _currentSwipeCell = currentSwipeCell;
    }
}

- (void)registerCellClass:(Class)cellClass {
    UINib* nib = [UINib moNibWithClass:cellClass bundle:nil];
    if(nib != nil) {
        _registeredCellNibs[NSStringFromClass(cellClass)] = nib;
        [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (void)registerHeaderFooterClass:(Class)headerFooterClass {
    UINib* nib = [UINib moNibWithClass:headerFooterClass bundle:nil];
    if(nib != nil) {
        _registeredHeaderFooterNibs[NSStringFromClass(headerFooterClass)] = nib;
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(headerFooterClass)];
    }
}

- (id)dequeueReusableCellWithClass:(Class)cellClass {
    MobilyTableCell* cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    cell.tableView = self;
    if([cell rootView] == nil) {
        UINib* nib = _registeredCellNibs[NSStringFromClass(cellClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:cell options:nil];
            if([cell isKindOfClass:MobilyTableCell.class] == YES) {
                [cell didLoadFromNib];
            }
        }
    }
    return cell;
}

- (id)dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath*)indexPath {
    MobilyTableCell* cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    cell.tableView = self;
    if([cell rootView] == nil) {
        UINib* nib = _registeredCellNibs[NSStringFromClass(cellClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:cell options:nil];
            if([cell isKindOfClass:MobilyTableCell.class] == YES) {
                [cell didLoadFromNib];
            }
        }
    }
    return cell;
}

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)headerFooterClass {
    MobilyTableCell* headerFooter = [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerFooterClass)];
    headerFooter.tableView = self;
    if([headerFooter rootView] == nil) {
        UINib* nib = _registeredHeaderFooterNibs[NSStringFromClass(headerFooterClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:headerFooter options:nil];
            if([headerFooter isKindOfClass:MobilyTableCell.class] == YES) {
                [headerFooter didLoadFromNib];
            }
        }
    }
    return headerFooter;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyTableCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
}

- (void)dealloc {
    self.constraintCenterXRootView = nil;
    self.constraintCenterYRootView = nil;
    self.constraintWidthRootView = nil;
    self.constraintHeightRootView = nil;
    self.rootView = nil;
}

#pragma mark Property

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [self cleanupConstraint];
            [_rootView removeFromSuperview];
        }
        _rootView = rootView;
        if(_rootView != nil) {
            _rootView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView moSetSubviews:[self orderedSubviews]];
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setConstraintCenterXRootView:(NSLayoutConstraint*)constraintCenterXRootView {
    if(_constraintCenterXRootView != constraintCenterXRootView) {
        if(_constraintCenterXRootView != nil) {
            [self.contentView removeConstraint:_constraintCenterXRootView];
        }
        _constraintCenterXRootView = constraintCenterXRootView;
        if(_constraintCenterXRootView != nil) {
            [self.contentView addConstraint:_constraintCenterXRootView];
        }
    }
}

- (void)setConstraintCenterYRootView:(NSLayoutConstraint*)constraintCenterYRootView {
    if(_constraintCenterYRootView != constraintCenterYRootView) {
        if(_constraintCenterYRootView != nil) {
            [self.contentView removeConstraint:_constraintCenterYRootView];
        }
        _constraintCenterYRootView = constraintCenterYRootView;
        if(_constraintCenterYRootView != nil) {
            [self.contentView addConstraint:_constraintCenterYRootView];
        }
    }
}

- (void)setConstraintWidthRootView:(NSLayoutConstraint*)constraintWidthRootView {
    if(_constraintWidthRootView != constraintWidthRootView) {
        if(_constraintWidthRootView != nil) {
            [self.contentView removeConstraint:_constraintWidthRootView];
        }
        _constraintWidthRootView = constraintWidthRootView;
        if(_constraintWidthRootView != nil) {
            [self.contentView addConstraint:_constraintWidthRootView];
        }
    }
}

- (void)setConstraintHeightRootView:(NSLayoutConstraint*)constraintHeightRootView {
    if(_constraintHeightRootView != constraintHeightRootView) {
        if(_constraintHeightRootView != nil) {
            [self.contentView removeConstraint:_constraintHeightRootView];
        }
        _constraintHeightRootView = constraintHeightRootView;
        if(_constraintHeightRootView != nil) {
            [self.contentView addConstraint:_constraintHeightRootView];
        }
    }
}

#pragma mark Public

- (void)didLoadFromNib {
}

+ (CGFloat)heightForModel:(id __unused)model tableView:(UITableView* __unused)tableView {
    return 240.0f;
}

#pragma mark UITableViewCell

- (void)updateConstraints {
    [super updateConstraints];
    
    if(_constraintCenterXRootView == nil) {
        self.constraintCenterXRootView = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:[self rootConstantX]];
    } else {
        _constraintCenterXRootView.constant = [self rootConstantX];
    }
    if(_constraintCenterYRootView == nil) {
        self.constraintCenterYRootView = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:[self rootConstantY]];
    } else {
        _constraintCenterYRootView.constant = [self rootConstantY];
    }
    if(_constraintWidthRootView == nil) {
        self.constraintWidthRootView = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:[self rootConstantWidth]];
    } else {
        _constraintWidthRootView.constant = [self rootConstantWidth];
    }
    if(_constraintHeightRootView == nil) {
        self.constraintHeightRootView = [NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:[self rootConstantHeight]];
    } else {
        _constraintHeightRootView.constant = [self rootConstantHeight];
    }
}

#pragma mark Private

- (NSArray*)orderedSubviews {
    NSMutableArray* result = NSMutableArray.array;
    if(_rootView != nil) {
        [result addObject:_rootView];
    }
    return result;
}

- (void)cleanupConstraint {
    self.constraintCenterXRootView = nil;
    self.constraintCenterYRootView = nil;
    self.constraintWidthRootView = nil;
    self.constraintHeightRootView = nil;
}

- (CGFloat)rootConstantX {
    return 0.0f;
}

- (CGFloat)rootConstantY {
    return 0.0f;
}

- (CGFloat)rootConstantWidth {
    return 0.0f;
}

- (CGFloat)rootConstantHeight {
    return 0.0f;
}

@end

/*--------------------------------------------------*/

@implementation MobilyTableSwipeCell

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGesture)];
    
    self.swipeStyle = MobilyTableSwipeCellStyleLeaves;
    self.swipeThreshold = 2.0f;
    self.swipeSpeed = 1050.0f;
    self.swipeVelocity = 570.0f;
    self.leftSwipeViewWidth = -1.0f;
    self.rightSwipeViewWidth = -1.0f;
}

- (void)dealloc {
    self.panGesture = nil;
    self.constraintOffsetLeftSwipeView = nil;
    self.leftSwipeView = nil;
    self.constraintOffsetRightSwipeView = nil;
    self.rightSwipeView = nil;
}

#pragma mark Property

- (void)setPanGesture:(UIPanGestureRecognizer*)gesturePanSwipeRight {
    if(_panGesture != gesturePanSwipeRight) {
        if(_panGesture != nil) {
            [self removeGestureRecognizer:_panGesture];
        }
        _panGesture = gesturePanSwipeRight;
        if(_panGesture != nil) {
            _panGesture.delegate = self;
            [self addGestureRecognizer:_panGesture];
        }
    }
}

- (void)setSwipeStyle:(MobilyTableSwipeCellStyle)swipeStyle {
    if(_swipeStyle != swipeStyle) {
        [self cleanupConstraint];
        _swipeStyle = swipeStyle;
        [self.contentView moSetSubviews:[self orderedSubviews]];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setShowedLeftSwipeView:(BOOL)showedSwipeLeft {
    [self setShowedLeftSwipeView:showedSwipeLeft animated:NO];
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView {
    [self setShowedRightSwipeView:showedRightSwipeView animated:NO];
}

- (void)setLeftSwipeView:(UIView*)leftSwipeView {
    if(_leftSwipeView != leftSwipeView) {
        if(_leftSwipeView != nil) {
            [self cleanupConstraint];
            [_leftSwipeView removeFromSuperview];
        }
        _leftSwipeView = leftSwipeView;
        if(_leftSwipeView != nil) {
            _leftSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView moSetSubviews:[self orderedSubviews]];
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setLeftSwipeViewWidth:(CGFloat)leftSwipeViewWidth {
    if(_leftSwipeViewWidth != leftSwipeViewWidth) {
        _leftSwipeViewWidth = leftSwipeViewWidth;
        if(_leftSwipeView != nil) {
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setConstraintOffsetLeftSwipeView:(NSLayoutConstraint*)constraintOffsetLeftSwipeView {
    if(_constraintOffsetLeftSwipeView != constraintOffsetLeftSwipeView) {
        if(_constraintOffsetLeftSwipeView != nil) {
            [self.contentView removeConstraint:_constraintOffsetLeftSwipeView];
        }
        _constraintOffsetLeftSwipeView = constraintOffsetLeftSwipeView;
        if(_constraintOffsetLeftSwipeView != nil) {
            [self.contentView addConstraint:_constraintOffsetLeftSwipeView];
        }
    }
}

- (void)setConstraintCenterYLeftSwipeView:(NSLayoutConstraint*)constraintCenterYLeftSwipeView {
    if(_constraintCenterYLeftSwipeView != constraintCenterYLeftSwipeView) {
        if(_constraintCenterYLeftSwipeView != nil) {
            [self.contentView removeConstraint:_constraintCenterYLeftSwipeView];
        }
        _constraintCenterYLeftSwipeView = constraintCenterYLeftSwipeView;
        if(_constraintCenterYLeftSwipeView != nil) {
            [self.contentView addConstraint:_constraintCenterYLeftSwipeView];
        }
    }
}

- (void)setConstraintWidthLeftSwipeView:(NSLayoutConstraint*)constraintWidthLeftSwipeView {
    if(_constraintWidthLeftSwipeView != constraintWidthLeftSwipeView) {
        if(_constraintWidthLeftSwipeView != nil) {
            [_leftSwipeView removeConstraint:_constraintWidthLeftSwipeView];
        }
        _constraintWidthLeftSwipeView = constraintWidthLeftSwipeView;
        if(_constraintWidthLeftSwipeView != nil) {
            [_leftSwipeView addConstraint:_constraintWidthLeftSwipeView];
        }
    }
}

- (void)setConstraintHeightLeftSwipeView:(NSLayoutConstraint*)constraintHeightLeftSwipeView {
    if(_constraintHeightLeftSwipeView != constraintHeightLeftSwipeView) {
        if(_constraintHeightLeftSwipeView != nil) {
            [self.contentView removeConstraint:_constraintHeightLeftSwipeView];
        }
        _constraintHeightLeftSwipeView = constraintHeightLeftSwipeView;
        if(_constraintHeightLeftSwipeView != nil) {
            [self.contentView addConstraint:_constraintHeightLeftSwipeView];
        }
    }
}

- (void)setRightSwipeView:(UIView*)rightSwipeView {
    if(_rightSwipeView != rightSwipeView) {
        if(_rightSwipeView != nil) {
            [self cleanupConstraint];
            [_rightSwipeView removeFromSuperview];
        }
        _rightSwipeView = rightSwipeView;
        if(_rightSwipeView != nil) {
            _rightSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView moSetSubviews:[self orderedSubviews]];
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setRightSwipeViewWidth:(CGFloat)rightSwipeViewWidth {
    if(_rightSwipeViewWidth != rightSwipeViewWidth) {
        _rightSwipeViewWidth = rightSwipeViewWidth;
        if(_rightSwipeView != nil) {
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setConstraintOffsetRightSwipeView:(NSLayoutConstraint*)constraintOffsetRightSwipeView {
    if(_constraintOffsetRightSwipeView != constraintOffsetRightSwipeView) {
        if(_constraintOffsetRightSwipeView != nil) {
            [self.contentView removeConstraint:_constraintOffsetRightSwipeView];
        }
        _constraintOffsetRightSwipeView = constraintOffsetRightSwipeView;
        if(_constraintOffsetRightSwipeView != nil) {
            [self.contentView addConstraint:_constraintOffsetRightSwipeView];
        }
    }
}

- (void)setConstraintCenterYRightSwipeView:(NSLayoutConstraint*)constraintCenterYRightSwipeView {
    if(_constraintCenterYRightSwipeView != constraintCenterYRightSwipeView) {
        if(_constraintCenterYRightSwipeView != nil) {
            [self.contentView removeConstraint:_constraintCenterYRightSwipeView];
        }
        _constraintCenterYRightSwipeView = constraintCenterYRightSwipeView;
        if(_constraintCenterYRightSwipeView != nil) {
            [self.contentView addConstraint:_constraintCenterYRightSwipeView];
        }
    }
}

- (void)setConstraintWidthRightSwipeView:(NSLayoutConstraint*)constraintWidthRightSwipeView {
    if(_constraintWidthRightSwipeView != constraintWidthRightSwipeView) {
        if(_constraintWidthRightSwipeView != nil) {
            [_rightSwipeView removeConstraint:_constraintWidthRightSwipeView];
        }
        _constraintWidthRightSwipeView = constraintWidthRightSwipeView;
        if(_constraintWidthRightSwipeView != nil) {
            [_rightSwipeView addConstraint:_constraintWidthRightSwipeView];
        }
    }
}

- (void)setConstraintHeightRightSwipeView:(NSLayoutConstraint*)constraintHeightRightSwipeView {
    if(_constraintHeightRightSwipeView != constraintHeightRightSwipeView) {
        if(_constraintHeightRightSwipeView != nil) {
            [self.contentView removeConstraint:_constraintHeightRightSwipeView];
        }
        _constraintHeightRightSwipeView = constraintHeightRightSwipeView;
        if(_constraintHeightRightSwipeView != nil) {
            [self.contentView addConstraint:_constraintHeightRightSwipeView];
        }
    }
}

- (void)setSwipeProgress:(CGFloat)swipeProgress {
    [self setSwipeProgress:swipeProgress speed:MOBILY_EPSILON endedSwipe:NO];
}

#pragma mark Public

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated {
    if(_showedLeftSwipeView != showedLeftSwipeView) {
        _showedLeftSwipeView = showedLeftSwipeView;
        _showedRightSwipeView = NO;
        
        CGFloat needSwipeProgress = (showedLeftSwipeView == YES) ? -1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? _leftSwipeView.moFrameWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) : MOBILY_EPSILON
                    endedSwipe:NO];
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated {
    if(_showedRightSwipeView != showedRightSwipeView) {
        _showedRightSwipeView = showedRightSwipeView;
        _showedLeftSwipeView = NO;
        
        CGFloat needSwipeProgress = (_showedRightSwipeView == YES) ? 1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? _rightSwipeView.moFrameWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) : MOBILY_EPSILON
                    endedSwipe:NO];
    }
}

- (void)setHiddenAnySwipeViewAnimated:(BOOL)animated {
    [self setShowedLeftSwipeView:NO animated:animated];
    [self setShowedRightSwipeView:NO animated:animated];
}

- (void)willBeganSwipe {
}

- (void)didBeganSwipe {
    self.swipeDragging = YES;
}

- (void)movingSwipe:(CGFloat __unused)progress {
}

- (void)willEndedSwipe {
    self.swipeDragging = NO;
    self.swipeDecelerating = YES;
}

- (void)didEndedSwipe {
    _showedLeftSwipeView = (_swipeProgress < 0.0f) ? YES : NO;
    _showedRightSwipeView = (_swipeProgress > 0.0f) ? YES : NO;
    self.swipeDecelerating = NO;
    if((_showedLeftSwipeView == YES) || (_showedRightSwipeView == YES)) {
        [[self tableView] setCurrentSwipeCell:self animated:YES];
    } else {
        [[self tableView] setCurrentSwipeCell:nil animated:YES];
    }
}

#pragma mark UITableViewCell

- (void)prepareForReuse {
    if([[self tableView] currentSwipeCell] == self) {
        [[self tableView] setCurrentSwipeCell:nil animated:NO];
    }
    [super prepareForReuse];
    if((_showedLeftSwipeView == YES) || (_showedRightSwipeView == YES)) {
        [self willEndedSwipe];
        [self setSwipeProgress:0.0f speed:MOBILY_EPSILON endedSwipe:YES];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if(_leftSwipeView != nil) {
        if(_leftSwipeViewWidth >= 0.0f) {
            if(_constraintWidthLeftSwipeView == nil) {
                self.constraintWidthLeftSwipeView = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_leftSwipeViewWidth];
            } else {
                _constraintOffsetLeftSwipeView.constant = _leftSwipeViewWidth;
            }
        } else {
            self.constraintWidthLeftSwipeView = nil;
        }
        if(_constraintOffsetLeftSwipeView == nil) {
            self.constraintOffsetLeftSwipeView = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:[self leftConstant]];
        } else {
            _constraintOffsetLeftSwipeView.constant = [self leftConstant];
        }
        if(_constraintCenterYLeftSwipeView == nil) {
            self.constraintCenterYLeftSwipeView = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintHeightLeftSwipeView == nil) {
            self.constraintHeightLeftSwipeView = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    }
    if(_rightSwipeView != nil) {
        if(_rightSwipeViewWidth >= 0.0f) {
            if(_constraintWidthRightSwipeView == nil) {
                self.constraintWidthRightSwipeView = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_rightSwipeViewWidth];
            } else {
                _constraintOffsetRightSwipeView.constant = _rightSwipeViewWidth;
            }
        } else {
            self.constraintWidthRightSwipeView = nil;
        }
        if(_constraintOffsetRightSwipeView == nil) {
            self.constraintOffsetRightSwipeView = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:[self rightConstant]];
        } else {
            _constraintOffsetRightSwipeView.constant = [self rightConstant];
        }
        if(_constraintCenterYRightSwipeView == nil) {
            [self setConstraintCenterYRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        }
        if(_constraintHeightRightSwipeView == nil) {
            [self setConstraintHeightRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        }
    }
}

#pragma mark Private

- (NSArray*)orderedSubviews {
    NSMutableArray* result = NSMutableArray.array;
    switch(_swipeStyle) {
        case MobilyTableSwipeCellStyleStands: {
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            if([self rootView] != nil) {
                [result addObject:[self rootView]];
            }
            break;
        }
        case MobilyTableSwipeCellStyleLeaves:
        case MobilyTableSwipeCellStylePushes: {
            if([self rootView] != nil) {
                [result addObject:[self rootView]];
            }
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            break;
        }
    }
    return result;
}

- (void)cleanupConstraint {
    [super cleanupConstraint];
    
    self.constraintOffsetLeftSwipeView = nil;
    self.constraintCenterYLeftSwipeView = nil;
    self.constraintWidthLeftSwipeView = nil;
    self.constraintHeightLeftSwipeView = nil;
    
    self.constraintOffsetRightSwipeView = nil;
    self.constraintCenterYRightSwipeView = nil;
    self.constraintWidthRightSwipeView = nil;
    self.constraintHeightRightSwipeView = nil;
}

- (CGFloat)rootConstantX {
    switch(_swipeStyle) {
        case MobilyTableSwipeCellStyleStands:
        case MobilyTableSwipeCellStyleLeaves: {
            if(_swipeProgress < 0.0f) {
                return _leftSwipeView.moFrameWidth * (-_swipeProgress);
            } else if(_swipeProgress > 0.0f) {
                return (-_rightSwipeView.moFrameWidth) * _swipeProgress;
            }
            break;
        }
        case MobilyTableSwipeCellStylePushes:
            break;
    }
    return 0.0f;
}

- (CGFloat)leftConstant {
    CGFloat leftWidth = _leftSwipeView.moFrameWidth;
    switch(_swipeStyle) {
        case MobilyTableSwipeCellStyleStands:
            return 0.0f;
        case MobilyTableSwipeCellStyleLeaves:
        case MobilyTableSwipeCellStylePushes:
            if(_swipeProgress < 0.0f) {
                return -leftWidth + (leftWidth * (-_swipeProgress));
            }
            break;
    }
    return -leftWidth;
}

- (CGFloat)rightConstant {
    CGFloat rightWidth = _rightSwipeView.moFrameWidth;
    switch(_swipeStyle) {
        case MobilyTableSwipeCellStyleStands:
            return 0.0f;
        case MobilyTableSwipeCellStyleLeaves:
        case MobilyTableSwipeCellStylePushes:
            if(_swipeProgress > 0.0f) {
                return rightWidth * (1.0f - _swipeProgress);
            }
            break;
    }
    return rightWidth;
}

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe {
    CGFloat minSwipeProgress = (_swipeDirection == MobilyDataCellSwipeDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_swipeDirection == MobilyDataCellSwipeDirectionRight) ? 1.0f :0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_swipeProgress != normalizedSwipeProgress) {
        _swipeProgress = normalizedSwipeProgress;
        [self setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:MOBILY_FABS(speed) / _swipeSpeed
                         animations:^{
                             [self updateConstraintsIfNeeded];
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished __unused) {
                             if(endedSwipe == YES) {
                                 [self didEndedSwipe];
                             }
                         }];
    } else {
        if(endedSwipe == YES) {
            [self didEndedSwipe];
        }
    }
}

- (void)handlerPanGesture {
    if(_swipeDecelerating == NO) {
        CGPoint translation = [_panGesture translationInView:self];
        CGPoint velocity = [_panGesture velocityInView:self];
        switch([_panGesture state]) {
            case UIGestureRecognizerStateBegan: {
                [self willBeganSwipe];
                self.swipeLastOffset = translation.x;
                self.swipeLastVelocity = velocity.x;
                self.swipeLeftWidth = -_leftSwipeView.moFrameWidth;
                self.swipeRightWidth = _rightSwipeView.moFrameWidth;
                self.swipeDirection = MobilyDataCellSwipeDirectionUnknown;
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat delta = _swipeLastOffset - translation.x;
                if(_swipeDirection == MobilyDataCellSwipeDirectionUnknown) {
                    if((_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.swipeDirection = MobilyDataCellSwipeDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.swipeDirection = MobilyDataCellSwipeDirectionRight;
                        [self didBeganSwipe];
                    } else if((_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.swipeDirection = MobilyDataCellSwipeDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.swipeDirection = MobilyDataCellSwipeDirectionRight;
                        [self didBeganSwipe];
                    }
                }
                if(_swipeDirection != MobilyDataCellSwipeDirectionUnknown) {
                    switch(_swipeDirection) {
                        case MobilyDataCellSwipeDirectionUnknown: {
                            break;
                        }
                        case MobilyDataCellSwipeDirectionLeft: {
                            CGFloat localDelta = MIN(MAX(_swipeLeftWidth, delta), -_swipeLeftWidth);
                            [self setSwipeProgress:_swipeProgress - (localDelta / _swipeLeftWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                        case MobilyDataCellSwipeDirectionRight: {
                            CGFloat localDelta = MIN(MAX(-_swipeRightWidth, delta), _swipeRightWidth);
                            [self setSwipeProgress:_swipeProgress + (localDelta / _swipeRightWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                    }
                    self.swipeLastOffset = translation.x;
                    self.swipeLastVelocity = velocity.x;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                [self willEndedSwipe];
                CGFloat swipeProgress = roundf(_swipeProgress - (_swipeLastVelocity / _swipeVelocity));
                CGFloat minSwipeProgress = (_swipeDirection == MobilyDataCellSwipeDirectionLeft) ? -1.0f : 0.0f;
                CGFloat maxSwipeProgress = (_swipeDirection == MobilyDataCellSwipeDirectionRight) ? 1.0f : 0.0f;
                CGFloat needSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
                switch(_swipeDirection) {
                    case MobilyDataCellSwipeDirectionLeft: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeLeftWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    case MobilyDataCellSwipeDirectionRight: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeRightWidth * MOBILY_FABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    default: {
                        [self didEndedSwipe];
                        break;
                    }
                }
                break;
            }
            default: {
                break;
            }
        }
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer == _panGesture) {
        if((_swipeDragging == NO) && (_swipeDecelerating == NO)) {
            CGPoint translation = [_panGesture translationInView:self];
            if(MOBILY_FABS(translation.x) >= MOBILY_FABS(translation.y)) {
                if((_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (translation.x < 0.0f)) {
                    return YES;
                } else if((_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (translation.x > 0.0f)) {
                    return YES;
                } else if((_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (translation.x > 0.0f)) {
                    return YES;
                } else if((_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (translation.x < 0.0f)) {
                    return YES;
                }
                return NO;
            }
        }
    }
    return NO;
}

@end

/*--------------------------------------------------*/
