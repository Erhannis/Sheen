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
            if ([levelID isEqualToString:DEFAULT_LEVEL_TEST]) {
                levelTemplate = [self createDefaultLevelTestInContext:context];
            } else {
                NSLog(@"Error - unknown level template \"%@\"", levelID);
            }
        } else {
            levelTemplate = [matches firstObject];
        }
    }
    
    return levelTemplate;
}

+ (LevelTemplate *)createDefaultLevelTestInContext:(NSManagedObjectContext *)context
{
    LevelTemplate *levelTemplate = nil;
    levelTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"LevelTemplate"
                                                  inManagedObjectContext:context];
    levelTemplate.levelID = DEFAULT_LEVEL_TEST;
    
    for (NSString *img in @[@"drop-9-red", @"drop-9-green", @"drop-9-blue", @"drop-9-yellow", @"drop-9-cyan", @"drop-9-purple", @"drop-9-white", @"drop-9-black"]) {
        Being *drop = [Being blankBeingInManagedObjectContext:context];
        drop.type = [NSNumber numberWithInt:BEING_TYPE_NPC];
        drop.imageFilename = img;
        drop.spatial = [SpatialEntity createZeroInManagedObjectContext:context];
        drop.spatial.xPos = [NSNumber numberWithDouble:20 * (drand48() - 0.5)];
        drop.spatial.yPos = [NSNumber numberWithDouble:20 * (drand48() - 0.5)];
        drop.levelTemplate = levelTemplate;
    }

    Wall *wall = [Wall blankWallInManagedObjectContext:context];
    wall.shape = [Wall dataFromPath:CGPathCreateWithEllipseInRect(CGRectMake(-800, -800, 1600, 1600), NULL)];
    wall.location = [SpatialEntity createZeroInManagedObjectContext:context];
    [wall addLevelsObject:levelTemplate];
    
    return levelTemplate;
}

@end
