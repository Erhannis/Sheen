//
//  LevelInstance+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelInstance+Create.h"
#import "Being+Create.h"
#import "PortalTemplate+Create.h"
#import "PortalInstance+Create.h"

@implementation LevelInstance (Create)

// Only instantiates levels with a portal path from `levelTemplate` to said level.
//     I.e., if there's a levelTemplate pointing to `levelTemplate` but not viceversa, it won't be found.
+ (LevelInstance *)createLevelInstanceWithTemplate:(LevelTemplate *)levelTemplate
                                      withSavegame:(Savegame *)savegame
                            inManagedObjectContext:(NSManagedObjectContext *)context
{
    LevelInstance *levelInstance = nil;
    
    if (levelTemplate) {
        NSMutableArray *levelTemplates = [[NSMutableArray alloc] init];
        NSMutableArray *levelInstances = [[NSMutableArray alloc] init];
        
        levelInstance = [LevelInstance recurseThroughPortalsFromTemplate:levelTemplate
                                                      withLevelTemplates:levelTemplates
                                          andCorrespondingLevelInstances:levelInstances
                                                            withSavegame:savegame];
    }
    
    return levelInstance;
}

+ (LevelInstance *)recurseThroughPortalsFromTemplate:(LevelTemplate *)levelTemplate
                                  withLevelTemplates:(NSMutableArray *)levelTemplates
                      andCorrespondingLevelInstances:(NSMutableArray *)levelInstances
                                        withSavegame:(Savegame *)savegame
{
    LevelInstance *levelInstance = nil;
    
    if (levelTemplate) {
        levelInstance = [NSEntityDescription insertNewObjectForEntityForName:@"LevelInstance"
                                                      inManagedObjectContext:levelTemplate.managedObjectContext];
        levelInstance.template = levelTemplate;
        levelInstance.savegame = savegame;
        for (Being *beingTemplate in levelTemplate.beings) {
            Being *newBeing = [Being twinBeing:beingTemplate];
            newBeing.levelInstance = levelInstance;
        }
        
        [levelTemplates addObject:levelTemplate];
        [levelInstances addObject:levelInstance];
        
        for (PortalTemplate *portalTemplate in levelTemplate.portalsOutgoing) {
            if (![levelTemplates containsObject:portalTemplate.toLevel]) {
                LevelInstance *toLevelInstance = [LevelInstance recurseThroughPortalsFromTemplate:portalTemplate.toLevel
                                                                               withLevelTemplates:levelTemplates
                                                                   andCorrespondingLevelInstances:levelInstances
                                                                                     withSavegame:savegame];
                [PortalInstance createPortalInstanceWithTemplate:portalTemplate
                                               fromLevelInstance:levelInstance
                                                 toLevelInstance:toLevelInstance];
            } else {
                LevelInstance *toLevelInstance = [levelInstances objectAtIndex:[levelTemplates indexOfObject:portalTemplate.toLevel]];
                [PortalInstance createPortalInstanceWithTemplate:portalTemplate
                                               fromLevelInstance:levelInstance
                                                 toLevelInstance:toLevelInstance];
            }
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
