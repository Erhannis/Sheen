//
//  LevelInstance+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelInstance.h"
#import "LevelTemplate.h"
#import "Savegame+Create.h"

@interface LevelInstance (Create)

+ (LevelInstance *)createLevelInstanceWithTemplate:(LevelTemplate *)levelTemplate
                            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (LevelInstance *)twinLevelInstance:(LevelInstance *)original
                        withSavegame:(Savegame *)savegame;

@end
