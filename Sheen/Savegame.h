//
//  Savegame.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelInstance, Player;

@interface Savegame : NSManagedObject

@property (nonatomic, retain) NSString * savegameID;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSSet *levels;
@property (nonatomic, retain) Player *player;
@end

@interface Savegame (CoreDataGeneratedAccessors)

- (void)addLevelsObject:(LevelInstance *)value;
- (void)removeLevelsObject:(LevelInstance *)value;
- (void)addLevels:(NSSet *)values;
- (void)removeLevels:(NSSet *)values;

@end
