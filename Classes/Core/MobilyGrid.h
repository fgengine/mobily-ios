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

#import "MobilyNS.h"

/*--------------------------------------------------*/

@interface MobilyGrid : NSObject< NSCopying >

@property(nonatomic, readonly, assign) NSUInteger columns;
@property(nonatomic, readonly, assign) NSUInteger rows;

- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows;
- (instancetype)initWithColumns:(NSUInteger)columns rows:(NSUInteger)rows objects:(NSArray*)objects;
- (instancetype)initWithGrid:(MobilyGrid*)grid;

- (BOOL)containsColumn:(NSUInteger)column row:(NSUInteger)row;
- (BOOL)isEmptyColumn:(NSInteger)column;
- (BOOL)isEmptyRow:(NSInteger)row;

- (id)objectAtColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (NSArray*)objects;

- (void)eachWithIndex:(void(^)(id object, NSUInteger column, NSUInteger row))block;

@end

/*--------------------------------------------------*/

@interface MobilyMutableGrid : MobilyGrid

- (void)setObject:(id)object atColumn:(NSUInteger)column atRow:(NSUInteger)row;
- (void)setObjects:(NSArray*)objects;

@end

/*--------------------------------------------------*/