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
@synthesize frame = _frame;
@synthesize allowAutoAlign = _allowAutoAlign;
@synthesize alignInsets = _alignInsets;
@synthesize alignPosition = _alignPosition;
@synthesize alignThreshold = _alignThreshold;

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _alignPosition = MobilyDataContainerAlignNone;
    _alignThreshold = UIOffsetMake(20.0f, 20.0f);
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

- (CGRect)frame {
    [_view validateLayoutIfNeed];
    return _frame;
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

- (void)_willBeginDragging {
}

- (void)_didScrollDragging:(BOOL)dragging decelerating:(BOOL)decelerating {
}

- (void)_willEndDraggingWithVelocity:(CGPoint)velocity contentOffset:(inout CGPoint*)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if(_allowAutoAlign == YES) {
        *contentOffset = [self _alignWithVelocity:velocity contentOffset:*contentOffset contentSize:contentSize visibleSize:visibleSize];
    }
}

- (void)_didEndDraggingWillDecelerate:(BOOL __unused)decelerate {
}

- (void)_willBeginDecelerating {
}

- (void)_didEndDecelerating {
}

- (void)_didEndScrollingAnimation {
}

- (void)_didBeginUpdateAnimated:(BOOL __unused)animated {
}

- (void)_didEndUpdateAnimated:(BOOL __unused)animated {
    if(_allowAutoAlign == YES) {
        [self align];
    }
}

- (CGPoint)_alignPointWithContentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    CGPoint alignPoint = CGPointZero;
    MobilyDataContainerAlign hAlignPosition = _alignPosition & (MobilyDataContainerAlignLeft | MobilyDataContainerAlignCenteredHorizontally | MobilyDataContainerAlignRight);
    MobilyDataContainerAlign vAlignPosition = _alignPosition & (MobilyDataContainerAlignTop | MobilyDataContainerAlignCenteredVertically | MobilyDataContainerAlignBottom);
    if(hAlignPosition != 0) {
        CGFloat sdx = contentOffset.x;
        CGFloat edx = contentSize.width - (contentOffset.x + visibleSize.width);
        if(ABS(sdx) <= (_alignThreshold.vertical * 0.5f)) {
            contentOffset.x = 0.0f;
        } else if(ABS(edx) <= (_alignThreshold.horizontal * 0.5f)) {
            contentOffset.x = contentSize.width - visibleSize.width;
            hAlignPosition = 0;
        }
    }
    if(vAlignPosition != 0) {
        CGFloat sdy = contentOffset.y;
        CGFloat edy = contentSize.height - (contentOffset.y + visibleSize.height);
        if(ABS(sdy) <= (_alignThreshold.vertical * 0.5f)) {
            contentOffset.y = 0.0f;
        } else if(ABS(edy) <= (_alignThreshold.vertical * 0.5f)) {
            contentOffset.y = contentSize.height - visibleSize.height;
            vAlignPosition = 0;
        }
    }
    if((hAlignPosition != 0) || (vAlignPosition != 0)) {
        CGRect visibleRect = CGRectMake(_alignInsets.left, _alignInsets.top, visibleSize.width - (_alignInsets.left + _alignInsets.right), visibleSize.height - (_alignInsets.top + _alignInsets.bottom));
        if((_alignPosition & MobilyDataContainerAlignLeft) != 0) {
            alignPoint.x = contentOffset.x + visibleRect.origin.x;
        } else if((_alignPosition & MobilyDataContainerAlignCenteredHorizontally) != 0) {
            alignPoint.x = contentOffset.x + (visibleRect.origin.x + (visibleRect.size.width * 0.5f));
        } else if((_alignPosition & MobilyDataContainerAlignRight) != 0) {
            alignPoint.x = contentOffset.x + (visibleRect.origin.x + visibleRect.size.width);
        } else {
            alignPoint.x = contentOffset.x;
        }
        if((_alignPosition & MobilyDataContainerAlignTop) != 0) {
            alignPoint.y = contentOffset.y + visibleRect.origin.y;
        } else if((_alignPosition & MobilyDataContainerAlignCenteredVertically) != 0) {
            alignPoint.y = contentOffset.y + (visibleRect.origin.y + (visibleRect.size.height * 0.5f));
        } else if((_alignPosition & MobilyDataContainerAlignBottom) != 0) {
            alignPoint.y = contentOffset.y + (visibleRect.origin.y + visibleRect.size.height);
        } else {
            alignPoint.y = contentOffset.y;
        }
    }
    return alignPoint;
}

- (CGPoint)_alignWithVelocity:(CGPoint __unused)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize __unused)contentSize visibleSize:(CGSize __unused)visibleSize {
    return contentOffset;
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect __unused)frame {
    return CGRectNull;
}

- (void)_willLayoutForBounds:(CGRect __unused)bounds {
}

- (void)_didLayoutForBounds:(CGRect __unused)bounds {
}

#pragma mark Public

- (NSArray*)allItems {
    return @[];
}

- (MobilyDataItem*)itemForPoint:(CGPoint __unused)point {
    return nil;
}

- (MobilyDataItem*)itemForData:(id __unused)data {
    return nil;
}

- (MobilyDataCell*)cellForData:(id)data {
    MobilyDataItem* item = [self itemForData:data];
    if(item != nil) {
        return item.cell;
    }
    return nil;
}

- (BOOL)containsEventForKey:(id)key {
    return [_view containsEventForKey:key];
}

- (BOOL)containsEventForIdentifier:(NSString*)identifier forKey:(id)key {
    return [_view containsEventForIdentifier:identifier forKey:key];
}

- (void)fireEventForKey:(id)key byObject:(id)object {
    [_view fireEventForKey:key bySender:self byObject:object];
}

- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object {
    [_view fireEventForIdentifier:identifier forKey:key bySender:self byObject:object];
}

- (id)fireEventForKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:self byObject:object orDefault:orDefault];
}

- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:identifier forKey:key bySender:self byObject:object orDefault:orDefault];
}

- (void)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    [_view fireEventForKey:key bySender:sender byObject:object];
}

- (void)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object {
    [_view fireEventForIdentifier:identifier forKey:key bySender:sender byObject:object];
}

- (id)fireEventForKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (id)fireEventForIdentifier:(NSString*)identifier forKey:(id)key bySender:(id)sender byObject:(id)object orDefault:(id)orDefault {
    return [_view fireEventForIdentifier:identifier forKey:key bySender:sender byObject:object orDefault:orDefault];
}

- (CGPoint)alignPoint {
    return [self _alignPointWithContentOffset:_view.contentOffset contentSize:_view.contentSize visibleSize:_view.boundsSize];
}

- (void)align {
    if((_view.dragging == NO) && (_view.decelerating == NO)) {
        [_view setContentOffset:[self _alignWithVelocity:CGPointZero contentOffset:_view.contentOffset contentSize:_view.contentSize visibleSize:_view.boundsSize] animated:YES];
    }
}

@end

/*--------------------------------------------------*/
