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

#import <MobilyNS.h>

/*--------------------------------------------------*/

@interface MobilyGrid : NSObject< NSCopying >

@property(nonatomic, readonly, assign) NSUInteger numberOfColumns;
@property(nonatomic, readonly, assign) NSUInteger numberOfRows;
@property(nonatomic, readonly, assign) NSUInteger count;

+ (instancetype)grid;
+ (instancetype)gridWithColumns:(NSUInteger)columns rows:(NSUInteger)rows;
+ (instancetype)gridWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects;
+ (instancetype)gridWithGrid:(MobilyGrid*)grid;

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows;
- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects;
- (instancetype)initWithGrid:(MobilyGrid*)grid;

- (BOOL)containsObject:(id)object;
- (BOOL)containsColumn:(NSUInteger)column row:(NSUInteger)row;
- (BOOL)isEmptyColumn:(NSInteger)column;
- (BOOL)isEmptyRow:(NSInteger)row;

- (id)objectAtColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)findObject:(id)object inColumn:(NSUInteger*)column inRow:(NSUInteger*)row;
- (void)findObjectUsingBlock:(BOOL(^)(id object))block inColumn:(NSUInteger*)column inRow:(NSUInteger*)row;
- (NSArray*)objects;

- (void)enumerateColumnsRowsUsingBlock:(void(^)(id object, NSUInteger column, NSUInteger row, BOOL* stopColumn, BOOL* stopRow))block;
- (void)enumerateRowsColumnsUsingBlock:(void(^)(id object, NSUInteger column, NSUInteger row, BOOL* stopColumn, BOOL* stopRow))block;
- (void)enumerateByColumn:(NSInteger)column usingBlock:(void(^)(id object, NSUInteger column, NSUInteger row, BOOL* stop))block;
- (void)enumerateByRow:(NSInteger)row usingBlock:(void(^)(id object, NSUInteger column, NSUInteger row, BOOL* stop))block;

- (void)eachColumnsRows:(void(^)(id object, NSUInteger column, NSUInteger row))block;
- (void)eachRowsColumns:(void(^)(id object, NSUInteger column, NSUInteger row))block;
- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byColumn:(NSInteger)column;
- (void)each:(void(^)(id object, NSUInteger column, NSUInteger row))block byRow:(NSInteger)row;

@end

/*--------------------------------------------------*/

@interface MobilyMutableGrid : MobilyGrid

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows;

- (void)setObject:(id)object atColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)setObjects:(NSArray*)objects;

- (void)insertColumn:(NSUInteger)column objects:(NSArray*)objects;
- (void)insertRow:(NSUInteger)row objects:(NSArray*)objects;
- (void)removeColumn:(NSUInteger)column;
- (void)removeRow:(NSUInteger)row;
- (void)removeAllObjects;

@end

/*--------------------------------------------------*/
