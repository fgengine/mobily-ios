//----------------------------------------------//

#import "FGScrollView.h"
#import "FGResponder.h"

//----------------------------------------------//

@interface FGScrollView ()

- (void)setup;

- (void)keyboardShow:(NSNotification*)notification;
- (void)keyboardHide:(NSNotification*)notification;

@end

//----------------------------------------------//

@implementation FGScrollView

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UIKeyboarNotification

- (void)keyboardShow:(NSNotification*)notification {
    UIResponder* currentResponder = [FGResponder currentFirstResponder];
    if(currentResponder != nil) {
        if([currentResponder isKindOfClass:[UIView class]] == YES) {
            UIView* view = (UIView*)currentResponder;
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
}

- (void)keyboardHide:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    if(info != nil) {
        NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration
                         animations:^{
                             [self setScrollIndicatorInsets:UIEdgeInsetsZero];
                             [self setContentInset:UIEdgeInsetsZero];
                         }];
    }
}

@end

//----------------------------------------------//
