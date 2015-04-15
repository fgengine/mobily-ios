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

@implementation MobilyDataContainerItemsGrid

#pragma mark Synthesize

@synthesize orientation = _orientation;
@synthesize margin = _margin;
@synthesize spacing = _spacing;
@synthesize defaultColumnSize = _defaultColumnSize;
@synthesize defaultRowSize = _defaultRowSize;
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
    _defaultColumnSize = CGSizeMake(128.0f, 64.0f);
    _defaultRowSize = CGSizeMake(64.0f, 44.0f);
    _numberOfColumns = 0;
    _numberOfRows = 0;
    _headerColumns = NSMutableArray.array;
    _footerColumns = NSMutableArray.array;
    _headerRows = NSMutableArray.array;
    _footerRows = NSMutableArray.array;
    _content = MobilyMutableGrid.grid;
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

- (void)setDefaultColumnSize:(CGSize)defaultColumnSize {
    if(CGSizeEqualToSize(_defaultColumnSize, defaultColumnSize) == NO) {
        _defaultColumnSize = defaultColumnSize;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

- (void)setDefaultRowSize:(CGSize)defaultRowSize {
    if(CGSizeEqualToSize(_defaultRowSize, defaultRowSize) == NO) {
        _defaultRowSize = defaultRowSize;
        if(_view != nil) {
            [_view setNeedValidateLayout];
        }
    }
}

#pragma mark Public

- (void)prependColumnIdentifier:(NSString*)identifier byData:(id)data {
    [self prependColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
              andColumnFooter:nil];
}

- (void)prependColumn:(MobilyDataItem*)column {
    [self prependColumnHeader:column
              andColumnFooter:nil];
}

- (void)prependColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData {
    [self prependColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
              andColumnFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]];
}

- (void)prependColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData {
    [self prependColumnHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
              andColumnFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]];
}

- (void)prependColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)footer {
    if(header != nil) {
        [_headerColumns insertObject:header atIndex:0];
        [self _prependEntry:header];
    }
    if(footer != nil) {
        [_footerColumns insertObject:footer atIndex:0];
        [self _prependEntry:footer];
    }
    if(header != nil) {
        [_content insertColumn:[_headerColumns indexOfObject:header] objects:nil];
    } else if(footer != nil) {
        [_content insertColumn:[_footerColumns indexOfObject:footer] objects:nil];
    }
}

- (void)appendColumnIdentifier:(NSString*)identifier byData:(id)data {
    [self appendColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
             andColumnFooter:nil];
}

- (void)appendColumn:(MobilyDataItem*)column {
    [self appendColumnHeader:column
             andColumnFooter:nil];
}

- (void)appendColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData {
    [self appendColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
             andColumnFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]];
}

- (void)appendColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData {
    [self appendColumnHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
             andColumnFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]];
}

- (void)appendColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)footer {
    if(header != nil) {
        [_headerColumns addObject:header];
        [self _appendEntry:header];
    }
    if(footer != nil) {
        [_footerColumns addObject:footer];
        [self _appendEntry:footer];
    }
    if(header != nil) {
        [_content insertColumn:[_headerColumns indexOfObject:header] objects:nil];
    } else if(footer != nil) {
        [_content insertColumn:[_footerColumns indexOfObject:footer] objects:nil];
    }
}

- (void)insertColumnIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index {
    [self insertColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
             andColumnFooter:nil
                     atIndex:index];
}

- (void)insertColumn:(MobilyDataItem*)column atIndex:(NSUInteger)index {
    [self insertColumnHeader:column
             andColumnFooter:nil
                     atIndex:index];
}

- (void)insertColumnIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData atIndex:(NSUInteger)index {
    [self insertColumnHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
             andColumnFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]
                     atIndex:index];
}

- (void)insertColumnHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData atIndex:(NSUInteger)index {
    [self insertColumnHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
             andColumnFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]
                     atIndex:index];
}

- (void)insertColumnHeader:(MobilyDataItem*)header andColumnFooter:(MobilyDataItem*)footer atIndex:(NSUInteger)index {
    if(header != nil) {
        [_headerColumns insertObject:header atIndex:index];
        [self _insertEntry:header atIndex:index];
    }
    if(footer != nil) {
        [_footerColumns insertObject:footer atIndex:index];
        [self _insertEntry:footer atIndex:index];
    }
    if(header != nil) {
        [_content insertColumn:index objects:nil];
    } else if(footer != nil) {
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

- (void)prependRowIdentifier:(NSString*)identifier byData:(id)data {
    [self prependRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
           andRowFooter:nil];
}

- (void)prependRow:(MobilyDataItem*)column {
    [self prependRowHeader:column
           andRowFooter:nil];
}

- (void)prependRowIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData {
    [self prependRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
              andRowFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]];
}

- (void)prependRowHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData {
    [self prependRowHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
              andRowFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]];
}

- (void)prependRowHeader:(MobilyDataItem*)header andRowFooter:(MobilyDataItem*)footer {
    if(header != nil) {
        [_headerRows insertObject:header atIndex:0];
        [self _prependEntry:header];
    }
    if(footer != nil) {
        [_footerRows insertObject:footer atIndex:0];
        [self _prependEntry:footer];
    }
    if(header != nil) {
        [_content insertRow:[_headerRows indexOfObject:header] objects:nil];
    } else if(footer != nil) {
        [_content insertRow:[_footerRows indexOfObject:footer] objects:nil];
    }
}

- (void)appendRowIdentifier:(NSString*)identifier byData:(id)data {
    [self appendRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
              andRowFooter:nil];
}

- (void)appendRow:(MobilyDataItem*)row {
    [self appendRowHeader:row
             andRowFooter:nil];
}

- (void)appendRowIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData {
    [self appendRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
             andRowFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]];
}

- (void)appendRowHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData {
    [self appendRowHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
             andRowFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]];
}

- (void)appendRowHeader:(MobilyDataItem*)header andRowFooter:(MobilyDataItem*)footer {
    if(header != nil) {
        [_headerRows addObject:header];
        [self _appendEntry:header];
    }
    if(footer != nil) {
        [_footerRows addObject:footer];
        [self _appendEntry:footer];
    }
    if(header != nil) {
        [_content insertRow:[_headerRows indexOfObject:header] objects:nil];
    } else if(footer != nil) {
        [_content insertRow:[_footerRows indexOfObject:footer] objects:nil];
    }
}

- (void)insertRowIdentifier:(NSString*)identifier byData:(id)data atIndex:(NSUInteger)index {
    [self insertRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:data]
             andRowFooter:nil
                  atIndex:index];
}

- (void)insertRow:(MobilyDataItem*)row atIndex:(NSUInteger)index {
    [self insertRowHeader:row
             andRowFooter:nil
                  atIndex:index];
}

- (void)insertRowIdentifier:(NSString*)identifier byHeaderData:(id)headerData byFooterData:(id)footerData atIndex:(NSUInteger)index {
    [self insertRowHeader:[MobilyDataItem itemWithIdentifier:identifier order:1 data:headerData]
             andRowFooter:[MobilyDataItem itemWithIdentifier:identifier order:1 data:footerData]
                  atIndex:index];
}

- (void)insertRowHeaderIdentifier:(NSString*)columnIdentifier byHeaderData:(id)headerData andFooterIdentifier:(NSString*)footerIdentifier byFooterData:(id)footerData atIndex:(NSUInteger)index {
    [self insertRowHeader:[MobilyDataItem itemWithIdentifier:columnIdentifier order:1 data:headerData]
             andRowFooter:[MobilyDataItem itemWithIdentifier:footerIdentifier order:1 data:footerData]
                  atIndex:index];
}

- (void)insertRowHeader:(MobilyDataItem*)header andRowFooter:(MobilyDataItem*)footer atIndex:(NSUInteger)index {
    if(header != nil) {
        [_headerRows insertObject:header atIndex:index];
        [self _insertEntry:header atIndex:index];
    }
    if(footer != nil) {
        [_footerRows insertObject:footer atIndex:index];
        [self _insertEntry:footer atIndex:index];
    }
    if(header != nil) {
        [_content insertRow:index objects:nil];
    } else if(footer != nil) {
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

- (void)insertContentIdentifier:(NSString*)identifier byData:(id)data atColumn:(NSUInteger)column atRow:(NSUInteger)row {
    [self insertContent:[MobilyDataItem itemWithIdentifier:identifier order:0 data:data]
               atColumn:column
                  atRow:row];
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
    CGFloat maxColumnHeight = 0.0f;
    NSMutableArray* columnsSize = [NSMutableArray array];
    for(MobilyDataItem* headerColumn in _headerColumns) {
        CGSize itemSize = [headerColumn sizeForAvailableSize:_defaultColumnSize];
        if((itemSize.width > 0.0f) && (itemSize.height > 0.0f)) {
            [columnsSize addObject:[NSValue valueWithCGSize:itemSize]];
            maxColumnHeight = MAX(maxColumnHeight, itemSize.height);
        }
    }
    CGFloat footerColumnHeight = 0.0f;
    for(MobilyDataItem* footerColumn in _footerColumns) {
        CGSize itemSize = [footerColumn sizeForAvailableSize:_defaultColumnSize];
        if((itemSize.width > 0.0f) && (itemSize.height > 0.0f)) {
            maxColumnHeight = MAX(maxColumnHeight, itemSize.height);
        }
    }
    CGFloat maxRowWidth = 0.0f;
    NSMutableArray* rowsSize = [NSMutableArray array];
    for(MobilyDataItem* headerRow in _headerRows) {
        CGSize itemSize = [headerRow sizeForAvailableSize:_defaultRowSize];
        if((itemSize.width > 0.0f) && (itemSize.height > 0.0f)) {
            [rowsSize addObject:[NSValue valueWithCGSize:itemSize]];
            maxRowWidth = MAX(maxRowWidth, itemSize.width);
        }
    }
    CGFloat footerRowWidth = 0.0f;
    for(MobilyDataItem* footerRow in _footerRows) {
        CGSize itemSize = [footerRow sizeForAvailableSize:_defaultRowSize];
        if((itemSize.width > 0.0f) && (itemSize.height > 0.0f)) {
            maxRowWidth = MAX(maxRowWidth, itemSize.width);
        }
    }
    /*
    CGSize contentSize = CGSizeZero;
    [_content eachColumnsRows:^(id object, NSUInteger column, NSUInteger row) {
    }];
    CGPoint offset = CGPointMake(frame.origin.x + _margin.left, frame.origin.y + _margin.top);
    CGPoint headerOffset = CGPointMake(offset.x + headerRowSize.width, offset.y + headerColumnSize.height);
    CGPoint footerOffset = CGPointMake(headerOffset.x + contentSize.width, headerOffset.y + contentSize.height);
    [_headerColumns eachWithIndex:^(MobilyDataItem* headerColumn, NSUInteger index) {
        headerColumn.updateFrame = CGRectMake(headerOffset.x + (headerColumnSize.width * index), offset.y, headerColumnSize.width, headerColumnSize.height);
    }];
    [_footerColumns eachWithIndex:^(MobilyDataItem* footerColumn, NSUInteger index) {
        footerColumn.updateFrame = CGRectMake(footerOffset.x + (footerColumnSize.width * index), offset.y, footerColumnSize.width, footerColumnSize.height);
    }];
    [_headerRows eachWithIndex:^(MobilyDataItem* headerRow, NSUInteger index) {
        headerRow.updateFrame = CGRectMake(offset.x, headerOffset.y + (headerRowSize.height * index), headerRowSize.width, headerRowSize.height);
    }];
    [_footerRows eachWithIndex:^(MobilyDataItem* footerRow, NSUInteger index) {
        footerRow.updateFrame = CGRectMake(offset.x, footerOffset.y + (footerRowSize.height * index), footerRowSize.width, footerRowSize.height);
    }];
    return CGRectMake(frame.origin.x,
                      frame.origin.y,
                      _margin.left + headerRowSize.width + contentSize.width + footerRowSize.width + _margin.right,
                      _margin.top + headerColumnSize.height + contentSize.height + footerRowSize.height + _margin.bottom);
    */
    return CGRectZero;
}

- (void)_willEntriesLayoutForBounds:(CGRect __unused)bounds {
}

@end

/*--------------------------------------------------*/
