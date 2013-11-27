//
//  Player.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Savegame;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * curHealth;
@property (nonatomic, retain) NSNumber * maxHealth;
@property (nonatomic, retain) NSNumber * curWill;
@property (nonatomic, retain) NSNumber * maxWill;
@property (nonatomic, retain) NSNumber * exp;
@property (nonatomic, retain) Savegame *savegame;
@property (nonatomic, retain) NSManagedObject *spatial;

@end
