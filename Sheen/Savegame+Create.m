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

+ (Savegame *)overwriteWithBlankAutosaveInManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:[Savegame getAutosaveInManagedObjectContext:context]];
    Savegame *savegame = [NSEntityDescription insertNewObjectForEntityForName:@"Savegame"
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
    if (!original) return nil;
    
    Savegame *savegame = nil;
    savegame = [NSEntityDescription insertNewObjectForEntityForName:@"Savegame"
                                             inManagedObjectContext:original.managedObjectContext];
    savegame.savegameID = [NSString stringWithFormat:@"%@",[[NSDate alloc] init]];
    savegame.thumbnail = original.thumbnail;
    savegame.player = [Player twinPlayer:original.player];
    
    //TODO This was/is showing a bunch of extras.  Why?
    for (LevelInstance *levelInstance in original.levels) {
        LevelInstance *newLevelInstance = [LevelInstance twinLevelInstance:levelInstance
                                                              withSavegame:savegame];
        //TODO Move this into the twin function?
        if (levelInstance == original.player.curLevel) {
            savegame.player.curLevel = newLevelInstance;
        }
    }
    
    return savegame;
}

// The autosave also doubles as the current game.
+ (void)setAsAutosave:(Savegame *)savegameToUse
{
    Savegame *autosave = [Savegame getAutosaveInManagedObjectContext:savegameToUse.managedObjectContext];
    if (autosave == savegameToUse) {
        return;
    }
    autosave.thumbnail = [savegameToUse.thumbnail copy];
    autosave.player = [Player twinPlayer:savegameToUse.player];
    [autosave removeLevels:autosave.levels];
    for (LevelInstance *levelInstance in savegameToUse.levels) {
        LevelInstance *newLevelInstance = [LevelInstance twinLevelInstance:levelInstance
                                                              withSavegame:autosave];
        //TODO Move this into the twin function?
        if (levelInstance == savegameToUse.player.curLevel) {
            autosave.player.curLevel = newLevelInstance;
        }
    }
}

@end
