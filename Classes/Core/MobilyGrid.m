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
    NSUInteger _columns;
    NSUInteger _rows;
    NSMutableArray* _objects;
}

@end

/*--------------------------------------------------*/

@implementation MobilyGrid

#pragma mark Synthesize

@synthesize columns = _columns;
@synthesize rows = _rows;

#pragma mark Init / Free

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows {
    self = [super init];
    if(self != nil) {
        _columns = columns;
        _rows = rows;
        _objects = [NSMutableArray arrayWithCapacity:_columns * _rows];
    }
    return self;
}

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects {
    self = [super init];
    if(self != nil) {
        _columns = columns;
        _rows = rows;
        _objects = [NSMutableArray arrayWithCapacity:_columns * _rows];
        if((_columns * _rows) == objects.count) {
            [_objects setArray:objects];
        }
    }
    return self;
}

- (instancetype)initWithGrid:(MobilyGrid*)grid {
    self = [super init];
    if(self != nil) {
        _columns = grid.columns;
        _rows = grid.rows;
        _objects = [NSMutableArray arrayWithArray:grid->_objects];
    }
    return self;
}

- (void)dealloc {
    _objects = nil;
}

#pragma mark Public

- (BOOL)containsColumn:(NSUInteger)column row:(NSUInteger)row {
    if((column > 0) && (column < _columns) && (row > 0) && (row < _rows)) {
        return (_objects[(_columns * column) + row] != nil);
    }
    return NO;
}

- (BOOL)isEmptyColumn:(NSInteger)column {
    for(NSUInteger row = 0; row < _rows; row++) {
        if(_objects[(_columns * column) + row] != nil) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEmptyRow:(NSInteger)row {
    for(NSUInteger column = 0; column < _columns; column++) {
        if(_objects[(_columns * column) + row] != nil) {
            return NO;
        }
    }
    return YES;
}

- (id)objectAtColumn:(NSUInteger)column atRow:(NSUInteger)row {
    if((column >= _columns) && (row >= _rows)) {
        return nil;
    }
    return _objects[(_columns * column) + row];
}

- (NSArray*)objects {
    return _objects;
}

- (void)eachWithIndex:(void(^)(id object, NSUInteger column, NSUInteger row))block {
    __block NSUInteger column = 0, row = 0;
    [_objects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
        block(object, column, row);
        row++;
        if(row >= _rows) {
            column++;
            row = 0;
        }
    }];
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
    if((column >= _columns) && (row >= _rows)) {
        NSLog(@"ERROR: [%@:%@] %@ - %d - %d", self.class, NSStringFromSelector(_cmd), object, (int)column, (int)row);
        return;
    }
#endif
    _objects[(_columns * column) + row] = object;
}

- (void)setObjects:(NSArray*)objects {
#if defined(MOBILY_DEBUG) && ((MOBILY_DEBUG_LEVEL & MOBILY_DEBUG_LEVEL_ERROR) != 0)
    if((_columns * _rows) != objects.count) {
        NSLog(@"ERROR: [%@:%@] %d", self.class, NSStringFromSelector(_cmd), (int)objects.count);
        return;
    }
#endif
    [_objects setArray:objects];
}

@end

/*--------------------------------------------------*/
