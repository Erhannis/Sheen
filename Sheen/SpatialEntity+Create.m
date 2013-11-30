//
//  SpatialEntity+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "SpatialEntity+Create.h"

@implementation SpatialEntity (Create)

+ (SpatialEntity *)createZeroInManagedObjectContext:(NSManagedObjectContext *)context
{
    SpatialEntity *spatialEntity = nil;
    
    spatialEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SpatialEntity"
                                                  inManagedObjectContext:context];
    spatialEntity.xPos = [NSNumber numberWithDouble:0];
    spatialEntity.yPos = [NSNumber numberWithDouble:0];
    spatialEntity.xVelocity = [NSNumber numberWithDouble:0];
    spatialEntity.yVelocity = [NSNumber numberWithDouble:0];
    
    return spatialEntity;
}

+ (SpatialEntity *)createFromSKNode:(SKNode *)node
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    SpatialEntity *spatialEntity = nil;
    
    spatialEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SpatialEntity"
                                                  inManagedObjectContext:context];
    spatialEntity.xPos = [NSNumber numberWithDouble:node.position.x];
    spatialEntity.yPos = [NSNumber numberWithDouble:node.position.y];
    spatialEntity.xVelocity = [NSNumber numberWithDouble:node.physicsBody.velocity.dx];
    spatialEntity.yVelocity = [NSNumber numberWithDouble:node.physicsBody.velocity.dy];
    
    return spatialEntity;
}

+ (SpatialEntity *)cloneCoreOf:(SpatialEntity *)original
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    SpatialEntity *spatialEntity = nil;
    
    if (original) {
        spatialEntity = [NSEntityDescription insertNewObjectForEntityForName:@"SpatialEntity"
                                                      inManagedObjectContext:context];
        spatialEntity.xPos = original.xPos;
        spatialEntity.yPos = original.yPos;
        spatialEntity.xVelocity = original.xVelocity;
        spatialEntity.yVelocity = original.yVelocity;
    }
    
    return spatialEntity;
}

@end
