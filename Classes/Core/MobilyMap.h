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

#import "MobilyObject.h"

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyMap : NSObject< MobilyObject, NSCopying, NSCoding, NSFastEnumeration >

+ (instancetype)map;
+ (instancetype)mapWithMap:(MobilyMap*)map;
+ (instancetype)mapWithContentsOfFile:(NSString*)path;
+ (instancetype)mapWithContentsOfURL:(NSURL*)URL;
+ (instancetype)mapWithObject:(id)anObject pairedWithKey:(id< NSCopying >)aKey;
+ (instancetype)mapWithDictionary:(NSDictionary*)entries;

- (instancetype)init;
- (instancetype)initWithMap:(MobilyMap*)map;
- (instancetype)initWithMap:(MobilyMap*)map copyEntries:(BOOL)flag;
- (instancetype)initWithContentsOfFile:(NSString*)path;
- (instancetype)initWithContentsOfURL:(NSURL*)URL;
- (instancetype)initWithContentsOfDictionary:(NSDictionary*)entries;
- (instancetype)initWithObjects:(NSArray*)orderedObjects pairedWithKeys:(NSArray*)orderedKeys;
- (instancetype)initWithCoder:(NSCoder*)decoder;

- (void)setup NS_REQUIRES_SUPER;

- (BOOL)containsObject:(id)object;
- (BOOL)containsObject:(id)object pairedWithKey:(id< NSCopying >)key;
- (BOOL)containsEntry:(NSDictionary*)entry;

- (NSUInteger)count;

- (id)firstObject;
- (id< NSCopying >)firstKey;
- (NSDictionary*)firstEntry;

- (id)lastObject;
- (id< NSCopying >)lastKey;
- (NSDictionary*)lastEntry;

- (id)objectAtIndex:(NSUInteger)index;
- (id< NSCopying >)keyAtIndex:(NSUInteger)index;
- (NSDictionary*)entryAtIndex:(NSUInteger)index;

- (NSArray*)objectsAtIndices:(NSIndexSet*)indeces;
- (NSArray*)keysAtIndices:(NSIndexSet*)indices;
- (MobilyMap*)entriesAtIndices:(NSIndexSet*)indices;
- (NSDictionary*)unorderedEntriesAtIndices:(NSIndexSet*)indices;
- (NSDictionary*)unmap;

- (NSArray*)allKeys;
- (NSArray*)allObjects;
- (NSArray*)allKeysForObject:(id)anObject;

- (id)objectForKey:(id< NSCopying >)key;
- (NSArray*)objectForKeys:(NSArray*)keys notFoundMarker:(id)anObject;

- (NSEnumerator*)objectEnumerator;
- (NSEnumerator*)keyEnumerator;
- (NSEnumerator*)entryEnumerator;
- (NSEnumerator*)reverseObjectEnumerator;
- (NSEnumerator*)reverseKeyEnumerator;
- (NSEnumerator*)reverseEntryEnumerator;

- (NSUInteger)indexOfObject:(id)object;
- (NSUInteger)indexOfKey:(id< NSCopying >)key;
- (NSUInteger)indexOfEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key;
- (NSUInteger)indexOfEntry:(NSDictionary*)entry;

- (NSUInteger)indexOfObject:(id)object inRange:(NSRange)range;
- (NSUInteger)indexOfKey:(id< NSCopying >)key inRange:(NSRange)range;
- (NSUInteger)indexOfEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key inRange:(NSRange)range;
- (NSUInteger)indexOfEntry:(NSDictionary*)entry inRange:(NSRange)range;
- (NSUInteger)indexOfObjectIdenticalTo:(id)object;
- (id< NSCopying >)keyOfObjectIdenticalTo:(id)object;
- (NSUInteger)indexOfObjectIdenticalTo:(id)object inRange:(NSRange)range;
- (id< NSCopying >)keyOfObjectIdenticalTo:(id)object inRange:(NSRange)range;
- (NSUInteger)indexOfObjectPassingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (id< NSCopying >)keyOfObjectPassingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (id< NSCopying >)keyOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSUInteger)indexOfObjectAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (id< NSCopying >)keyOfObjectAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSUInteger)indexOfObject:(id)object inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp;
- (id< NSCopying >)keyOfObject:(id)object inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp;
- (NSIndexSet*)indicesOfObjectsPassingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSArray*)keysOfObjectsPassingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSIndexSet*)indicesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSArray*)keysOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSIndexSet*)indicesOfObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;
- (NSArray*)keysOfObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts passingTest:(BOOL(^)(id obj, NSUInteger idx, BOOL* stop))predicate;

- (void)makeObjectsPerformSelector:(SEL)aSelector;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject;

- (void)enumerateObjectsUsingBlock:(void(^)(id obj, NSUInteger idx, BOOL* stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void(^)(id obj, NSUInteger idx, BOOL* stop))block;
- (void)enumerateObjectsAtIndices:(NSIndexSet*)indexSet options:(NSEnumerationOptions)opts usingBlock:(void(^)(id obj, NSUInteger idx, BOOL* stop))block;
- (void)each:(void(^)(id key, id object))block;
- (void)eachWithIndex:(void(^)(id key, id object, NSUInteger index))block;
- (void)eachKey:(void(^)(id key))block;
- (void)eachKeyWithIndex:(void(^)(id key, NSUInteger index))block;
- (void)eachValue:(void(^)(id object))block;
- (void)eachValueWithIndex:(void(^)(id object, NSUInteger index))block;

- (id)firstObjectInCommonWithMap:(MobilyMap*)otherMap;
- (id)firstKeyInCommonWithMap:(MobilyMap*)otherMap;
- (id)firstEntryInCommonWithMap:(MobilyMap*)otherMap;

- (BOOL)isEqualToMap:(MobilyMap*)otherMap;

- (MobilyMap*)mapByAddingObject:(id)object pairedWithKey:(id< NSCopying >)aKey;
- (MobilyMap*)mapByAddingEntry:(NSDictionary*)entry;
- (MobilyMap*)mapByAddingObjects:(NSArray*)orderedObjects pairedWithKeys:(NSArray*)orderedKeys;

- (MobilyMap*)filteredOrderDictionarysUsingPredicateForObjects:(NSPredicate*)predicate;
- (MobilyMap*)subMapWithRange:(NSRange)range;

- (NSData*)sortedObjectsHint;
- (NSData*)sortedKeysHint;

- (MobilyMap*)sortedByObjectsUsingFunction:(NSInteger(*)(id, id, void*))comparator context:(void*)context;
- (MobilyMap*)sortedByKeysUsingFunction:(NSInteger(*)(id< NSCopying>, id< NSCopying>, void*))comparator context:(void*)context;
- (MobilyMap*)sortedByObjectsUsingFunction:(NSInteger(*)(id, id, void*))comparator context:(void*)context hint:(NSData*)hint;
- (MobilyMap*)sortedByKeysUsingFunction:(NSInteger(*)(id< NSCopying>, id< NSCopying>, void*))comparator context:(void*)context hint:(NSData*)hint;
- (MobilyMap*)sortedByObjectsUsingDescriptors:(NSArray*)descriptors;
- (MobilyMap*)sortedByKeysUsingDescriptors:(NSArray*)descriptors;
- (MobilyMap*)sortedByObjectsUsingSelector:(SEL)comparator;
- (MobilyMap*)sortedByKeysUsingSelector:(SEL)comparator;
- (MobilyMap*)sortedByObjectsUsingComparator:(NSComparator)cmptr;
- (MobilyMap*)sortedByKeysUsingComparator:(NSComparator)cmptr;
- (MobilyMap*)sortedByObjectsWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
- (MobilyMap*)sortedByKeysWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;

- (NSString*)description;
- (NSString*)descriptionWithLocale:(id)locale;
- (NSString*)descriptionWithLocale:(id)locale indent:(NSUInteger)level;

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)flag;
- (BOOL)writeToURL:(NSURL*)aURL atomically:(BOOL)flag;

- (void)addObserver:(NSObject*)anObserver toObjectsAtIndices:(NSIndexSet*)indices forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context;
- (void)addObserver:(NSObject*)observer forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context;
- (void)removeObserver:(NSObject*)anObserver fromObjectsAtIndices:(NSIndexSet*)indices forKeyPath:(NSString*)keyPath;
- (void)removeObserver:(NSObject*)observer forKeyPath:(NSString*)keyPath context:(void*)context;

- (void)setValue:(id)value forKey:(NSString*)key;
- (void)setValue:(id)value forKeyPath:(NSString*)keyPath;
- (id)valueForKey:(NSString*)key;
- (id)valueForKeyPath:(NSString*)keyPath;

- (void)encodeWithCoder:(NSCoder*)aCoder;

- (id)copy;
- (id)copyWithZone:(NSZone*)zone;
- (id)mutableCopy;
- (id)mutableCopyWithZone:(NSZone*)zone;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (id)objectForKeyedSubscript:(id)key;

@end

/*--------------------------------------------------*/

@interface MobilyMutableMap : MobilyMap

+ (instancetype)mapWithCapacity:(NSUInteger)numEntries;
- (instancetype)initWithCapacity:(NSUInteger)numEntries;

- (void)addObject:(id)object pairedWithKey:(id< NSCopying >)key;
- (void)addEntry:(NSDictionary*)entry;
- (void)addEntriesFromMap:(MobilyMap*)map;
- (void)addEntriesFromDictionary:(NSDictionary*)dictionary;

- (void)insertObject:(id)object pairedWithKey:(id< NSCopying >)key atIndex:(NSUInteger)index;
- (void)insertEntry:(NSDictionary*)entry atIndex:(NSUInteger)index;
- (void)insertEntriesFromMap:(MobilyMap*)map atIndex:(NSUInteger)index;
- (void)insertEntriesFromDictionary:(NSDictionary*)dictionary atIndex:(NSUInteger)index;

- (void)setObject:(id)object forKey:(id< NSCopying >)aKey;
- (void)setEntry:(NSDictionary*)entry;
- (void)setEntriesFromMap:(MobilyMap*)map;
- (void)setEntriesFromDictionary:(NSDictionary*)dictionary;
- (void)setObject:(id)object forKey:(id< NSCopying >)aKey atIndex:(NSUInteger)index;
- (void)setEntry:(NSDictionary*)entry  atIndex:(NSUInteger)index;
- (void)setEntriesFromMap:(MobilyMap*)map atIndex:(NSUInteger)index;
- (void)setEntriesFromDictionary:(NSDictionary*)dictionary  atIndex:(NSUInteger)index;

- (void)removeObjectForKey:(id)key;
- (void)removeObjectsForKeys:(NSArray*)keys;
- (void)removeFirstEntry;
- (void)removeLastEntry;
- (void)removeEntryWithObject:(id)object;
- (void)removeEntryWithKey:(id< NSCopying >)key;
- (void)removeEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key;
- (void)removeEntry:(NSDictionary*)entry;
- (void)removeEntryWithObject:(id)object inRange:(NSRange)range;
- (void)removeEntryWithKey:(id< NSCopying >)key inRange:(NSRange)range;
- (void)removeEntryWithObject:(id)object pairedWithKey:(id< NSCopying >)key inRange:(NSRange)ramge;
- (void)removeEntry:(NSDictionary*)entry inRange:(NSRange)range;
- (void)removeEntryAtIndex:(NSUInteger)index;
- (void)removeEntriesAtIndices:(NSIndexSet*)indices;
- (void)removeEntryWithObjectIdenticalTo:(id)anObject;
- (void)removeEntryWithObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeEntriesWithObjectsInArray:(NSArray*)array;
- (void)removeEntriesWithKeysInArray:(NSArray*)array;
- (void)removeEntriesInRange:(NSRange)range;
- (void)removeAllObjects;
- (void)removeAllEntries;

- (void)replaceEntryAtIndex:(NSInteger)index withObject:(id)object pairedWithKey:(id< NSCopying >)key;
- (void)replaceEntryAtIndex:(NSUInteger)index withEntry:(NSDictionary*)entry;
- (void)replaceEntriesAtIndices:(NSIndexSet*)indices withObjects:(NSArray*)objects pairedWithKeys:(NSArray*)keys;
- (void)replaceEntriesAtIndices:(NSIndexSet*)indices withEntries:(NSArray*)orderedEntries;
- (void)replaceEntriesAtIndices:(NSIndexSet*)indices withEntriesFromMap:(MobilyMap*)map;

- (void)replaceEntriesInRange:(NSRange)range withObjectsFromArray:(NSArray*)objects pairedWithKeysFromArray:(NSArray*)keys inRange:(NSRange)range2;
- (void)replaceEntriesInRange:(NSRange)range withEntriesFrom:(NSArray*)orderedEntries inRange:(NSRange)range2;
- (void)replaceEntriesInRange:(NSRange)range withEntriesFromMap:(MobilyMap*)dictionary inRange:(NSRange)range2;
- (void)replaceEntriesInRange:(NSRange)range withObjectsFromArray:(NSArray*)objects pairedWithKeysFromArray:(NSArray*)keys;
- (void)replaceEntriesInRange:(NSRange)range withEntriesFrom:(NSArray*)orderedEntries;
- (void)replaceEntriesInRange:(NSRange)range withEntriesFromMap:(MobilyMap*)dictionary;

- (void)setEntriesToObjects:(NSArray*)objects pairedWithKeys:(NSArray*)keys;
- (void)setEntriesToMap:(MobilyMap*)map;

- (void)filterEntriesUsingPredicateForObjects:(NSPredicate*)predicate;

- (void)exchangeEntryAtIndex:(NSUInteger)idx1 withEntryAtIndex:(NSUInteger)idx2;

- (void)sortEntriesByObjectUsingDescriptors:(NSArray*)descriptors;
- (void)sortEntriesByKeysUsingDescriptors:(NSArray*)descriptors;
- (void)sortEntriesByObjectUsingComparator:(NSComparator)cmptr;
- (void)sortEntriesByKeysUsingComparator:(NSComparator)cmptr;
- (void)sortEntriesByObjectWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
- (void)sortEntriesByKeysWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr;
- (void)sortEntriesByObjectUsingFunction:(NSInteger(*)(id, id, void*))compare context:(void*)context;
- (void)sortEntriesByKeysUsingFunction:(NSInteger(*)(id, id, void*))compare context:(void*)context;
- (void)sortEntriesByObjectUsingSelector:(SEL)comparator;
- (void)sortEntriesByKeysUsingSelector:(SEL)comparator;

- (void)setObject:(id)object forKeyedSubscript:(id< NSCopying >)key;

@end

/*--------------------------------------------------*/
