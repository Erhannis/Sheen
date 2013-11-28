//
//  Player+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Player.h"

@interface Player (Create)

+ (Player *)blankPlayerInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Player *)defaultPlayerInManagedObjectContext:(NSManagedObjectContext *)context;


@end
