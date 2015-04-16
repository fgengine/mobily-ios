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

#import <Mobily/MobilyObject.h>
#import <Mobily/MobilyUI.h>

/*--------------------------------------------------*/

#import <CoreLocation/CoreLocation.h>

/*--------------------------------------------------*/

@class MobilyGeoLocationRequest;

/*--------------------------------------------------*/

typedef NS_ENUM(NSInteger, MobilyGeoLocationServicesState) {
    MobilyGeoLocationServicesStateAvailable,
    MobilyGeoLocationServicesStateNotDetermined,
    MobilyGeoLocationServicesStateDenied,
    MobilyGeoLocationServicesStateRestricted,
    MobilyGeoLocationServicesStateDisabled
};

typedef CGFloat MobilyGeoLocationAccuracy;

typedef NS_ENUM(NSInteger, MobilyGeoLocationStatus) {
    MobilyGeoLocationStatusSuccess = 0,
    MobilyGeoLocationStatusTimedOut,
    MobilyGeoLocationStatusServicesNotDetermined,
    MobilyGeoLocationStatusServicesDenied,
    MobilyGeoLocationStatusServicesRestricted,
    MobilyGeoLocationStatusServicesDisabled,
    MobilyGeoLocationStatusError
};

typedef void(^MobilyGeoLocationRequestComplete)(CLLocation* location, MobilyGeoLocationRequest* request);
typedef void(^MobilyGeoLocationRequestFailure)(MobilyGeoLocationRequest* request);
typedef void(^MobilyGeoLocationReverseGeocodeBlock)(NSArray* placemarks, NSError* error);

/*--------------------------------------------------*/

@interface MobilyGeoLocationManager : NSObject < MobilyObject >

@property(nonatomic, readonly, copy) NSArray* requests;

+ (MobilyGeoLocationServicesState)servicesState;

+ (instancetype)shared;

- (void)setup NS_REQUIRES_SUPER;

- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;
- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;
- (MobilyGeoLocationRequest*)requestWithDesiredAccuracy:(MobilyGeoLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout delayUntilAuthorized:(BOOL)delayUntilAuthorized complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;
- (MobilyGeoLocationRequest*)subscribeStaleThreshold:(NSTimeInterval)staleThreshold complete:(MobilyGeoLocationRequestComplete)complete failure:(MobilyGeoLocationRequestFailure)failure;

- (void)reverseGeocodeLocation:(CLLocation*)location block:(MobilyGeoLocationReverseGeocodeBlock)block;

- (void)forceCompleteRequest:(MobilyGeoLocationRequest*)request;
- (void)cancelRequest:(MobilyGeoLocationRequest*)request;

@end

/*--------------------------------------------------*/

@interface MobilyGeoLocationRequest : NSObject

@property(nonatomic, readonly, assign, getter=isSubscription) BOOL subscription;
@property(nonatomic, readonly, assign) MobilyGeoLocationAccuracy desiredAccuracy;
@property(nonatomic, readonly, assign) NSTimeInterval staleThreshold;
@property(nonatomic, readonly, assign) NSTimeInterval timeout;
@property(nonatomic, readonly, assign) NSTimeInterval timeAlive;
@property(nonatomic, readonly, copy) MobilyGeoLocationRequestComplete complete;
@property(nonatomic, readonly, copy) MobilyGeoLocationRequestFailure failure;

@property(nonatomic, readonly, assign, getter=isCanceled) BOOL canceled;
@property(nonatomic, readonly, readonly) BOOL hasTimedOut;

@end

/*--------------------------------------------------*/
