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

+ (LevelInstance *)twinLevelInstanceSetStartingFrom:(LevelInstance *)original
                                       withSavegame:(Savegame *)savegame
{
    LevelInstance *levelInstance = nil;

    if (original) {
        NSMutableArray *levelInstancesA = [[NSMutableArray alloc] init];
        NSMutableArray *levelInstancesB = [[NSMutableArray alloc] init];
        
        levelInstance = [LevelInstance recurseThroughPortalsFromInstance:original
                                                     withLevelInstancesA:levelInstancesA
                                         andCorrespondingLevelInstancesB:levelInstancesB
                                                            withSavegame:savegame];
    }
    
    return levelInstance;
}

+ (LevelInstance *)recurseThroughPortalsFromInstance:(LevelInstance *)original
                                 withLevelInstancesA:(NSMutableArray *)levelInstancesA
                     andCorrespondingLevelInstancesB:(NSMutableArray *)levelInstancesB
                                        withSavegame:(Savegame *)savegame
{
    LevelInstance *levelInstance = nil;
    
    if (original) {
        levelInstance = [NSEntityDescription insertNewObjectForEntityForName:@"LevelInstance"
                                                                     inManagedObjectContext:original.managedObjectContext];
        levelInstance.template = original.template;
        levelInstance.savegame = savegame;
        
        for (Being *being in original.beings) {
            Being *newBeing = [Being twinBeing:being];
            newBeing.levelInstance = levelInstance;
        }
        
        [levelInstancesA addObject:original];
        [levelInstancesB addObject:levelInstance];
        
        for (PortalInstance *portalInstance in original.portalsOutgoing) {
            if (![levelInstancesA containsObject:portalInstance.toLevelInstance]) {
                LevelInstance *toLevelInstance = [LevelInstance recurseThroughPortalsFromInstance:portalInstance.toLevelInstance
                                                                              withLevelInstancesA:levelInstancesA
                                                                  andCorrespondingLevelInstancesB:levelInstancesB
                                                                                     withSavegame:savegame];
                [PortalInstance createPortalInstanceWithTemplate:portalInstance.template
                                               fromLevelInstance:levelInstance
                                                 toLevelInstance:toLevelInstance];
            } else {
                LevelInstance *toLevelInstance = [levelInstancesB objectAtIndex:[levelInstancesA indexOfObject:portalInstance.toLevelInstance]];
                [PortalInstance createPortalInstanceWithTemplate:portalInstance.template
                                               fromLevelInstance:levelInstance
                                                 toLevelInstance:toLevelInstance];
            }
        }
        for (PortalInstance *portalInstance in original.portalsIncoming) {
            if (![levelInstancesA containsObject:portalInstance.fromLevelInstance]) {
                [LevelInstance recurseThroughPortalsFromInstance:portalInstance.fromLevelInstance
                                             withLevelInstancesA:levelInstancesA
                                 andCorrespondingLevelInstancesB:levelInstancesB
                                                    withSavegame:savegame];
            }
        }
    }
    
    return levelInstance;
}

@end
