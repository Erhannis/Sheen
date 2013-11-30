//
//  Being+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Being+Create.h"
#import "SpatialEntity+Create.h"

@implementation Being (Create)

+ (Being *)blankBeingInManagedObjectContext:(NSManagedObjectContext *)context
{
    Being *being = nil;
    being = [NSEntityDescription insertNewObjectForEntityForName:@"Being"
                                           inManagedObjectContext:context];
    return being;
}

+ (Being *)cloneCoreOf:(Being *)original
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Being *being = nil;
    
    if (original) {
        being = [NSEntityDescription insertNewObjectForEntityForName:@"Being"
                                              inManagedObjectContext:context];
        being.type = original.type;
        being.imageFilename = original.imageFilename;
        being.spatial = [SpatialEntity cloneCoreOf:original.spatial
                            inManagedObjectContext:context];
    }
    
    return being;
}

@end
