//
//  LevelTemplate+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelTemplate.h"

@interface LevelTemplate (Create)

#define DEFAULT_LEVEL_TEST @"default level test"

+ (LevelTemplate *)levelTemplateWithID:(NSString *)levelID
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
