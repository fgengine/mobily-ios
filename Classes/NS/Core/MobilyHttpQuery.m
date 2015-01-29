/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
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

#import "MobilyHttpQuery.h"

/*--------------------------------------------------*/

@interface MobilyHttpQuery () < NSURLConnectionDelegate, NSURLConnectionDataDelegate >

@property(nonatomic, readwrite, strong) NSError* error;

@property(nonatomic, readwrite, strong) NSURLConnection* connection;
@property(nonatomic, readwrite, strong) NSMutableURLRequest* request;
@property(nonatomic, readwrite, strong) NSHTTPURLResponse* response;
@property(nonatomic, readwrite, strong) NSMutableData* mutableResponseData;

- (NSDictionary*)formDataFromDictionary:(NSDictionary*)dictionary;
- (void)formDataFromDictionary:(NSMutableDictionary*)dictionary value:(id)value keyPath:(NSString*)keyPath;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyHttpQuery

#pragma mark Standart

- (id)init {
    self = [super init];
    if(self != nil) {
        [self setRequest:[NSMutableURLRequest new]];
        [_request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [_request setNetworkServiceType:NSURLNetworkServiceTypeDefault];
    }
    return self;
}

- (void)dealloc {
    [self cancel];
    
    [self setCertificateFilename:nil];
    [self setError:nil];
    [self setRequest:nil];
    [self setResponse:nil];
    [self setMutableResponseData:nil];
    [self setStartCallback:nil];
    [self setCancelCallback:nil];
    [self setFinishCallback:nil];
    [self setErrorCallback:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark Public

- (void)setRequestUrl:(NSURL*)url params:(NSDictionary*)params {
    NSURLComponents* urlComponents = [NSURLComponents componentsWithString:[url absoluteString]];
    NSMutableDictionary* queryParams = [NSMutableDictionary dictionary];
    if([[urlComponents query] length] > 0) {
        [queryParams addEntriesFromDictionary:[[urlComponents query] dictionaryFromQueryComponents]];
    }
    [queryParams addEntriesFromDictionary:[self formDataFromDictionary:params]];
    NSMutableString* queryString = [NSMutableString string];
    [queryParams enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        if([queryString length] > 0) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", key, [value description]];
    }];
    [urlComponents setQuery:queryString];
    [self setRequestUrl:[NSURL URLWithString:[urlComponents string]]];
}

- (void)setRequestUrlParams:(NSDictionary*)params {
    [self setRequestUrl:[_request URL] params:params];
}

- (void)setRequestBodyParams:(NSDictionary*)params {
    NSMutableData* body = [NSMutableData data];
    NSDictionary* formData = [self formDataFromDictionary:params];
    [formData enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        if([body length] > 0) {
            [body appendData:[@"&" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[[NSString stringWithFormat:@"%@=%@", key, [value description]] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [self addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]]];
    [self setRequestBody:body];
}

- (void)setRequestBodyParams:(NSDictionary*)params boundary:(NSString*)boundary attachments:(NSArray*)attachments {
    NSMutableData* body = [NSMutableData data];
    NSDictionary* formData = [self formDataFromDictionary:params];
    [formData enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL* stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [value description]] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [attachments enumerateObjectsUsingBlock:^(NSDictionary* attachment, NSUInteger index, BOOL* stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [attachment objectForKey:@"name"], [attachment objectForKey:@"filename"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [attachment objectForKey:@"type"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[attachment objectForKey:@"data"]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]];
    [self addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]]];
    [self setRequestBody:body];
}

- (void)addRequestHeader:(NSString*)header value:(NSString*)value {
    [_request setValue:value forHTTPHeaderField:header];
}

- (void)removeRequestHeader:(NSString*)header {
    NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithDictionary:[_request allHTTPHeaderFields]];
    if(headers != nil) {
        [headers removeObjectForKey:header];
        [_request setAllHTTPHeaderFields:headers];
    }
}

- (void)start {
    if(_connection == nil) {
        [self setResponse:nil];
        [self setMutableResponseData:nil];
        
        [self setConnection:[[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO]];
        if(_connection != nil) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [_connection start];
            
            if([_delegate respondsToSelector:@selector(didStartHttpQuery:)] == YES) {
                [_delegate didStartHttpQuery:self];
            } else if(_startCallback != nil) {
                _startCallback(self);
            }
            
            [[NSRunLoop currentRunLoop] run];
        }
    }
}

- (void)cancel {
    if(_connection != nil) {
        [_connection cancel];
        
        [self setConnection:nil];
        [self setResponse:nil];
        [self setMutableResponseData:nil];
        
        if([_delegate respondsToSelector:@selector(didCancelHttpQuery:)] == YES) {
            [_delegate didCancelHttpQuery:self];
        } else if(_cancelCallback != nil) {
            _cancelCallback(self);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

#pragma mark Property

- (void)setRequestUrl:(NSURL*)requestUrl {
    [_request setURL:requestUrl];
}

- (NSURL*)requestUrl {
    return [_request URL];
}

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
    [_request setTimeoutInterval:requestTimeout];
}

- (NSTimeInterval)requestTimeout {
    return [_request timeoutInterval];
}

- (void)setRequestMethod:(NSString*)requestMethod {
    [_request setHTTPMethod:requestMethod];
}

- (NSString*)requestMethod {
    return [_request HTTPMethod];
}

- (void)setRequestHeaders:(NSDictionary*)requestHeaders {
    [_request setAllHTTPHeaderFields:requestHeaders];
}

- (NSDictionary*)requestHeaders {
    return [_request allHTTPHeaderFields];
}

- (void)setRequestBody:(NSData*)requestBody {
    [_request setHTTPBody:requestBody];
}

- (NSData*)requestBody {
    return [_request HTTPBody];
}

- (NSInteger)responseStatusCode {
    return [_response statusCode];
}

- (NSString*)responseMimeType {
    return [_response MIMEType];
}

- (NSString*)responseTextEncoding {
    return [_response textEncodingName];
}

- (NSDictionary*)responseHeaders {
    return [_response allHeaderFields];
}

- (NSData*)responseData {
    return _mutableResponseData;
}

- (NSString*)responseString {
    return [NSString stringWithData:_mutableResponseData encoding:NSASCIIStringEncoding];
}

- (NSDictionary*)responseJsonObject {
    id json = [self responseJson];
    if([json isKindOfClass:[NSDictionary class]] == YES) {
        return json;
    }
    return nil;
}

- (NSArray*)responseJsonArray {
    id json = [self responseJson];
    if([json isKindOfClass:[NSArray class]] == YES) {
        return json;
    }
    return nil;
}

- (id)responseJson {
    if([_mutableResponseData length] < 1) {
        return nil;
    }
    NSError* parseError = nil;
    id result = [NSJSONSerialization JSONObjectWithData:_mutableResponseData options:0 error:&parseError];
    if(parseError != nil) {
        NSLog(@"MobilyHttpQuery::responseJson:%@", parseError);
    }
    return result;
}

#pragma mark Private

- (NSDictionary*)formDataFromDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id keyPath, id value, BOOL* stop) {
        [self formDataFromDictionary:result value:value keyPath:keyPath];
    }];
    return result;
}

- (void)formDataFromDictionary:(NSMutableDictionary*)dictionary value:(id)value keyPath:(NSString*)keyPath {
    if([value isKindOfClass:[NSDictionary class]] == YES) {
        [value enumerateKeysAndObjectsUsingBlock:^(id dictKey, id dictValue, BOOL* stop) {
            [self formDataFromDictionary:dictionary value:dictValue keyPath:[NSString stringWithFormat:@"%@[%@]", keyPath, dictKey]];
        }];
    } else if([value isKindOfClass:[NSArray class]] == YES) {
        [value enumerateObjectsUsingBlock:^(id arrayValue, NSUInteger arrayIndex, BOOL* stop) {
            [self formDataFromDictionary:dictionary value:arrayValue keyPath:[NSString stringWithFormat:@"%@[%lu]", keyPath, (unsigned long)arrayIndex]];
        }];
    } else {
        [dictionary setObject:value forKey:keyPath];
    }
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    [self setConnection:nil];
    [self setResponse:nil];
    [self setMutableResponseData:nil];
    [self setError:error];
    
    if([_delegate respondsToSelector:@selector(httpQuery:didError:)] == YES) {
        [_delegate httpQuery:self didError:_error];
    } else if(_errorCallback != nil) {
        _errorCallback(_error);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    id< NSURLAuthenticationChallengeSender > sender = [challenge sender];
    SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
    
    if(_certificateFilename != nil) {
        SecCertificateRef localCertificate = NULL;
        SecTrustResultType serverTrustResult = kSecTrustResultOtherError;
        NSString* path = [[NSBundle mainBundle] pathForResource:_certificateFilename ofType:@"der"];
        if(path != nil) {
            NSData* data = [NSData dataWithContentsOfFile:path];
            if(data != nil) {
                localCertificate = SecCertificateCreateWithData(NULL, (__bridge_retained CFDataRef)data);
                if(localCertificate != NULL) {
                    CFArrayRef certArray = CFArrayCreate(NULL, (void*)&localCertificate, 1, NULL);
                    if(certArray != NULL) {
                        SecTrustSetAnchorCertificates(serverTrust, certArray);
                        SecTrustEvaluate(serverTrust, &serverTrustResult);
                        if(serverTrustResult == kSecTrustResultRecoverableTrustFailure) {
                            CFDataRef errorData = SecTrustCopyExceptions(serverTrust);
                            SecTrustSetExceptions(serverTrust, errorData);
                            SecTrustEvaluate(serverTrust, &serverTrustResult);
                        }
                        CFRelease(certArray);
                    }
                }
            }
        }
        if((serverTrustResult == kSecTrustResultUnspecified) || (serverTrustResult == kSecTrustResultProceed)) {
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            if(serverCertificate != NULL) {
                NSString* serverHash = nil;
                NSData* serverCertificateData = (__bridge NSData*)SecCertificateCopyData(serverCertificate);
                if(serverCertificateData != nil) {
                    serverHash = [[serverCertificateData toBase64] stringBySHA256];
                }
                NSString* localHash = nil;
                NSData* localCertificateData = (__bridge NSData*)SecCertificateCopyData(localCertificate);
                if(localCertificateData != nil) {
                    localHash = [[localCertificateData toBase64] stringBySHA256];
                }
                if([serverHash isEqualToString:localHash] == YES) {
                    NSURLCredential* credential = [NSURLCredential credentialForTrust:serverTrust];
                    if(credential != nil) {
                        [sender useCredential:credential forAuthenticationChallenge:challenge];
                    } else {
                        [sender cancelAuthenticationChallenge:challenge];
                    }
                } else {
                    [sender cancelAuthenticationChallenge:challenge];
                }
            } else {
                [sender cancelAuthenticationChallenge:challenge];
            }
        } else {
            [sender cancelAuthenticationChallenge:challenge];
        }
        if(localCertificate != NULL) {
            CFRelease(localCertificate);
        }
    } else {
        [sender useCredential:[NSURLCredential credentialForTrust:serverTrust] forAuthenticationChallenge:challenge];
    }
}

#pragma mark NSURLConnectionDataDelegate

- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    if([response isKindOfClass:[NSHTTPURLResponse class]] == YES) {
        [self setResponse:(NSHTTPURLResponse*)response];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    if(_mutableResponseData == nil) {
        [self setMutableResponseData:[NSMutableData data]];
    }
    [_mutableResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    [self setConnection:nil];
    
    if([_delegate respondsToSelector:@selector(didFinishHttpQuery:)] == YES) {
        [_delegate didFinishHttpQuery:self];
    } else if(_finishCallback != nil) {
        _finishCallback(self);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

/*--------------------------------------------------*/
