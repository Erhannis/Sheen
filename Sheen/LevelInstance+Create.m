//
//  LevelInstance+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelInstance+Create.h"
#import "Being+Create.h"

@implementation LevelInstance (Create)

+ (LevelInstance *)createLevelInstanceWithTemplate:(LevelTemplate *)levelTemplate
                            inManagedObjectContext:(NSManagedObjectContext *)context
{
    LevelInstance *levelInstance = nil;
    
    if (levelTemplate) {
        levelInstance = [NSEntityDescription insertNewObjectForEntityForName:@"LevelInstance"
                                                      inManagedObjectContext:context];
        levelInstance.template = levelTemplate;
        for (Being *beingTemplate in levelTemplate.beings) {
            Being *newBeing = [Being twinBeing:beingTemplate];
            newBeing.levelInstance = levelInstance;
        }
    }
    
    return levelInstance;
}

+ (LevelInstance *)twinLevelInstance:(LevelInstance *)original
                        withSavegame:(Savegame *)savegame
{
    if (!original) return nil;
    
    LevelInstance *levelInstance = [NSEntityDescription insertNewObjectForEntityForName:@"LevelInstance"
                                                                 inManagedObjectContext:original.managedObjectContext];
    levelInstance.template = original.template;
    
    for (Being *being in original.beings) {
        Being *newBeing = [Being twinBeing:being];
        newBeing.levelInstance = levelInstance;
    }
    
    levelInstance.savegame = savegame;
    
    return levelInstance;
}

@end
