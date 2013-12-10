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

#define DEFAULT_CONNECTED_LEVEL_TEST_1_0 @"default connected level test 1-0"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_1 @"default connected level test 1-1"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_2 @"default connected level test 1-2"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_3 @"default connected level test 1-3"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_4 @"default connected level test 1-4"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_5 @"default connected level test 1-5"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_6 @"default connected level test 1-6"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_7 @"default connected level test 1-7"
#define DEFAULT_CONNECTED_LEVEL_TEST_1_8 @"default connected level test 1-8"

+ (LevelTemplate *)levelTemplateWithID:(NSString *)levelID
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
