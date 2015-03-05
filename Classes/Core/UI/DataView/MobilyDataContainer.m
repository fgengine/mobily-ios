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

#import "MobilyDataContainer+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataContainer

#pragma mark Synthesize

@synthesize view = _view;
@synthesize parent = _parent;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
}

#pragma mark Property

- (void)setView:(MobilyDataView*)view {
    if(_view != view) {
        [self _willChangeView];
        _view = view;
        [self _didChangeView];
    }
}

- (void)setParent:(MobilyDataContainer*)parent {
    if(_parent != parent) {
        [self _willChangeParent];
        _parent = parent;
        [self _didChangeParent];
    }
}

#pragma mark Property private

- (void)_willChangeView {
}

- (void)_didChangeView {
}

- (void)_willChangeParent {
}

- (void)_didChangeParent {
    if(_parent != nil) {
        self.view = _parent.view;
    }
}

- (void)_didBeginUpdate {
}

- (void)_didEndUpdate {
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    return CGRectNull;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
}

- (void)_didLayoutForBounds:(CGRect)bounds {
}

#pragma mark Public

- (NSArray*)allItems {
    return @[];
}

- (MobilyDataItem*)itemForData:(id)data {
    return nil;
}

- (MobilyDataCell*)cellForData:(id)data {
    return nil;
}

- (BOOL)containsEventForKey:(id)key {
    return [_view containsEventForKey:key];
}

- (id)fireEventForKey:(id)key byObject:(id)object {
    return [_view fireEventForKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:self byObject:object orDefault:orDefault];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_view fireEventForKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:sender byObject:object orDefault:orDefault];
}

@end

/*--------------------------------------------------*/
