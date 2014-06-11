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

#pragma mark Standart

- (id)initWithSubject:(id)subject keyPath:(NSString*)keyPath block:(MobilyKVOBlock)block {
	self = [super init];
	if(self != nil) {
        [self setSubject:subject];
        [self setKeyPath:keyPath];
        [self setBlock:block];
        
		[subject addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:MobilyKVOContext];
	}
    return self;
}

- (void)dealloc {
	[self stopObservation];
    
    [self setKeyPath:nil];
    [self setBlock:nil];
    
    MOBILY_SAFE_DEALLOC;
}

#pragma mark MobilyKVO

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(context == MobilyKVOContext) {
		if(_block != nil) {
			id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
			if(oldValue == [NSNull null]) {
				oldValue = nil;
            }
			id newValue = [change objectForKey:NSKeyValueChangeNewKey];
			if(newValue == [NSNull null]) {
				newValue = nil;
            }
			_block(self, oldValue, newValue);
		}
	}
}

#pragma mark Public

- (void)stopObservation {
	[_subject removeObserver:self forKeyPath:_keyPath context:MobilyKVOContext];
    [self setSubject:nil];
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
