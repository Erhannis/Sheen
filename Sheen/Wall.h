//
//  Wall.h
//  Sheen
//
//  Created by Matthew Ewer on 11/27/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Wall : NSManagedObject

@property (nonatomic, retain) NSData * shape;
@property (nonatomic, retain) NSManagedObject *location;
@property (nonatomic, retain) NSSet *levels;
@end

@interface Wall (CoreDataGeneratedAccessors)

- (void)addLevelsObject:(NSManagedObject *)value;
- (void)removeLevelsObject:(NSManagedObject *)value;
- (void)addLevels:(NSSet *)values;
- (void)removeLevels:(NSSet *)values;

@end
