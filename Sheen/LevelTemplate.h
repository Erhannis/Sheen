//
//  LevelTemplate.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Portal, Wall;

@interface LevelTemplate : NSManagedObject

@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * bgColor;
@property (nonatomic, retain) NSSet *walls;
@property (nonatomic, retain) NSSet *instances;
@property (nonatomic, retain) NSSet *beings;
@property (nonatomic, retain) NSSet *portalsOutgoing;
@property (nonatomic, retain) NSSet *portalsIncoming;
@end

@interface LevelTemplate (CoreDataGeneratedAccessors)

- (void)addWallsObject:(Wall *)value;
- (void)removeWallsObject:(Wall *)value;
- (void)addWalls:(NSSet *)values;
- (void)removeWalls:(NSSet *)values;

- (void)addInstancesObject:(NSManagedObject *)value;
- (void)removeInstancesObject:(NSManagedObject *)value;
- (void)addInstances:(NSSet *)values;
- (void)removeInstances:(NSSet *)values;

- (void)addBeingsObject:(NSManagedObject *)value;
- (void)removeBeingsObject:(NSManagedObject *)value;
- (void)addBeings:(NSSet *)values;
- (void)removeBeings:(NSSet *)values;

- (void)addPortalsOutgoingObject:(Portal *)value;
- (void)removePortalsOutgoingObject:(Portal *)value;
- (void)addPortalsOutgoing:(NSSet *)values;
- (void)removePortalsOutgoing:(NSSet *)values;

- (void)addPortalsIncomingObject:(Portal *)value;
- (void)removePortalsIncomingObject:(Portal *)value;
- (void)addPortalsIncoming:(NSSet *)values;
- (void)removePortalsIncoming:(NSSet *)values;

@end
