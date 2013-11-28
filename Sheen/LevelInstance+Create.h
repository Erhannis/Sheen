//
//  LevelInstance+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelInstance.h"
#import "LevelTemplate.h"

@interface LevelInstance (Create)

+ (LevelInstance *)createLevelInstanceWithTemplate:(LevelTemplate *)levelTemplate
                            inManagedObjectContext:(NSManagedObjectContext *)context;

@end
