//
//  PortalTemplate+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PortalTemplate+Create.h"

@implementation PortalTemplate (Create)

#define DEFAULT_PORTAL_RADIUS (50.0)

+ (PortalTemplate *)blankPortalTemplateInManagedObjectContext:(NSManagedObjectContext *)context
{
    PortalTemplate *portalTemplate = nil;
    portalTemplate = [NSEntityDescription insertNewObjectForEntityForName:@"PortalTemplate"
                                                   inManagedObjectContext:context];
    
    return portalTemplate;
}

+ (PortalTemplate *)defaultPortalTemplateInManagedObjectContext:(NSManagedObjectContext *)context
{
    PortalTemplate *portalTemplate = [PortalTemplate blankPortalTemplateInManagedObjectContext:context];
    portalTemplate.radius = [NSNumber numberWithFloat:DEFAULT_PORTAL_RADIUS];
    
    return portalTemplate;
}

@end
