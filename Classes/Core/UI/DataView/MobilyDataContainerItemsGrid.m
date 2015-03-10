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

@implementation MobilyDataContainerItemsGrid

#pragma mark Synthesize

@synthesize orientation = _orientation;
@synthesize margin = _margin;
@synthesize spacing = _spacing;
@synthesize numberOfColumns = _numberOfColumns;
@synthesize numberOfRows = _numberOfRows;
@synthesize headerColumns = _headerColumns;
@synthesize footerColumns = _footerColumns;
@synthesize headerRows = _headerRows;
@synthesize footerRows = _footerRows;
@synthesize content = _content;

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
    
    _orientation = MobilyDataContainerOrientationVertical;
    _margin = UIEdgeInsetsZero;
    _spacing = UIOffsetZero;
    _numberOfColumns = 0;
    _numberOfRows = 0;
    _headerColumns = NSMutableArray.array;
    _footerColumns = NSMutableArray.array;
    _headerRows = NSMutableArray.array;
    _footerRows = NSMutableArray.array;
    _content = MobilyMutableGrid.grid;
}

- (void)dealloc {
}

#pragma mark Property

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

#pragma mark Public

- (void)prependColumn:(MobilyDataItem*)column {
    [self prependHeaderColumn:column footerColumn:nil];
}

- (void)prependHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn {
    if(headerColumn != nil) {
        [_headerColumns insertObject:headerColumn atIndex:0];
        [self _prependEntry:headerColumn];
    }
    if(footerColumn != nil) {
        [_footerColumns insertObject:footerColumn atIndex:0];
        [self _prependEntry:footerColumn];
    }
    if(headerColumn != nil) {
        [_content insertColumn:[_headerColumns indexOfObject:headerColumn] objects:nil];
    } else if(footerColumn != nil) {
        [_content insertColumn:[_footerColumns indexOfObject:footerColumn] objects:nil];
    }
}

- (void)appendColumn:(MobilyDataItem*)column {
    [self appendHeaderColumn:column footerColumn:nil];
}

- (void)appendHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn {
    if(headerColumn != nil) {
        [_headerColumns addObject:headerColumn];
        [self _appendEntry:headerColumn];
    }
    if(footerColumn != nil) {
        [_footerColumns addObject:footerColumn];
        [self _appendEntry:footerColumn];
    }
    if(headerColumn != nil) {
        [_content insertColumn:[_headerColumns indexOfObject:headerColumn] objects:nil];
    } else if(footerColumn != nil) {
        [_content insertColumn:[_footerColumns indexOfObject:footerColumn] objects:nil];
    }
}

- (void)insertColumn:(MobilyDataItem*)column atIndex:(NSUInteger)index {
    [self insertHeaderColumn:column footerColumn:nil atIndex:index];
}

- (void)insertHeaderColumn:(MobilyDataItem*)headerColumn footerColumn:(MobilyDataItem*)footerColumn atIndex:(NSUInteger)index {
    if(headerColumn != nil) {
        [_headerColumns insertObject:headerColumn atIndex:index];
        [self _insertEntry:headerColumn atIndex:index];
    }
    if(footerColumn != nil) {
        [_footerColumns insertObject:footerColumn atIndex:index];
        [self _insertEntry:footerColumn atIndex:index];
    }
    if(headerColumn != nil) {
        [_content insertColumn:index objects:nil];
    } else if(footerColumn != nil) {
        [_content insertColumn:index objects:nil];
    }
}

- (void)deleteColumn:(MobilyDataItem*)column {
    NSUInteger headerIndex = [_headerColumns indexOfObject:column];
    NSUInteger footerIndex = [_footerColumns indexOfObject:column];
    NSUInteger index = (headerIndex != NSNotFound) ? headerIndex : footerIndex;
    if(headerIndex != NSNotFound) {
        [_headerColumns removeObjectAtIndex:index];
        [self _deleteEntry:_headerColumns[index]];
    }
    if(footerIndex != NSNotFound) {
        [_footerColumns removeObjectAtIndex:index];
        [self _deleteEntry:_footerColumns[index]];
    }
}

- (void)deleteAllColumns {
    if(_headerColumns.count > 0) {
        NSArray* headerColumns = [NSArray arrayWithArray:_headerColumns];
        [self _deleteEntries:headerColumns];
        [_headerColumns removeAllObjects];
    }
    if(_footerColumns.count > 0) {
        NSArray* footerColumns = [NSArray arrayWithArray:_footerColumns];
        [self _deleteEntries:footerColumns];
        [_footerColumns removeAllObjects];
    }
    if(_content.numberOfColumns > 0) {
        NSArray* cells = [NSArray arrayWithArray:_content.objects];
        [self _deleteEntries:cells];
        [_content removeAllObjects];
    }
}

- (void)prependRow:(MobilyDataItem*)row {
    [self prependHeaderRow:row footerRow:nil];
}

- (void)prependHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow {
    if(headerRow != nil) {
        [_headerRows insertObject:headerRow atIndex:0];
        [self _prependEntry:headerRow];
    }
    if(footerRow != nil) {
        [_footerRows insertObject:footerRow atIndex:0];
        [self _prependEntry:footerRow];
    }
    if(headerRow != nil) {
        [_content insertRow:[_headerRows indexOfObject:headerRow] objects:nil];
    } else if(footerRow != nil) {
        [_content insertRow:[_footerRows indexOfObject:footerRow] objects:nil];
    }
}

- (void)appendRow:(MobilyDataItem*)row {
    [self appendHeaderRow:row footerRow:nil];
}

- (void)appendHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow {
    if(headerRow != nil) {
        [_headerRows addObject:headerRow];
        [self _appendEntry:headerRow];
    }
    if(footerRow != nil) {
        [_footerRows addObject:footerRow];
        [self _appendEntry:footerRow];
    }
    if(headerRow != nil) {
        [_content insertRow:[_headerRows indexOfObject:headerRow] objects:nil];
    } else if(footerRow != nil) {
        [_content insertRow:[_footerRows indexOfObject:footerRow] objects:nil];
    }
}

- (void)insertRow:(MobilyDataItem*)row atIndex:(NSUInteger)index {
    [self insertHeaderRow:row footerRow:nil atIndex:index];
}

- (void)insertHeaderRow:(MobilyDataItem*)headerRow footerRow:(MobilyDataItem*)footerRow atIndex:(NSUInteger)index {
    if(headerRow != nil) {
        [_headerRows insertObject:headerRow atIndex:index];
        [self _insertEntry:headerRow atIndex:index];
    }
    if(footerRow != nil) {
        [_footerRows insertObject:footerRow atIndex:index];
        [self _insertEntry:footerRow atIndex:index];
    }
    if(headerRow != nil) {
        [_content insertRow:index objects:nil];
    } else if(footerRow != nil) {
        [_content insertRow:index objects:nil];
    }
}

- (void)deleteRow:(MobilyDataItem*)row {
    NSUInteger headerIndex = [_headerRows indexOfObject:row];
    NSUInteger footerIndex = [_footerRows indexOfObject:row];
    NSUInteger index = (headerIndex != NSNotFound) ? headerIndex : footerIndex;
    if(headerIndex != NSNotFound) {
        [_headerRows removeObjectAtIndex:index];
        [self _deleteEntry:_headerRows[index]];
    }
    if(footerIndex != NSNotFound) {
        [_footerRows removeObjectAtIndex:index];
        [self _deleteEntry:_footerRows[index]];
    }
}

- (void)deleteAllRows {
    if(_headerRows.count > 0) {
        NSArray* headerRows = [NSArray arrayWithArray:_headerRows];
        [self _deleteEntries:headerRows];
        [_headerRows removeAllObjects];
    }
    if(_footerRows.count > 0) {
        NSArray* footerRows = [NSArray arrayWithArray:_footerRows];
        [self _deleteEntries:footerRows];
        [_footerRows removeAllObjects];
    }
    if(_content.numberOfRows > 0) {
        NSArray* cells = [NSArray arrayWithArray:_content.objects];
        [self _deleteEntries:cells];
        [_content removeAllObjects];
    }
}

- (void)insertContent:(MobilyDataItem*)content atColumn:(NSUInteger)column atRow:(NSUInteger)row {
    [_content setObject:content atColumn:column atRow:row];
    [self _appendEntry:content];
}

- (void)deleteContentAtColumn:(NSUInteger)column atRow:(NSUInteger)row {
    MobilyDataItem* cell = [_content objectAtColumn:column atRow:row];
    if(cell != nil) {
        [_content setObject:nil atColumn:column atRow:row];
        [self _deleteEntry:cell];
    }
}

- (void)deleteAllContent {
    if(_headerRows.count > 0) {
        NSArray* headerRows = [NSArray arrayWithArray:_headerRows];
        [self _deleteEntries:headerRows];
        [_headerRows removeAllObjects];
    }
    if(_footerRows.count > 0) {
        NSArray* footerRows = [NSArray arrayWithArray:_footerRows];
        [self _deleteEntries:footerRows];
        [_footerRows removeAllObjects];
    }
    if(_content.numberOfRows > 0) {
        NSArray* cells = [NSArray arrayWithArray:_content.objects];
        [self _deleteEntries:cells];
        [_content setObjects:nil];
    }
}

#pragma mark Private override

- (CGRect)_validateEntriesForAvailableFrame:(CGRect)frame {
    return CGRectMake(frame.origin.x, frame.origin.y, _margin.left + _margin.right, _margin.top + _margin.bottom);
}

- (void)_willEntriesLayoutForBounds:(CGRect)bounds {
}

@end

/*--------------------------------------------------*/
