//
//  LevelSetTestTube1.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelSetTestTube1.h"
#import "Being+Create.h"
#import "SpatialEntity+Create.h"
#import "Wall+Create.h"
#import "PortalTemplate+Create.h"
#import "Color+Create.h"
#import "MathUtils.h"

@implementation LevelSetTestTube1

// Generates the level set, connects them, and returns the root.
+ (LevelTemplate *)createDefaultConnectedLevelSetTest1InContext:(NSManagedObjectContext *)context
{
    SKColor *colorLight = [SKColor colorWithRed:0.9 green:0.6 blue:0.2 alpha:1.0];
    SKColor *colorDark = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    CGFloat step = 1.0 / 8;
    CGFloat gamma = 0.0;
    LevelTemplate *level1_0 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_0.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_0;
    level1_0.name = @"Test Tube 1-0";
    level1_0.song = @"djlang59_-_Drops_of_H2O_(_The_Filtered_Water_Treatment_)";
    level1_0.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_1 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_1.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_1;
    level1_1.name = @"Test Tube 1-1";
    level1_1.song = @"Pitx_-_Chords_For_David";
    level1_1.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_2 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_2.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_2;
    level1_2.name = @"Test Tube 1-2";
    level1_2.song = @"gurdonark_-_Homework";
    level1_2.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_3 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_3.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_3;
    level1_3.name = @"Test Tube 1-3";
    level1_3.song = @"_ghost_-_Reverie_(small_theme)";
    level1_3.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_4 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_4.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_4;
    level1_4.name = @"Test Tube 1-4";
    level1_4.song = @"flatwound_-_The_Long_Goodbye";
    level1_4.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_5 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_5.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_5;
    level1_5.name = @"Test Tube 1-5";
    level1_5.song = @"_ghost_-_Empty_rooms_(small_theme)";
    level1_5.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_6 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_6.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_6;
    level1_6.name = @"Test Tube 1-6";
    level1_6.song = @"gurdonark_-_Restless_Sleep";
    level1_6.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_7 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_7.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_7;
    level1_7.name = @"Test Tube 1-7";
    level1_7.song = @"onlymeith_-_Truth_";
    level1_7.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    gamma += step;
    LevelTemplate *level1_8 = [self createDefaultConnectedLevelTest1_0InContext:context];
    level1_8.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_8;
    level1_8.name = @"Test Tube 1-8";
    level1_8.song = @"gurdonark_-_Snow_Geese_at_Hagerman_Wildlife_Preserve";
    level1_8.bgColor = [Color colorInManagedObjectContext:context withSKColor:[MathUtils colorInterpolateFromColor:colorLight
                                                                                                           toColor:colorDark
                                                                                                           atValue:gamma]];
    
    PortalTemplate *portalTemplate = nil;

    // from level 0
    {
        portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
        portalTemplate.fromLevel = level1_0;
        portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:300.0];
        portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toLevel = level1_1;
        portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:300.0];
        portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:0.0];
    }
    
    NSArray *middleLevels = @[level1_1, level1_2, level1_3, level1_4, level1_5, level1_6, level1_7, level1_8];
    for (int i = 0; i < middleLevels.count - 1; i++) {
        portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
        portalTemplate.fromLevel = [middleLevels objectAtIndex:i];
        portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:300.0 * ((i % 2 == 0) ? -1 : 1)];
        portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toLevel = [middleLevels objectAtIndex:i+1];
        portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:300.0 * ((i % 2 == 0) ? -1 : 1)];
        portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:0.0];
    }
    
    // from level 8
    {
        // No outgoing portals.
    }
    
    return level1_0;
}

#define ONE_BG_COLOR_RED     (0x00 / 255.0)
#define ONE_BG_COLOR_GREEN   (0x20 / 255.0)
#define ONE_BG_COLOR_BLUE    (0x60 / 255.0)
#define ONE_BG_COLOR_ALPHA   (0xFF / 255.0)

+ (LevelTemplate *)createDefaultConnectedLevelTest1_0InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_CONNECTED_LEVEL_TEST_1_0;
    levelTemplate.name = @"Test Level Connected 1-0";
    levelTemplate.song = @"gurdonark_-_Snow_Geese_at_Hagerman_Wildlife_Preserve";
    
    levelTemplate.bgColor = [Color colorInManagedObjectContext:context
                                                       withRed:ONE_BG_COLOR_RED
                                                         green:ONE_BG_COLOR_GREEN
                                                          blue:ONE_BG_COLOR_BLUE
                                                         alpha:ONE_BG_COLOR_ALPHA];
    
    for (NSString *img in @[@"drop-9-red", @"drop-9-green", @"drop-9-blue", @"drop-9-yellow", @"drop-9-cyan", @"drop-9-purple", @"drop-9-white", @"drop-9-black"]) {
        Being *drop = [Being blankBeingInManagedObjectContext:context];
        drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
        drop.imageFilename = img;
        drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
        drop.spatial.xPos = [NSNumber numberWithDouble:20 * (drand48() - 0.5)];
        drop.spatial.yPos = [NSNumber numberWithDouble:20 * (drand48() - 0.5)];
        drop.levelTemplate = levelTemplate;
        drop.color = nil;
    }
    
    Wall *wall = [Wall blankWallInManagedObjectContext:context];
    wall.shape = [Wall dataFromPath:CGPathCreateWithEllipseInRect(CGRectMake(-800, -800, 1600, 1600), NULL)];
    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
    wall.color = nil;
    [wall addLevelsObject:levelTemplate];
    
    return levelTemplate;
}

@end
