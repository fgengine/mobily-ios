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

#import "MobilyDataContainer+Private.h"

/*--------------------------------------------------*/

@implementation MobilyDataContainerSectionsList

#pragma mark Synthesize

@synthesize orientation = _orientation;
@synthesize margin = _margin;
@synthesize spacing = _spacing;
@synthesize pagingEnabled = _pagingEnabled;
@synthesize currentSection = _currentSection;

#pragma mark Init / Free

+ (instancetype)containerWithOrientation:(MobilyDataContainerOrientation)orientation {
    return [[self alloc] initWithOrientation:orientation];
}

- (instancetype)initWithOrientation:(MobilyDataContainerOrientation)orientation {
    self = [super init];
    if(self != nil) {
        _orientation = orientation;
    }
    return self;
}

- (void)setup {
    [super setup];
    
    _margin = UIEdgeInsetsZero;
    _spacing = UIOffsetZero;
}

#pragma mark Property

- (void)setAllowAutoAlign:(BOOL)allowAutoAlign {
    if(_allowAutoAlign != allowAutoAlign) {
        [super setAllowAutoAlign:allowAutoAlign];
        if(_pagingEnabled == YES) {
            self.pagingEnabled = NO;
        }
    }
}

- (void)setOrientation:(MobilyDataContainerOrientation)orientation {
    if(_orientation != orientation) {
        _orientation = orientation;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setMargin:(UIEdgeInsets)margin {
    if(UIEdgeInsetsEqualToEdgeInsets(_margin, margin) == NO) {
        _margin = margin;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setSpacing:(UIOffset)spacing {
    if(UIOffsetEqualToOffset(_spacing, spacing) == NO) {
        _spacing = spacing;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    if(_pagingEnabled != pagingEnabled) {
        if(_pagingEnabled == YES) {
            _currentSection = nil;
        }
        _pagingEnabled = pagingEnabled;
        _allowAutoAlign = _pagingEnabled;
        if(_pagingEnabled == YES) {
            [self align];
        }
    }
}

- (void)setCurrentSectionIndex:(NSUInteger)currentSectionIndex {
    [self setCurrentSection:_sections[currentSectionIndex] animated:NO];
}

- (void)setCurrentSectionIndex:(NSUInteger)currentSectionIndex animated:(BOOL)animated {
    [self setCurrentSection:_sections[currentSectionIndex] animated:animated];
}

- (NSUInteger)currentSectionIndex {
    return [_sections indexOfObjectIdenticalTo:_currentSection];
}

- (void)setCurrentSection:(MobilyDataContainer*)currentSection {
    [self setCurrentSection:currentSection animated:NO];
}

- (void)setCurrentSection:(MobilyDataContainer*)currentSection animated:(BOOL)animated {
    if(_currentSection != currentSection) {
        _currentSection = currentSection;
        if((_pagingEnabled == YES) && (_currentSection != nil)) {
            [self scrollToSection:_currentSection scrollPosition:(MobilyDataViewPosition)_alignPosition animated:animated];
        }
    }
}

#pragma mark Public override

- (void)replaceOriginSection:(MobilyDataContainer*)originSection withSection:(MobilyDataContainer*)section {
    if((_pagingEnabled == YES) && (_currentSection == originSection)) {
        _currentSection = section;
    }
    [super replaceOriginSection:originSection withSection:section];
}

- (void)deleteSection:(MobilyDataContainer*)section {
    if((_pagingEnabled == YES) && (_currentSection == section)) {
        _currentSection = [_sections nextObjectOfObject:_currentSection];
    }
    [super deleteSection:section];
}

- (void)deleteAllSections {
    if(_pagingEnabled == YES) {
        _currentSection = nil;
    }
    [super deleteAllSections];
}

#pragma mark Private override

- (void)_didEndDraggingWillDecelerate:(BOOL __unused)decelerate {
    [super _didEndDraggingWillDecelerate:decelerate];
    
    if((_pagingEnabled == YES) && (decelerate == NO)) {
        CGPoint alignPoint = [self alignPoint];
        for(MobilyDataContainer* section in _sections) {
            if(CGRectContainsPoint(section.frame, alignPoint) == YES) {
                _currentSection = section;
                [self fireEventForKey:MobilyDataContainerCurrentSectionChanged byObject:_currentSection];
                break;
            }
        }
    }
}

- (void)_didEndDecelerating {
    [super _didEndDecelerating];
    
    if(_pagingEnabled == YES) {
        CGPoint alignPoint = [self alignPoint];
        for(MobilyDataContainer* section in _sections) {
            if(CGRectContainsPoint(section.frame, alignPoint) == YES) {
                _currentSection = section;
                [self fireEventForKey:MobilyDataContainerCurrentSectionChanged byObject:_currentSection];
                break;
            }
        }
    }
}

- (void)_didEndUpdateAnimated:(BOOL)animated {
    [super _didEndUpdateAnimated:animated];
    
    if((_pagingEnabled == YES) && (_currentSection != nil)) {
        [self scrollToSection:_currentSection scrollPosition:(MobilyDataViewPosition)_alignPosition animated:animated];
    }
}

- (CGRect)_validateSectionsForAvailableFrame:(CGRect)frame {
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGSize restriction = CGSizeMake(frame.size.width - (_margin.left + _margin.right), frame.size.height - (_margin.left + _margin.right));
    CGSize cumulative = CGSizeZero;
    switch(_orientation) {
        case MobilyDataContainerOrientationVertical: {
            for(MobilyDataContainer* container in _sections) {
                CGRect containerFrame = [container _validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, restriction.width, restriction.height)];
                if(CGRectIsNull(containerFrame) == NO) {
                    offset.y = (containerFrame.origin.y + containerFrame.size.height) + _spacing.vertical;
                    cumulative.width = MAX(containerFrame.size.width, restriction.width);
                    cumulative.height += containerFrame.size.height + _spacing.vertical;
                }
            }
            cumulative.height -= _spacing.vertical;
            break;
        }
        case MobilyDataContainerOrientationHorizontal: {
            for(MobilyDataContainer* container in _sections) {
                CGRect containerFrame = [container _validateLayoutForAvailableFrame:CGRectMake(offset.x, offset.y, restriction.width, restriction.height)];
                if(CGRectIsNull(containerFrame) == NO) {
                    offset.x = (containerFrame.origin.x + containerFrame.size.width) + _spacing.horizontal;
                    cumulative.width += containerFrame.size.width + _spacing.horizontal;
                    cumulative.height = MAX(containerFrame.size.height, restriction.height);
                }
            }
            cumulative.width -= _spacing.horizontal;
            break;
        }
    }
    return CGRectMake(frame.origin.x, frame.origin.y, _margin.left + cumulative.width + _margin.right, _margin.top + cumulative.height + _margin.bottom);
}

@end

/*--------------------------------------------------*/

NSString* MobilyDataContainerCurrentSectionChanged = @"MobilyDataContainerCurrentSectionChanged";

/*--------------------------------------------------*/
