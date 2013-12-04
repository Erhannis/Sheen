//
//  Savegame+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/30/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Savegame.h"

@interface Savegame (Create)

#define SAVEGAME_ID_AUTOSAVE @"autosave"
#define SAVEGAME_ID_NEW_SAVEGAME @"New Savegame"

+ (Savegame *)getAutosaveInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Savegame *)overwriteWithBlankAutosaveInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Savegame *)getNewSavegameChoiceInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Savegame *)twinSavegame:(Savegame *)original;

+ (void)setAsAutosave:(Savegame *)savegameToUse;

@end
