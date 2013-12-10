//
//  PortalTemplate.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelTemplate, PortalInstance, SpatialEntity;

@interface PortalTemplate : NSManagedObject

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) LevelTemplate *fromLevel;
@property (nonatomic, retain) SpatialEntity *fromPlace;
@property (nonatomic, retain) NSSet *instances;
@property (nonatomic, retain) LevelTemplate *toLevel;
@property (nonatomic, retain) SpatialEntity *toPlace;
@end

@interface PortalTemplate (CoreDataGeneratedAccessors)

- (void)addInstancesObject:(PortalInstance *)value;
- (void)removeInstancesObject:(PortalInstance *)value;
- (void)addInstances:(NSSet *)values;
- (void)removeInstances:(NSSet *)values;

@end
