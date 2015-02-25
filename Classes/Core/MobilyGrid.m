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
    NSMutableArray* _objects;
}

@property(nonatomic, readonly, copy) NSArray* columns;

@end

/*--------------------------------------------------*/

@implementation MobilyGrid

#pragma mark Synthesize

@synthesize numberOfColumns = _numberOfColumns;
@synthesize numberOfRows = _numberOfRows;
@synthesize count = _count;
@synthesize columns = _objects;

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

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _objects = NSMutableArray.array;
    }
    return self;
}

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows {
    self = [super init];
    if(self != nil) {
        _numberOfColumns = columns;
        _numberOfRows = rows;
        _count = _numberOfColumns * _numberOfRows;
        _objects = [NSMutableArray arrayWithCapacity:_numberOfColumns];
        for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
            NSMutableArray* columnObjects = [NSMutableArray arrayWithCapacity:_numberOfRows];
            for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
                [columnObjects addObject:[NSNull null]];
            }
            [_objects addObject:columnObjects];
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
        _objects = [NSMutableArray arrayWithCapacity:_numberOfColumns];
        if(objects.count > 0) {
            NSUInteger index = 0;
            for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
                NSMutableArray* columnObjects = [NSMutableArray arrayWithCapacity:_numberOfRows];
                for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
                    if(index < objects.count) {
                        [columnObjects addObject:objects[index]];
                    } else {
                        [columnObjects addObject:[NSNull null]];
                    }
                    index++;
                }
                [_objects addObject:columnObjects];
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
        _objects = [NSMutableArray arrayWithArray:grid.columns];
    }
    return self;
}

- (void)dealloc {
    _objects = nil;
}

#pragma mark Public

- (BOOL)containsColumn:(NSUInteger)column row:(NSUInteger)row {
    return ([_objects[column][row] isKindOfClass:NSNull.class] == NO);
}

- (BOOL)isEmptyColumn:(NSInteger)column {
    for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
        if([_objects[column][ir] isKindOfClass:NSNull.class] == NO) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEmptyRow:(NSInteger)row {
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        if([_objects[ic][row] isKindOfClass:NSNull.class] == NO) {
            return NO;
        }
    }
    return YES;
}

- (id)objectAtColumn:(NSUInteger)column atRow:(NSUInteger)row {
    id object = _objects[column][row];
    if([object isKindOfClass:NSNull.class] == YES) {
        return nil;
    }
    return object;
}

- (NSArray*)objects {
    NSMutableArray* result = [NSMutableArray array];
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        NSMutableArray* columnObjects = _objects[ic];
        for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
            [result addObject:columnObjects[ir]];
        }
    }
    return result;
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block {
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        NSMutableArray* columnObjects = _objects[ic];
        for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
            block(columnObjects[ir], ic, ir);
        }
    }
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byColumn:(NSInteger)column {
    NSMutableArray* columnObjects = _objects[column];
    for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
        block(columnObjects[column][ir], column, ir);
    }
}

- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byRow:(NSInteger)row {
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        block(_objects[ic][row], ic, row);
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

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows {
    if((_numberOfColumns != numberOfColumns) || (_numberOfRows != numberOfRows)) {
        _numberOfColumns = numberOfColumns;
        _numberOfRows = numberOfRows;
        _count = _numberOfColumns * _numberOfRows;
        [_objects removeAllObjects];
        for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
            NSMutableArray* columnObjects = [NSMutableArray arrayWithCapacity:_numberOfRows];
            for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
                [columnObjects addObject:[NSNull null]];
            }
            [_objects addObject:columnObjects];
        }
    }
}

- (void)setObject:(id)object atColumn:(NSUInteger)column atRow:(NSUInteger)row {
    _objects[column][row] = (object != nil) ? object : [NSNull null];
}

- (void)setObjects:(NSArray*)objects {
    [_objects removeAllObjects];
    if(objects.count > 0) {
        NSUInteger index = 0;
        for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
            NSMutableArray* columnObjects = [NSMutableArray arrayWithCapacity:_numberOfRows];
            for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
                if(index < objects.count) {
                    [columnObjects addObject:objects[index]];
                } else {
                    [columnObjects addObject:[NSNull null]];
                }
                index++;
            }
            [_objects addObject:columnObjects];
        }
    }
}

- (void)insertColumn:(NSUInteger)column objects:(NSArray*)objects {
    NSMutableArray* columnObjects = [NSMutableArray arrayWithCapacity:_numberOfRows];
    for(NSUInteger ir = 0; ir < _numberOfRows; ir++) {
        if(ir < objects.count) {
            [columnObjects addObject:objects[ir]];
        } else {
            [columnObjects addObject:[NSNull null]];
        }
    }
    [_objects insertObject:columnObjects atIndex:column];
    _numberOfColumns++;
    _count = _numberOfColumns * _numberOfRows;
}

- (void)insertRow:(NSUInteger)row objects:(NSArray*)objects {
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        if(ic < objects.count) {
            [_objects[ic][row] insertObject:objects[ic] atIndex:row];
        } else {
            [_objects[ic][row] insertObject:[NSNull null] atIndex:row];
        }
    }
    _numberOfRows--;
    _count = _numberOfColumns * _numberOfRows;
}

- (void)removeColumn:(NSUInteger)column {
    [_objects removeObjectAtIndex:column];
    _numberOfColumns--;
    _count = _numberOfColumns * _numberOfRows;
}

- (void)removeRow:(NSUInteger)row {
    for(NSUInteger ic = 0; ic < _numberOfColumns; ic++) {
        [_objects[ic] removeObjectAtIndex:row];
    }
    _numberOfRows--;
    _count = _numberOfColumns * _numberOfRows;
}

- (void)removeAllObjects {
    [_objects removeAllObjects];
    _numberOfColumns = 0;
    _numberOfRows = 0;
    _count = 0;
}

@end

/*--------------------------------------------------*/
