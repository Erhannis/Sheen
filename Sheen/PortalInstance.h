//
//  PortalInstance.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelInstance, PortalTemplate;

@interface PortalInstance : NSManagedObject

@property (nonatomic, retain) LevelInstance *fromLevelInstance;
@property (nonatomic, retain) LevelInstance *toLevelInstance;
@property (nonatomic, retain) PortalTemplate *template;

@end
