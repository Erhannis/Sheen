//
//  PortalInstance+Create.m
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PortalInstance+Create.h"
#import "Por"

@implementation PortalInstance (Create)

+ (PortalInstance *)createPortalInstanceWithTemplate:(PortalTemplate *)portalTemplate
                                   fromLevelInstance:(LevelInstance *)fromLevelInstance
                                     toLevelInstance:(LevelInstance *)toLevelInstance
{
    PortalInstance *portalInstance = nil;
    
    if (portalTemplate) {
        portalInstance = [NSEntityDescription insertNewObjectForEntityForName:@"PortalInstance"
                                                       inManagedObjectContext:portalTemplate.managedObjectContext];
        portalInstance.template = portalTemplate;
        portalInstance.fromLevelInstance = fromLevelInstance;
        portalInstance.toLevelInstance = toLevelInstance;
    }
    
    return portalInstance;
}

@end
