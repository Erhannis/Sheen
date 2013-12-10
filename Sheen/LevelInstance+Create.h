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

// Currently, this should only be used when making a new game.  I don't know what will happen if you
//     call it in connection to an existing game.
+ (LevelInstance *)createLevelInstanceWithTemplate:(LevelTemplate *)levelTemplate
                                      withSavegame:(Savegame *)savegame
                            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (LevelInstance *)twinLevelInstance:(LevelInstance *)original
                        withSavegame:(Savegame *)savegame;

@end
