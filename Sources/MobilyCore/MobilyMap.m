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

#import <MobilyCore/MobilyMap.h>

/*--------------------------------------------------*/

@interface MobilyMap () {
@protected
    NSMutableArray* _keys;
    NSMutableArray* _objects;
    NSMutableDictionary* _pairs;
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyMap

#pragma mark Creation

+ (instancetype)map {
    return [[[self class] alloc] init];
}

+ (instancetype)mapWithMap:(MobilyMap*)map {
    return [[[self class] alloc] initWithMap:map];
}

+ (instancetype)mapWithContentsOfFile:(NSString*)path {
    return [[[self class] alloc] initWithContentsOfFile:path];
}

+ (instancetype)mapWithContentsOfURL:(NSURL*)URL {
    return [[[self class] alloc] initWithContentsOfURL:URL];
}

+ (instancetype)mapWithObject:(id)anObject pairedWithKey:(id< NSCopying >)aKey {
    return [[[self class] alloc] initWithObjects:@[anObject] pairedWithKeys:@[aKey]];
}

+ (instancetype)mapWithDictionary:(NSDictionary*)entrys {
    return [[[self class] alloc] initWithContentsOfDictionary:entrys];
}

#pragma mark Init / Free

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _keys = [[NSMutableArray alloc] init];
        _objects = [[NSMutableArray alloc] init];
        _pairs = [[NSMutableDictionary alloc] init];
        [self setup];
    }
    return self;
}

- (instancetype)initWithMap:(MobilyMap*)map {
    return [self initWithMap:map copyEntries:NO];
}

- (instancetype)initWithMap:(MobilyMap*)map copyEntries:(BOOL)flag {
    self = [super init];
    if(self != nil) {
        _keys = [[NSMutableArray alloc] initWithArray:map.allKeys copyItems:flag];
        _objects = [[NSMutableArray alloc] initWithArray:map.allObjects copyItems:flag];
        _pairs = [[NSMutableDictionary alloc] initWithObjects:_objects forKeys:_keys];
        [self setup];
    }
    return self;
}

- (instancetype)initWithContentsOfFile:(NSString*)path {
    NSDictionary* rawData = [NSDictionary dictionaryWithContentsOfFile:path];
    return [self initWithObjects:rawData[@"Objects"] pairedWithKeys:rawData[@"Keys"]];
}

- (instancetype)initWithContentsOfURL:(NSURL*)URL {
    NSDictionary* rawData = [NSDictionary dictionaryWithContentsOfURL:URL];
    return [self initWithObjects:rawData[@"Objects"] pairedWithKeys:rawData[@"Keys"]];
}

- (instancetype)initWithContentsOfDictionary:(NSDictionary*)entrys {
    self = [super init];
    if(self != nil) {
        _keys = [[NSMutableArray alloc] initWithArray:entrys.allKeys];
        _objects = [[NSMutableArray alloc] init];
        for(id key in _keys) {
            [_objects addObject:entrys[key]];
        }
        _pairs = [[NSMutableDictionary alloc] initWithObjects:_objects forKeys:_keys];
        [self setup];
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray*)orderedObjects pairedWithKeys:(NSArray*)orderedKeys {
    NSAssert(orderedObjects.count == orderedKeys.count, @"The amount of _objects does not match the number of _keys");
    NSAssert([[NSSet setWithArray:orderedKeys] count] == orderedKeys.count, @"There are duplicate _keys on initialization");
    self = [super init];
    if(self != nil) {
        _keys = [[NSMutableArray alloc] initWithArray:orderedKeys];
        _objects = [[NSMutableArray alloc] initWithArray:orderedObjects];
        _pairs = [[NSMutableDictionary alloc] initWithObjects:_objects forKeys:_keys];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)decoder {
    return [self initWithObjects:[decoder decodeObjectForKey:@"NSODObjects"] pairedWithKeys:[decoder decodeObjectForKey:@"NSODKeys"]];
}

- (void)setup {
}

#pragma mark Querying

- (BOOL)containsObject:(id)object {
    return [_objects containsObject:object];
}

- (BOOL)containsObject:(id)object pairedWithKey:(id< NSCopying >)key {
    if(([_objects containsObject:object] == YES) && ([_keys containsObject:key] == YES)) {
        return YES;
    }
    return NO;
}

- (BOOL)containsEntry:(NSDictionary*)entry {
    return [self containsObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0]];
}

- (NSUInteger)count {
    return [_keys count];
}

- (id)firstObject {
    return _objects.firstObject;
}

- (id< NSCopying >)firstKey {
    return _keys.firstObject;
}

- (NSDictionary*)firstEntry {
    return @{ _keys.firstObject: _objects.firstObject };
}

- (id)lastObject {
    return _objects.lastObject;
}

- (id< NSCopying >)lastKey {
    return _keys.lastObject;
}

- (NSDictionary*)lastEntry {
    return @{ _keys.lastObject: _objects.lastObject };
}

- (id)objectAtIndex:(NSUInteger)index {
    return _objects[index];
}

- (id< NSCopying >)keyAtIndex:(NSUInteger)index {
    return _keys[index];
}

- (NSDictionary*)entryAtIndex:(NSUInteger)index {
    return @{ _keys[index]: self[index] };
}

- (NSArray*)objectsAtIndices:(NSIndexSet*)indexes {
    return [_objects objectsAtIndexes:indexes];
}

- (NSArray*)keysAtIndices:(NSIndexSet*)indexes {
    return [_keys objectsAtIndexes:indexes];
}

- (MobilyMap*)entriesAtIndices:(NSIndexSet*)indexes {
    return [[MobilyMap alloc] initWithObjects:[_objects objectsAtIndexes:indexes] pairedWithKeys:[_keys objectsAtIndexes:indexes]];
}

- (NSDictionary*)unorderedEntriesAtIndices:(NSIndexSet*)indexes {
    return [NSDictionary dictionaryWithObjects:[_objects objectsAtIndexes:indexes] forKeys:[_keys objectsAtIndexes:indexes]];
}

- (NSDictionary*)unmap {
    return [NSDictionary dictionaryWithObjects:_objects forKeys:_keys];
}

- (NSArray*)allKeys {
    return _keys;
}

- (NSArray*)allObjects {
    return _objects;
}

- (NSArray*)allKeysForObject:(id)anObject {
    return [_pairs allKeysForObject:anObject];
}

- (id)objectForKey:(id< NSCopying >)key {
    return _pairs[key];
}

- (NSArray*)objectForKeys:(NSArray*)orderedKeys notFoundMarker:(id)anObject {
    return [_pairs objectsForKeys:orderedKeys notFoundMarker:anObject];
}

#pragma mark Enumeration

- (NSEnumerator*)objectEnumerator {
    return [_objects objectEnumerator];
}

- (NSEnumerator*)keyEnumerator {
    return [_keys objectEnumerator];
}

- (NSEnumerator*)entryEnumerator {
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < _keys.count; i++) {
        [temp addObject:[self entryAtIndex:i]];
    }
    return [temp objectEnumerator];
}

- (NSEnumerator*)reverseObjectEnumerator {
    return [_objects reverseObjectEnumerator];
}

- (NSEnumerator*)reverseKeyEnumerator {
    return [_keys reverseObjectEnumerator];
}

- (NSEnumerator*)reverseEntryEnumerator {
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    for(NSUInteger i = 1; i <= _keys.count; i--) {
        [temp addObject:[self entryAtIndex:(_keys.count - i)]];
    }
    return [temp objectEnumerator];
}

#pragma mark Searching

- (NSUInteger)indexOfObject:(id)object {
    return [_objects indexOfObject:object];
}

- (NSUInteger)indexOfKey:(id< NSCopying >)key {
    return [_keys indexOfObject:key];
}

- (NSUInteger)indexOfEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key {
    NSIndexSet* idx1 = [_objects indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger index __unused, BOOL* stop __unused) {
        return [obj isEqual:object];
    }];
    NSIndexSet* idx2 = [_keys indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger index __unused, BOOL* stop __unused) {
        return [obj isEqual:key];
    }];
    NSUInteger index = NSNotFound;
    NSUInteger current_index = [idx1 firstIndex];
    while((current_index != NSNotFound) && (index == NSNotFound)) {
        if([idx2 containsIndex:current_index] == YES) {
            index = current_index;
        }
        current_index = [idx1 indexGreaterThanIndex:current_index];
    }
    return index;
}

- (NSUInteger)indexOfEntry:(NSDictionary*)entry {
    return [self indexOfEntryWithObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0]];
}

- (NSUInteger)indexOfObject:(id)object inRange:(NSRange)range {
    return [_objects indexOfObject:object inRange:range];
}

- (NSUInteger)indexOfKey:(id< NSCopying >)key inRange:(NSRange)range {
    return [_keys indexOfObject:key inRange:range];
}

- (NSUInteger)indexOfEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key inRange:(NSRange)range {
    NSIndexSet* idx1 = [[_objects objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger index __unused, BOOL* stop __unused) {
        return [obj isEqual:object];
    }];
    NSIndexSet* idx2 = [[_keys objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger index __unused, BOOL* stop __unused) {
        return [obj isEqual:key];
    }];
    NSUInteger index = NSNotFound;
    NSUInteger current_index = [idx1 firstIndex];
    while((current_index != NSNotFound) && (index == NSNotFound)) {
        if([idx2 containsIndex:current_index] == YES) {
            index = current_index;
        }
        current_index = [idx1 indexGreaterThanIndex:current_index];
    }
    return index;
}

- (NSUInteger)indexOfEntry:(NSDictionary*)entry inRange:(NSRange)range {
    return [self indexOfEntryWithObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0] inRange:range];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)object {
    return [_objects indexOfObjectIdenticalTo:object];
}

- (id< NSCopying >)keyOfObjectIdenticalTo:(id)object {
    return _keys[[_objects indexOfObjectIdenticalTo:object]];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)object inRange:(NSRange)range {
    return [_objects indexOfObjectIdenticalTo:object inRange:range];
}

- (id< NSCopying >)keyOfObjectIdenticalTo:(id)object inRange:(NSRange)range {
    return _keys[[_objects indexOfObjectIdenticalTo:object inRange:range]];
}

- (NSUInteger)indexOfObjectPassingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexOfObjectPassingTest:predicate];
}

- (id< NSCopying >)keyOfObjectPassingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return _keys[[_objects indexOfObjectPassingTest:predicate]];
}

- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexOfObjectWithOptions:opts passingTest:predicate];
}

- (id< NSCopying >)keyOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return _keys[[_objects indexOfObjectWithOptions:opts passingTest:predicate]];
}

- (NSUInteger)indexOfObjectAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexOfObjectAtIndexes:indexSet options:opts passingTest:predicate];
}

- (id< NSCopying >)keyOfObjectAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return _keys[[_objects indexOfObjectAtIndexes:indexSet options:opts passingTest:predicate]];
}

- (NSUInteger)indexOfObject:(id)object inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp {
    return [_objects indexOfObject:object inSortedRange:r options:opts usingComparator:cmp];
}

- (id< NSCopying >)keyOfObject:(id)object inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp {
    return _keys[[object indexOfObject:object inSortedRange:r options:opts usingComparator:cmp]];
}

- (NSIndexSet*)indicesOfObjectsPassingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexesOfObjectsPassingTest:predicate];
}

- (NSArray*)keysOfObjectsPassingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_keys objectsAtIndexes:[_objects indexesOfObjectsPassingTest:predicate]];
}

- (NSIndexSet*)indicesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexesOfObjectsWithOptions:opts passingTest:predicate];
}

- (NSArray*)keysOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_keys objectsAtIndexes:[_objects indexesOfObjectsWithOptions:opts passingTest:predicate]];
}

- (NSIndexSet*)indicesOfObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_objects indexesOfObjectsAtIndexes:indexSet options:opts passingTest:predicate];
}

- (NSArray*)keysOfObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id, NSUInteger, BOOL*))predicate {
    return [_keys objectsAtIndexes:[_objects indexesOfObjectsAtIndexes:indexSet options:opts passingTest:predicate]];
}

#pragma mark Performing Selectors

- (void)makeObjectsPerformSelector:(SEL)aSelector {
    [_objects makeObjectsPerformSelector:aSelector];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject {
    [_objects makeObjectsPerformSelector:aSelector withObject:anObject];
}

- (void)enumerateObjectsUsingBlock:(void(^)(id, NSUInteger, BOOL*))block {
    [_objects enumerateObjectsUsingBlock:block];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void(^)(id, NSUInteger, BOOL*))block {
    [_objects enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)enumerateObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts usingBlock:(void(^)(id, NSUInteger, BOOL*))block {
    [_objects enumerateObjectsAtIndexes:indexSet options:opts usingBlock:block];
}

- (void)moEach:(void(^)(id key, id object))block {
    [_objects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop __unused) {
        block(_keys[index], object);
    }];
}

- (void)eachWithIndex:(void(^)(id key, id object, NSUInteger index))block {
    [_objects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop __unused) {
        block(_keys[index], object, index);
    }];
}

- (void)eachKey:(void(^)(id key))block {
    [_objects enumerateObjectsUsingBlock:^(id object __unused, NSUInteger index, BOOL* stop __unused) {
        block(_keys[index]);
    }];
}

- (void)eachKeyWithIndex:(void(^)(id key, NSUInteger index))block {
    [_objects enumerateObjectsUsingBlock:^(id object __unused, NSUInteger index, BOOL* stop __unused) {
        block(_keys[index], index);
    }];
}

- (void)eachValue:(void(^)(id object))block {
    [_objects enumerateObjectsUsingBlock:^(id object, NSUInteger index __unused, BOOL* stop __unused) {
        block(object);
    }];
}

- (void)eachValueWithIndex:(void(^)(id object, NSUInteger index))block {
    [_objects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop __unused) {
        block(object, index);
    }];
}

#pragma mark Comparing

- (id)firstObjectInCommonWithMap:(MobilyMap*)otherMap {
    return [_objects firstObjectCommonWithArray:otherMap.allObjects];
}

- (id)firstKeyInCommonWithMap:(MobilyMap*)otherMap {
    return [_keys firstObjectCommonWithArray:otherMap.allKeys];
}

- (id)firstEntryInCommonWithMap:(MobilyMap*)otherMap {
    NSArray* temp1 = [_keys firstObjectCommonWithArray:otherMap.allKeys];
    id object = nil;
    int i = 0;
    while(i < temp1.count && object == nil) {
        if([self[temp1[i]] isEqual:otherMap[temp1[i]]] == YES) {
            _objects = self[temp1[i]];
        }
    }
    return object;
}

- (BOOL)isEqualToMap:(MobilyMap*)otherMap {
    if([self count] != otherMap.count) {
        return NO;
    } else {
        BOOL A = [_keys isEqualToArray:otherMap.allKeys];
        BOOL B = [_objects isEqualToArray:otherMap.allObjects];
        if((A == YES) && (B == YES)) {
            return YES;
        }
    }
    return NO;
}

#pragma mark Deriving

- (MobilyMap*)mapByAddingObject:(id)object pairedWithKey:(id< NSCopying >)aKey {
    return [[MobilyMap alloc] initWithObjects:[_objects arrayByAddingObject:object] pairedWithKeys:[_keys arrayByAddingObject:aKey]];
}

- (MobilyMap*)mapByAddingEntry:(NSDictionary*)entry {
    return [[MobilyMap alloc] initWithObjects:[_objects arrayByAddingObject:(entry.allValues)[0]] pairedWithKeys:[_keys arrayByAddingObject:(entry.allKeys)[0]]];
}

- (MobilyMap*)mapByAddingObjects:(NSArray*)orderedObjects pairedWithKeys:(NSArray*)orderedKeys {
    return [[MobilyMap alloc] initWithObjects:[_objects arrayByAddingObjectsFromArray:orderedObjects] pairedWithKeys:[_keys arrayByAddingObjectsFromArray:orderedKeys]];
}

- (MobilyMap*)filteredOrderDictionarysUsingPredicateForObjects:(NSPredicate*)predicate {
    NSArray* tempObj = [_objects filteredArrayUsingPredicate:predicate];
    int i = 0;
    int j = 0;
    NSMutableArray* tempKey = [[NSMutableArray alloc] init];
    while((i < tempObj.count) && (j < _keys.count)) {
        if([tempObj[i] isEqual:_objects[j]] == YES) {
            [tempKey addObject:_keys[j]];
            j++;
            i++;
        }
        j++;
    }
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:tempKey];
}

- (MobilyMap*)subMapWithRange:(NSRange)range {
    return [[MobilyMap alloc] initWithObjects:[_objects subarrayWithRange:range] pairedWithKeys:[_keys subarrayWithRange:range]];
}

#pragma mark Sorting

- (NSArray*)keysForSortedObjects:(NSArray*)tempObj {
    NSMutableArray* tempKey = [[NSMutableArray alloc] init];
    NSMutableArray* testObj = [[NSMutableArray alloc] initWithArray:_objects];
    NSMutableArray* testKey = [[NSMutableArray alloc] initWithArray:_keys];
    while(testObj.count > 0) {
        NSInteger index = [testObj indexOfObjectIdenticalTo:tempObj[(tempObj.count - testObj.count)]];
        [tempKey addObject:testKey[index]];
        [testKey removeObjectAtIndex:index];
        [testObj removeObjectAtIndex:index];
    }
    return tempKey;
}

- (NSArray*)objectsForSortedKeys:(NSArray*)tempKey {
    NSMutableArray* tempObj = [[NSMutableArray alloc] init];
    for(id key in tempKey) {
        [tempObj addObject:_pairs[key]];
    }
    return tempObj;
}

- (NSData*)sortedObjectsHint {
    return [_objects sortedArrayHint];
}

- (NSData*)sortedKeysHint {
    return [_keys sortedArrayHint];
}

- (MobilyMap*)sortedByObjectsUsingFunction:(NSInteger(*)(__strong id, __strong id, void*))comparator context:(void*)context {
    NSArray* tempObj = [_objects sortedArrayUsingFunction:comparator context:context];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];
}

- (MobilyMap*)sortedByKeysUsingFunction:(NSInteger(*)(__strong id< NSCopying>, __strong id< NSCopying>, void*))comparator context:(void*)context {
    NSArray* tempKey = [_keys sortedArrayUsingFunction:comparator context:context];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

- (MobilyMap*)sortedByObjectsUsingFunction:(NSInteger(*)(__strong id, __strong id, void*))comparator context:(void*)context hint:(NSData*)hint {
    NSArray* tempObj = [_objects sortedArrayUsingFunction:comparator context:context hint:hint];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];
}

- (MobilyMap*)sortedByKeysUsingFunction:(NSInteger(*)(__strong id< NSCopying>, __strong id< NSCopying>, void*))comparator context:(void*)context hint:(NSData*)hint {
    NSArray* tempKey = [_keys sortedArrayUsingFunction:comparator context:context hint:hint];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

- (MobilyMap*)sortedByObjectsUsingDescriptors:(NSArray*)descriptors {
    NSArray* tempObj = [_objects sortedArrayUsingDescriptors:descriptors];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];
}

- (MobilyMap*)sortedByKeysUsingDescriptors:(NSArray*)descriptors {
    NSArray* tempKey = [_keys sortedArrayUsingDescriptors:descriptors];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

- (MobilyMap*)sortedByObjectsUsingSelector:(SEL)comparator {
    NSArray* tempObj = [_objects sortedArrayUsingSelector:comparator];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];
}

- (MobilyMap*)sortedByKeysUsingSelector:(SEL)comparator {
    NSArray* tempKey = [_keys sortedArrayUsingSelector:comparator];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

- (MobilyMap*)sortedByObjectsUsingComparator:(NSComparator)cmptr {
    NSArray* tempObj = [_objects sortedArrayUsingComparator:cmptr];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];
}

- (MobilyMap*)sortedByKeysUsingComparator:(NSComparator)cmptr {
    NSArray* tempKey = [_keys sortedArrayUsingComparator:cmptr];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

- (MobilyMap*)sortedByObjectsWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    NSArray* tempObj = [_objects sortedArrayWithOptions:opts usingComparator:cmptr];
    return [[MobilyMap alloc] initWithObjects:tempObj pairedWithKeys:[self keysForSortedObjects:tempObj]];    
}

- (MobilyMap*)sortedByKeysWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    NSArray* tempKey = [_objects sortedArrayWithOptions:opts usingComparator:cmptr];
    return [[MobilyMap alloc] initWithObjects:[self objectsForSortedKeys:tempKey] pairedWithKeys:tempKey];
}

#pragma mark Description

- (NSString*)description {
    NSMutableString* string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for(int i = 0; i < self.count; i++) {
        id key = _keys[i];
        id object = _objects[i];
        NSString* keyDes = @"";
        NSString* objDes = @"";
        if([key respondsToSelector:@selector(description)] == YES) {
            keyDes = [key description];
        } else {
            keyDes = nil;
        }
        if([object respondsToSelector:@selector(description)] == YES) {
            objDes = [object description];
        } else {
            objDes = nil;
        }
        [string appendFormat:@"\n\t%@ = %@", keyDes, objDes];
        if(i < self.count - 1) {
            [string appendString:@";"];
        }
    }
    [string appendString:@"\n}"];
    return string;
}

- (NSString*)descriptionWithLocale:(id)locale {
    NSMutableString* string = [[NSMutableString alloc] init];
    [string appendString:@"{"];
    for(int i = 0; i < self.count; i++) {
        id key = _keys[i];
        id object = _objects[i];
        NSString* keyDes = @"";
        NSString* objDes = @"";
        if([key respondsToSelector:@selector(descriptionWithLocale:indent:)] == YES) {
            keyDes = [key descriptionWithLocale:locale indent:1];
        }
        else if([key respondsToSelector:@selector(descriptionWithLocale:)] == YES) {
            keyDes = [key descriptionWithLocale:locale];
        } else if([key respondsToSelector:@selector(description)] == YES) {
            keyDes = [key description];
        } else {
            keyDes = nil;
        }
        if([object respondsToSelector:@selector(descriptionWithLocale:indent:)] == YES) {
            objDes = [object descriptionWithLocale:locale indent:1];
        }
        else if([object respondsToSelector:@selector(descriptionWithLocale:)] == YES) {
            objDes = [object descriptionWithLocale:locale];
        } else if([object respondsToSelector:@selector(description)] == YES) {
            objDes = [object description];
        } else {
            objDes = nil;
        }
        [string appendFormat:@"\n\t%@ = %@", keyDes, objDes];
        if(i < self.count - 1) {
            [string appendString:@";"];
        }
    }
    [string appendString:@"\n}"];
    return string;
}

- (NSString*)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString* string = [[NSMutableString alloc] init];
    [string appendString:@"    {"];
    for(int i = 0; i < self.count; i++) {
        id key = _keys[i];
        id object = _objects[i];
        NSString* keyDes = @"";
        NSString* objDes = @"";
        if([key respondsToSelector:@selector(descriptionWithLocale:indent:)] == YES) {
            keyDes = [key descriptionWithLocale:locale indent:level + 1];
        } else if([key respondsToSelector:@selector(descriptionWithLocale:)] == YES) {
            keyDes = [key descriptionWithLocale:locale];
        } else if([key respondsToSelector:@selector(description)] == YES) {
            keyDes = [key description];
        } else {
            keyDes = nil;
        }
        if([object respondsToSelector:@selector(descriptionWithLocale:indent:)] == YES) {
            objDes = [object descriptionWithLocale:locale indent:level + 1];
        } else if([object respondsToSelector:@selector(descriptionWithLocale:)] == YES) {
            objDes = [object descriptionWithLocale:locale];
        } else if([object respondsToSelector:@selector(description)] == YES) {
            objDes = [object description];
        } else {
            objDes = nil;
        }
        for(int i = 0; i < level; i++) {
            [string appendString:@"\t"];
        }
        [string appendFormat:@"\n%@ = %@", keyDes, objDes];
        if(i < self.count - 1) {
            [string appendString:@";"];
        }
    }
    [string appendString:@"\n"];
    for(int i = 0; i < level; i++) {
        [string appendString:@"\t"];
    }
    [string appendString:@"}"];
    return string;
}

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)flag {
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:_objects forKeys:_keys];
    return [dict writeToFile:path atomically:flag];
}

- (BOOL)writeToURL:(NSURL*)aURL atomically:(BOOL)flag {
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:_objects forKeys:_keys];
    return [dict writeToURL:aURL atomically:flag];
}

#pragma mark KVO

- (void)addObserver:(NSObject*)anObserver toObjectsAtIndices:(NSIndexSet*)indexes forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context {
    [_objects addObserver:anObserver toObjectsAtIndexes:indexes forKeyPath:keyPath options:options context:context];
}

- (void)addObserver:(NSObject*)observer forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context {
    [_pairs addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)removeObserver:(NSObject*)anObserver fromObjectsAtIndices:(NSIndexSet*)indexes forKeyPath:(NSString*)keyPath {
    [_objects removeObserver:anObserver fromObjectsAtIndexes:indexes forKeyPath:keyPath];
}

- (void)removeObserver:(NSObject*)observer forKeyPath:(NSString*)keyPath context:(void*)context {
    [_pairs removeObserver:observer forKeyPath:keyPath context:context];
}

- (void)setValue:(id)value forKey:(NSString*)key {
    [_objects setValue:value forKey:key];
}

- (id)valueForKey:(NSString*)key {
    return [_objects valueForKey:key];
}

- (void)setValue:(id)value forKeyPath:(NSString*)keyPath {
    [_pairs setValue:value forKeyPath:keyPath];
}

- (id)valueForKeyPath:(NSString*)keyPath {
    return [_pairs valueForKeyPath:keyPath];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_objects forKey:@"NSODObjects"];
    [aCoder encodeObject:_keys forKey:@"NSODKeys"];
}

#pragma mark NSCopying

- (id)copy {
    return [self copyWithZone:NSDefaultMallocZone()];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[MobilyMap alloc] initWithObjects:[_objects copyWithZone:zone] pairedWithKeys:[_keys copyWithZone:zone]];
}

- (id)mutableCopy {
    return [self mutableCopyWithZone:NSDefaultMallocZone()];
}

- (id)mutableCopyWithZone:(NSZone*)zone {
    return [[MobilyMutableMap allocWithZone:zone] initWithMap:self];
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_keys countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark Indexed Subscripts

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return _objects[index];
}

- (id)objectForKeyedSubscript:(id)key {
    return _pairs[key];
}

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyMutableMap

#pragma mark Creating

+ (instancetype)mapWithCapacity:(NSUInteger)numEntrys {
    return [[[self class] alloc] initWithCapacity:numEntrys];
}

#pragma mark Init / Free

- (instancetype)initWithCapacity:(NSUInteger)numEntrys {
    return [[MobilyMutableMap alloc] initWithObjects:[NSMutableArray arrayWithCapacity:numEntrys] pairedWithKeys:[NSMutableArray arrayWithCapacity:numEntrys]];
}

#pragma mark Adding Objects

- (void)addObject:(id)object pairedWithKey:(id< NSCopying >)key {
    if(_pairs[key] != nil) {
        [self removeEntryWithKey:key];
    }
    _pairs[key] = object;
    [_keys addObject:key];
    [_objects addObject:object];
}

- (void)addEntry:(NSDictionary*)entry {
    [self addObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0]];
}

- (void)addEntriesFromMap:(MobilyMap*)map {
    for(int i = 0; i < map.count; i++) {
        [self addObject:map[i] pairedWithKey:[map keyAtIndex:i]];
    }
}

- (void)addEntriesFromDictionary:(NSDictionary*)dictionary {
    for(id key in dictionary.allKeys) {
        [self addObject:dictionary[key] pairedWithKey:key];
    }
}

- (void)insertObject:(id)object pairedWithKey:(id< NSCopying >)key atIndex:(NSUInteger)index {
    if(_pairs[key] != nil) {
        [self removeEntryWithKey:key];
    }
    _pairs[key] = object;
    [_keys insertObject:key atIndex:index];
    [_objects insertObject:object atIndex:index];
}

- (void)insertEntry:(NSDictionary*)entry atIndex:(NSUInteger)index {
    [self insertObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0] atIndex:index];
}

- (void)insertEntriesFromMap:(MobilyMap*)map atIndex:(NSUInteger)index {
    for(int i = 0; i < map.count; i++) {
        [self insertObject:map[i] pairedWithKey:[map keyAtIndex:i] atIndex:(index + i)];
    }
}

- (void)insertEntriesFromDictionary:(NSDictionary*)dictionary atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for(id key in dictionary.allKeys) {
        [self insertObject:dictionary[key] pairedWithKey:key atIndex:i];
        i++;
    }
}

- (void)setObject:(id)object forKey:(id< NSCopying >)aKey {
    if(_pairs[aKey] != nil) {
        _pairs[aKey] = object;
        _objects[[self indexOfKey:aKey]] = object;
    } else {
        [self addObject:object pairedWithKey:aKey];
    }
}

- (void)setEntry:(NSDictionary*)entry {
    self[(entry.allKeys)[0]] = (entry.allValues)[0];
}

- (void)setEntriesFromMap:(MobilyMap*)map {
    for(NSUInteger i = 0; i < map.count; i++) {
        self[[map keyAtIndex:i]] = map[i];
    }
}

- (void)setEntriesFromDictionary:(NSDictionary*)dictionary {
    for(id key in dictionary.allKeys) {
        self[key] = dictionary[key];
    }
}

- (void)setObject:(id)object forKey:(id< NSCopying >)aKey atIndex:(NSUInteger)index {
    if(_pairs[aKey] != nil) {
        _pairs[aKey] = object;
        _objects[[self indexOfKey:aKey]] = object;
    } else {
        [self insertObject:object pairedWithKey:_keys atIndex:index];
    }
}

- (void)setEntry:(NSDictionary*)entry atIndex:(NSUInteger)index {
    [self setObject:(entry.allValues)[0] forKey:(entry.allKeys)[0] atIndex:index];
}

- (void)setEntriesFromMap:(MobilyMap*)map atIndex:(NSUInteger)index {
    for(NSUInteger i = 0; i < map.count; i++) {
        [self setObject:map[i] forKey:[map keyAtIndex:i] atIndex:(index + i)];
    }
}

- (void)setEntriesFromDictionary:(NSDictionary*)dictionary atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for(id key in dictionary.allKeys) {
        [self setObject:dictionary[key] forKey:key atIndex:i];
        i++;
    }
}

#pragma mark Removing

- (void)removeObjectForKey:(id)key {
    [self removeEntryWithKey:key];
}

- (void)removeObjectsForKeys:(NSArray*)arrayKeys {
    [self removeEntriesWithKeysInArray:arrayKeys];
}

- (void)removeFirstEntry {
    if(_keys.count > 0) {
        [self removeEntryAtIndex:0];
    }
}

- (void)removeLastEntry {
    if(_keys.count > 0) {
        [self removeEntryAtIndex:(_keys.count - 1)];
    }
}

- (void)removeEntryWithObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryWithKey:(id< NSCopying >)key {
    NSUInteger index = [self indexOfKey:key];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key {
    NSUInteger index = [self indexOfEntryWithObject:object pairedWithKey:key];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntry:(NSDictionary*)entry {
    [self removeEntryWithObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0]];
}

- (void)removeEntryWithObject:(id)object inRange:(NSRange)range {
    NSUInteger index = [self indexOfObject:object inRange:range];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryWithKey:(id< NSCopying >)key inRange:(NSRange)range {
    NSUInteger index = [self indexOfKey:key inRange:range];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key inRange:(NSRange)range {
    NSUInteger index = [self indexOfEntryWithObject:object pairedWithKey:key inRange:range];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntry:(NSDictionary*)entry inRange:(NSRange)range {
    NSUInteger index = [self indexOfEntry:entry inRange:range];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryAtIndex:(NSUInteger)index {
    id key = _keys[index];
    [_keys removeObjectAtIndex:index];
    [_objects removeObjectAtIndex:index];
    [_pairs removeObjectForKey:key];
}

- (void)removeEntriesAtIndices:(NSIndexSet*)indexes {
    NSArray* tempKey = [self keysAtIndices:indexes];
    for(id key in tempKey) {
        [self removeEntryWithKey:key];
    }
}

- (void)removeEntryWithObjectIdenticalTo:(id)anObject {
    NSUInteger index = [self indexOfObjectIdenticalTo:anObject];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntryWithObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    NSUInteger index = [self indexOfObjectIdenticalTo:anObject inRange:range];
    if(index != NSNotFound) {
        [self removeEntryAtIndex:index];
    }
}

- (void)removeEntriesWithObjectsInArray:(NSArray*)array {
    for(id object in array) {
        [self removeEntryWithObject:object];
    }
}

- (void)removeEntriesWithKeysInArray:(NSArray*)array {
    for(id key in array) {
        [self removeEntryWithKey:key];
    }
}

- (void)removeEntriesInRange:(NSRange)range {
    for(NSUInteger i = range.location; i < range.location + range.length; i++) {
        [self removeEntryAtIndex:i];
    }
}

- (void)removeAllObjects {
    [self removeAllEntries];
}

- (void)removeAllEntries {
    [_keys removeAllObjects];
    [_objects removeAllObjects];
    [_pairs removeAllObjects];
}

#pragma mark Replacing Objects

- (void)replaceEntryAtIndex:(NSInteger)index withObject:(id)object pairedWithKey:(id< NSCopying >)key {
    id oldKey = _keys[index];
    [_pairs removeObjectForKey:oldKey];
    _pairs[key] = object;
    _keys[index] = key;
    _objects[index] = object;
}

- (void)replaceEntryAtIndex:(NSUInteger)index withEntry:(NSDictionary*)entry {
    [self replaceEntryAtIndex:index withObject:(entry.allValues)[0] pairedWithKey:(entry.allKeys)[0]];
}

- (void)replaceEntriesAtIndices:(NSIndexSet*)indexes withObjects:(NSArray*)aobjects pairedWithKeys:(NSArray*)akeys {
    NSUInteger index = [indexes firstIndex];
    int i = 0;
    while(index != NSNotFound) {
        if((i < aobjects.count) && (i < akeys.count)) {
            [self replaceEntryAtIndex:index withObject:aobjects[i] pairedWithKey:akeys[i]];
        }
        index = [indexes indexGreaterThanIndex:index];
        i++;
    }
}

- (void)replaceEntriesAtIndices:(NSIndexSet*)indexes withEntries:(NSArray*)orderedEntrys {
    NSUInteger index = [indexes firstIndex];
    int i = 0;
    while(index != NSNotFound) {
        if(i < orderedEntrys.count) {
            [self replaceEntryAtIndex:index withObject:orderedEntrys[i][0] pairedWithKey:orderedEntrys[i][0]];
        }
        index = [indexes indexGreaterThanIndex:index];
    }
}

- (void)replaceEntriesAtIndices:(NSIndexSet*)indexes withEntriesFromMap:(MobilyMap*)map {
    NSUInteger index = [indexes firstIndex];
    int i = 0;
    while(index != NSNotFound) {
        if(i < map.count) {
            [self replaceEntryAtIndex:index withObject:map[i] pairedWithKey:[map keyAtIndex:i]];
        }
        index = [indexes indexGreaterThanIndex:index];
    }
}

- (void)replaceEntriesInRange:(NSRange)range withObjectsFromArray:(NSArray*)object pairedWithKeysFromArray:(NSArray*)key inRange:(NSRange)range2 {
    [self replaceEntriesAtIndices:[NSIndexSet indexSetWithIndexesInRange:range] withObjects:[object objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range2]] pairedWithKeys:[key objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range2]]];
}

- (void)replaceEntriesInRange:(NSRange)range withEntriesFrom:(NSArray*)orderedEntries inRange:(NSRange)range2 {
    [self replaceEntriesAtIndices:[NSIndexSet indexSetWithIndexesInRange:range] withEntries:[orderedEntries objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range2]]];
}

- (void)replaceEntriesInRange:(NSRange)range withEntriesFromMap:(MobilyMap*)dictionary inRange:(NSRange)range2 {
    [self replaceEntriesInRange:range withObjectsFromArray:[dictionary.allObjects objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range2]] pairedWithKeysFromArray:[dictionary.allKeys objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range2]]];
}

- (void)replaceEntriesInRange:(NSRange)range withObjectsFromArray:(NSArray*)object pairedWithKeysFromArray:(NSArray*)key {
    [self replaceEntriesAtIndices:[NSIndexSet indexSetWithIndexesInRange:range] withObjects:object pairedWithKeys:key];
}

- (void)replaceEntriesInRange:(NSRange)range withEntriesFrom:(NSArray*)orderedEntrys {
    [self replaceEntriesAtIndices:[NSIndexSet indexSetWithIndexesInRange:range] withEntries:orderedEntrys];
}

- (void)replaceEntriesInRange:(NSRange)range withEntriesFromMap:(MobilyMap*)dictionary {
    [self replaceEntriesAtIndices:[NSIndexSet indexSetWithIndexesInRange:range] withEntriesFromMap:dictionary];
}

- (void)setEntriesToObjects:(NSArray*)object pairedWithKeys:(NSArray*)key {
    int i = 0;
    while((i < object.count) && (i < key.count)) {
        self[key[i]] = object[i];
        i++;
    }
}

- (void)setEntriesToMap:(MobilyMap*)map {
    for(id key in map.allKeys) {
        self[key] = map[key];
    }
}

#pragma mark Filtering

- (NSArray*)keysForSortedObjects:(NSArray*)tempObj {
    NSMutableArray* tempKey = [[NSMutableArray alloc] init];
    NSMutableArray* testObj = [[NSMutableArray alloc] initWithArray:_objects];
    NSMutableArray* testKey = [[NSMutableArray alloc] initWithArray:_keys];
    while((testObj.count > 0) && (tempObj.count > 0)) {
        NSInteger index = [testObj indexOfObjectIdenticalTo:tempObj[(tempObj.count - testObj.count)]];
        [tempKey addObject:testKey[index]];
        [testKey removeObjectAtIndex:index];
        [testObj removeObjectAtIndex:index];
    }
    return tempKey;
}

- (NSArray*)objectsForSortedKeys:(NSArray*)tempKey {
    NSMutableArray* tempObj = [[NSMutableArray alloc] init];
    for(id key in tempKey) {
        [tempObj addObject:_pairs[key]];
    }
    return tempObj;
}

- (void)filterEntriesUsingPredicateForObjects:(NSPredicate*)predicate {
    NSArray* tempObj = [_objects filteredArrayUsingPredicate:predicate];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    [_pairs removeAllObjects];
    _objects = [tempObj mutableCopy];
    _keys = [tempKey mutableCopy];
    for(int i = 0; i < _keys.count; i++) {
        _pairs[_keys[i]] = _objects[i];
    }
}

#pragma mark Sorting

- (void)exchangeEntryAtIndex:(NSUInteger)idx1 withEntryAtIndex:(NSUInteger)idx2 {
    [_keys exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [_objects exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortEntriesByObjectUsingDescriptors:(NSArray*)descriptors {
    NSArray* tempObj = [_objects sortedArrayUsingDescriptors:descriptors];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByKeysUsingDescriptors:(NSArray*)descriptors {
    NSArray* tempKey = [_keys sortedArrayUsingDescriptors:descriptors];
    NSArray* tempObj = [self objectsForSortedKeys:tempKey];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByObjectUsingComparator:(NSComparator)cmptr {
    NSArray* tempObj = [_objects sortedArrayUsingComparator:cmptr];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByKeysUsingComparator:(NSComparator)cmptr {
    NSArray* tempKey = [_keys sortedArrayUsingComparator:cmptr];
    NSArray* tempObj = [self objectsForSortedKeys:tempKey];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByObjectWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    NSArray* tempObj = [_objects sortedArrayWithOptions:opts usingComparator:cmptr];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByKeysWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    NSArray* tempKey = [_keys sortedArrayWithOptions:opts usingComparator:cmptr];
    NSArray* tempObj = [self objectsForSortedKeys:tempKey];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByObjectUsingFunction:(NSInteger(*)(__strong id, __strong id, void*))compare context:(void*)context {
    NSArray* tempObj = [_objects sortedArrayUsingFunction:compare context:context];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByKeysUsingFunction:(NSInteger(*)(__strong id, __strong id, void*))compare context:(void*)context {
    NSArray* tempKey = [_keys sortedArrayUsingFunction:compare context:context];
    NSArray* tempObj = [self objectsForSortedKeys:tempKey];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByObjectUsingSelector:(SEL)comparator {
    NSArray* tempObj = [_objects sortedArrayUsingSelector:comparator];
    NSArray* tempKey = [self keysForSortedObjects:tempObj];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

- (void)sortEntriesByKeysUsingSelector:(SEL)comparator {
    NSArray* tempKey = [_keys sortedArrayUsingSelector:comparator];
    NSArray* tempObj = [self objectsForSortedKeys:tempKey];
    _keys = [tempKey mutableCopy];
    _objects = [tempObj mutableCopy];
}

#pragma mark Indexed Subscripts

- (void)setObject:(id)obj forKeyedSubscript:(id< NSCopying >)key {
    [self setObject:obj forKey:key];
}

@end

/*--------------------------------------------------*/
