//
//  LevelSetTestTube1.h
//  Sheen
//
//  Created by Matthew Ewer on 12/9/13.
//  Copyright (c) 2013 CS193P - Matthew Ewer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LevelTemplate+Create.h"

@interface LevelSetTestTube1 : NSObject

+ (LevelTemplate *)createDefaultConnectedLevelSetTest1InContext:(NSManagedObjectContext *)context;

@end
