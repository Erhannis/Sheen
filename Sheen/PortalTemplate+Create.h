//
//  PortalTemplate+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PortalTemplate.h"

@interface PortalTemplate (Create)

#define DEFAULT_PORTAL_OUTGOING_COLOR [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]
#define DEFAULT_PORTAL_INCOMING_COLOR [SKColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5]
#define DEFAULT_PORTAL_STROKE_WIDTH (2.0)
#define DEFAULT_PORTAL_GLOW_WIDTH (5.0)

+ (PortalTemplate *)defaultPortalTemplateInManagedObjectContext:(NSManagedObjectContext *)context;

@end
