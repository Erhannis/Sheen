//
//  PortalTemplate+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "PortalTemplate.h"

@interface PortalTemplate (Create)

+ (PortalTemplate *)defaultPortalTemplateInManagedObjectContext:(NSManagedObjectContext *)context;

@end
