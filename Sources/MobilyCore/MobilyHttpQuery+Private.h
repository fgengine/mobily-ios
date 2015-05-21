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

#import <MobilyCore/MobilyHttpQuery.h>

/*--------------------------------------------------*/

@interface MobilyHttpQuery () < NSURLConnectionDelegate, NSURLConnectionDataDelegate > {
@protected
    NSString* _certificateFilename;
    BOOL _allowInvalidCertificates;
    NSError* _error;
    __weak id< MobilyHttpQueryDelegate > _delegate;
    MobilyHttpQueryBlock _startCallback;
    MobilyHttpQueryBlock _cancelCallback;
    MobilyHttpQueryBlock _finishCallback;
    MobilyHttpQueryErrorBlock _errorCallback;
    
    NSURLConnection* _connection;
    NSMutableURLRequest* _request;
    NSHTTPURLResponse* _response;
    NSMutableData* _mutableResponseData;
}

@property(nonatomic, readwrite, strong) NSURLConnection* connection;
@property(nonatomic, readwrite, strong) NSMutableURLRequest* request;
@property(nonatomic, readwrite, strong) NSHTTPURLResponse* response;
@property(nonatomic, readwrite, strong) NSMutableData* mutableResponseData;

- (NSDictionary*)_formDataFromDictionary:(NSDictionary*)dictionary;
- (void)_formDataFromDictionary:(NSMutableDictionary*)dictionary value:(id)value keyPath:(NSString*)keyPath;

@end

/*--------------------------------------------------*/

@interface MobilyHttpAttachment () {
    NSString* _name;
    NSString* _filename;
    NSString* _mimeType;
    NSData* _data;
}

@end

/*--------------------------------------------------*/
