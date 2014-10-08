//----------------------------------------------//

#import "MobilyBuilder.h"

//----------------------------------------------//

@interface MobilyViewTable : UIView< MobilyBuilderObject >

- (void)setupView;

- (void)setArray:(NSArray*)array;

- (void)addObject:(id)object;
- (void)addObjectsFromArray:(NSArray*)array;

- (void)insertObject:(id)object atIndex:(NSUInteger)index;
- (void)insertObjectsFromArray:(NSArray*)array atIndex:(NSUInteger)index;

- (void)removeObjectsInArray:(NSArray*)array;
- (void)removeObjectsInRange:(NSRange)range;
- (void)removeObject:(id)object inRange:(NSRange)range;
- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeAllObjects;

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray*)otherArray;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)registerClassCell:(Class)classCell classData:(Class)classData;
- (void)unregisterClassCell:(Class)classCell classData:(Class)classData;

@end

//----------------------------------------------//

@interface MobilyViewTableSection : NSObject

@property(nonatomic, readwrite, assign) Class classCell;
@property(nonatomic, readwrite, assign) Class classData;

- (void)registerClassCell:(Class)classCell classData:(Class)classData;
- (void)unregisterClassCell:(Class)classCell classData:(Class)classData;

@end

//----------------------------------------------//

@interface MobilyViewTableRowFactory : NSObject

@property(nonatomic, readwrite, assign) Class classData;
@property(nonatomic, readwrite, assign) Class classCell;

- (id)initWithClassCell:(Class)classCell classData:(Class)classData;

@end

//----------------------------------------------//

@interface MobilyViewTableCell : UITableViewCell< MobilyBuilderObject >

- (void)setupView;

@end

//----------------------------------------------//
