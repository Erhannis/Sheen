//
//  Color.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Being, Item, LevelTemplate, Player, Wall;

@interface Color : NSManagedObject

@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSNumber * alpha;
@property (nonatomic, retain) LevelTemplate *levelTemplate;
@property (nonatomic, retain) Item *item;
@property (nonatomic, retain) Wall *wall;
@property (nonatomic, retain) Being *being;
@property (nonatomic, retain) Player *player;

@end
