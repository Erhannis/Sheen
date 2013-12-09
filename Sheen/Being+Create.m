//
//  Being+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Being+Create.h"
#import "SpatialEntity+Create.h"
#import "Color+Create.h"

@implementation Being (Create)

+ (Being *)blankBeingInManagedObjectContext:(NSManagedObjectContext *)context
{
    Being *being = nil;
    being = [NSEntityDescription insertNewObjectForEntityForName:@"Being"
                                           inManagedObjectContext:context];
    return being;
}

+ (Being *)twinBeing:(Being *)original
{
    if (!original) return nil;
    
    Being *being = [NSEntityDescription insertNewObjectForEntityForName:@"Being"
                                                 inManagedObjectContext:original.managedObjectContext];
    being.type = original.type;
    being.imageFilename = original.imageFilename;
    being.spatial = [SpatialEntity twinSpatialEntity:original.spatial];
    being.color = [Color twinColor:original.color];

    return being;
}

@end
