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
@property (nonatomic, retain) NSSet *portalsOutgoing;
@property (nonatomic, retain) NSSet *portalsIncoming;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Savegame *savegame;
@property (nonatomic, retain) LevelTemplate *template;
@end

@interface LevelInstance (CoreDataGeneratedAccessors)

- (void)addBeingsObject:(Being *)value;
- (void)removeBeingsObject:(Being *)value;
- (void)addBeings:(NSSet *)values;
- (void)removeBeings:(NSSet *)values;

- (void)addPortalsOutgoingObject:(PortalInstance *)value;
- (void)removePortalsOutgoingObject:(PortalInstance *)value;
- (void)addPortalsOutgoing:(NSSet *)values;
- (void)removePortalsOutgoing:(NSSet *)values;

- (void)addPortalsIncomingObject:(PortalInstance *)value;
- (void)removePortalsIncomingObject:(PortalInstance *)value;
- (void)addPortalsIncoming:(NSSet *)values;
- (void)removePortalsIncoming:(NSSet *)values;

@end
