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

#import <MobilyCore/MobilyUI.h>
#import <StoreKit/StoreKit.h>

/*--------------------------------------------------*/

@class MobilyStoreProductsRequest;
@class MobilyStorePaymentRequest;

/*--------------------------------------------------*/

typedef void (^MobilyStoreManagerProductsRequestSuccess)(MobilyStoreProductsRequest* productsRequest);
typedef void (^MobilyStoreManagerProductsRequestFailure)(MobilyStoreProductsRequest* productsRequest, NSError* error);

typedef void (^MobilyStoreManagerPaymentRequestProcessing)(MobilyStorePaymentRequest* paymentRequest);
typedef void (^MobilyStoreManagerPaymentTransactionProcessing)(SKPaymentQueue* paymentQueue, SKPaymentTransaction* paymentTransaction);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyStoreManager : NSObject < MobilyObject >

@property(nonatomic, readwrite, copy) MobilyStoreManagerPaymentTransactionProcessing paymentTransactionProcessing;

+ (instancetype)shared;

- (void)setup NS_REQUIRES_SUPER;

- (MobilyStoreProductsRequest*)productsRequestByIdentifiers:(NSSet*)identifiers success:(MobilyStoreManagerProductsRequestSuccess)success failure:(MobilyStoreManagerProductsRequestFailure)failure;
- (void)cancelProductsRequest:(MobilyStoreProductsRequest*)productsRequest;

- (BOOL)canMakePayments;
- (MobilyStorePaymentRequest*)paymentRequestWithProduct:(SKProduct*)product processing:(MobilyStoreManagerPaymentRequestProcessing)processing;
- (void)finishPaymentRequest:(MobilyStorePaymentRequest*)paymentRequest;

@end


/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyStoreProductsRequest : NSObject

@property(nonatomic, readonly, strong) SKProductsRequest* request;
@property(nonatomic, readonly, strong) SKProductsResponse* response;

- (SKProduct*)productByIdentifier:(NSString*)identifier;

- (void)cancel;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyStorePaymentRequest : NSObject

@property(nonatomic, readonly, strong) SKProduct* product;
@property(nonatomic, readonly, strong) SKPaymentTransaction* transaction;
@property(nonatomic, readonly, strong) NSData* transactionReceipt;

- (void)finish;

@end

/*--------------------------------------------------*/

@interface SKProduct (MobilyStore)

@property(nonatomic, readonly, strong) NSString* moPriceAsString;

@end

/*--------------------------------------------------*/

@interface SKPaymentTransaction (MobilyStore)

@property(nonatomic, readonly, strong) NSData* moReceipt;

@end

/*--------------------------------------------------*/
