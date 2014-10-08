//----------------------------------------------//

#import "MobilyViewTable.h"

//----------------------------------------------//

@interface MobilyViewTable ()

@property(nonatomic, readwrite, strong) NSMutableArray* section;

@property(nonatomic, readwrite, weak) UIResponder* keyboardResponder;

- (void)notificationKeyboardShow:(NSNotification*)notification;
- (void)notificationKeyboardHide:(NSNotification*)notification;
- (void)updateData;

@end

//----------------------------------------------//

@interface MobilyViewTableSection ()

@property(nonatomic, readwrite, strong) NSMutableArray* rows;

@end

//----------------------------------------------//

@interface MobilyViewTableRowFactory ()



@end

//----------------------------------------------//

@interface MobilyViewTableCell ()



@end

//----------------------------------------------//

@implementation MobilyViewTable

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
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

#pragma mark UIKeyboarNotification

- (void)notificationKeyboardShow:(NSNotification*)notification {
    [self setKeyboardResponder:[UIResponder currentFirstResponderInView:self]];
    if([_keyboardResponder isKindOfClass:[UIView class]] == YES) {
        UIView* view = (UIView*)_keyboardResponder;
        NSDictionary* info = [notification userInfo];
        if(info != nil) {
            CGRect screenRect = [[self window] bounds];
            CGRect scrollRect = [self convertRect:[self bounds] toView:[[[self window] rootViewController] view]];
            CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            UIEdgeInsets scrollInsets = [self contentInset];
            CGPoint scrollOffset = [self contentOffset];
            CGSize scrollSize = [self contentSize];
            
            CGFloat overallSize = 0.0f;
            switch([[UIApplication sharedApplication] statusBarOrientation]) {
                case UIInterfaceOrientationPortrait:
                case UIInterfaceOrientationPortraitUpsideDown:
                    overallSize = ABS((screenRect.size.height - keyboardRect.size.height) - (scrollRect.origin.y + scrollRect.size.height));
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    overallSize = ABS((screenRect.size.width - keyboardRect.size.width) - (scrollRect.origin.y + scrollRect.size.height));
                    break;
                case UIInterfaceOrientationUnknown:
                    break;
            }
            scrollInsets = UIEdgeInsetsMake(scrollInsets.top, scrollInsets.left, overallSize, scrollInsets.right);
            [self setScrollIndicatorInsets:scrollInsets];
            [self setContentInset:scrollInsets];
            
            scrollRect = UIEdgeInsetsInsetRect(scrollRect, scrollInsets);
            
            CGRect rect = [view convertRect:[view bounds] toView:self];
            scrollOffset.y = (rect.origin.y + (rect.size.height * 0.5f)) - (scrollRect.size.height * 0.5f);
            if(scrollOffset.y < 0.0f) {
                scrollOffset.y = 0.0f;
            } else if(scrollOffset.y > scrollSize.height - scrollRect.size.height) {
                scrollOffset.y = scrollSize.height - scrollRect.size.height;
            }
            [self setContentOffset:scrollOffset animated:YES];
        }
    }
}

- (void)notificationKeyboardHide:(NSNotification*)notification {
    if(_keyboardResponder != nil) {
        NSDictionary* info = [notification userInfo];
        if(info != nil) {
            NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            [UIView animateWithDuration:duration
                             animations:^{
                                 [self setScrollIndicatorInsets:UIEdgeInsetsZero];
                                 [self setContentInset:UIEdgeInsetsZero];
                             }];
        }
        [self setKeyboardResponder:nil];
    }
}

- (void)updateData {
    [self reloadData];
}

#pragma mark Public

- (void)setupView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setArray:(NSArray*)array {
    [self updateData];
}

- (void)addObject:(id)object {
    [self updateData];
}

- (void)addObjectsFromArray:(NSArray*)array {
    [self updateData];
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    [self updateData];
}

- (void)insertObjectsFromArray:(NSArray*)array atIndex:(NSUInteger)index {
    [self updateData];
}

- (void)removeObjectsInArray:(NSArray*)array {
    [self updateData];
}

- (void)removeObjectsInRange:(NSRange)range {
    [self updateData];
}

- (void)removeObject:(id)object inRange:(NSRange)range {
    [self updateData];
}

- (void)removeObject:(id)object {
    [self updateData];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self updateData];
}

- (void)removeLastObject {
    [self updateData];
}

- (void)removeAllObjects {
    [self updateData];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray range:(NSRange)otherRange {
    [self updateData];
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray {
    [self updateData];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [self updateData];
}

- (void)registerClassCell:(Class)classCell classData:(Class)classData {
}

- (void)unregisterClassCell:(Class)classCell classData:(Class)classData {
}

@end

//----------------------------------------------//

@implementation MobilyViewTableSection

- (void)registerClassCell:(Class)classCell classData:(Class)classData {
}

- (void)unregisterClassCell:(Class)classCell classData:(Class)classData {
}

@end

//----------------------------------------------//

@implementation MobilyViewTableRowFactory

- (id)initWithClassCell:(Class)classCell classData:(Class)classData {
    self = [super init];
    if(self != nil) {
    }
    return self;
}

@end

//----------------------------------------------//

@implementation MobilyViewTableCell

@synthesize objectName = _objectName;
@synthesize objectParent = _objectParent;
@synthesize objectChilds = _objectChilds;

#pragma mark Standart

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setObjectName:nil];
    [self setObjectParent:nil];
    [self setObjectChilds:nil];
    
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

#pragma mark Public

- (void)setupView {
}

@end

//----------------------------------------------//
