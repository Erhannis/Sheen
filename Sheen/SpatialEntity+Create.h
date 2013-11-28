//
//  SpatialEntity+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SpatialEntity.h"

@interface SpatialEntity (Create)

+ (SpatialEntity *)createZeroInManagedObjectContext:(NSManagedObjectContext *)context;
+ (SpatialEntity *)cloneCoreOf:(SpatialEntity *)original
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
