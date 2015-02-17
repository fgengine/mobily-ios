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

#import "MobilyKVO.h"

/*--------------------------------------------------*/

static void* MobilyKVOContext = &MobilyKVOContext;

/*--------------------------------------------------*/

@interface MobilyKVO ()

@property(nonatomic, readwrite, weak) id subject;
@property(nonatomic, readwrite, strong) NSString* keyPath;

@end

/*--------------------------------------------------*/

@implementation MobilyKVO

#pragma mark Init / Free

- (instancetype)initWithSubject:(id)subject keyPath:(NSString*)keyPath block:(MobilyKVOBlock)block {
	self = [super init];
	if(self != nil) {
        self.subject = subject;
        self.keyPath = keyPath;
        self.block = block;
        
		[subject addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:MobilyKVOContext];
        
        [self setup];
	}
    return self;
}

- (void)setup {
}

- (void)dealloc {
	[self stopObservation];
    
    self.keyPath = nil;
    self.block = nil;
}

#pragma mark Public

- (void)stopObservation {
	[_subject removeObserver:self forKeyPath:_keyPath context:MobilyKVOContext];
    self.subject = nil;
}

#pragma mark Private

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(context == MobilyKVOContext) {
		if(_block != nil) {
			id oldValue = change[NSKeyValueChangeOldKey];
			if(oldValue == [NSNull null]) {
				oldValue = nil;
            }
			id newValue = change[NSKeyValueChangeNewKey];
			if(newValue == [NSNull null]) {
				newValue = nil;
            }
			_block(self, oldValue, newValue);
		}
	}
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation NSObject (MobilyKVO)

- (MobilyKVO*)observeKeyPath:(NSString*)keyPath withBlock:(MobilyKVOBlock)block {
	return [[MobilyKVO alloc] initWithSubject:self keyPath:keyPath block:block];
}

- (MobilyKVO*)observeSelector:(SEL)selector withBlock:(MobilyKVOBlock)block {
	return [[MobilyKVO alloc] initWithSubject:self keyPath:NSStringFromSelector(selector) block:block];
}

@end

/*--------------------------------------------------*/
