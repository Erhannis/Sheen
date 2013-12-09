//
//  Portal+Create.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import "Portal.h"

@interface Portal (Create)

+ (Portal *)defaultPortalInManagedObjectContext:(NSManagedObjectContext *)context;

@end
