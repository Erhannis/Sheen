//
//  Being+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Being.h"

@interface Being (Create)

#define BEING_TYPE_NPC (1)

+ (Being *)blankBeingInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Being *)twinBeing:(Being *)original;

@end
