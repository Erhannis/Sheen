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
            Being *newBeing = [Being cloneCoreOf:beingTemplate
                          inManagedObjectContext:context];
            // I believe this adds the being to `levelInstance.beings`.
            newBeing.levelInstance = levelInstance;
        }
    }
    
    return levelInstance;
}

@end
