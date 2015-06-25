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

#import <MobilyStore/MobilyStoreManager.h>

/*--------------------------------------------------*/

@interface MobilyStoreManager () < SKPaymentTransactionObserver > {
@protected
    NSMutableArray* _requestProducts;
    NSMutableArray* _requestPayments;
}

- (void)_finishProductsRequest:(MobilyStoreProductsRequest*)productsRequest;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStoreProductsRequest () {
@protected
    SKProductsRequest* _request;
    SKProductsResponse* _response;
    MobilyStoreManagerProductsSuccess _success;
    MobilyStoreManagerProductsFailure _failure;
}

@property(nonatomic, readwrite, strong) SKProductsRequest* request;
@property(nonatomic, readwrite, copy) MobilyStoreManagerProductsRequestSuccess success;
@property(nonatomic, readwrite, copy) MobilyStoreManagerProductsRequestFailure failure;

- (instancetype)initWithIdentifiers:(NSSet*)identifiers success:(MobilyStoreManagerProductsRequestSuccess)success failure:(MobilyStoreManagerProductsRequestFailure)failure;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyStorePaymentRequest () {
@protected
    SKProduct* _product;
    SKPaymentTransaction* _transaction;
    MobilyStoreManagerPaymentRequestProcessing _processing;
}

@property(nonatomic, readwrite, strong) SKPaymentTransaction* transaction;

- (instancetype)initWithProduct:(SKProduct*)product processing:(MobilyStoreManagerPaymentRequestProcessing)processing;
- (void)_updateTransaction:(SKPaymentTransaction*)transaction;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStoreManager

#pragma mark Singleton

+ (instancetype)shared {
    static id shared = nil;
    if(shared == nil) {
        @synchronized(self) {
            if(shared == nil) {
                shared = [self new];
            }
        }
    }
    return shared;
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _requestProducts = [NSMutableArray array];
    _requestPayments = [NSMutableArray array];
    
    [SKPaymentQueue.defaultQueue addTransactionObserver:self];
}

- (void)dealloc {
    [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
}

#pragma mark Public

- (MobilyStoreProductsRequest*)productsRequestByIdentifiers:(NSSet*)identifiers success:(MobilyStoreManagerProductsRequestSuccess)success failure:(MobilyStoreManagerProductsRequestFailure)failure {
    MobilyStoreProductsRequest* productsRequest = [[MobilyStoreProductsRequest alloc] initWithIdentifiers:alloc success:success failure:failure];
    if(productsRequest != nil) {
        [_requestProducts addObject:productsRequest];
    }
    return productsRequest;
}

- (void)cancelProductsRequest:(MobilyStoreProductsRequest*)productsRequest {
    [productsRequest cancel];
}

- (BOOL)canMakePayments {
    return [SKPaymentQueue canMakePayments];
}

- (MobilyStorePaymentRequest*)paymentRequestWithProduct:(SKProduct*)product processing:(MobilyStoreManagerPaymentRequestProcessing)processing {
    MobilyStorePaymentRequest paymentRequest = [[MobilyStorePaymentRequest alloc] initWithProduct:product processing:processing];
    if(paymentRequest != nil) {
        [_requestPayments addObject:paymentRequest];
    }
    return paymentRequest;
}

- (void)finishPaymentRequest:(MobilyStorePaymentRequest*)paymentRequest {
    [paymentRequest finish];
}

#pragma mark Private

- (void)_finishProductsRequest:(MobilyStoreProductsRequest*)productsRequest {
    [_requestProducts removeObject:productsRequest];
}

- (void)_finishPaymentRequest:(MobilyStorePaymentRequest*)paymentRequest {
    [_requestPayments removeObject:paymentRequest];
}

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    [transactions each:^(SKPaymentTransaction* transaction) {
        MobilyStorePaymentRequest* paymentRequest = [_requestPayments find:^BOOL(MobilyStorePaymentRequest* paymentRequest) {
            return [transaction.payment.productIdentifier isEqualToString:paymentRequest.product.productIdentifier];
        }];
        if(paymentRequest == nil) {
            paymentRequest = [[MobilyStorePaymentRequest alloc] initWithTransaction:transaction];
            if(paymentRequest != nil) {
                [_requestPayments addObject:paymentRequest];
            }
        }
        [paymentRequest _updateTransaction:transaction];
    }];
}

- (void)paymentQueue:(SKPaymentQueue*)queue removedTransactions:(NSArray*)transactions {
    [transactions each:^(SKPaymentTransaction* transaction) {
        MobilyStorePaymentRequest* paymentRequest = [_requestPayments find:^BOOL(MobilyStorePaymentRequest* paymentRequest) {
            return [transaction.payment.productIdentifier isEqualToString:paymentRequest.product.productIdentifier];
        }];
        if(paymentRequest != nil) {
            [self _finishPaymentRequest:paymentRequest];
        }
    }];
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedDownloads:(NSArray*)downloads {
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStoreProductsRequest

#pragma mark Synthesize

@synthesize request = _request;
@synthesize response = _response;
@synthesize success = _success;
@synthesize failure = _failure;

#pragma mark Init / Free

- (instancetype)initWithIdentifiers:(NSSet*)identifiers success:(MobilyStoreManagerProductsRequestSuccess)success failure:(MobilyStoreManagerProductsRequestFailure)failure {
    self = [super init];
    if(self != nil) {
        self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
        self.success = success;
        self.failure = failure;
    }
    return self;
}

#pragma mark Property

- (void)setRequest:(SKProductsRequest*)request {
    if(_request != request) {
        if(_request != nil) {
            [_request cancel];
        }
        _request = request;
        if(_request != nil) {
            _request.delegate = self;
            [_request start];
        }
    }
}

#pragma mark Public

- (void)cancel {
    self.request = nil;
}

#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
    self.response = response;
    if(_success != nil) {
        _success(self);
    }
    [MobilyStoreManager.shared _finishProductsRequest:self];
}

- (void)requestDidFinish:(SKRequest*)request  {
    [MobilyStoreManager.shared _finishProductsRequest:self];
}

- (void)request:(SKRequest*)request didFailWithError:(NSError*)error {
    if(_failure != nil) {
        _failure(self, error);
    }
    [MobilyStoreManager.shared _finishProductsRequest:self];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyStorePaymentRequest

#pragma mark Synthesize

@synthesize product = _product;
@synthesize transaction = _transaction;
@synthesize processing = _processing;

#pragma mark Init / Free

- (instancetype)initWithProduct:(SKProduct*)product processing:(MobilyStoreManagerPaymentRequestProcessing)processing {
    self = [super init];
    if(self != nil) {
        self.product = product;
        self.processing = processing;
    }
    return self;
}

#pragma mark Private

- (void)_updateTransaction:(SKPaymentTransaction*)transaction error:(NSError*)error {
    if(_transaction == nil) {
        self.transaction = transaction;
    }
    if(_processing != nil) {
        _processing(self);
    }
}

#pragma mark Public

- (void)finish {
    [SKPaymentQueue.defaultQueue finishTransaction:_transaction];
}

@end

/*--------------------------------------------------*/
