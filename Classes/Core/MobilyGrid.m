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

#import "MobilyGrid.h"

/*--------------------------------------------------*/

@interface MobilyGrid () {
@protected
    NSUInteger _numberOfColumns;
    NSUInteger _numberOfRows;
    NSUInteger _count;
    NSMutableArray* _columns;
}

@property(nonatomic, readonly, copy) NSArray* columns;

@end

/*--------------------------------------------------*/

@implementation MobilyGrid

#pragma mark Synthesize

@synthesize numberOfColumns = _numberOfColumns;
@synthesize numberOfRows = _numberOfRows;
@synthesize count = _count;
@synthesize columns = _columns;

#pragma mark Init / Free

+ (instancetype)grid {
    return [[self alloc] init];
}

+ (instancetype)gridWithColumns:(NSUInteger)columns rows:(NSUInteger)rows {
    return [[self alloc] initWithColumns:columns rows:rows];
}

+ (instancetype)gridWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects {
    return [[self alloc] initWithColumns:columns rows:rows objects:objects];
}

+ (instancetype)gridWithGrid:(MobilyGrid*)grid {
    return [[self alloc] gridWithGrid:grid];
}

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows {
    self = [super init];
    if(self != nil) {
        _numberOfColumns = columns;
        _numberOfRows = rows;
        _count = _numberOfColumns * _numberOfRows;
        _columns = [NSMutableArray arrayWithCapacity:_numberOfColumns];
        for(NSUInteger c = 0; c < _numberOfColumns; c++) {
            NSMutableArray* rows = [NSMutableArray arrayWithCapacity:_numberOfColumns];
            for(NSUInteger r = 0; r < _numberOfRows; r++) {
                [rows addObject:[NSNull null]];
            }
            [_columns addObject:rows];
        }
    }
    return self;
}

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects {
    self = [super init];
    if(self != nil) {
        _numberOfColumns = columns;
        _numberOfRows = rows;
        _count = _numberOfColumns * _numberOfRows;
        _columns = [NSMutableArray arrayWithCapacity:_numberOfColumns];
        if(objects.count > 0) {
            NSUInteger index = 0;
            for(NSUInteger c = 0; c < _numberOfColumns; c++) {
                NSMutableArray* rows = [NSMutableArray arrayWithCapacity:_numberOfColumns];
                for(NSUInteger r = 0; r < _numberOfRows; r++) {
                    if(index < _count) {
                        [rows addObject:objects[index]];
                    } else {
                        [rows addObject:[NSNull null]];
                    }
                    index++;
                }
                [_columns addObject:rows];
            }
        }
    }
    return self;
}

- (instancetype)initWithGrid:(MobilyGrid*)grid {
    self = [super init];
    if(self != nil) {
        _numberOfColumns = grid.numberOfColumns;
        _numberOfRows = grid.numberOfRows;
        _count = grid.count;
        _columns = [NSMutableArray arrayWithArray:grid.columns];
    }
    return self;
}

- (void)dealloc {
    _columns = nil;
}

#pragma mark Public

- (BOOL)containsColumn:(NSUInteger)column row:(NSUInteger)row {
    if((column < _numberOfColumns) && (row < _numberOfRows)) {
        return ([_columns[column][row] isKindOfClass:NSNull.class] == NO);
    }
    return NO;
}

- (BOOL)isEmptyColumn:(NSInteger)column {
    if(column < _numberOfColumns) {
        for(NSUInteger row = 0; row < _numberOfRows; row++) {
            if([_columns[column][row] isKindOfClass:NSNull.class] == NO) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)isEmptyRow:(NSInteger)row {
    if(row < _numberOfRows) {
        for(NSUInteger column = 0; column < _numberOfColumns; column++) {
            if([_columns[column][row] isKindOfClass:NSNull.class] == NO) {
                return NO;
            }
        }
    }
    return YES;
}

- (id)objectAtColumn:(NSUInteger)column atRow:(NSUInteger)row {
    if((column >= _numberOfColumns) && (row >= _numberOfRows)) {
        return nil;
    }
    return _columns[column][row];
}

- (NSArray*)objects {
    NSMutableArray* result = [NSMutableArray array];
    for(NSUInteger c = 0; c < _numberOfColumns; c++) {
        NSMutableArray* rows = _columns[c];
        for(NSUInteger r = 0; r < _numberOfRows; r++) {
            [result addObject:rows[r]];
        }
    }
    return result;
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block {
    for(NSUInteger c = 0; c < _numberOfColumns; c++) {
        NSMutableArray* rows = _columns[c];
        for(NSUInteger r = 0; r < _numberOfRows; r++) {
            block(rows[r], c, r);
        }
    }
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byColumn:(NSInteger)column {
    NSMutableArray* rows = _columns[column];
    for(NSUInteger r = 0; r < _numberOfRows; r++) {
        block(rows[r], column, r);
    }
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byRow:(NSInteger)row {
    for(NSUInteger c = 0; c < _numberOfColumns; c++) {
        for(NSUInteger r = 0; r < _numberOfRows; r++) {
            block(_columns[c][row], c, row);
        }
    }
}

#pragma mark NSCopying

- (id)copy {
    return [self copyWithZone:NSDefaultMallocZone()];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[MobilyGrid alloc] initWithGrid:self];
}

- (id)mutableCopy {
    return [self mutableCopyWithZone:NSDefaultMallocZone()];
}

- (id)mutableCopyWithZone:(NSZone*)zone {
    return [[MobilyMutableGrid alloc] initWithGrid:self];
}

@end

/*--------------------------------------------------*/

@implementation MobilyMutableGrid

#pragma mark Public

- (void)setObject:(id)object atColumn:(NSUInteger)column atRow:(NSUInteger)row {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if((column >= _numberOfColumns) && (row >= _numberOfRows)) {
        NSLog(@"ERROR: [%@:%@] %@ - %d - %d", self.class, NSStringFromSelector(_cmd), object, (int)column, (int)row);
        return;
    }
#endif
    _columns[column][row] = object;
}

- (void)setObjects:(NSArray*)objects {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if((_numberOfColumns * _numberOfRows) != objects.count) {
        NSLog(@"ERROR: [%@:%@] %d", self.class, NSStringFromSelector(_cmd), (int)objects.count);
        return;
    }
#endif
    [_columns removeAllObjects];
    if(objects.count > 0) {
        NSUInteger index = 0;
        for(NSUInteger c = 0; c < _numberOfColumns; c++) {
            NSMutableArray* rows = [NSMutableArray arrayWithCapacity:_numberOfColumns];
            for(NSUInteger r = 0; r < _numberOfRows; r++) {
                if(index < _count) {
                    [rows addObject:objects[index]];
                } else {
                    [rows addObject:[NSNull null]];
                }
                index++;
            }
            [_columns addObject:rows];
        }
    }
}

- (void)removeObjectAtColumn:(NSUInteger)column atRow:(NSUInteger)row {
    if((column < _numberOfColumns) && (row < _numberOfRows)) {
        _columns[column][row] = [NSNull null];
    }
}

- (void)removeObjectsForColumn:(NSUInteger)column {
    if(column < _numberOfColumns) {
        for(NSUInteger row = 0; row < _numberOfRows; row++) {
            _columns[column][row] = [NSNull null];
        }
    }
}

- (void)removeObjectsForRow:(NSUInteger)row {
    if(row < _numberOfRows) {
        for(NSUInteger column = 0; column < _numberOfColumns; column++) {
            _columns[column][row] = [NSNull null];
        }
    }
}

- (void)removeAllObjects {
    [_columns removeAllObjects];
}

@end

/*--------------------------------------------------*/
