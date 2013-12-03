//
//  DatabaseManager.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//
/*
 I've attempted to arrange the database in such a manner that it can be rearranged into a tree, with the following hierarchy:
 
 Savegame
   [LevelInstance]
     LevelTemplate
       [Being]
         SpatialEntity
       Portal x 2
         SpatialEntity x 2
       [Wall]
         SpatialEntity
     [Being]
       SpatialEntity
   Player
     LevelInstance
       LevelTemplate
         [Being]
           SpatialEntity
         Portal x 2
           SpatialEntity x 2
         [Wall]
           SpatialEntity
       [Being]
         SpatialEntity
     SpatialEntity
 
 Or, in a more compact form:
 
 Savegame
   LevelInstance
   Player
 LevelInstance
   LevelTemplate
   Being
 Player
   LevelInstance
   SpatialEntity
 LevelTemplate
   Being
   Portal
   Wall
 Being
   SpatialEntity
 Portal
   SpatialEntity
 Wall
   SpatialEntity
 
 */
#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

#define DatabaseAvailabilityNotification @"DatabaseAvailabilityNotification"
#define DatabaseAvailabilityContext @"Context"

#define DATABASE_THUMBNAIL_EDGE_LENGTH (100)

@property (nonatomic, strong) UIManagedDocument *document;

+ (void)cleanUpUnusedObjectsInContext:(NSManagedObjectContext *)context;

@end
