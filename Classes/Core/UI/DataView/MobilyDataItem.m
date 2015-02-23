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

#import "MobilyDataItem.h"

/*--------------------------------------------------*/

@interface MobilyDataItem ()

@property(nonatomic, readwrite, strong) NSString* identifier;
@property(nonatomic, readwrite, strong) id data;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataItem

#pragma mark Synthesize

@synthesize widget = _widget;
@synthesize parentContainer = _parentContainer;
@synthesize identifier = _identifier;
@synthesize data = _data;
@synthesize view = _view;
@synthesize originFrame = _originFrame;
@synthesize updateFrame = _updateFrame;
@synthesize displayFrame = _displayFrame;
@synthesize zOrder = _zOrder;
@synthesize allowsSnapToEdge = _allowsSnapToEdge;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsHighlighting = _allowsHighlighting;
@synthesize allowsEditing = _allowsEditing;
@synthesize selected = _selected;
@synthesize highlighted = _highlighted;
@synthesize editing = _editing;

#pragma mark Init / Free

+ (instancetype)dataItemWithIdentifier:(NSString*)identifier data:(id)data {
    return [[self alloc] initWithIdentifier:identifier data:data];
}

- (instancetype)initWithIdentifier:(NSString*)identifier data:(id)data {
    self = [super init];
    if(self != nil) {
        _originFrame = CGRectNull;
        _updateFrame = CGRectNull;
        _displayFrame = CGRectNull;
        _allowsSelection = YES;
        _allowsHighlighting = YES;
        _allowsEditing = YES;
        
        self.identifier = identifier;
        self.data = data;
        
        [self setup];
    }
    return self;
}

- (void)setup {
}

- (void)dealloc {
    self.identifier = nil;
    self.data = nil;
}

#pragma mark Property

- (void)setParentContainer:(id< MobilyDataContainer >)parentContainer {
    if(_parentContainer != parentContainer) {
        if(_parentContainer != nil) {
            if(_allowsSnapToEdge == YES) {
                [_parentContainer removeSnapToEdgeItem:self];
            }
        }
        _parentContainer = parentContainer;
        if(_parentContainer != nil) {
            self.widget = parentContainer.widget;
            if(_allowsSnapToEdge == YES) {
                [_parentContainer addSnapToEdgeItem:self];
            }
        } else {
            self.widget = nil;
        }
    }
}

- (void)setView:(UIView< MobilyDataItemView >*)view {
    if(_view != view) {
        if(_view != nil) {
            [_view removeFromSuperview];
            _view.item = nil;
        }
        _view = view;
        if(_view != nil) {
            [UIView performWithoutAnimation:^{
                _view.item = self;
                [_widget insertSubview:_view atIndex:0];
                if(CGRectIsNull(_originFrame) == NO) {
                    _view.frame = _originFrame;
                }
                _view.zPosition = _zOrder;
                _view.selected = _selected;
                _view.highlighted = _highlighted;
            }];
            _view.frame = self.frame;
        }
    }
}

- (void)setUpdateFrame:(CGRect)updateFrame {
    if(CGRectEqualToRect(_updateFrame, updateFrame) == NO) {
        _updateFrame = updateFrame;
        if(CGRectIsNull(_originFrame) == YES) {
            _originFrame = _updateFrame;
        }
        if((_view != nil) && ((CGRectIsNull(_updateFrame) == NO) && (CGRectIsNull(_displayFrame) == YES))) {
            _view.frame = _updateFrame;
        }
    }
}

- (void)setDisplayFrame:(CGRect)displayFrame {
    if(CGRectEqualToRect(_displayFrame, displayFrame) == NO) {
        _displayFrame = displayFrame;
        if((_view != nil) && (CGRectIsNull(_displayFrame) == NO)) {
            _view.frame = _displayFrame;
        }
    }
}

- (CGRect)displayFrame {
    if(CGRectIsNull(_displayFrame) == YES) {
        return _updateFrame;
    }
    return _displayFrame;
}

- (CGRect)frame {
    if(CGRectIsNull(_displayFrame) == NO) {
        return _displayFrame;
    } else if(CGRectIsNull(_updateFrame) == NO) {
        return _updateFrame;
    }
    return _originFrame;
}

- (void)setZOrder:(CGFloat)zOrder {
    if(_zOrder != zOrder) {
        _zOrder = zOrder;
        if(_view != nil) {
            _view.zPosition = zOrder;
        }
    }
}

- (void)setAllowsSnapToEdge:(BOOL)allowsSnapToEdge {
    if(_allowsSnapToEdge != allowsSnapToEdge) {
        if((_parentContainer != nil) && (_allowsSnapToEdge == YES)) {
            [_parentContainer removeSnapToEdgeItem:self];
        }
        _allowsSnapToEdge = allowsSnapToEdge;
        if((_parentContainer != nil) && (_allowsSnapToEdge == YES)) {
            [_parentContainer addSnapToEdgeItem:self];
        }
        if(_widget != nil) {
            [_widget setNeedLayoutForVisible];
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

#pragma mark Public

- (BOOL)containsEventForKey:(id)key {
    return [_widget containsEventForKey:key];
}

- (id)performEventForKey:(id)key byObject:(id)object {
    return [_widget performEventForKey:key bySender:self byObject:object];
}

- (id)performEventForKey:(id)key byObject:(id)object defaultResult:(id)defaultResult {
    return [_widget performEventForKey:key bySender:self byObject:object defaultResult:defaultResult];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object {
    return [_widget performEventForKey:key bySender:sender byObject:object];
}

- (id)performEventForKey:(id)key bySender:(id)sender byObject:(id)object defaultResult:(id)defaultResult {
    return [_widget performEventForKey:key bySender:sender byObject:object defaultResult:defaultResult];
}

- (void)didBeginUpdate {
}

- (void)didEndUpdate {
    self.originFrame = _updateFrame;
    if(_view != nil) {
        _view.frame = self.frame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(_selected != selected) {
        _selected = selected;
        if(_widget != nil) {
            if(_selected == YES) {
                if([_widget isSelectedItem:self] == NO) {
                    [_widget selectItem:self animated:animated];
                }
            } else {
                if([_widget isSelectedItem:self] == YES) {
                    [_widget deselectItem:self animated:animated];
                }
            }
        }
        if(_view != nil) {
            [_view setSelected:_selected animated:animated];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(_highlighted != highlighted) {
        _highlighted = highlighted;
        if(_widget != nil) {
            if(_highlighted == YES) {
                if([_widget isHighlightedItem:self] == NO) {
                    [_widget highlightItem:self animated:animated];
                }
            } else {
                if([_widget isHighlightedItem:self] == YES) {
                    [_widget unhighlightItem:self animated:animated];
                }
            }
        }
        if(_view != nil) {
            [_view setHighlighted:_highlighted animated:animated];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if(_editing != editing) {
        _editing = editing;
        if(_widget != nil) {
            if(_editing == YES) {
                if([_widget isEditingItem:self] == NO) {
                    [_widget beganEditItem:self animated:animated];
                }
            } else {
                if([_widget isEditingItem:self] == YES) {
                    [_widget endedEditItem:self animated:animated];
                }
            }
        }
        if(_view != nil) {
            [_view setEditing:_editing animated:NO];
        }
    }
}

- (CGSize)sizeForAvailableSize:(CGSize)size {
    Class< MobilyDataItemView > viewClass = [_widget viewClassWithItem:self];
    if(viewClass != nil) {
        return [viewClass sizeForItem:_data availableSize:size];
    }
    return CGSizeZero;
}

- (void)appear {
    [_widget appearItem:self];
}

- (void)disappear {
    [_widget disappearItem:self];
}

- (void)validateLayoutForVisibleBounds:(CGRect)bounds {
    if(_view == nil) {
        if(CGRectIntersectsRect(bounds, CGRectUnion(_originFrame, self.frame)) == YES) {
            [self appear];
        }
    } else {
        [_view validateLayoutForVisibleBounds:bounds];
    }
}

- (void)invalidateLayoutForVisibleBounds:(CGRect)bounds {
    if(_view != nil) {
        if(CGRectIntersectsRect(bounds, self.frame) == NO) {
            [self disappear];
        } else {
            [_view invalidateLayoutForVisibleBounds:bounds];
        }
    }
}

@end

/*--------------------------------------------------*/
