//
//  PortalTemplate+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PortalTemplate.h"

@interface PortalTemplate (Create)

#define DEFAULT_PORTAL_OUTGOING_COLOR [SKColor redColor]
#define DEFAULT_PORTAL_INCOMING_COLOR [SKColor greenColor]
#define DEFAULT_PORTAL_STROKE_WIDTH (2.0)
#define DEFAULT_PORTAL_GLOW_WIDTH (5.0)

+ (PortalTemplate *)defaultPortalTemplateInManagedObjectContext:(NSManagedObjectContext *)context;

@end
