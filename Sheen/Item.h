//
//  Item.h
//  Sheen
//
//  Created by Matthew Ewer on 12/4/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) Player *player;

@end