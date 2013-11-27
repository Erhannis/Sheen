//
//  LevelInstance.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LevelTemplate, Savegame;

@interface LevelInstance : NSManagedObject

@property (nonatomic, retain) Savegame *savegameOnThisLevel;
@property (nonatomic, retain) Savegame *savegame;
@property (nonatomic, retain) LevelTemplate *template;
@property (nonatomic, retain) NSSet *beings;
@end

@interface LevelInstance (CoreDataGeneratedAccessors)

- (void)addBeingsObject:(NSManagedObject *)value;
- (void)removeBeingsObject:(NSManagedObject *)value;
- (void)addBeings:(NSSet *)values;
- (void)removeBeings:(NSSet *)values;

@end
