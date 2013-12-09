//
//  Portal+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Portal+Create.h"

@implementation Portal (Create)

#define DEFAULT_RADIUS (50.0)

+ (Portal *)blankPortalInManagedObjectContext:(NSManagedObjectContext *)context
{
    Portal *portal = nil;
    portal = [NSEntityDescription insertNewObjectForEntityForName:@"Portal"
                                           inManagedObjectContext:context];
    
    return portal;
}

+ (Portal *)defaultPortalInManagedObjectContext:(NSManagedObjectContext *)context
{
    Portal *portal = [Portal blankPortalInManagedObjectContext:context];
    portal.radius = [NSNumber numberWithFloat:DEFAULT_RADIUS];
    
    return portal;
}

@end
