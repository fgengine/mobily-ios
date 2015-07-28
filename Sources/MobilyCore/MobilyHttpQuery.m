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

#import <MobilyCore/MobilyHttpQuery+Private.h>

/*--------------------------------------------------*/

@implementation MobilyHttpQuery

#pragma mark Synthesize

@synthesize certificateFilename = _certificateFilename;
@synthesize allowInvalidCertificates = _allowInvalidCertificates;
@synthesize error = _error;
@synthesize delegate = _delegate;
@synthesize startCallback = _startCallback;
@synthesize cancelCallback = _cancelCallback;
@synthesize finishCallback = _finishCallback;
@synthesize errorCallback = _errorCallback;

@synthesize connection = _connection;
@synthesize request = _request;
@synthesize response = _response;
@synthesize mutableResponseData = _mutableResponseData;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _request = [NSMutableURLRequest new];
        _request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _request.networkServiceType = NSURLNetworkServiceTypeDefault;
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [self cancel];
}

#pragma mark Public

- (void)setRequestUrl:(NSURL*)url params:(NSDictionary*)params {
    NSURLComponents* urlComponents = [NSURLComponents componentsWithString:[url absoluteString]];
    NSMutableDictionary* queryParams = NSMutableDictionary.dictionary;
    if([urlComponents.query length] > 0) {
        [queryParams addEntriesFromDictionary:urlComponents.query.moDictionaryFromQueryComponents];
    }
    [queryParams addEntriesFromDictionary:[self _formDataFromDictionary:params]];
    NSMutableString* queryString = NSMutableString.string;
    [queryParams enumerateKeysAndObjectsUsingBlock:^(NSString* key, id< NSObject > value, BOOL* stop __unused) {
        if(queryString.length > 0) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", key, value.description];
    }];
    urlComponents.query = queryString;
    _request.URL = urlComponents.URL;
}

- (void)setRequestUrlParams:(NSDictionary*)params {
    [self setRequestUrl:_request.URL params:params];
}

- (void)setRequestBodyParams:(NSDictionary*)params encodeParamKey:(BOOL)encodeParamKey encodeParamValue:(BOOL)encodeParamValue {
    NSMutableString* bodyString = NSMutableString.string;
    NSDictionary* formData = [self _formDataFromDictionary:params];
    [formData enumerateKeysAndObjectsUsingBlock:^(NSString* key, id< NSObject > value, BOOL* stop __unused) {
        if(bodyString.length > 0) {
            [bodyString appendString:@"&"];
        }
        NSString* tempKey = (encodeParamKey == YES) ? key.moStringByEncodingURLFormat : key;
        NSString* tempValue = (encodeParamValue == YES) ? value.description.moStringByEncodingURLFormat : value.description;
        [bodyString appendFormat:@"%@=%@", tempKey, tempValue];
    }];
    
    NSData* body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [_request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    [_request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    _request.HTTPBody = body;
}

- (void)setRequestBodyParams:(NSDictionary*)params encodeParamKey:(BOOL)encodeParamKey encodeParamValue:(BOOL)encodeParamValue boundary:(NSString*)boundary attachments:(NSArray*)attachments {
    NSMutableData* body = NSMutableData.data;
    NSDictionary* formData = [self _formDataFromDictionary:params];
    NSString* boundaryEncoded = boundary.moStringByEncodingURLFormat;
    [formData enumerateKeysAndObjectsUsingBlock:^(NSString* key, id< NSObject > value, BOOL* stop __unused) {
        NSString* tempKey = (encodeParamKey == YES) ? key.moStringByEncodingURLFormat : key;
        NSString* tempValue = (encodeParamValue == YES) ? value.description.moStringByEncodingURLFormat : value.description;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", boundaryEncoded, tempKey, tempValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    for(MobilyHttpAttachment* attachment in attachments) {
        NSString* tempName = (attachment.encodeName == YES) ? attachment.name.moStringByEncodingURLFormat : attachment.name;
        NSString* tempFilename = (attachment.encodeFilename == YES) ? attachment.filename.moStringByEncodingURLFormat : attachment.filename;
        NSString* tempMimeType = (attachment.encodeMimeType == YES) ? attachment.mimeType.moStringByEncodingURLFormat : attachment.mimeType;
        [body appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", boundaryEncoded, tempName, tempFilename, tempMimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:attachment.data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundaryEncoded] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryEncoded] forHTTPHeaderField:@"Content-Type"];
    [_request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    _request.HTTPBody = body;
}

- (void)addRequestHeader:(NSString*)header value:(NSString*)value {
    [_request addValue:value forHTTPHeaderField:header];
}

- (void)addRequestHeaders:(NSDictionary*)headers {
    NSMutableDictionary* mutableHeaders = [NSMutableDictionary dictionaryWithDictionary:[_request allHTTPHeaderFields]];
    if(mutableHeaders != nil) {
        mutableHeaders.valuesForKeysWithDictionary = headers;
        _request.allHTTPHeaderFields = mutableHeaders;
    }
}

- (void)removeRequestHeader:(NSString*)header {
    NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithDictionary:[_request allHTTPHeaderFields]];
    if(headers != nil) {
        [headers removeObjectForKey:header];
        _request.allHTTPHeaderFields = headers;
    }
}

- (void)removeRequestHeaders:(NSArray*)headers {
    NSMutableDictionary* mutableHeaders = [NSMutableDictionary dictionaryWithDictionary:[_request allHTTPHeaderFields]];
    if(mutableHeaders != nil) {
        [mutableHeaders removeObjectsForKeys:headers];
        _request.allHTTPHeaderFields = mutableHeaders;
    }
}

- (void)start {
    if(_connection == nil) {
        _response = nil;
        _mutableResponseData = nil;
        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
        UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
        [_connection scheduleInRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
        [_connection start];
        if([_delegate respondsToSelector:@selector(didStartHttpQuery:)] == YES) {
            [_delegate didStartHttpQuery:self];
        } else if(_startCallback != nil) {
            _startCallback(self);
        }
        [NSRunLoop.currentRunLoop run];
    }
}

- (void)cancel {
    if(_connection != nil) {
        [_connection cancel];
        _connection = nil;
        _response = nil;
        _mutableResponseData = nil;
        if([_delegate respondsToSelector:@selector(didCancelHttpQuery:)] == YES) {
            [_delegate didCancelHttpQuery:self];
        } else if(_cancelCallback != nil) {
            _cancelCallback(self);
        }
        UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
    }
}

#pragma mark Property

- (void)setRequestUrl:(NSURL*)requestUrl {
    _request.URL = requestUrl;
}

- (NSURL*)requestUrl {
    return _request.URL;
}

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
    _request.timeoutInterval = requestTimeout;
}

- (NSTimeInterval)requestTimeout {
    return _request.timeoutInterval;
}

- (void)setRequestMethod:(NSString*)requestMethod {
    _request.HTTPMethod = requestMethod;
}

- (NSString*)requestMethod {
    return _request.HTTPMethod;
}

- (void)setRequestHeaders:(NSDictionary*)requestHeaders {
    _request.allHTTPHeaderFields = requestHeaders;
}

- (NSDictionary*)requestHeaders {
    return [_request allHTTPHeaderFields];
}

- (void)setRequestBody:(NSData*)requestBody {
    _request.HTTPBody = requestBody;
}

- (NSData*)requestBody {
    return _request.HTTPBody;
}

- (NSInteger)responseStatusCode {
    return _response.statusCode;
}

- (NSString*)responseMimeType {
    return _response.MIMEType;
}

- (NSString*)responseTextEncoding {
    return _response.textEncodingName;
}

- (NSDictionary*)responseHeaders {
    return _response.allHeaderFields;
}

- (NSData*)responseData {
    return _mutableResponseData;
}

- (NSString*)responseString {
    return [NSString moStringWithData:_mutableResponseData encoding:NSASCIIStringEncoding];
}

- (NSDictionary*)responseJsonObject {
    id json = self.responseJson;
    if([json isKindOfClass:NSDictionary.class] == YES) {
        return json;
    }
    return nil;
}

- (NSArray*)responseJsonArray {
    id json = self.responseJson;
    if([json isKindOfClass:NSArray.class] == YES) {
        return json;
    }
    return nil;
}

- (id)responseJson {
    if(_mutableResponseData.length < 1) {
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

- (NSDictionary*)_formDataFromDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary* result = NSMutableDictionary.dictionary;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id keyPath, id value, BOOL* stop __unused) {
        [self _formDataFromDictionary:result value:value keyPath:keyPath];
    }];
    return result;
}

- (void)_formDataFromDictionary:(NSMutableDictionary*)dictionary value:(id)value keyPath:(NSString*)keyPath {
    if([value isKindOfClass:NSDictionary.class] == YES) {
        [value enumerateKeysAndObjectsUsingBlock:^(id dictKey, id dictValue, BOOL* stop __unused) {
            [self _formDataFromDictionary:dictionary value:dictValue keyPath:[NSString stringWithFormat:@"%@[%@]", keyPath, dictKey]];
        }];
    } else if([value isKindOfClass:NSArray.class] == YES) {
        [value enumerateObjectsUsingBlock:^(id arrayValue, NSUInteger arrayIndex, BOOL* stop __unused) {
            [self _formDataFromDictionary:dictionary value:arrayValue keyPath:[NSString stringWithFormat:@"%@[%lu]", keyPath, (unsigned long)arrayIndex]];
        }];
    } else {
        dictionary[keyPath] = value;
    }
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection* __unused)connection didFailWithError:(NSError*)error {
    _connection = nil;
    _response = nil;
    _mutableResponseData = nil;
    _error = error;
    
    if([_delegate respondsToSelector:@selector(httpQuery:didError:)] == YES) {
        [_delegate httpQuery:self didError:_error];
    } else if(_errorCallback != nil) {
        _errorCallback(_error);
    }
    
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection* __unused)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    id< NSURLAuthenticationChallengeSender > sender = challenge.sender;
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    
    if(_certificateFilename != nil) {
        SecCertificateRef localCertificate = NULL;
        SecTrustResultType serverTrustResult = kSecTrustResultOtherError;
        NSString* path = [NSBundle.mainBundle pathForResource:_certificateFilename ofType:@"der"];
        if(path != nil) {
            NSData* data = [NSData dataWithContentsOfFile:path];
            if(data != nil) {
                CFDataRef cfData = (__bridge_retained CFDataRef)data;
                localCertificate = SecCertificateCreateWithData(NULL, cfData);
                if(localCertificate != NULL) {
                    CFArrayRef cfCertArray = CFArrayCreate(NULL, (void*)&localCertificate, 1, NULL);
                    if(cfCertArray != NULL) {
                        SecTrustSetAnchorCertificates(serverTrust, cfCertArray);
                        SecTrustEvaluate(serverTrust, &serverTrustResult);
                        if(serverTrustResult == kSecTrustResultRecoverableTrustFailure) {
                            CFDataRef cfErrorData = SecTrustCopyExceptions(serverTrust);
                            SecTrustSetExceptions(serverTrust, cfErrorData);
                            SecTrustEvaluate(serverTrust, &serverTrustResult);
                            CFRelease(cfErrorData);
                        }
                        CFRelease(cfCertArray);
                    }
                }
                CFRelease(cfData);
            }
        }
        if((serverTrustResult == kSecTrustResultUnspecified) || (serverTrustResult == kSecTrustResultProceed)) {
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            if(serverCertificate != NULL) {
                NSString* serverHash = nil;
                NSData* serverCertificateData = (__bridge_transfer NSData*)SecCertificateCopyData(serverCertificate);
                if(serverCertificateData != nil) {
                    serverHash = serverCertificateData.moToBase64.moStringBySHA256;
                }
                NSString* localHash = nil;
                NSData* localCertificateData = (__bridge_transfer NSData*)SecCertificateCopyData(localCertificate);
                if(localCertificateData != nil) {
                    localHash = localCertificateData.moToBase64.moStringBySHA256;
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
    } else if(_allowInvalidCertificates == NO) {
        [sender useCredential:[NSURLCredential credentialForTrust:serverTrust] forAuthenticationChallenge:challenge];
    } else {
        [sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

#pragma mark NSURLConnectionDataDelegate

- (NSCachedURLResponse*)connection:(NSURLConnection* __unused)connection willCacheResponse:(NSCachedURLResponse* __unused)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection* __unused)connection didReceiveResponse:(NSURLResponse*)response {
    if([response isKindOfClass:NSHTTPURLResponse.class] == YES) {
        _response = (NSHTTPURLResponse*)response;
    }
}

- (void)connection:(NSURLConnection* __unused)connection didReceiveData:(NSData*)data {
    if(_mutableResponseData == nil) {
        _mutableResponseData = NSMutableData.data;
    }
    [_mutableResponseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection* __unused)connection {
    _error = nil;
    _connection = nil;
    if([_delegate respondsToSelector:@selector(didFinishHttpQuery:)] == YES) {
        [_delegate didFinishHttpQuery:self];
    } else if(_finishCallback != nil) {
        _finishCallback(self);
    }
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}

@end

/*--------------------------------------------------*/

@implementation MobilyHttpAttachment

#pragma mark Synthesize

@synthesize name = _name;
@synthesize encodeName = _encodeName;
@synthesize filename = _filename;
@synthesize encodeFilename = _encodeFilename;
@synthesize mimeType = _mimeType;
@synthesize encodeMimeType = _encodeMimeType;
@synthesize data = _data;

#pragma mark Init / Free

- (instancetype)initWithName:(NSString*)name filename:(NSString*)filename mimeType:(NSString*)mimeType data:(NSData*)data {
    self = [super init];
    if(self != nil) {
        _name = name;
        _encodeName = YES;
        _filename = filename;
        _encodeFilename = YES;
        _mimeType = mimeType;
        _encodeMimeType = YES;
        _data = data;
        [self setup];
    }
    return self;
}

- (void)setup {
}

#pragma mark Debug

- (NSString*)description {
    return [NSString stringWithFormat:@"\tName = \"%@\"; Filename = \"%@\"; MimeType = \"%@\"; (%d bytes);", _name, _filename, _mimeType, (int)_data.length];
}

@end

/*--------------------------------------------------*/
