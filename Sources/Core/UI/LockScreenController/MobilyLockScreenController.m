/*--------------------------------------------------*/

#import <MobilyLockScreenController.h>
#import <MobilyLockScreenPincodeView.h>
#import <MobilyButton.h>

/*--------------------------------------------------*/

#import <MobilyTimeout.h>

/*--------------------------------------------------*/

#import <AudioToolbox/AudioToolbox.h>
#import <LocalAuthentication/LocalAuthentication.h>

/*--------------------------------------------------*/

@interface MobilyLockScreenController () < MobilyLockScreenPincodeViewDelegate > {
    MobilyLockScreenMode _prevLockScreenMode;
    NSString* _confirmPincode;
}

@property(nonatomic, readwrite, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, readwrite, weak) IBOutlet UILabel* subtitleLabel;
@property(nonatomic, readwrite, weak) IBOutlet MobilyButton* cancelButton;
@property(nonatomic, readwrite, weak) IBOutlet MobilyLockScreenPincodeView* pincodeView;

- (BOOL)_isPincodeValid:(NSString*)pincode;
- (void)_policyDeviceOwnerAuthentication;
- (void)_unlockDelayDismissViewController:(NSTimeInterval)delay;
- (void)_unlockScreenSuccessful:(NSString*)pincode;
- (void)_unlockScreenFailure;

- (CAAnimation*)_makeShakeAnimation;

- (void)_swipeSubtitleAndPincodeView;
- (NSLayoutConstraint*)_findLayoutConstraint:(UIView*)superview childView:(UIView*)childView attribute:(NSLayoutAttribute)attribute;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

static const NSTimeInterval MobilyLockScreenController_SwipeAnimationDuration = 0.3f;
static const NSTimeInterval MobilyLockScreenController_DismissWaitingDuration = 0.4f;
static const NSTimeInterval MobilyLockScreenController_ShakeAnimationDuration = 0.5f;

/*--------------------------------------------------*/

@implementation MobilyLockScreenController

- (void)setup {
    [super setup];
    
    _allowTouchID = YES;
}

#pragma mark Load / Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch(_lockScreenMode) {
        case MobilyLockScreenModeUnlock:
        case MobilyLockScreenModeVerification:
            _cancelButton.hidden = YES;
            break;
        case MobilyLockScreenModeAuth:
        case MobilyLockScreenModeNew:
        case MobilyLockScreenModeChange:
            _cancelButton.hidden = NO;
            break;
    }
    [self _updateTitle:NSLocalizedStringFromTable(@"Pincode Title", @"MobilyLockScreenController", nil)
              subtitle:NSLocalizedStringFromTable(@"Pincode Subtitle", @"MobilyLockScreenController", nil)];
}

#pragma mark Appear / Disappear

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if((_lockScreenMode == MobilyLockScreenModeUnlock) && (_allowTouchID == YES)) {
        [self _policyDeviceOwnerAuthentication];
    }
}

#pragma mark Property

- (void)setPincodeView:(MobilyLockScreenPincodeView*)pincodeView {
    if(_pincodeView != pincodeView) {
        if(_pincodeView != nil) {
            _pincodeView.delegate = nil;
        }
        _pincodeView = pincodeView;
        if(_pincodeView != nil) {
            _pincodeView.delegate = self;
        }
    }
}

#pragma mark Private

- (BOOL)_isPincodeValid:(NSString*)pincode {
    if(_lockScreenMode == MobilyLockScreenModeVerification) {
        return [_confirmPincode isEqualToString:pincode];
    }
    return [_pincode isEqualToString:pincode];
}

- (void)_updateTitle:(NSString*)title subtitle:(NSString*)subtitle {
    [_titleLabel setText:title];
    [_subtitleLabel setText:subtitle];
}

- (void)_policyDeviceOwnerAuthentication {
    NSError* error   = nil;
    LAContext* context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:NSLocalizedStringFromTable(@"Pincode TouchID", @"MobilyLockScreenController", nil)
                          reply:^(BOOL success, NSError* authenticationError) {
                              if(success == YES) {
                                  [self _unlockDelayDismissViewController:MobilyLockScreenController_DismissWaitingDuration];
                              } else {
                                  NSLog(@"MobilyLockScreenController::LAContext::Authentication Error : %@", authenticationError);
                              }
                          }];
    } else {
        NSLog(@"MobilyLockScreenController::LAContext::Policy Error : %@", [error localizedDescription]);
    }
}

- (void)_unlockDelayDismissViewController:(NSTimeInterval)delay {
    [_pincodeView wasCompleted];
    [MobilyTimeout executeBlock:^{
        [self dismissViewControllerAnimated:NO completion:^{
            if(_didSuccessfulBlock != nil) {
                _didSuccessfulBlock();
            }
        }];
    } afterDelay:delay];
}

- (void)_unlockScreenSuccessful:(NSString*)pincode {
    [self dismissViewControllerAnimated:NO completion:^{
        switch(_lockScreenMode) {
            case MobilyLockScreenModeUnlock:
            case MobilyLockScreenModeAuth:
                if(_didSuccessfulBlock != nil) {
                    _didSuccessfulBlock();
                }
                break;
            case MobilyLockScreenModeNew:
            case MobilyLockScreenModeChange: {
                if(_didChangeBlock != nil) {
                    _didChangeBlock(pincode);
                }
                break;
            default:
                break;
            }
        }
    }];
}

- (void)_unlockScreenFailure {
    if(_lockScreenMode != MobilyLockScreenModeVerification) {
        if(_didFailureBlock != nil) {
            _didFailureBlock();
        }
    }

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [_pincodeView.layer addAnimation:[self _makeShakeAnimation] forKey:@"shake"];
    [_subtitleLabel setText:NSLocalizedStringFromTable(@"Pincode Not Match Title", @"MobilyLockScreenController", nil)];
    [_pincodeView setEnabled:NO];
    
    [MobilyTimeout executeBlock:^{
        [_pincodeView setEnabled:YES];
        [_pincodeView initPincode];
        switch(_lockScreenMode) {
            case MobilyLockScreenModeUnlock:
            case MobilyLockScreenModeAuth:
            case MobilyLockScreenModeNew: {
                [self _updateTitle:NSLocalizedStringFromTable(@"Pincode Title", @"MobilyLockScreenController", nil)
                          subtitle:NSLocalizedStringFromTable(@"Pincode Subtitle", @"MobilyLockScreenController", nil)];
                break;
            }
            case MobilyLockScreenModeChange:
                [self _updateTitle:NSLocalizedStringFromTable(@"New Pincode Title", @"MobilyLockScreenController", nil)
                          subtitle:NSLocalizedStringFromTable(@"New Pincode Subtitle", @"MobilyLockScreenController", nil)];
                break;
            default:
                break;
        }
    } afterDelay:MobilyLockScreenController_ShakeAnimationDuration];
}

- (CAAnimation*)_makeShakeAnimation {
    CAKeyframeAnimation* shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shake.duration = MobilyLockScreenController_ShakeAnimationDuration;
    shake.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
    return shake;
}

- (void)_swipeSubtitleAndPincodeView {
    __weak UIView* weakView = self.view;
    __weak MobilyLockScreenPincodeView* weakCode = _pincodeView;
    [_pincodeView setEnabled:NO];
    
    NSLayoutConstraint* centerX = [self _findLayoutConstraint:weakView childView:_subtitleLabel attribute:NSLayoutAttributeCenterX];
    centerX.constant = CGRectGetWidth(self.view.bounds);
    [UIView animateWithDuration:MobilyLockScreenController_SwipeAnimationDuration animations:^{
        [weakView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakCode initPincode];
        centerX.constant = -CGRectGetWidth(weakView.bounds);
        [weakView layoutIfNeeded];
        centerX.constant = 0;
        [UIView animateWithDuration:MobilyLockScreenController_SwipeAnimationDuration animations:^{
            [weakView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakCode setEnabled:YES];
        }];
    }];
}

- (NSLayoutConstraint*)_findLayoutConstraint:(UIView*)superview childView:(UIView*)childView attribute:(NSLayoutAttribute)attribute {
    for(NSLayoutConstraint* constraint in superview.constraints) {
        if((constraint.firstItem == superview) && (constraint.secondItem == childView) && (constraint.firstAttribute == attribute)) {
            return constraint;
        }
    }
    return nil;
}

#pragma mark Action

- (IBAction)pressedNumber:(UIButton*)sender {
    [_pincodeView appendingPincode:[NSString stringWithFormat:@"%d", (int)sender.tag]];
}

- (IBAction)pressedCancel:(id)sender {
    if(_didCancelledBlock != nil) {
        _didCancelledBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedDelete:(id)sender {
    [_pincodeView removeLastPincode];
}

#pragma mark MobilyLockScreenPincodeViewDelegate

- (void)lockScreenPincodeView:(MobilyLockScreenPincodeView*)lockScreenPincodeView pincode:(NSString*)pincode {
    switch(_lockScreenMode) {
        case MobilyLockScreenModeUnlock:
        case MobilyLockScreenModeAuth:
            if([self _isPincodeValid:pincode] == YES) {
                [self _unlockScreenSuccessful:pincode];
            } else {
                [self _unlockScreenFailure];
            }
            break;
        case MobilyLockScreenModeVerification:
            if([self _isPincodeValid:pincode] == YES) {
                self.lockScreenMode = _prevLockScreenMode;
                [self _unlockScreenSuccessful:pincode];
            } else {
                self.lockScreenMode = _prevLockScreenMode;
                [self _unlockScreenFailure];
            }
            break;
        case MobilyLockScreenModeNew:
        case MobilyLockScreenModeChange:
            _confirmPincode = pincode;
            _prevLockScreenMode = _lockScreenMode;
            self.lockScreenMode = MobilyLockScreenModeVerification;
            [self _updateTitle:NSLocalizedStringFromTable(@"Pincode Title Confirm", @"MobilyLockScreenController", nil)
                      subtitle:NSLocalizedStringFromTable(@"Pincode Subtitle Confirm", @"MobilyLockScreenController", nil)];
            [self _swipeSubtitleAndPincodeView];
            break;
    }
}

@end

/*--------------------------------------------------*/
