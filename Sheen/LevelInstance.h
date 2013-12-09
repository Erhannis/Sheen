//
//  LevelInstance.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Being, LevelTemplate, Player, PortalInstance, Savegame;

@interface LevelInstance : NSManagedObject

@property (nonatomic, retain) NSSet *beings;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Savegame *savegame;
@property (nonatomic, retain) LevelTemplate *template;
@property (nonatomic, retain) PortalInstance *newRelationship;
@property (nonatomic, retain) PortalInstance *newRelationship1;
@end

@interface LevelInstance (CoreDataGeneratedAccessors)

- (void)addBeingsObject:(Being *)value;
- (void)removeBeingsObject:(Being *)value;
- (void)addBeings:(NSSet *)values;
- (void)removeBeings:(NSSet *)values;

@end
