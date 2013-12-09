//
//  SpatialEntity+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SpatialEntity.h"
#import <SpriteKit/SpriteKit.h>

@interface SpatialEntity (Create)

+ (SpatialEntity *)createZeroInManagedObjectContext:(NSManagedObjectContext *)context;
+ (SpatialEntity *)createFromSKNode:(SKNode *)node
             inManagedObjectContext:(NSManagedObjectContext *)context;

+ (SpatialEntity *)twinSpatialEntity:(SpatialEntity *)original;

@end
