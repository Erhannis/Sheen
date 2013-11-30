//
//  Savegame+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/30/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Savegame.h"

@interface Savegame (Create)

+ (Savegame *)getAutosaveInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Savegame *)createBlankAutosaveInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Savegame *)twinSavegame:(Savegame *)original;

@end
