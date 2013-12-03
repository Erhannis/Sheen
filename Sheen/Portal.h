//
//  Portal.h
//  Sheen
//
//  Created by Matthew Ewer on 12/2/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelTemplate, SpatialEntity;

@interface Portal : NSManagedObject

@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) LevelTemplate *fromLevel;
@property (nonatomic, retain) SpatialEntity *fromPlace;
@property (nonatomic, retain) LevelTemplate *toLevel;
@property (nonatomic, retain) SpatialEntity *toPlace;

@end
