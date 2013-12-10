//
//  LevelTemplate+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "LevelTemplate+Create.h"
#import "Being+Create.h"
#import "SpatialEntity+Create.h"
#import "Wall+Create.h"
#import "Color+Create.h"
#import "PortalTemplate+Create.h"

@implementation LevelTemplate (Create)

+ (LevelTemplate *)levelTemplateWithID:(NSString *)levelID
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    
    if (levelID.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LevelTemplate"];
        request.predicate = [NSPredicate predicateWithFormat:@"levelID = %@", levelID];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request
                                                  error:&error];
        
        if (!matches || error) {
            NSLog(@"Error dbFetching levelTemplate - err: %@", error.localizedDescription);
        } else if (!matches.count) {
            if ([levelID isEqualToString:DEFAULT_LEVEL_TEST_0]) {
                levelTemplate = [self createDefaultLevelTest0InContext:context];
            } else if ([levelID isEqualToString:DEFAULT_LEVEL_TEST_1]) {
                levelTemplate = [self createDefaultLevelTest1InContext:context];
            } else if ([levelID isEqualToString:DEFAULT_CONNECTED_LEVEL_TEST_0]) {
                levelTemplate = [self createDefaultConnectedLevelSetTest0InContext:context];
            } else {
                // Uhhh...for now, I'm going to ignore the branches of the connected level set.
                NSLog(@"Error - unknown level template \"%@\"", levelID);
            }
        } else {
            levelTemplate = [matches firstObject];
        }
    }
    
    return levelTemplate;
}

#pragma mark - Simple test levels

#define ONE_BG_COLOR_RED     (0x00 / 255.0)
#define ONE_BG_COLOR_GREEN   (0x20 / 255.0)
#define ONE_BG_COLOR_BLUE    (0x60 / 255.0)
#define ONE_BG_COLOR_ALPHA   (0xFF / 255.0)

+ (LevelTemplate *)createDefaultLevelTest0InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_LEVEL_TEST_0;
    levelTemplate.name = @"Test Level 0";
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

+ (LevelTemplate *)createDefaultLevelTest1InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_LEVEL_TEST_1;
    levelTemplate.name = @"Test Level 1";
    levelTemplate.song = @"gurdonark_-_Snow_Geese_at_Hagerman_Wildlife_Preserve";
    
    levelTemplate.bgColor = [Color colorInManagedObjectContext:context
                                                       withRed:ONE_BG_COLOR_RED
                                                         green:ONE_BG_COLOR_GREEN
                                                          blue:ONE_BG_COLOR_BLUE
                                                         alpha:ONE_BG_COLOR_ALPHA];
    
    Being *drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-purple";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:200];
    drop.spatial.yPos = [NSNumber numberWithDouble:-200];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;

    drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-cyan";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:0];
    drop.spatial.yPos = [NSNumber numberWithDouble:500];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;
    
    Wall *wall = [Wall blankWallInManagedObjectContext:context];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -300, 300);
    CGPathAddLineToPoint(path, NULL, 300, 300);
    CGPathAddLineToPoint(path, NULL, 300, -100);
    CGPathAddLineToPoint(path, NULL, 100, -100);
    CGPathAddLineToPoint(path, NULL, 100, 100);
    CGPathAddLineToPoint(path, NULL, -100, 100);
    CGPathAddLineToPoint(path, NULL, -100, -100);
    CGPathAddLineToPoint(path, NULL, -300, -100);
    CGPathCloseSubpath(path);
    wall.shape = [Wall dataFromPath:path];
    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
    wall.color = nil;
    [wall addLevelsObject:levelTemplate];
    
    return levelTemplate;
}

#pragma mark - Connected level test 1

// Generates the level set, connects them, and returns the root.
+ (LevelTemplate *)createDefaultConnectedLevelSetTest0InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *level0 = [LevelTemplate createDefaultConnectedLevelTest0InContext:context];
    LevelTemplate *level0_0 = [LevelTemplate createDefaultConnectedLevelTest0_0InContext:context];
    LevelTemplate *level0_1 = [LevelTemplate createDefaultConnectedLevelTest0_1InContext:context];
    
    // from level 0
    {
        PortalTemplate *portalTemplate = nil;
        
        portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
        portalTemplate.fromLevel = level0;
        portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:-300.0];
        portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toLevel = level0_0;
        portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:300.0];
        
        portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
        portalTemplate.fromLevel = level0;
        portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:300.0];
        portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toLevel = level0_1;
        portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
        portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:0.0];
        portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:0.0];
    }
    
    // from level 1
    {
        // No outgoing portals, yet.
    }

    // from level 2
    {
        // No outgoing portals, yet.
    }
    
    return level0;
}

+ (LevelTemplate *)createDefaultConnectedLevelTest0InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_CONNECTED_LEVEL_TEST_0;
    levelTemplate.name = @"Test Level Connected 0";
    levelTemplate.song = @"djlang59_-_Drops_of_H2O_(_The_Filtered_Water_Treatment_)";
    levelTemplate.bgColor = [Color colorInManagedObjectContext:context
                                                       withRed:0.6
                                                         green:0.3
                                                          blue:0.1
                                                         alpha:1.0];
    
    Being *drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-purple";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:200];
    drop.spatial.yPos = [NSNumber numberWithDouble:-200];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;
    
    drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-cyan";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:0];
    drop.spatial.yPos = [NSNumber numberWithDouble:500];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;
    
//    Wall *wall = [Wall blankWallInManagedObjectContext:context];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, -300, 300);
//    CGPathAddLineToPoint(path, NULL, 300, 300);
//    CGPathAddLineToPoint(path, NULL, 300, -100);
//    CGPathAddLineToPoint(path, NULL, 100, -100);
//    CGPathAddLineToPoint(path, NULL, 100, 100);
//    CGPathAddLineToPoint(path, NULL, -100, 100);
//    CGPathAddLineToPoint(path, NULL, -100, -100);
//    CGPathAddLineToPoint(path, NULL, -300, -100);
//    CGPathCloseSubpath(path);
//    wall.shape = [Wall dataFromPath:path];
//    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
//    wall.color = nil;
//    [wall addLevelsObject:levelTemplate];

    return levelTemplate;
}

+ (LevelTemplate *)createDefaultConnectedLevelTest0_0InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_CONNECTED_LEVEL_TEST_0_0;
    levelTemplate.name = @"Test Level Connected 0-0";
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

+ (LevelTemplate *)createDefaultConnectedLevelTest0_1InContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_CONNECTED_LEVEL_TEST_0_1;
    levelTemplate.name = @"Test Level Connected 0-1";
    levelTemplate.song = @"flatwound_-_The_Long_Goodbye";
    
    levelTemplate.bgColor = [Color colorInManagedObjectContext:context
                                                       withRed:ONE_BG_COLOR_RED
                                                         green:ONE_BG_COLOR_GREEN
                                                          blue:ONE_BG_COLOR_BLUE
                                                         alpha:ONE_BG_COLOR_ALPHA];
    
    Being *drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-purple";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:200];
    drop.spatial.yPos = [NSNumber numberWithDouble:-200];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;
    
    drop = [Being blankBeingInManagedObjectContext:context];
    drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    drop.imageFilename = @"drop-9-cyan";
    drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    drop.spatial.xPos = [NSNumber numberWithDouble:0];
    drop.spatial.yPos = [NSNumber numberWithDouble:500];
    drop.levelTemplate = levelTemplate;
    drop.color = nil;
    
    Wall *wall = [Wall blankWallInManagedObjectContext:context];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -300, 300);
    CGPathAddLineToPoint(path, NULL, 300, 300);
    CGPathAddLineToPoint(path, NULL, 300, -100);
    CGPathAddLineToPoint(path, NULL, 100, -100);
    CGPathAddLineToPoint(path, NULL, 100, 100);
    CGPathAddLineToPoint(path, NULL, -100, 100);
    CGPathAddLineToPoint(path, NULL, -100, -100);
    CGPathAddLineToPoint(path, NULL, -300, -100);
    CGPathCloseSubpath(path);
    wall.shape = [Wall dataFromPath:path];
    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
    wall.color = nil;
    [wall addLevelsObject:levelTemplate];
    
    return levelTemplate;
}

#pragma mark - Template Creation Template

// Not called: it's a template.
+ (LevelTemplate *)templateCreationTemplateInContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = @"";
    levelTemplate.name = @"";
    levelTemplate.song = @"";
    levelTemplate.bgColor = [Color colorInManagedObjectContext:context
                                                       withRed:0.0
                                                         green:0.0
                                                          blue:0.0
                                                         alpha:0.0];
    
    // for Being
    Being *being = [Being blankBeingInManagedObjectContext:context];
    being.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
    being.imageFilename = @"drop-9-purple";
    being.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
    being.spatial.xPos = [NSNumber numberWithDouble:0];
    being.spatial.yPos = [NSNumber numberWithDouble:0];
    being.levelTemplate = levelTemplate;
    being.color = nil;
    
    // for Wall
    Wall *wall = [Wall blankWallInManagedObjectContext:context];
    wall.shape = [Wall dataFromPath:CGPathCreateWithEllipseInRect(CGRectMake(-800, -800, 1600, 1600), NULL)];
    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
    wall.location.xPos = [NSNumber numberWithDouble:0];
    wall.location.yPos = [NSNumber numberWithDouble:0];
    wall.color = nil;
    [wall addLevelsObject:levelTemplate];
    
    // for portalsIncoming
    // Do nothing; we're not responsible for incoming portals.  I think.
    
    return levelTemplate;
}

+ (void)templateCreationTemplateDoPortalsInContext:(NSManagedObjectContext *)context
                                         fromLevel:(LevelTemplate *)fromLevel
                                          toLevel1:(LevelTemplate *)toLevel1
                                          toLevel2:(LevelTemplate *)toLevel2
{
    // for portalsOutgoing
    PortalTemplate *portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
    portalTemplate.fromLevel = fromLevel;
    portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
    portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.toLevel = toLevel1;
    portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
    portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:0.0];

    portalTemplate = [PortalTemplate defaultPortalTemplateInManagedObjectContext:context];
    portalTemplate.fromLevel = fromLevel;
    portalTemplate.fromPlace = [SpatialEntity createZeroInManagedObjectContext:context];
    portalTemplate.fromPlace.xPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.fromPlace.yPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.toLevel = toLevel2;
    portalTemplate.toPlace = [SpatialEntity createZeroInManagedObjectContext:context];
    portalTemplate.toPlace.xPos = [NSNumber numberWithFloat:0.0];
    portalTemplate.toPlace.yPos = [NSNumber numberWithFloat:0.0];
}


@end
