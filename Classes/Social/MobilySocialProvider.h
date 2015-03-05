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

#import "MobilySocialManager.h"
#import "MobilyModel.h"

/*--------------------------------------------------*/

typedef void (^MobilySocialProviderSuccessBlock)();
typedef void (^MobilySocialProviderFailureBlock)(NSError* error);

/*--------------------------------------------------*/

@interface MobilySocialProvider : NSObject < MobilyObject >

@property(nonatomic, readwrite, weak) MobilySocialManager* manager;
@property(nonatomic, readonly, strong) NSString* name;
@property(nonatomic, readonly, strong) NSString* userDefaultsKey;

@property(nonatomic, readwrite, strong) id session;

+ (Class)sessionClass;

- (instancetype)initWithName:(NSString*)name;

- (void)signoutSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure;

- (void)didBecomeActive;
- (void)willResignActive;

- (BOOL)openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation;

@end

/*--------------------------------------------------*/

@interface MobilySocialSession : MobilyModel

@property(nonatomic, readonly, assign, getter=isValid) BOOL valid;

@end

/*--------------------------------------------------*/
