//
//  Player.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Color, Item, LevelInstance, Savegame, SpatialEntity;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * curHealth;
@property (nonatomic, retain) NSNumber * curWill;
@property (nonatomic, retain) NSNumber * exp;
@property (nonatomic, retain) NSNumber * maxHealth;
@property (nonatomic, retain) NSNumber * maxWill;
@property (nonatomic, retain) Color *color;
@property (nonatomic, retain) LevelInstance *curLevel;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Savegame *savegame;
@property (nonatomic, retain) SpatialEntity *spatial;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
