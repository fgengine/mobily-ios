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

#import "MobilyObject.h"

/*--------------------------------------------------*/

@class MobilyKVO;

/*--------------------------------------------------*/

typedef void (^MobilyKVOBlock)(MobilyKVO* kvo, id oldValue, id newValue);

/*--------------------------------------------------*/

@interface MobilyKVO : NSObject< MobilyObject >

@property(nonatomic, readonly, weak) id subject;
@property(nonatomic, readonly, strong) NSString* keyPath;
@property(nonatomic, readwrite, copy) MobilyKVOBlock block;

- (instancetype)initWithSubject:(id)subject keyPath:(NSString*)keyPath block:(MobilyKVOBlock)block;
- (void)stopObservation;

@end

/*--------------------------------------------------*/

@interface NSObject (MobilyKVO)

- (MobilyKVO*)observeKeyPath:(NSString*)keyPath withBlock:(MobilyKVOBlock)block;
- (MobilyKVO*)observeSelector:(SEL)selector withBlock:(MobilyKVOBlock)block;

@end

/*--------------------------------------------------*/
