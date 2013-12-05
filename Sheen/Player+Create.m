//
//  Player+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Player+Create.h"
#import "SpatialEntity+Create.h"
#import "Savegame+Create.h"
#import "Item+Create.h"

@implementation Player (Create)

#define DEFAULT_MAX_HEALTH (10)
#define DEFAULT_MAX_WILL (10)

+ (Player *)blankPlayerInManagedObjectContext:(NSManagedObjectContext *)context
{
    Player *player = nil;
    player = [NSEntityDescription insertNewObjectForEntityForName:@"Player"
                                           inManagedObjectContext:context];
    return player;
}

+ (Player *)defaultPlayerInManagedObjectContext:(NSManagedObjectContext *)context
{
    Player *player = [Player blankPlayerInManagedObjectContext:context];
    player.maxHealth = [NSNumber numberWithDouble:DEFAULT_MAX_HEALTH];
    player.curHealth = player.maxHealth;
    player.maxWill = [NSNumber numberWithDouble:DEFAULT_MAX_WILL];
    player.curWill = player.maxWill;
    player.exp = [NSNumber numberWithDouble:0];
    player.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    player.savegame = [Savegame getAutosaveInManagedObjectContext:context];
    
    return player;
}

+ (Player *)twinPlayer:(Player *)original
{
    Player *player = [Player blankPlayerInManagedObjectContext:original.managedObjectContext];
    player.maxHealth = original.maxHealth;
    player.curHealth = original.curHealth;
    player.maxWill = original.maxWill;
    player.curWill = original.curWill;
    player.exp = original.exp;
    player.spatial = [SpatialEntity cloneCoreOf:original.spatial
                         inManagedObjectContext:original.managedObjectContext];
    
    for (Item *item in original.items) {
        Item *newItem = [Item twinItem:item];
        newItem.player = player;
    }
    
    return player;
}

@end
