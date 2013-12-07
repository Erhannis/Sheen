//
//  Being.h
//  Sheen
//
//  Created by Matthew Ewer on 12/6/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelInstance, LevelTemplate, SpatialEntity;

@interface Being : NSManagedObject

@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) LevelInstance *levelInstance;
@property (nonatomic, retain) LevelTemplate *levelTemplate;
@property (nonatomic, retain) SpatialEntity *spatial;

@end
