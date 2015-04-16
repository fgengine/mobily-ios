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

#import <Mobily/MobilyGeoLocationManager.h>

/*--------------------------------------------------*/

@protocol MobilyGeoLocationRequestDelegate

- (void)requestDidTimeout:(MobilyGeoLocationRequest*)request;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyGeoLocationManager () < CLLocationManagerDelegate, MobilyGeoLocationRequestDelegate > {
    CLLocationManager* _locationManager;
    CLLocation* _currentLocation;
    BOOL _isUpdatingLocation;
    BOOL _updateFailed;
    NSMutableArray* _requests;
}

- (void)_startUpdatingIfNeeded;
- (void)_stopUpdatingIfPossible;

- (void)_addRequest:(MobilyGeoLocationRequest*)request;
- (void)_removeRequest:(MobilyGeoLocationRequest*)request;

- (void)_processRequests;
- (void)_forceCompleteRequest:(MobilyGeoLocationRequest*)request;
- (void)_completeRequest:(MobilyGeoLocationRequest*)request;
- (void)_completeAllRequests;
- (void)_cancelRequest:(MobilyGeoLocationRequest*)request;
- (void)_cancelAllRequests;

- (CLLocation*)_currentLocation;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyGeoLocationRequest () {
    id< MobilyGeoLocationRequestDelegate > _delegate;
    BOOL _isSubscription;
    MobilyGeoLocationAccuracy _desiredAccuracy;
    NSTimeInterval _staleThreshold;
    NSTimeInterval _timeout;
    MobilyGeoLocationRequestComplete _complete;
    MobilyGeoLocationRequestFailure _failure;
    BOOL _canceled;
    BOOL _hasTimedOut;
    
    NSDate* _requestStartTime;
    NSTimer* _timer;
}

- (instancetype)initWithDelegate:(id< MobilyGeoLocationRequestDelegate >)delegate desiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;
- (instancetype)initWithDelegate:(id< MobilyGeoLocationRequestDelegate >)delegate staleThreshold:(NSTimeInterval)staleThreshold complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;

- (void)_complete;
- (void)_forceTimeout;
- (void)_cancel;

- (void)_startTimerIfNeeded;

- (void)_timeoutTriggered:(NSTimer*)timer;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyGeoLocationManager

#pragma mark Synthesize

@synthesize requests = _requests;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _requests = [NSMutableArray array];
}

#pragma mark Static

+ (MobilyGeoLocationServicesState)servicesState {
    if([CLLocationManager locationServicesEnabled] == NO) {
        return MobilyGeoLocationServicesStateDisabled;
    } else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return MobilyGeoLocationServicesStateNotDetermined;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return MobilyGeoLocationServicesStateDenied;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return MobilyGeoLocationServicesStateRestricted;
    }
    return MobilyGeoLocationServicesStateAvailable;
}

+ (instancetype)shared {
    static id shared = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark Public

- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    return [self requestWithDesiredAccuracy:desiredAccuracy timeout:0.0f delayUntilAuthorized:NO complete:complete failure:failure];
}

- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    return [self requestWithDesiredAccuracy:desiredAccuracy timeout:timeout delayUntilAuthorized:NO complete:complete failure:failure];
}

- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout delayUntilAuthorized:(BOOL)delayUntilAuthorized complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    MobilyGeoLocationRequest* request = [[MobilyGeoLocationRequest alloc] initWithDelegate:self desiredAccuracy:desiredAccuracy timeout:timeout complete:complete failure:failure];
    BOOL deferTimeout = delayUntilAuthorized && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
    if(deferTimeout == NO) {
        [request _startTimerIfNeeded];
    }
    [self _addRequest:request];
    return request;
}

- (MobilyGeoLocationRequest*)subscribeStaleThreshold:(NSTimeInterval)staleThreshold complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    MobilyGeoLocationRequest* request = [[MobilyGeoLocationRequest alloc] initWithDelegate:self staleThreshold:staleThreshold complete:complete failure:failure];
    [self _addRequest:request];
    return request;
}

- (void)reverseGeocodeLocation:(CLLocation*)location block:(MobilyGeoLocationReverseGeocodeBlock)block {
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:block];
}

- (void)forceCompleteRequest:(MobilyGeoLocationRequest*)request {
    if([_requests containsObject:request] == YES) {
        [self _forceCompleteRequest:request];
    }
}

- (void)cancelRequest:(MobilyGeoLocationRequest*)request {
    if([_requests containsObject:request] == YES) {
        [self _cancelRequest:request];
    }
}

#pragma mark Private

- (void)_startUpdatingIfNeeded {
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
    if([UIDevice systemVersion] >= 8.0f) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch(authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined: {
                BOOL hasAlwaysKey = ([NSBundle.mainBundle objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil);
                BOOL hasWhenInUseKey = ([NSBundle.mainBundle objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil);
                if(hasAlwaysKey == YES) {
                    [_locationManager requestAlwaysAuthorization];
                } else if(hasWhenInUseKey == YES) {
                    [_locationManager requestWhenInUseAuthorization];
                } else {
                    NSAssert((hasAlwaysKey == YES) || (hasWhenInUseKey == YES), @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
                }
                break;
            }
            case kCLAuthorizationStatusDenied: {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            }
            default: break;
        }
    }
#endif
    if(_requests.count == 0) {
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        _isUpdatingLocation = YES;
    }
}

- (void)_stopUpdatingIfPossible {
    if(_requests.count == 0) {
        [_locationManager stopUpdatingLocation];
        _isUpdatingLocation = NO;
    }
}

- (void)_addRequest:(MobilyGeoLocationRequest*)request {
    switch([MobilyGeoLocationManager servicesState]) {
        case MobilyGeoLocationServicesStateDisabled:
        case MobilyGeoLocationServicesStateDenied:
        case MobilyGeoLocationServicesStateRestricted:
            [self _completeRequest:request];
            return;
        default:
            break;
    }
    [self _startUpdatingIfNeeded];
    [_requests addObject:request];
}

- (void)_removeRequest:(MobilyGeoLocationRequest*)request {
    [_requests removeObject:request];
    [self _stopUpdatingIfPossible];
}

- (void)_processRequests {
    CLLocation* location = [self _currentLocation];
    NSMutableArray* completingRequests = [NSMutableArray array];
    for(MobilyGeoLocationRequest* request in _requests) {
        if(request.hasTimedOut == YES) {
            [completingRequests addObject:request];
            continue;
        }
        if(location != nil) {
            if(request.isSubscription == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(request.complete != nil) {
                        request.complete(location, request);
                    }
                });
            } else {
                CLLocationAccuracy desiredAccuracy = MAX(location.horizontalAccuracy, location.verticalAccuracy);
                NSTimeInterval timeSinceUpdate = fabs(location.timestamp.timeIntervalSinceNow);
                if((desiredAccuracy <= request.desiredAccuracy) && (timeSinceUpdate <= request.staleThreshold)) {
                    [completingRequests addObject:request];
                }
            }
        }
    }
    for(MobilyGeoLocationRequest* request in completingRequests) {
        [self _completeRequest:request];
    }
}

- (void)_forceCompleteRequest:(MobilyGeoLocationRequest*)request {
    if(request.isSubscription == YES) {
        [self _cancelRequest:request];
    } else {
        [request _forceTimeout];
        [self _completeRequest:request];
    }
}

- (void)_completeRequest:(MobilyGeoLocationRequest*)request {
    [request _complete];
    [self _removeRequest:request];
    CLLocation* location = [self _currentLocation];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(request.complete != nil) {
            request.complete(location, request);
        }
    });
}

- (void)_completeAllRequests {
    for(MobilyGeoLocationRequest* request in _requests) {
        [self _completeRequest:request];
    }
}

- (void)_cancelRequest:(MobilyGeoLocationRequest*)request {
    [request _cancel];
    [self _removeRequest:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(request.failure != nil) {
            request.failure(request);
        }
    });
}

- (void)_cancelAllRequests {
    for(MobilyGeoLocationRequest* request in _requests) {
        [self _cancelRequest:request];
    }
}

- (CLLocation*)_currentLocation {
    if(_currentLocation != nil) {
        if((_currentLocation.coordinate.latitude == 0.0) && (_currentLocation.coordinate.longitude == 0.0)) {
            _currentLocation = nil;
        }
    }
    return _currentLocation;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager* __unused)manager didUpdateLocations:(NSArray*)locations {
    _updateFailed = NO;
    _currentLocation = [locations lastObject];
    [self _processRequests];
}

- (void)locationManager:(CLLocationManager* __unused)manager didFailWithError:(NSError* __unused)error {
    _updateFailed = YES;
    [self _completeAllRequests];
}

- (void)locationManager:(CLLocationManager* __unused)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch(status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self _completeAllRequests];
            break;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
#elif (__IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_8_0)
        case kCLAuthorizationStatusAuthorized: {
#endif
            for(MobilyGeoLocationRequest* request in _requests) {
                [request _startTimerIfNeeded];
            }
            break;
        }
        default:
            break;
    }
}
    
#pragma mark MobilyGeoLocationRequestDelegate
    
- (void)requestDidTimeout:(MobilyGeoLocationRequest*)request {
    [self _completeRequest:request];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyGeoLocationRequest

#pragma mark Synthesize

@synthesize subscription = _subscription;
@synthesize desiredAccuracy = _desiredAccuracy;
@synthesize staleThreshold = _staleThreshold;
@synthesize timeout = _timeout;
@synthesize complete = _complete;
@synthesize failure = _failure;
@synthesize canceled = _canceled;
@synthesize hasTimedOut = _hasTimedOut;

#pragma mark Init / Free

- (instancetype)initWithDelegate:(id< MobilyGeoLocationRequestDelegate >)delegate desiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    self = [super init];
    if(self != nil) {
        _delegate = delegate;
        _desiredAccuracy = desiredAccuracy;
        _timeout = timeout;
        _complete = complete;
        _failure = failure;
    }
    return self;
}

- (instancetype)initWithDelegate:(id< MobilyGeoLocationRequestDelegate >)delegate staleThreshold:(NSTimeInterval)staleThreshold complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure {
    self = [super init];
    if(self != nil) {
        _delegate = delegate;
        _subscription = YES;
        _staleThreshold = staleThreshold;
        _complete = complete;
        _failure = failure;
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
}

#pragma mark Public

- (NSTimeInterval)timeAlive {
    if(_requestStartTime == nil) {
        return 0.0f;
    }
    return fabs(_requestStartTime.timeIntervalSinceNow);
}

- (BOOL)hasTimedOut {
    if((_timeout > 0.0f) && (self.timeAlive > _timeout)) {
        _hasTimedOut = YES;
    }
    return _hasTimedOut;
}

#pragma mark Private

- (void)_complete {
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _requestStartTime = nil;
}

- (void)_forceTimeout {
    if(_desiredAccuracy > FLT_EPSILON) {
        _hasTimedOut = YES;
    }
}

- (void)_cancel {
    if(_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _requestStartTime = nil;
    _canceled = YES;
}

- (void)_startTimerIfNeeded {
    if((_timeout > 0) && (_timer == nil)) {
        _requestStartTime = [NSDate date];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeout target:self selector:@selector(_timeoutTriggered:) userInfo:nil repeats:NO];
    }
}

- (void)_timeoutTriggered:(NSTimer*)timer {
    _hasTimedOut = YES;
    [_delegate requestDidTimeout:self];
}

@end

/*--------------------------------------------------*/
