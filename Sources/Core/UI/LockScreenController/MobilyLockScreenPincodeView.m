/*--------------------------------------------------*/

#import <MobilyLockScreenPincodeView.h>
#import <MobilyTimeout.h>

/*--------------------------------------------------*/

@interface MobilyLockScreenPincodeView() {
    NSUInteger _wasCompleted;
}

@property(nonatomic, readwrite, strong) NSString* pincode;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyLockScreenPincodeView

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    _enabled = YES;
    _pincodeLength = 4;
    _pincode = @"";
}

#pragma mark Property

- (void)setPincode:(NSString*)pincode {
    if([_pincode isEqualToString:pincode] == NO) {
        _pincode = pincode;
        if(_pincode.length == _pincodeLength) {
            if([_delegate respondsToSelector:@selector(lockScreenPincodeView:pincode:)] == YES) {
                [_delegate lockScreenPincodeView:self pincode:pincode];
            }
        }
        [self setNeedsDisplay];
    }
}

#pragma mark Public

- (void)initPincode {
    _pincode = @"";
}

- (void)appendingPincode:(NSString*)pincode {
    if(_enabled == YES) {
        if(_pincode.length < _pincodeLength) {
            self.pincode = [_pincode stringByAppendingString:pincode];
        }
    }
}

- (void)removeLastPincode {
    if(_enabled == YES) {
        if(_pincode.length > 0) {
            self.pincode = [_pincode substringToIndex:_pincode.length - 1];
        }
    }
}

- (void)wasCompleted {
    for(NSUInteger index = 0; index < _pincodeLength; index++) {
        [MobilyTimeout executeBlock:^{
            _wasCompleted++;
            [self setNeedsDisplay];
        } afterDelay:index * 0.01f];
    }
}

#pragma mark Public override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [_pincodeColor setFill];
    
    CGSize boxSize  = CGSizeMake(CGRectGetWidth(rect) / _pincodeLength, CGRectGetHeight(rect));
    CGSize charSize = CGSizeMake(16, 4);
    CGFloat y = rect.origin.y;
    NSUInteger completed = MAX(_pincode.length, _wasCompleted);
    NSInteger str = MIN(completed, _pincodeLength);
    for(NSUInteger index = 0; index < str; index++) {
        CGFloat x = boxSize.width * index;
        CGRect rounded = CGRectMake(x + floorf((boxSize.width  - charSize.width) * 0.5f), y + floorf((boxSize.height - charSize.width) * 0.5f), charSize.width, charSize.width);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, _pincodeColor.CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGContextFillEllipseInRect(context, rounded);
        CGContextFillPath(context);
    }
    for(NSUInteger index = str; index < _pincodeLength; index++) {
        CGFloat x = boxSize.width * index;
        CGRect rounded = CGRectMake(x + floorf((boxSize.width  - charSize.width) * 0.5f), y + floorf((boxSize.height - charSize.height) * 0.5f), charSize.width, charSize.height);
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rounded cornerRadius:5];
        [path fill];
    }
}

@end

/*--------------------------------------------------*/
