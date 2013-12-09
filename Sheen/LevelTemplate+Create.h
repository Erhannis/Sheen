//
//  LevelTemplate+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelTemplate.h"

@interface LevelTemplate (Create)

#define DEFAULT_LEVEL_TEST_0 @"default level test 0"
#define DEFAULT_LEVEL_TEST_1 @"default level test 1"

#define DEFAULT_CONNECTED_LEVEL_TEST_0 @"default connected level test 0"
#define DEFAULT_CONNECTED_LEVEL_TEST_0_0 @"default connected level test 0-0"
#define DEFAULT_CONNECTED_LEVEL_TEST_0_1 @"default connected level test 0-1"

+ (LevelTemplate *)levelTemplateWithID:(NSString *)levelID
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
