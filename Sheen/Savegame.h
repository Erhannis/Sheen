//
//  Savegame.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Savegame : NSManagedObject

@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSManagedObject *player;
@property (nonatomic, retain) NSManagedObject *curLevel;
@property (nonatomic, retain) NSSet *levels;
@end

@interface Savegame (CoreDataGeneratedAccessors)

- (void)addLevelsObject:(NSManagedObject *)value;
- (void)removeLevelsObject:(NSManagedObject *)value;
- (void)addLevels:(NSSet *)values;
- (void)removeLevels:(NSSet *)values;

@end
