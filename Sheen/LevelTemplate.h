//
//  LevelTemplate.h
//  Sheen
//
//  Created by Matthew Ewer on 12/6/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Being, LevelInstance, Portal, Wall;

@interface LevelTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * bgColor;
@property (nonatomic, retain) NSString * levelID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) NSSet *beings;
@property (nonatomic, retain) NSSet *instances;
@property (nonatomic, retain) NSSet *portalsIncoming;
@property (nonatomic, retain) NSSet *portalsOutgoing;
@property (nonatomic, retain) NSSet *walls;
@end

@interface LevelTemplate (CoreDataGeneratedAccessors)

- (void)addBeingsObject:(Being *)value;
- (void)removeBeingsObject:(Being *)value;
- (void)addBeings:(NSSet *)values;
- (void)removeBeings:(NSSet *)values;

- (void)addInstancesObject:(LevelInstance *)value;
- (void)removeInstancesObject:(LevelInstance *)value;
- (void)addInstances:(NSSet *)values;
- (void)removeInstances:(NSSet *)values;

- (void)addPortalsIncomingObject:(Portal *)value;
- (void)removePortalsIncomingObject:(Portal *)value;
- (void)addPortalsIncoming:(NSSet *)values;
- (void)removePortalsIncoming:(NSSet *)values;

- (void)addPortalsOutgoingObject:(Portal *)value;
- (void)removePortalsOutgoingObject:(Portal *)value;
- (void)addPortalsOutgoing:(NSSet *)values;
- (void)removePortalsOutgoing:(NSSet *)values;

- (void)addWallsObject:(Wall *)value;
- (void)removeWallsObject:(Wall *)value;
- (void)addWalls:(NSSet *)values;
- (void)removeWalls:(NSSet *)values;

@end
