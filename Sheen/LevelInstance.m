//
//  LevelInstance.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelInstance.h"
#import "Being.h"
#import "LevelTemplate.h"
#import "Player.h"
#import "PortalInstance.h"
#import "Savegame.h"


@implementation LevelInstance

@dynamic beings;
@dynamic portalsOutgoing;
@dynamic portalsIncoming;
@dynamic player;
@dynamic savegame;
@dynamic template;

@end
