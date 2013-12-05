//
//  SpatialEntity.h
//  Sheen
//
//  Created by Matthew Ewer on 12/4/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Being, Player, Portal, Wall;

@interface SpatialEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * xPos;
@property (nonatomic, retain) NSNumber * xVelocity;
@property (nonatomic, retain) NSNumber * yPos;
@property (nonatomic, retain) NSNumber * yVelocity;
@property (nonatomic, retain) Being *being;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Portal *portalFrom;
@property (nonatomic, retain) Portal *portalTo;
@property (nonatomic, retain) Wall *wall;

@end
