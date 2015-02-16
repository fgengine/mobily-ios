/*--------------------------------------------------*/

#import "MobilyTableView.h"

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

typedef NS_ENUM(NSUInteger, MobilyTableSwipeCellDirection) {
    MobilyTableSwipeCellDirectionUnknown,
    MobilyTableSwipeCellDirectionLeft,
    MobilyTableSwipeCellDirectionRight
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
@property(nonatomic, readwrite, assign) MobilyTableSwipeCellDirection swipeDirection;

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
    [self setRegisteredCellNibs:[NSMutableDictionary dictionary]];
    [self setRegisteredHeaderFooterNibs:[NSMutableDictionary dictionary]];
    
    [self registerAdjustmentResponder];
}

- (void)dealloc {
    [self unregisterAdjustmentResponder];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
    [self setRegisteredCellNibs:nil];
    [self setRegisteredHeaderFooterNibs:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyBuilderObject

- (void)addObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andAddingObject:objectChild]];
        [self addSubview:(UIView*)objectChild];
    }
}

- (void)removeObjectChild:(id< MobilyBuilderObject >)objectChild {
    if([objectChild isKindOfClass:[UIView class]] == YES) {
        [self setObjectChilds:[NSArray arrayWithArray:_objectChilds andRemovingObject:objectChild]];
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

#pragma mark Property

- (void)setCurrentSwipeCell:(MobilyTableSwipeCell*)currentSwipeCell {
    [self setCurrentSwipeCell:currentSwipeCell animated:NO];
}

#pragma mark Public

- (void)setCurrentSwipeCell:(MobilyTableSwipeCell*)currentSwipeCell animated:(BOOL)animated {
    if(_currentSwipeCell != currentSwipeCell) {
        if(_currentSwipeCell != nil) {
            [_currentSwipeCell setHiddenAnySwipeViewAnimated:animated];
        }
        MOBILY_SAFE_SETTER(_currentSwipeCell, currentSwipeCell);
    }
}

- (void)registerCellClass:(Class)cellClass {
    UINib* nib = [UINib nibWithClass:cellClass bundle:nil];
    if(nib != nil) {
        [_registeredCellNibs setObject:nib forKey:NSStringFromClass(cellClass)];
        [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    }
}

- (void)registerHeaderFooterClass:(Class)headerFooterClass {
    UINib* nib = [UINib nibWithClass:headerFooterClass bundle:nil];
    if(nib != nil) {
        [_registeredHeaderFooterNibs setObject:nib forKey:NSStringFromClass(headerFooterClass)];
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(headerFooterClass)];
    }
}

- (id)dequeueReusableCellWithClass:(Class)cellClass {
    id cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    [cell setTableView:self];
    if([cell rootView] == nil) {
        UINib* nib = [_registeredCellNibs objectForKey:NSStringFromClass(cellClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:cell options:nil];
            if([cell isKindOfClass:[MobilyTableCell class]] == YES) {
                [cell didLoadFromNib];
            }
        }
    }
    return cell;
}

- (id)dequeueReusableCellWithClass:(Class)cellClass forIndexPath:(NSIndexPath*)indexPath {
    id cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    [cell setTableView:self];
    if([cell rootView] == nil) {
        UINib* nib = [_registeredCellNibs objectForKey:NSStringFromClass(cellClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:cell options:nil];
            if([cell isKindOfClass:[MobilyTableCell class]] == YES) {
                [cell didLoadFromNib];
            }
        }
    }
    return cell;
}

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)headerFooterClass {
    id headerFooter = [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerFooterClass)];
    [headerFooter setTableView:self];
    if([headerFooter rootView] == nil) {
        UINib* nib = [_registeredHeaderFooterNibs objectForKey:NSStringFromClass(headerFooterClass)];
        if(nib != nil) {
            [nib instantiateWithOwner:headerFooter options:nil];
            if([headerFooter isKindOfClass:[MobilyTableCell class]] == YES) {
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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setClipsToBounds:YES];
}

- (void)dealloc {
    [self setConstraintCenterXRootView:nil];
    [self setConstraintCenterYRootView:nil];
    [self setConstraintWidthRootView:nil];
    [self setConstraintHeightRootView:nil];
    [self setRootView:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setRootView:(UIView*)rootView {
    if(_rootView != rootView) {
        if(_rootView != nil) {
            [self cleanupConstraint];
            [_rootView removeFromSuperview];
        }
        MOBILY_SAFE_SETTER(_rootView, rootView);
        if(_rootView != nil) {
            [_rootView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self contentView] setSubviews:[self orderedSubviews]];
            [self setNeedsUpdateConstraints];
        }
    }
}

- (void)setConstraintCenterXRootView:(NSLayoutConstraint*)constraintCenterXRootView {
    if(_constraintCenterXRootView != constraintCenterXRootView) {
        if(_constraintCenterXRootView != nil) {
            [[self contentView] removeConstraint:_constraintCenterXRootView];
        }
        MOBILY_SAFE_SETTER(_constraintCenterXRootView, constraintCenterXRootView);
        if(_constraintCenterXRootView != nil) {
            [[self contentView] addConstraint:_constraintCenterXRootView];
        }
    }
}

- (void)setConstraintCenterYRootView:(NSLayoutConstraint*)constraintCenterYRootView {
    if(_constraintCenterYRootView != constraintCenterYRootView) {
        if(_constraintCenterYRootView != nil) {
            [[self contentView] removeConstraint:_constraintCenterYRootView];
        }
        MOBILY_SAFE_SETTER(_constraintCenterYRootView, constraintCenterYRootView);
        if(_constraintCenterYRootView != nil) {
            [[self contentView] addConstraint:_constraintCenterYRootView];
        }
    }
}

- (void)setConstraintWidthRootView:(NSLayoutConstraint*)constraintWidthRootView {
    if(_constraintWidthRootView != constraintWidthRootView) {
        if(_constraintWidthRootView != nil) {
            [[self contentView] removeConstraint:_constraintWidthRootView];
        }
        MOBILY_SAFE_SETTER(_constraintWidthRootView, constraintWidthRootView);
        if(_constraintWidthRootView != nil) {
            [[self contentView] addConstraint:_constraintWidthRootView];
        }
    }
}

- (void)setConstraintHeightRootView:(NSLayoutConstraint*)constraintHeightRootView {
    if(_constraintHeightRootView != constraintHeightRootView) {
        if(_constraintHeightRootView != nil) {
            [[self contentView] removeConstraint:_constraintHeightRootView];
        }
        MOBILY_SAFE_SETTER(_constraintHeightRootView, constraintHeightRootView);
        if(_constraintHeightRootView != nil) {
            [[self contentView] addConstraint:_constraintHeightRootView];
        }
    }
}

#pragma mark Public

- (void)didLoadFromNib {
}

+ (CGFloat)heightForModel:(id)model tableView:(UITableView*)tableView {
    return 240.0f;
}

#pragma mark UITableViewCell

- (void)updateConstraints {
    [super updateConstraints];
    
    if(_constraintCenterXRootView == nil) {
        [self setConstraintCenterXRootView:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:[self rootConstantX]]];
    } else {
        [_constraintCenterXRootView setConstant:[self rootConstantX]];
    }
    if(_constraintCenterYRootView == nil) {
        [self setConstraintCenterYRootView:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:[self rootConstantY]]];
    } else {
        [_constraintCenterYRootView setConstant:[self rootConstantY]];
    }
    if(_constraintWidthRootView == nil) {
        [self setConstraintWidthRootView:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeWidth multiplier:1.0f constant:[self rootConstantWidth]]];
    } else {
        [_constraintWidthRootView setConstant:[self rootConstantWidth]];
    }
    if(_constraintHeightRootView == nil) {
        [self setConstraintHeightRootView:[NSLayoutConstraint constraintWithItem:_rootView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeHeight multiplier:1.0f constant:[self rootConstantHeight]]];
    } else {
        [_constraintHeightRootView setConstant:[self rootConstantHeight]];
    }
}

#pragma mark Private

- (NSArray*)orderedSubviews {
    NSMutableArray* result = [NSMutableArray array];
    if(_rootView != nil) {
        [result addObject:_rootView];
    }
    return result;
}

- (void)cleanupConstraint {
    [self setConstraintCenterXRootView:nil];
    [self setConstraintCenterYRootView:nil];
    [self setConstraintWidthRootView:nil];
    [self setConstraintHeightRootView:nil];
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
    
    [self setPanGesture:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGesture)]];
    
    [self setSwipeStyle:MobilyTableSwipeCellStyleLeaves];
    [self setSwipeThreshold:2.0f];
    [self setSwipeSpeed:1050.0f];
    [self setSwipeVelocity:570.0f];
    [self setLeftSwipeViewWidth:-1.0f];
    [self setRightSwipeViewWidth:-1.0f];
}

- (void)dealloc {
    [self setPanGesture:nil];
    [self setConstraintOffsetLeftSwipeView:nil];
    [self setLeftSwipeView:nil];
    [self setConstraintOffsetRightSwipeView:nil];
    [self setRightSwipeView:nil];

    MOBILY_SAFE_DEALLOC;
}

#pragma mark Property

- (void)setPanGesture:(UIPanGestureRecognizer*)gesturePanSwipeRight {
    if(_panGesture != gesturePanSwipeRight) {
        if(_panGesture != nil) {
            [self removeGestureRecognizer:_panGesture];
        }
        MOBILY_SAFE_SETTER(_panGesture, gesturePanSwipeRight);
        if(_panGesture != nil) {
            [_panGesture setDelegate:self];
            [self addGestureRecognizer:_panGesture];
        }
    }
}

- (void)setSwipeStyle:(MobilyTableSwipeCellStyle)swipeStyle {
    if(_swipeStyle != swipeStyle) {
        [self cleanupConstraint];
        _swipeStyle = swipeStyle;
        [[self contentView] setSubviews:[self orderedSubviews]];
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
        MOBILY_SAFE_SETTER(_leftSwipeView, leftSwipeView);
        if(_leftSwipeView != nil) {
            [_leftSwipeView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self contentView] setSubviews:[self orderedSubviews]];
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
            [[self contentView] removeConstraint:_constraintOffsetLeftSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintOffsetLeftSwipeView, constraintOffsetLeftSwipeView);
        if(_constraintOffsetLeftSwipeView != nil) {
            [[self contentView] addConstraint:_constraintOffsetLeftSwipeView];
        }
    }
}

- (void)setConstraintCenterYLeftSwipeView:(NSLayoutConstraint*)constraintCenterYLeftSwipeView {
    if(_constraintCenterYLeftSwipeView != constraintCenterYLeftSwipeView) {
        if(_constraintCenterYLeftSwipeView != nil) {
            [[self contentView] removeConstraint:_constraintCenterYLeftSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintCenterYLeftSwipeView, constraintCenterYLeftSwipeView);
        if(_constraintCenterYLeftSwipeView != nil) {
            [[self contentView] addConstraint:_constraintCenterYLeftSwipeView];
        }
    }
}

- (void)setConstraintWidthLeftSwipeView:(NSLayoutConstraint*)constraintWidthLeftSwipeView {
    if(_constraintWidthLeftSwipeView != constraintWidthLeftSwipeView) {
        if(_constraintWidthLeftSwipeView != nil) {
            [_leftSwipeView removeConstraint:_constraintWidthLeftSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintWidthLeftSwipeView, constraintWidthLeftSwipeView);
        if(_constraintWidthLeftSwipeView != nil) {
            [_leftSwipeView addConstraint:_constraintWidthLeftSwipeView];
        }
    }
}

- (void)setConstraintHeightLeftSwipeView:(NSLayoutConstraint*)constraintHeightLeftSwipeView {
    if(_constraintHeightLeftSwipeView != constraintHeightLeftSwipeView) {
        if(_constraintHeightLeftSwipeView != nil) {
            [[self contentView] removeConstraint:_constraintHeightLeftSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintHeightLeftSwipeView, constraintHeightLeftSwipeView);
        if(_constraintHeightLeftSwipeView != nil) {
            [[self contentView] addConstraint:_constraintHeightLeftSwipeView];
        }
    }
}

- (void)setRightSwipeView:(UIView*)rightSwipeView {
    if(_rightSwipeView != rightSwipeView) {
        if(_rightSwipeView != nil) {
            [self cleanupConstraint];
            [_rightSwipeView removeFromSuperview];
        }
        MOBILY_SAFE_SETTER(_rightSwipeView, rightSwipeView);
        if(_rightSwipeView != nil) {
            [_rightSwipeView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [[self contentView] setSubviews:[self orderedSubviews]];
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
            [[self contentView] removeConstraint:_constraintOffsetRightSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintOffsetRightSwipeView, constraintOffsetRightSwipeView);
        if(_constraintOffsetRightSwipeView != nil) {
            [[self contentView] addConstraint:_constraintOffsetRightSwipeView];
        }
    }
}

- (void)setConstraintCenterYRightSwipeView:(NSLayoutConstraint*)constraintCenterYRightSwipeView {
    if(_constraintCenterYRightSwipeView != constraintCenterYRightSwipeView) {
        if(_constraintCenterYRightSwipeView != nil) {
            [[self contentView] removeConstraint:_constraintCenterYRightSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintCenterYRightSwipeView, constraintCenterYRightSwipeView);
        if(_constraintCenterYRightSwipeView != nil) {
            [[self contentView] addConstraint:_constraintCenterYRightSwipeView];
        }
    }
}

- (void)setConstraintWidthRightSwipeView:(NSLayoutConstraint*)constraintWidthRightSwipeView {
    if(_constraintWidthRightSwipeView != constraintWidthRightSwipeView) {
        if(_constraintWidthRightSwipeView != nil) {
            [_rightSwipeView removeConstraint:_constraintWidthRightSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintWidthRightSwipeView, constraintWidthRightSwipeView);
        if(_constraintWidthRightSwipeView != nil) {
            [_rightSwipeView addConstraint:_constraintWidthRightSwipeView];
        }
    }
}

- (void)setConstraintHeightRightSwipeView:(NSLayoutConstraint*)constraintHeightRightSwipeView {
    if(_constraintHeightRightSwipeView != constraintHeightRightSwipeView) {
        if(_constraintHeightRightSwipeView != nil) {
            [[self contentView] removeConstraint:_constraintHeightRightSwipeView];
        }
        MOBILY_SAFE_SETTER(_constraintHeightRightSwipeView, constraintHeightRightSwipeView);
        if(_constraintHeightRightSwipeView != nil) {
            [[self contentView] addConstraint:_constraintHeightRightSwipeView];
        }
    }
}

- (void)setSwipeProgress:(CGFloat)swipeProgress {
    [self setSwipeProgress:swipeProgress speed:FLT_EPSILON endedSwipe:NO];
}

#pragma mark Public

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated {
    if(_showedLeftSwipeView != showedLeftSwipeView) {
        _showedLeftSwipeView = showedLeftSwipeView;
        _showedRightSwipeView = NO;
        
        CGFloat needSwipeProgress = (showedLeftSwipeView == YES) ? -1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? [_leftSwipeView frameWidth] * ABS(needSwipeProgress - _swipeProgress) : FLT_EPSILON
                    endedSwipe:NO];
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated {
    if(_showedRightSwipeView != showedRightSwipeView) {
        _showedRightSwipeView = showedRightSwipeView;
        _showedLeftSwipeView = NO;
        
        CGFloat needSwipeProgress = (_showedRightSwipeView == YES) ? 1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? [_rightSwipeView frameWidth] * ABS(needSwipeProgress - _swipeProgress) : FLT_EPSILON
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
    [self setSwipeDragging:YES];
}

- (void)movingSwipe:(CGFloat)progress {
}

- (void)willEndedSwipe {
    [self setSwipeDragging:NO];
    [self setSwipeDecelerating:YES];
}

- (void)didEndedSwipe {
    _showedLeftSwipeView = (_swipeProgress < 0.0f) ? YES : NO;
    _showedRightSwipeView = (_swipeProgress > 0.0f) ? YES : NO;
    [self setSwipeDecelerating:NO];
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
        [self setSwipeProgress:0.0f speed:FLT_EPSILON endedSwipe:YES];
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if(_leftSwipeView != nil) {
        if(_leftSwipeViewWidth >= 0.0f) {
            if(_constraintWidthLeftSwipeView == nil) {
                [self setConstraintWidthLeftSwipeView:[NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_leftSwipeViewWidth]];
            } else {
                [_constraintOffsetLeftSwipeView setConstant:_leftSwipeViewWidth];
            }
        } else {
            [self setConstraintWidthLeftSwipeView:nil];
        }
        if(_constraintOffsetLeftSwipeView == nil) {
            [self setConstraintOffsetLeftSwipeView:[NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeLeft multiplier:1.0f constant:[self leftConstant]]];
        } else {
            [_constraintOffsetLeftSwipeView setConstant:[self leftConstant]];
        }
        if(_constraintCenterYLeftSwipeView == nil) {
            [self setConstraintCenterYLeftSwipeView:[NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        }
        if(_constraintHeightLeftSwipeView == nil) {
            [self setConstraintHeightLeftSwipeView:[NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        }
    }
    if(_rightSwipeView != nil) {
        if(_rightSwipeViewWidth >= 0.0f) {
            if(_constraintWidthRightSwipeView == nil) {
                [self setConstraintWidthRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_rightSwipeViewWidth]];
            } else {
                [_constraintOffsetRightSwipeView setConstant:_rightSwipeViewWidth];
            }
        } else {
            [self setConstraintWidthRightSwipeView:nil];
        }
        if(_constraintOffsetRightSwipeView == nil) {
            [self setConstraintOffsetRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeRight multiplier:1.0f constant:[self rightConstant]]];
        } else {
            [_constraintOffsetRightSwipeView setConstant:[self rightConstant]];
        }
        if(_constraintCenterYRightSwipeView == nil) {
            [self setConstraintCenterYRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        }
        if(_constraintHeightRightSwipeView == nil) {
            [self setConstraintHeightRightSwipeView:[NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[self contentView] attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        }
    }
}

#pragma mark Private

- (NSArray*)orderedSubviews {
    NSMutableArray* result = [NSMutableArray array];
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
    
    [self setConstraintOffsetLeftSwipeView:nil];
    [self setConstraintCenterYLeftSwipeView:nil];
    [self setConstraintWidthLeftSwipeView:nil];
    [self setConstraintHeightLeftSwipeView:nil];
    
    [self setConstraintOffsetRightSwipeView:nil];
    [self setConstraintCenterYRightSwipeView:nil];
    [self setConstraintWidthRightSwipeView:nil];
    [self setConstraintHeightRightSwipeView:nil];
}

- (CGFloat)rootConstantX {
    switch(_swipeStyle) {
        case MobilyTableSwipeCellStyleStands:
        case MobilyTableSwipeCellStyleLeaves: {
            if(_swipeProgress < 0.0f) {
                return [_leftSwipeView frameWidth] * (-_swipeProgress);
            } else if(_swipeProgress > 0.0f) {
                return (-[_rightSwipeView frameWidth]) * _swipeProgress;
            }
            break;
        }
        case MobilyTableSwipeCellStylePushes:
            break;
    }
    return 0.0f;
}

- (CGFloat)leftConstant {
    CGFloat leftWidth = [_leftSwipeView frameWidth];
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
    CGFloat rightWidth = [_rightSwipeView frameWidth];
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
    CGFloat minSwipeProgress = (_swipeDirection == MobilyTableSwipeCellDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_swipeDirection == MobilyTableSwipeCellDirectionRight) ? 1.0f :0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_swipeProgress != normalizedSwipeProgress) {
        _swipeProgress = normalizedSwipeProgress;
        [self setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:ABS(speed) / _swipeSpeed
                         animations:^{
                             [self updateConstraintsIfNeeded];
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
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
                [self setSwipeLastOffset:translation.x];
                [self setSwipeLastVelocity:velocity.x];
                [self setSwipeLeftWidth:-[_leftSwipeView frameWidth]];
                [self setSwipeRightWidth:[_rightSwipeView frameWidth]];
                [self setSwipeDirection:MobilyTableSwipeCellDirectionUnknown];
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat delta = _swipeLastOffset - translation.x;
                if(_swipeDirection == MobilyTableSwipeCellDirectionUnknown) {
                    if((_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (delta > _swipeThreshold)) {
                        [self setSwipeDirection:MobilyTableSwipeCellDirectionLeft];
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (delta < -_swipeThreshold)) {
                        [self setSwipeDirection:MobilyTableSwipeCellDirectionRight];
                        [self didBeganSwipe];
                    } else if((_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (delta < -_swipeThreshold)) {
                        [self setSwipeDirection:MobilyTableSwipeCellDirectionLeft];
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (delta > _swipeThreshold)) {
                        [self setSwipeDirection:MobilyTableSwipeCellDirectionRight];
                        [self didBeganSwipe];
                    }
                }
                if(_swipeDirection != MobilyTableSwipeCellDirectionUnknown) {
                    switch(_swipeDirection) {
                        case MobilyTableSwipeCellDirectionUnknown: {
                            break;
                        }
                        case MobilyTableSwipeCellDirectionLeft: {
                            CGFloat localDelta = MIN(MAX(_swipeLeftWidth, delta), -_swipeLeftWidth);
                            [self setSwipeProgress:_swipeProgress - (localDelta / _swipeLeftWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                        case MobilyTableSwipeCellDirectionRight: {
                            CGFloat localDelta = MIN(MAX(-_swipeRightWidth, delta), _swipeRightWidth);
                            [self setSwipeProgress:_swipeProgress + (localDelta / _swipeRightWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_swipeProgress];
                            break;
                        }
                    }
                    [self setSwipeLastOffset:translation.x];
                    [self setSwipeLastVelocity:velocity.x];
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                [self willEndedSwipe];
                CGFloat swipeProgress = roundf(_swipeProgress - (_swipeLastVelocity / _swipeVelocity));
                CGFloat minSwipeProgress = (_swipeDirection == MobilyTableSwipeCellDirectionLeft) ? -1.0f : 0.0f;
                CGFloat maxSwipeProgress = (_swipeDirection == MobilyTableSwipeCellDirectionRight) ? 1.0f : 0.0f;
                CGFloat needSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
                switch(_swipeDirection) {
                    case MobilyTableSwipeCellDirectionLeft: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeLeftWidth * ABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
                        break;
                    }
                    case MobilyTableSwipeCellDirectionRight: {
                        [self setSwipeProgress:needSwipeProgress speed:_swipeRightWidth * ABS(needSwipeProgress - _swipeProgress) endedSwipe:YES];
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
    if((_swipeDragging == NO) && (_swipeDecelerating == NO)) {
        CGPoint translation = [_panGesture translationInView:self];
        if(fabs(translation.x) >= fabs(translation.y)) {
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
    return NO;
}

@end

/*--------------------------------------------------*/
