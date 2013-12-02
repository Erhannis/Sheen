//
//  Savegame+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/30/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Savegame+Create.h"
#import "Player+Create.h"
#import "LevelInstance+Create.h"

@implementation Savegame (Create)

+ (Savegame *)getAutosaveInManagedObjectContext:(NSManagedObjectContext *)context
{
    Savegame *savegame = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Savegame"];
    request.predicate = [NSPredicate predicateWithFormat:@"savegameID = %@", SAVEGAME_ID_AUTOSAVE];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request
                                              error:&error];
    
    if (!matches || error) {
        NSLog(@"Error dbFetching savegame - err: %@", error.localizedDescription);
    } else if (!matches.count) {
        savegame = [self createBlankAutosaveInManagedObjectContext:context];
    } else {
        savegame = [matches firstObject];
    }
    
    return savegame;
}

+ (Savegame *)createBlankAutosaveInManagedObjectContext:(NSManagedObjectContext *)context
{
    Savegame *savegame = nil;
    savegame = [NSEntityDescription insertNewObjectForEntityForName:@"Savegame"
                                             inManagedObjectContext:context];
    savegame.savegameID = SAVEGAME_ID_AUTOSAVE;
    
    return savegame;
}

+ (Savegame *)getNewSavegameChoiceInManagedObjectContext:(NSManagedObjectContext *)context
{
    Savegame *savegame = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Savegame"];
    request.predicate = [NSPredicate predicateWithFormat:@"savegameID = %@", SAVEGAME_ID_NEW_SAVEGAME];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request
                                              error:&error];
    
    if (!matches || error) {
        NSLog(@"Error dbFetching savegame - err: %@", error.localizedDescription);
    } else if (!matches.count) {
        savegame = [NSEntityDescription insertNewObjectForEntityForName:@"Savegame"
                                                 inManagedObjectContext:context];
        savegame.savegameID = SAVEGAME_ID_NEW_SAVEGAME;
    } else {
        savegame = [matches firstObject];
    }
    
    return savegame;
}

+ (Savegame *)twinSavegame:(Savegame *)original
{
    Savegame *savegame = nil;
    savegame = [NSEntityDescription insertNewObjectForEntityForName:@"Savegame"
                                             inManagedObjectContext:original.managedObjectContext];
    savegame.savegameID = [NSString stringWithFormat:@"%i",arc4random()];
    savegame.thumbnail = original.thumbnail;
    savegame.player = [Player twinPlayer:original.player];
    
    for (LevelInstance *levelInstance in original.levels) {
        LevelInstance *newLevelInstance = [LevelInstance twinLevelInstance:levelInstance];
        newLevelInstance.savegame = savegame;
        if (levelInstance == original.player.curLevel) {
            NSLog(@"curLevel found");
            savegame.player.curLevel = newLevelInstance;
        }
    }
    
    return savegame;
}

@end
